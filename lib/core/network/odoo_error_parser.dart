import 'odoo_exception.dart';

/// Maps Odoo error payloads (JSON-RPC `error` objects and XML-RPC faults)
/// to [OdooException]s.
abstract final class OdooErrorParser {
  static const sessionExpiredCode = 100;

  /// Parses the `error` member of a JSON-RPC response.
  static OdooException fromJsonRpc(Object? error) {
    if (error is! Map) {
      return const OdooException(OdooErrorKind.server, 'Odoo Server Error');
    }
    final code = error['code'] is int ? error['code'] as int : null;
    final data = error['data'] is Map ? error['data'] as Map : const {};
    final name = data['name'] is String ? data['name'] as String : null;
    final message = _firstText([data['message'], error['message']]);
    return OdooException(
      _classify(code: code, name: name, message: message),
      message,
      code: code,
      name: name,
    );
  }

  /// Parses an XML-RPC fault (`faultCode`, `faultString`).
  static OdooException fromXmlRpcFault(int code, String faultString) {
    final message = _lastLine(faultString);
    return OdooException(
      _classify(code: code, name: faultString, message: faultString),
      message,
      code: code,
    );
  }

  static OdooErrorKind _classify({int? code, String? name, String? message}) {
    final text = '${name ?? ''} ${message ?? ''}';
    if (code == sessionExpiredCode || text.contains('SessionExpired')) {
      return OdooErrorKind.sessionExpired;
    }
    if (text.contains('AccessDenied') || message == 'Access Denied') {
      return OdooErrorKind.accessDenied;
    }
    final dbMissing = RegExp(r'database ".*" does not exist');
    if (dbMissing.hasMatch(text) || text.contains('KeyError: \'')) {
      return OdooErrorKind.databaseNotFound;
    }
    return OdooErrorKind.server;
  }

  static String _firstText(List<Object?> candidates) {
    for (final c in candidates) {
      if (c is String && c.trim().isNotEmpty) return c.trim();
    }
    return 'Odoo Server Error';
  }

  /// Business faults are plain messages; crashes are full tracebacks whose
  /// last line holds the useful part.
  static String _lastLine(String text) {
    final trimmed = text.trim();
    if (!trimmed.startsWith('Traceback')) {
      return trimmed.isEmpty ? 'Odoo Server Error' : trimmed;
    }
    final lines = trimmed.split('\n').where((l) => l.trim().isNotEmpty);
    return lines.last.trim();
  }
}
