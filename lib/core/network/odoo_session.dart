import 'package:equatable/equatable.dart';

import 'odoo_parsing.dart';

/// Result of a successful authentication.
class OdooSession extends Equatable {
  const OdooSession({
    required this.uid,
    required this.database,
    required this.login,
    this.name,
    this.isInternal,
  });

  /// Builds a session from `/web/session/authenticate`'s `result`.
  factory OdooSession.fromJsonRpc(Map result, {required String login}) =>
      OdooSession(
        uid: result['uid'] as int,
        database: OdooParsing.string(result['db']) ?? '',
        login: OdooParsing.string(result['username']) ?? login,
        name: OdooParsing.string(result['name']),
        isInternal: result['is_internal_user'] is bool
            ? result['is_internal_user'] as bool
            : null,
      );

  final int uid;
  final String database;
  final String login;

  /// Display name, when the transport returns it (JSON-RPC does).
  final String? name;

  /// Hint from the transport; the app still asks `has_group` explicitly.
  final bool? isInternal;

  @override
  List<Object?> get props => [uid, database, login, name, isInternal];
}
