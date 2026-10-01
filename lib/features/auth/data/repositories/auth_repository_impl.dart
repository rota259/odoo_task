import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/odoo_endpoint.dart';
import '../../../../core/storage/credentials_store.dart';
import '../../../../core/storage/local_data_cleaner.dart';
import '../../../../core/storage/stored_credentials.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/entities/login_request.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';
import 'sign_in_flow.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remote,
    required AuthLocalDataSource local,
    required CredentialsStore credentials,
    required OdooEndpoint endpoint,
    required List<LocalDataCleaner> cleaners,
  }) : _remote = remote,
       _signIn = SignInFlow(remote, endpoint),
       _local = local,
       _credentials = credentials,
       _cleaners = cleaners;

  final AuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;
  final CredentialsStore _credentials;
  final SignInFlow _signIn;
  final List<LocalDataCleaner> _cleaners;

  @override
  Future<Either<Failure, AuthUser>> login(LoginRequest request) async {
    final previous = _local.readUser();
    final result = await guard(() => _signIn(request));
    final user = result.toNullable();
    if (user == null) return result;
    final sameAccount =
        previous?.login == user.login && previous?.database == user.database;
    if (previous != null && !sameAccount) await _clearLocalData();
    await _credentials.save(
      StoredCredentials(
        baseUrl: user.baseUrl,
        database: user.database,
        login: request.login,
        password: request.password,
      ),
    );
    await _local.saveUser(user);
    return result;
  }

  @override
  Future<Either<Failure, AuthUser?>> restoreSession() async {
    final saved = await _credentials.read();
    if (saved == null) return const Right(null);
    final request = LoginRequest(
      baseUrl: saved.baseUrl,
      database: saved.database,
      login: saved.login,
      password: saved.password,
    );
    final result = await guard(() => _signIn(request));
    final user = result.toNullable();
    if (user != null) {
      await _local.saveUser(user);
      return Right(user);
    }
    final failure = result.getLeft().toNullable()!;
    final cached = _local.readUser();
    // Offline start: trust the last profile; requests re-auth when online.
    if (failure is NetworkFailure && cached != null) return Right(cached);
    return Left(failure);
  }

  @override
  Future<void> logout() async {
    await _remote.logout();
    await _credentials.clear();
    await _clearLocalData();
  }

  Future<void> _clearLocalData() async {
    await _local.clear();
    for (final cleaner in _cleaners) {
      await cleaner.clearLocalData();
    }
  }
}
