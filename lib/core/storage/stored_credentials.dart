import 'package:equatable/equatable.dart';

class StoredCredentials extends Equatable {
  const StoredCredentials({
    required this.baseUrl,
    required this.database,
    required this.login,
    required this.password,
  });

  factory StoredCredentials.fromJson(Map<String, dynamic> json) =>
      StoredCredentials(
        baseUrl: json['baseUrl'] as String,
        database: json['database'] as String,
        login: json['login'] as String,
        password: json['password'] as String,
      );

  final String baseUrl;
  final String database;
  final String login;
  final String password;

  Map<String, dynamic> toJson() => {
    'baseUrl': baseUrl,
    'database': database,
    'login': login,
    'password': password,
  };

  @override
  List<Object?> get props => [baseUrl, database, login, password];
}
