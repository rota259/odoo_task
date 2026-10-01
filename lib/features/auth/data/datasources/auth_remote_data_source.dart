import '../../../../core/network/odoo_client.dart';
import '../../../../core/network/odoo_session.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource(this._client);

  static const internalGroup = 'base.group_user';
  final OdooClient _client;

  Future<OdooSession> authenticate(String db, String login, String password) =>
      _client.authenticate(db, login, password);

  /// `res.users.has_group` is an `@api.model` method in Odoo 17: it takes
  /// only the group xml id and checks the *current* user.
  Future<bool> isInternalUser() async {
    final result = await _client.callMethod('res.users', 'has_group', [
      internalGroup,
    ]);
    return result == true;
  }

  /// Display name of the current user (XML-RPC does not return it on login).
  Future<String?> userName(int uid) async {
    final rows = await _client.read('res.users', [uid], ['name']);
    final name = rows.isEmpty ? null : rows.first['name'];
    return name is String ? name : null;
  }

  Future<void> logout() => _client.logout();
}
