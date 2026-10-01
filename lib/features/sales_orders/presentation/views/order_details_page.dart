import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../viewmodels/sale_order_details_view_model.dart';
import '../viewmodels/sales_orders_view_model.dart';
import 'order_details_view.dart';

/// Route entry for `/orders/:id`.
class OrderDetailsPage extends StatelessWidget {
  const OrderDetailsPage({super.key, required this.orderId});

  final int orderId;

  @override
  Widget build(BuildContext context) {
    // Lets the order number Hero land before the full record loads.
    final preview = context
        .read<SalesOrdersViewModel>()
        .state
        .orders
        .where((o) => o.id == orderId)
        .firstOrNull;
    return BlocProvider(
      create: (_) => getIt<SaleOrderDetailsViewModel>(param1: orderId)..load(),
      child: OrderDetailsView(preview: preview),
    );
  }
}
