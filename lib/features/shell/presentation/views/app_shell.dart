import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/responsive/window_size.dart';
import '../../../auth/presentation/viewmodels/auth_view_model.dart';
import '../../../customers/presentation/viewmodels/customer_list_view_model.dart';
import '../../../sales_orders/presentation/viewmodels/sales_orders_view_model.dart';
import '../widgets/app_navigation.dart';

/// Signed-in scaffold: owns the list ViewModels (so they survive navigation
/// between list and details) and the adaptive navigation chrome.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    final isInternal = context.select(
      (AuthViewModel vm) => vm.state.isInternal,
    );
    final compact = context.windowSize.isCompact;
    final destinations = AppDestinations(isInternal: isInternal);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<CustomerListViewModel>()..load()),
        BlocProvider(create: (_) => getIt<SalesOrdersViewModel>()..load()),
      ],
      child: Scaffold(
        body: compact
            ? shell
            : Row(
                children: [
                  AppNavRail(shell: shell, destinations: destinations),
                  const VerticalDivider(width: 1),
                  Expanded(child: shell),
                ],
              ),
        bottomNavigationBar: compact && isInternal
            ? AppBottomNav(shell: shell, destinations: destinations)
            : null,
      ),
    );
  }
}
