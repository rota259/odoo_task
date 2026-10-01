import 'package:equatable/equatable.dart';

class LoginRequest extends Equatable {
  const LoginRequest({
    required this.baseUrl,
    required this.database,
    required this.login,
    required this.password,
  });

  final String baseUrl;
  final String database;
  final String login;
  final String password;

  @override
  List<Object?> get props => [baseUrl, database, login, password];
}
