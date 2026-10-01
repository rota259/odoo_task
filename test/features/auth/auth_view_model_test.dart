import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:odoo_task/core/error/failures.dart';
import 'package:odoo_task/core/sync/sync_result.dart';
import 'package:odoo_task/features/auth/domain/usecases/auth_usecases.dart';
import 'package:odoo_task/features/auth/presentation/viewmodels/auth_state.dart';
import 'package:odoo_task/features/auth/presentation/viewmodels/auth_view_model.dart';

import '../../helpers/mocks.dart';
import 'auth_fixtures.dart';

void main() {
  late MockAuthRepository repo;
  late MockSyncService sync;

  setUpAll(registerFallbacks);
  setUp(() {
    repo = MockAuthRepository();
    sync = MockSyncService();
    when(() => sync.flush()).thenAnswer((_) async => SyncResult.empty);
  });

  AuthViewModel build() => AuthViewModel(
    login: LoginUseCase(repo),
    restoreSession: RestoreSessionUseCase(repo),
    logout: LogoutUseCase(repo),
    sync: sync,
  );

  blocTest<AuthViewModel, AuthState>(
    'successful login authenticates and flushes the offline queue',
    setUp: () => when(
      () => repo.login(any()),
    ).thenAnswer((_) async => const Right(authUser)),
    build: build,
    act: (vm) => vm.login(authRequest),
    expect: () => [
      const AuthState(status: AuthStatus.unknown, isSubmitting: true),
      const AuthState(status: AuthStatus.authenticated, user: authUser),
    ],
    verify: (_) => verify(() => sync.flush()).called(1),
  );

  blocTest<AuthViewModel, AuthState>(
    'failed login keeps the user on the form with the failure',
    setUp: () => when(
      () => repo.login(any()),
    ).thenAnswer((_) async => const Left(InvalidCredentialsFailure())),
    build: build,
    act: (vm) => vm.login(authRequest),
    skip: 1,
    expect: () => [const AuthState(failure: InvalidCredentialsFailure())],
  );

  blocTest<AuthViewModel, AuthState>(
    'restore without credentials -> unauthenticated',
    setUp: () => when(
      () => repo.restoreSession(),
    ).thenAnswer((_) async => const Right(null)),
    build: build,
    act: (vm) => vm.restore(),
    expect: () => [const AuthState(status: AuthStatus.unauthenticated)],
  );

  blocTest<AuthViewModel, AuthState>(
    'restore with a valid session -> authenticated (auto-login)',
    setUp: () => when(
      () => repo.restoreSession(),
    ).thenAnswer((_) async => const Right(authUser)),
    build: build,
    act: (vm) => vm.restore(),
    expect: () => [
      const AuthState(status: AuthStatus.authenticated, user: authUser),
    ],
  );

  blocTest<AuthViewModel, AuthState>(
    'logout clears everything',
    setUp: () => when(() => repo.logout()).thenAnswer((_) async {}),
    build: build,
    seed: () =>
        const AuthState(status: AuthStatus.authenticated, user: authUser),
    act: (vm) => vm.logout(),
    expect: () => [const AuthState(status: AuthStatus.unauthenticated)],
    verify: (_) => verify(() => repo.logout()).called(1),
  );
}
