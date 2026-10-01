import 'package:fpdart/fpdart.dart';

import '../network/odoo_exception.dart';
import 'failures.dart';

abstract final class FailureMapper {
  static Failure fromException(Object error) => switch (error) {
    OdooException(kind: OdooErrorKind.accessDenied) =>
      const InvalidCredentialsFailure(),
    OdooException(kind: OdooErrorKind.databaseNotFound) =>
      const DatabaseNotFoundFailure(),
    OdooException(kind: OdooErrorKind.sessionExpired) =>
      const SessionExpiredFailure(),
    OdooException(kind: OdooErrorKind.network, :final message) =>
      NetworkFailure(message),
    // A transport error that survived the XML-RPC fallback means the URL
    // does not point at an Odoo server: report it as unreachable.
    OdooException(kind: OdooErrorKind.transport, :final message) =>
      NetworkFailure(message),
    OdooException(kind: OdooErrorKind.server, :final message) => ServerFailure(
      message,
    ),
    _ => UnexpectedFailure(error.toString()),
  };
}

/// Runs [action] and converts thrown exceptions into a [Failure].
Future<Either<Failure, T>> guard<T>(Future<T> Function() action) async {
  try {
    return Right(await action());
  } on Object catch (e) {
    return Left(FailureMapper.fromException(e));
  }
}
