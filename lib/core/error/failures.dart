import 'package:equatable/equatable.dart';

/// Domain-level errors returned in `Either<Failure, T>`.
///
/// Views translate them to localized text; [message] keeps the raw
/// server message (e.g. an Odoo validation error) when there is one.
sealed class Failure extends Equatable {
  const Failure([this.message]);

  final String? message;

  @override
  List<Object?> get props => [runtimeType, message];
}

/// Wrong login or password.
class InvalidCredentialsFailure extends Failure {
  const InvalidCredentialsFailure();
}

/// The configured database does not exist.
class DatabaseNotFoundFailure extends Failure {
  const DatabaseNotFoundFailure();
}

/// The server could not be reached.
class NetworkFailure extends Failure {
  const NetworkFailure([super.message]);
}

/// The device has no connection and no cached data can answer.
class OfflineFailure extends Failure {
  const OfflineFailure();
}

/// The session expired and silent re-authentication was impossible.
class SessionExpiredFailure extends Failure {
  const SessionExpiredFailure();
}

/// Odoo rejected the call; [message] is Odoo's own error text.
class ServerFailure extends Failure {
  const ServerFailure(String super.message);
}

/// Input rejected before reaching the server (e.g. malformed phone).
class ValidationFailure extends Failure {
  const ValidationFailure([super.message]);
}

/// Local storage problem.
class CacheFailure extends Failure {
  const CacheFailure([super.message]);
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message]);
}
