import '../storage/credentials_store.dart';
import 'odoo_client.dart';
import 'odoo_endpoint.dart';
import 'odoo_exception.dart';
import 'odoo_orm_mixin.dart';
import 'odoo_session.dart';
import 'xml_rpc_caller.dart';

/// Fallback transport: Odoo's external XML-RPC API.
///
/// Stateless on the server: every `execute_kw` carries db, uid and password.
/// After an app restart the uid is recovered from secure storage.
class XmlRpcOdooClient with OdooOrmMixin implements OdooClient {
  XmlRpcOdooClient(
    this._endpoint,
    this._credentials, {
    XmlRpcCall call = defaultXmlRpcCall,
  }) : _call = call;

  final OdooEndpoint _endpoint;
  final CredentialsStore _credentials;
  final XmlRpcCall _call;

  String? _db;
  int? _uid;
  String? _password;

  @override
  Future<OdooSession> authenticate(
    String db,
    String login,
    String password,
  ) async {
    final uid = await guardedXmlRpcCall(
      _call,
      _endpoint.resolve('/xmlrpc/2/common'),
      'authenticate',
      [db, login, password, <String, dynamic>{}],
    );
    // Wrong credentials are not a fault here: Odoo answers `false`.
    if (uid is! int) throw const OdooException.accessDenied();
    _db = db;
    _uid = uid;
    _password = password;
    return OdooSession(uid: uid, database: db, login: login);
  }

  @override
  Future<dynamic> callMethod(
    String model,
    String method,
    List<dynamic> args, [
    Map<String, dynamic> kwargs = const {},
  ]) async {
    if (_uid == null) await _restore();
    return guardedXmlRpcCall(
      _call,
      _endpoint.resolve('/xmlrpc/2/object'),
      'execute_kw',
      [_db, _uid, _password, model, method, args, kwargs],
    );
  }

  Future<void> _restore() async {
    final saved = await _credentials.read();
    if (saved == null) {
      throw const OdooException(
        OdooErrorKind.sessionExpired,
        'Session expired',
      );
    }
    await authenticate(saved.database, saved.login, saved.password);
  }

  @override
  Future<void> logout() async {
    _db = null;
    _uid = null;
    _password = null;
  }
}
