import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../features/sales_orders/presentation/views/order_details_page.dart';
import '../../features/sales_orders/presentation/views/orders_home_page.dart';
import '../../features/sales_orders/presentation/views/orders_pane.dart';
import 'routes.dart';
import 'transitions.dart';

/// `/orders` and `/orders/:id` (internal users only, see `authRedirect`).
RouteBase orderRoutes() => ShellRoute(
  builder: (_, state, child) => OrdersPane(
    selectedId: int.tryParse(state.pathParameters[Routes.idParam] ?? ''),
    child: child,
  ),
  routes: [
    GoRoute(
      path: Routes.orders,
      pageBuilder: (_, state) =>
          AppTransitions.fadeThrough(state, const OrdersHomePage()),
      routes: [
        GoRoute(
          path: ':${Routes.idParam}',
          pageBuilder: (_, state) {
            final id = int.parse(state.pathParameters[Routes.idParam]!);
            return AppTransitions.fadeThrough(
              state,
              OrderDetailsPage(key: ValueKey(id), orderId: id),
            );
          },
        ),
      ],
    ),
  ],
);
