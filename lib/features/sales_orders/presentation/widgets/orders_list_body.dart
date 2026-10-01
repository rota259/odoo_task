import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/l10n_x.dart';
import '../../../../core/presentation/view_status.dart';
import '../../../../core/widgets/skeleton_list.dart';
import '../../../../core/widgets/state_switcher.dart';
import '../../../../core/widgets/state_views.dart';
import '../viewmodels/sales_orders_state.dart';
import '../viewmodels/sales_orders_view_model.dart';
import 'orders_list_content.dart';

class OrdersListBody extends StatelessWidget {
  const OrdersListBody({super.key, this.selectedId});

  final int? selectedId;

  @override
  Widget build(BuildContext context) {
    final vm = context.read<SalesOrdersViewModel>();
    return BlocBuilder<SalesOrdersViewModel, SalesOrdersState>(
      builder: (context, state) {
        final l10n = context.l10n;
        final Widget child = switch (state.status) {
          ViewStatus.initial || ViewStatus.loading => const SkeletonList(
            key: ValueKey('loading'),
            showAvatar: false,
          ),
          ViewStatus.failure => ErrorView(
            key: ValueKey(state.isOffline ? 'offline' : 'error'),
            failure: state.failure!,
            offlineBody: l10n.salesOfflineBody,
            onRetry: vm.load,
          ),
          ViewStatus.success when state.orders.isEmpty => EmptyView(
            key: const ValueKey('empty'),
            icon: Icons.receipt_long_outlined,
            title: l10n.noOrders,
          ),
          ViewStatus.success => OrdersListContent(
            key: const ValueKey('data'),
            state: state,
            selectedId: selectedId,
            onLoadMore: vm.loadMore,
          ),
        };
        return RefreshIndicator(
          onRefresh: vm.refresh,
          child: StateSwitcher(child: child),
        );
      },
    );
  }
}
