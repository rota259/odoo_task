import 'package:equatable/equatable.dart';

class AuthUser extends Equatable {
  const AuthUser({
    required this.uid,
    required this.name,
    required this.login,
    required this.database,
    required this.baseUrl,
    required this.isInternal,
  });

  final int uid;
  final String name;
  final String login;
  final String database;
  final String baseUrl;

  /// Member of `base.group_user` (employees). Portal users are not.
  final bool isInternal;

  @override
  List<Object?> get props => [uid, name, login, database, baseUrl, isInternal];
}
