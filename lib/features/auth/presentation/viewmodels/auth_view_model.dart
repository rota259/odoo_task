import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/sync/sync_service.dart';
import '../../domain/entities/login_request.dart';
import '../../domain/usecases/auth_usecases.dart';
import 'auth_state.dart';

/// App-wide authentication ViewModel; the router guard listens to it.
class AuthViewModel extends Cubit<AuthState> {
  AuthViewModel({
    required LoginUseCase login,
    required RestoreSessionUseCase restoreSession,
    required LogoutUseCase logout,
    required SyncService sync,
  }) : _login = login,
       _restoreSession = restoreSession,
       _logout = logout,
       _sync = sync,
       super(const AuthState());

  final LoginUseCase _login;
  final RestoreSessionUseCase _restoreSession;
  final LogoutUseCase _logout;
  final SyncService _sync;

  /// Auto-login on app start.
  Future<void> restore() async {
    final result = await _restoreSession();
    result.match(
      (failure) =>
          emit(AuthState(status: AuthStatus.unauthenticated, failure: failure)),
      (user) {
        if (user == null) {
          return emit(const AuthState(status: AuthStatus.unauthenticated));
        }
        emit(AuthState(status: AuthStatus.authenticated, user: user));
        unawaited(_sync.flush());
      },
    );
  }

  Future<void> login(LoginRequest request) async {
    if (state.isSubmitting) return;
    emit(state.copyWith(isSubmitting: true, failure: () => null));
    final result = await _login(request);
    result.match(
      (failure) =>
          emit(state.copyWith(isSubmitting: false, failure: () => failure)),
      (user) {
        emit(AuthState(status: AuthStatus.authenticated, user: user));
        unawaited(_sync.flush());
      },
    );
  }

  Future<void> logout() async {
    await _logout();
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }

  void clearError() {
    if (state.failure != null) emit(state.copyWith(failure: () => null));
  }
}
