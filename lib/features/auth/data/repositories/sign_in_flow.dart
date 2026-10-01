import '../../../../core/network/odoo_endpoint.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/entities/login_request.dart';
import '../datasources/auth_remote_data_source.dart';

/// Points the client at the requested server, authenticates and resolves
/// the user's profile (name + internal/portal).
class SignInFlow {
  SignInFlow(this._remote, this._endpoint);

  final AuthRemoteDataSource _remote;
  final OdooEndpoint _endpoint;

  Future<AuthUser> call(LoginRequest request) async {
    _endpoint.update(baseUrl: request.baseUrl, database: request.database);
    final db = _endpoint.database;
    final session = await _remote.authenticate(
      db,
      request.login,
      request.password,
    );
    final isInternal = await _remote.isInternalUser();
    final name = session.name ?? await _remote.userName(session.uid);
    return AuthUser(
      uid: session.uid,
      name: name ?? request.login,
      login: request.login,
      database: db,
      baseUrl: _endpoint.baseUrl,
      isInternal: isInternal,
    );
  }
}
