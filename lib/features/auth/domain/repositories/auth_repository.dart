import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/auth_user.dart';
import '../entities/login_request.dart';

abstract interface class AuthRepository {
  /// Authenticates, resolves whether the user is internal and stores the
  /// credentials securely for silent re-authentication.
  Future<Either<Failure, AuthUser>> login(LoginRequest request);

  /// Signs in again with stored credentials. `Right(null)` when there are
  /// none. Offline, falls back to the last known profile.
  Future<Either<Failure, AuthUser?>> restoreSession();

  /// Clears the server session, credentials and every local cache.
  Future<void> logout();
}
