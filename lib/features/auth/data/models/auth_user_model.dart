import '../../domain/entities/auth_user.dart';

/// Cache (Hive) representation of [AuthUser].
extension AuthUserModel on AuthUser {
  Map<String, dynamic> toCache() => {
    'uid': uid,
    'name': name,
    'login': login,
    'database': database,
    'baseUrl': baseUrl,
    'isInternal': isInternal,
  };

  static AuthUser? fromCache(Map<dynamic, dynamic>? map) {
    if (map == null || map['uid'] is! int) return null;
    return AuthUser(
      uid: map['uid'] as int,
      name: map['name'] as String? ?? '',
      login: map['login'] as String? ?? '',
      database: map['database'] as String? ?? '',
      baseUrl: map['baseUrl'] as String? ?? '',
      isInternal: map['isInternal'] == true,
    );
  }
}
