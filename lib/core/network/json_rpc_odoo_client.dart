import 'package:cookie_jar/cookie_jar.dart';

import '../storage/credentials_store.dart';
import 'json_rpc_transport.dart';
import 'odoo_client.dart';
import 'odoo_exception.dart';
import 'odoo_orm_mixin.dart';
import 'odoo_session.dart';

/// Primary transport: Odoo's web JSON-RPC endpoints.
///
/// The `session_id` cookie lives in a persistent [CookieJar]. When Odoo
/// reports an expired session (code 100), the client logs in again with
/// the credentials from secure storage and retries the call once.
class JsonRpcOdooClient with OdooOrmMixin implements OdooClient {
  JsonRpcOdooClient(this._transport, this._cookies, this._credentials);

  final JsonRpcTransport _transport;
  final CookieJar _cookies;
  final CredentialsStore _credentials;

  @override
  Future<OdooSession> authenticate(
    String db,
    String login,
    String password,
  ) async {
    final result = await _transport.post('/web/session/authenticate', {
      'db': db,
      'login': login,
      'password': password,
    });
    if (result is! Map || result['uid'] is! int) {
      throw const OdooException.accessDenied();
    }
    return OdooSession.fromJsonRpc(result, login: login);
  }

  @override
  Future<dynamic> callMethod(
    String model,
    String method,
    List<dynamic> args, [
    Map<String, dynamic> kwargs = const {},
  ]) async {
    try {
      return await _callKw(model, method, args, kwargs);
    } on OdooException catch (e) {
      if (e.kind != OdooErrorKind.sessionExpired) rethrow;
      await _reauthenticate(e);
      return _callKw(model, method, args, kwargs);
    }
  }

  Future<dynamic> _callKw(
    String model,
    String method,
    List<dynamic> args,
    Map<String, dynamic> kwargs,
  ) => _transport.post('/web/dataset/call_kw/$model/$method', {
    'model': model,
    'method': method,
    'args': args,
    'kwargs': kwargs,
  });

  Future<void> _reauthenticate(OdooException original) async {
    final saved = await _credentials.read();
    if (saved == null) throw original;
    await authenticate(saved.database, saved.login, saved.password);
  }

  @override
  Future<void> logout() async {
    try {
      await _transport.post('/web/session/destroy', const {});
    } on OdooException {
      // Best effort: the local cookie is dropped below anyway.
    }
    await _cookies.deleteAll();
  }
}
