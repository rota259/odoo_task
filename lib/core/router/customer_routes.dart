import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../features/customers/presentation/views/customer_details_page.dart';
import '../../features/customers/presentation/views/customers_home_page.dart';
import '../../features/customers/presentation/views/customers_pane.dart';
import 'routes.dart';
import 'transitions.dart';

/// `/customers` and `/customers/:id`, wrapped in a shell that shows the
/// list beside the details on medium/expanded screens.
RouteBase customerRoutes() => ShellRoute(
  builder: (_, state, child) => CustomersPane(
    selectedId: int.tryParse(state.pathParameters[Routes.idParam] ?? ''),
    child: child,
  ),
  routes: [
    GoRoute(
      path: Routes.customers,
      pageBuilder: (_, state) =>
          AppTransitions.fadeThrough(state, const CustomersHomePage()),
      routes: [
        GoRoute(
          path: ':${Routes.idParam}',
          pageBuilder: (_, state) {
            final id = int.parse(state.pathParameters[Routes.idParam]!);
            return AppTransitions.fadeThrough(
              state,
              CustomerDetailsPage(key: ValueKey(id), customerId: id),
            );
          },
        ),
      ],
    ),
  ],
);
