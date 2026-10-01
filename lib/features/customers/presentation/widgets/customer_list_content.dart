import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/widgets/staggered_entry.dart';
import '../../domain/repositories/customer_repository.dart';
import '../viewmodels/customer_list_state.dart';
import 'customer_tile.dart';

/// Scrollable customers with infinite scroll.
class CustomerListContent extends StatefulWidget {
  const CustomerListContent({
    super.key,
    required this.state,
    required this.onLoadMore,
    this.selectedId,
  });

  static const loadMoreThreshold = 400.0;

  final CustomerListState state;
  final VoidCallback onLoadMore;
  final int? selectedId;

  @override
  State<CustomerListContent> createState() => _CustomerListContentState();
}

class _CustomerListContentState extends State<CustomerListContent> {
  /// Ids already animated in; rows re-built on scroll do not animate again.
  final _seen = <int>{};

  bool _onScroll(ScrollNotification n) {
    if (n.metrics.extentAfter < CustomerListContent.loadMoreThreshold) {
      widget.onLoadMore();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final customers = widget.state.customers;
    final showLoader = widget.state.isLoadingMore;
    return NotificationListener<ScrollNotification>(
      onNotification: _onScroll,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsetsDirectional.all(AppDimens.lg),
        itemCount: customers.length + (showLoader ? 1 : 0),
        separatorBuilder: (_, _) => const SizedBox(height: AppDimens.md),
        itemBuilder: (context, index) {
          if (index >= customers.length) return const _LoadingMore();
          final customer = customers[index];
          final firstPage = index < CustomerRepository.pageSize;
          return StaggeredEntry(
            index: index,
            animate: firstPage && _seen.add(customer.id),
            child: CustomerTile(
              customer: customer,
              selected: customer.id == widget.selectedId,
              onTap: () => context.go(Routes.customer(customer.id)),
            ),
          );
        },
      ),
    );
  }
}

class _LoadingMore extends StatelessWidget {
  const _LoadingMore();

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsetsDirectional.all(AppDimens.lg),
    child: Center(
      child: SizedBox.square(
        dimension: 24,
        child: CircularProgressIndicator(strokeWidth: 2.4),
      ),
    ),
  );
}
