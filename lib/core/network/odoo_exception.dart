/// What went wrong talking to Odoo, independent of the transport used.
enum OdooErrorKind {
  /// Wrong login or password (`odoo.exceptions.AccessDenied`).
  accessDenied,

  /// The requested database does not exist on the server.
  databaseNotFound,

  /// The web session is gone (JSON-RPC error code 100).
  sessionExpired,

  /// Odoo processed the call and raised a business/validation error.
  server,

  /// The server could not be reached at all (DNS, refused, timeout).
  network,

  /// The endpoint answered, but not like an Odoo JSON-RPC endpoint
  /// (404, HTML, non-JSON...). Triggers the XML-RPC fallback.
  transport,
}

class OdooException implements Exception {
  const OdooException(this.kind, this.message, {this.code, this.name});

  const OdooException.network([String message = 'Server unreachable'])
    : this(OdooErrorKind.network, message);

  const OdooException.transport(String message)
    : this(OdooErrorKind.transport, message);

  const OdooException.accessDenied([String message = 'Access Denied'])
    : this(OdooErrorKind.accessDenied, message);

  final OdooErrorKind kind;

  /// Human readable message, taken from `error.data.message` when available.
  final String message;

  /// Raw JSON-RPC error code (e.g. 100 or 200) or XML-RPC fault code.
  final int? code;

  /// Python exception name, e.g. `odoo.exceptions.ValidationError`.
  final String? name;

  bool get isTransport => kind == OdooErrorKind.transport;

  @override
  String toString() => 'OdooException($kind, $message)';
}
