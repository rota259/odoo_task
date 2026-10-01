import 'package:flutter_test/flutter_test.dart';
import 'package:odoo_task/core/router/auth_guard.dart';
import 'package:odoo_task/core/router/routes.dart';
import 'package:odoo_task/features/auth/domain/entities/auth_user.dart';
import 'package:odoo_task/features/auth/presentation/viewmodels/auth_state.dart';

AuthState _signedIn({required bool internal}) => AuthState(
  status: AuthStatus.authenticated,
  user: AuthUser(
    uid: 1,
    name: 'n',
    login: 'l',
    database: 'd',
    baseUrl: 'u',
    isInternal: internal,
  ),
);

void main() {
  test('unknown session waits on the splash', () {
    expect(authRedirect(const AuthState(), Routes.customers), Routes.splash);
    expect(authRedirect(const AuthState(), Routes.splash), isNull);
  });

  test('signed out users are sent to login', () {
    const out = AuthState(status: AuthStatus.unauthenticated);
    expect(authRedirect(out, Routes.orders), Routes.login);
    expect(authRedirect(out, Routes.login), isNull);
  });

  test('signed in users leave login/splash for customers', () {
    final s = _signedIn(internal: false);
    expect(authRedirect(s, Routes.login), Routes.customers);
    expect(authRedirect(s, Routes.splash), Routes.customers);
    expect(authRedirect(s, Routes.customer(4)), isNull);
  });

  test('portal (non-internal) users can never reach sales orders', () {
    final portal = _signedIn(internal: false);
    expect(authRedirect(portal, Routes.orders), Routes.customers);
    expect(authRedirect(portal, Routes.order(3)), Routes.customers);
  });

  test('internal users can open sales orders', () {
    final internal = _signedIn(internal: true);
    expect(authRedirect(internal, Routes.orders), isNull);
    expect(authRedirect(internal, Routes.order(3)), isNull);
  });

  test('look-alike paths are not treated as orders', () {
    expect(authRedirect(_signedIn(internal: false), '/ordersx'), isNull);
  });
}
