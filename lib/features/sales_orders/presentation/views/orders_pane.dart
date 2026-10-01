import 'package:flutter/material.dart';

import '../../../../core/responsive/master_detail_layout.dart';
import 'orders_list_view.dart';

/// Shell of the orders branch (list beside details on larger screens).
class OrdersPane extends StatelessWidget {
  const OrdersPane({super.key, required this.child, this.selectedId});

  final Widget child;
  final int? selectedId;

  @override
  Widget build(BuildContext context) => MasterDetailLayout(
    master: OrdersListView(selectedId: selectedId),
    detail: child,
  );
}
