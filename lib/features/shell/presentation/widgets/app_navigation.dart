import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n_x.dart';
import '../../../../core/router/routes.dart';

/// Branch indexes match the order in `createRouter`.
class AppDestinations {
  const AppDestinations({required this.isInternal});

  static const customers = 0;
  static const orders = 1;
  final bool isInternal;

  /// Sales Orders only exist for internal users.
  int get settingsRailIndex => isInternal ? 2 : 1;
}

void _goBranch(StatefulNavigationShell shell, int index) => shell.goBranch(
  index,
  // Tapping the active destination pops back to its root.
  initialLocation: index == shell.currentIndex,
);

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.shell,
    required this.destinations,
  });

  final StatefulNavigationShell shell;
  final AppDestinations destinations;

  @override
  Widget build(BuildContext context) => NavigationBar(
    selectedIndex: shell.currentIndex,
    onDestinationSelected: (i) => _goBranch(shell, i),
    destinations: [
      NavigationDestination(
        icon: const Icon(Icons.people_outline_rounded),
        selectedIcon: const Icon(Icons.people_rounded),
        label: context.l10n.customers,
      ),
      NavigationDestination(
        icon: const Icon(Icons.receipt_long_outlined),
        selectedIcon: const Icon(Icons.receipt_long_rounded),
        label: context.l10n.salesOrders,
      ),
    ],
  );
}

class AppNavRail extends StatelessWidget {
  const AppNavRail({
    super.key,
    required this.shell,
    required this.destinations,
  });

  final StatefulNavigationShell shell;
  final AppDestinations destinations;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SafeArea(
      child: NavigationRail(
        selectedIndex: shell.currentIndex,
        labelType: NavigationRailLabelType.all,
        scrollable: true,
        onDestinationSelected: (i) => i == destinations.settingsRailIndex
            ? context.push(Routes.settings)
            : _goBranch(shell, i),
        destinations: [
          NavigationRailDestination(
            icon: const Icon(Icons.people_outline_rounded),
            selectedIcon: const Icon(Icons.people_rounded),
            label: Text(l10n.customers),
          ),
          if (destinations.isInternal)
            NavigationRailDestination(
              icon: const Icon(Icons.receipt_long_outlined),
              selectedIcon: const Icon(Icons.receipt_long_rounded),
              label: Text(l10n.salesOrders),
            ),
          NavigationRailDestination(
            icon: const Icon(Icons.settings_outlined),
            label: Text(l10n.settings),
          ),
        ],
      ),
    );
  }
}
