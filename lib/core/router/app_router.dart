import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/viewmodels/auth_view_model.dart';
import '../../features/auth/presentation/views/login_view.dart';
import '../../features/settings/presentation/views/settings_view.dart';
import '../../features/shell/presentation/views/app_shell.dart';
import '../../features/shell/presentation/views/splash_view.dart';
import '../../features/shell/presentation/widgets/branch_container.dart';
import 'auth_guard.dart';
import 'customer_routes.dart';
import 'order_routes.dart';
import 'refresh_stream.dart';
import 'routes.dart';
import 'transitions.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

GoRouter createRouter(AuthViewModel auth) => GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: Routes.splash,
  refreshListenable: RefreshStream(auth.stream),
  redirect: (context, state) => authRedirect(auth.state, state.matchedLocation),
  routes: [
    GoRoute(
      path: Routes.splash,
      pageBuilder: (_, state) =>
          AppTransitions.fadeThrough(state, const SplashView()),
    ),
    GoRoute(
      path: Routes.login,
      pageBuilder: (_, state) =>
          AppTransitions.fadeThrough(state, const LoginView()),
    ),
    GoRoute(
      path: Routes.settings,
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (_, state) =>
          AppTransitions.sharedAxis(state, const SettingsView()),
    ),
    StatefulShellRoute(
      pageBuilder: (_, state, shell) =>
          AppTransitions.fadeThrough(state, AppShell(shell: shell)),
      navigatorContainerBuilder: (_, shell, children) =>
          BranchContainer(index: shell.currentIndex, children: children),
      branches: [
        StatefulShellBranch(routes: [customerRoutes()]),
        StatefulShellBranch(routes: [orderRoutes()]),
      ],
    ),
  ],
);
