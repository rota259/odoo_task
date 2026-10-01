import 'odoo_client.dart';
import 'odoo_exception.dart';
import 'odoo_orm_mixin.dart';
import 'odoo_session.dart';

/// Uses JSON-RPC first and permanently switches to XML-RPC for the rest of
/// the session when JSON-RPC fails at the transport level (404, non-JSON).
///
/// Wrong credentials, network outages and Odoo business errors are rethrown
/// untouched: XML-RPC would not fix those.
class FallbackOdooClient with OdooOrmMixin implements OdooClient {
  FallbackOdooClient({required this.primary, required this.fallback});

  final OdooClient primary;
  final OdooClient fallback;
  bool _usingFallback = false;

  bool get isUsingFallback => _usingFallback;

  @override
  Future<OdooSession> authenticate(String db, String login, String password) =>
      _run((c) => c.authenticate(db, login, password));

  @override
  Future<dynamic> callMethod(
    String model,
    String method,
    List<dynamic> args, [
    Map<String, dynamic> kwargs = const {},
  ]) => _run((c) => c.callMethod(model, method, args, kwargs));

  Future<T> _run<T>(Future<T> Function(OdooClient client) action) async {
    if (_usingFallback) return action(fallback);
    try {
      return await action(primary);
    } on OdooException catch (e) {
      if (!e.isTransport) rethrow;
      _usingFallback = true;
      return action(fallback);
    }
  }

  @override
  Future<void> logout() async {
    await Future.wait([primary.logout(), fallback.logout()]);
    _usingFallback = false;
  }
}
