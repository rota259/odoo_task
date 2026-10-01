import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/widgets/staggered_entry.dart';
import '../../domain/repositories/sale_order_repository.dart';
import '../viewmodels/sales_orders_state.dart';
import 'order_tile.dart';

class OrdersListContent extends StatefulWidget {
  const OrdersListContent({
    super.key,
    required this.state,
    required this.onLoadMore,
    this.selectedId,
  });

  static const loadMoreThreshold = 400.0;

  final SalesOrdersState state;
  final VoidCallback onLoadMore;
  final int? selectedId;

  @override
  State<OrdersListContent> createState() => _OrdersListContentState();
}

class _OrdersListContentState extends State<OrdersListContent> {
  final _seen = <int>{};

  bool _onScroll(ScrollNotification n) {
    if (n.metrics.extentAfter < OrdersListContent.loadMoreThreshold) {
      widget.onLoadMore();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final orders = widget.state.orders;
    final loader = widget.state.isLoadingMore;
    return NotificationListener<ScrollNotification>(
      onNotification: _onScroll,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsetsDirectional.all(AppDimens.lg),
        itemCount: orders.length + (loader ? 1 : 0),
        separatorBuilder: (_, _) => const SizedBox(height: AppDimens.md),
        itemBuilder: (context, index) {
          if (index >= orders.length) {
            return const Padding(
              padding: EdgeInsetsDirectional.all(AppDimens.lg),
              child: Center(child: CircularProgressIndicator(strokeWidth: 2.4)),
            );
          }
          final order = orders[index];
          return StaggeredEntry(
            index: index,
            animate:
                index < SaleOrderRepository.pageSize && _seen.add(order.id),
            child: OrderTile(
              order: order,
              selected: order.id == widget.selectedId,
              onTap: () => context.go(Routes.order(order.id)),
            ),
          );
        },
      ),
    );
  }
}
