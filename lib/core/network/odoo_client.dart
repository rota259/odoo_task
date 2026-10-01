import 'odoo_session.dart';

/// Transport-agnostic access to Odoo's ORM.
///
/// Implementations: JSON-RPC (primary), XML-RPC (fallback) and a
/// fallback-aware composite. All failures surface as `OdooException`.
abstract interface class OdooClient {
  Future<OdooSession> authenticate(String db, String login, String password);

  Future<List<Map<String, dynamic>>> searchRead(
    String model, {
    List<dynamic> domain = const [],
    List<String> fields = const [],
    int? limit,
    int? offset,
    String? order,
  });

  Future<int> searchCount(String model, List<dynamic> domain);

  Future<List<Map<String, dynamic>>> read(
    String model,
    List<int> ids,
    List<String> fields,
  );

  Future<bool> write(String model, List<int> ids, Map<String, dynamic> values);

  Future<dynamic> callMethod(
    String model,
    String method,
    List<dynamic> args, [
    Map<String, dynamic> kwargs = const {},
  ]);

  /// Drops the server session / cached uid (used on logout).
  Future<void> logout();
}
