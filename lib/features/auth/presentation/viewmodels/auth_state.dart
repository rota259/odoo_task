import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/auth_user.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.unknown,
    this.user,
    this.isSubmitting = false,
    this.failure,
  });

  final AuthStatus status;
  final AuthUser? user;

  /// A login request is in flight.
  final bool isSubmitting;

  /// Last login / restore failure, shown on the login screen.
  final Failure? failure;

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isInternal => user?.isInternal ?? false;

  AuthState copyWith({
    AuthStatus? status,
    AuthUser? Function()? user,
    bool? isSubmitting,
    Failure? Function()? failure,
  }) => AuthState(
    status: status ?? this.status,
    user: user != null ? user() : this.user,
    isSubmitting: isSubmitting ?? this.isSubmitting,
    failure: failure != null ? failure() : this.failure,
  );

  @override
  List<Object?> get props => [status, user, isSubmitting, failure];
}
