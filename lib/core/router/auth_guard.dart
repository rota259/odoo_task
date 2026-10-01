import '../../features/auth/presentation/viewmodels/auth_state.dart';
import 'routes.dart';

/// Pure redirect logic for go_router (unit-testable).
///
/// - unknown session  -> splash
/// - signed out       -> login
/// - signed in        -> away from splash/login
/// - non-internal     -> never reaches Sales Orders
String? authRedirect(AuthState auth, String location) {
  final atSplash = location == Routes.splash;
  final atLogin = location == Routes.login;
  switch (auth.status) {
    case AuthStatus.unknown:
      return atSplash ? null : Routes.splash;
    case AuthStatus.unauthenticated:
      return atLogin ? null : Routes.login;
    case AuthStatus.authenticated:
      if (atSplash || atLogin) return Routes.customers;
      final wantsOrders =
          location == Routes.orders || location.startsWith('${Routes.orders}/');
      if (wantsOrders && !auth.isInternal) return Routes.customers;
      return null;
  }
}
