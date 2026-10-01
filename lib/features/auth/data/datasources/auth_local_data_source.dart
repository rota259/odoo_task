import 'package:hive_ce/hive.dart';

import '../../domain/entities/auth_user.dart';
import '../models/auth_user_model.dart';

/// Last signed-in profile, used to auto-login while offline.
class AuthLocalDataSource {
  AuthLocalDataSource(this._box);

  static const boxName = 'session';
  static const _userKey = 'user';
  final Box<Map<dynamic, dynamic>> _box;

  AuthUser? readUser() => AuthUserModel.fromCache(_box.get(_userKey));

  Future<void> saveUser(AuthUser user) => _box.put(_userKey, user.toCache());

  Future<void> clear() => _box.clear();
}
