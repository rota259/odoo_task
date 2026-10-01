import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/auth_user.dart';
import '../entities/login_request.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  const LoginUseCase(this._repository);
  final AuthRepository _repository;

  Future<Either<Failure, AuthUser>> call(LoginRequest request) =>
      _repository.login(request);
}

class RestoreSessionUseCase {
  const RestoreSessionUseCase(this._repository);
  final AuthRepository _repository;

  Future<Either<Failure, AuthUser?>> call() => _repository.restoreSession();
}

class LogoutUseCase {
  const LogoutUseCase(this._repository);
  final AuthRepository _repository;

  Future<void> call() => _repository.logout();
}
