import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/l10n_x.dart';
import '../../../../core/presentation/view_status.dart';
import '../../../../core/widgets/skeleton_list.dart';
import '../../../../core/widgets/state_switcher.dart';
import '../../../../core/widgets/state_views.dart';
import '../viewmodels/customer_list_state.dart';
import '../viewmodels/customer_list_view_model.dart';
import 'customer_list_content.dart';

/// Loading / error / empty / data states of the customer list.
class CustomerListBody extends StatelessWidget {
  const CustomerListBody({super.key, this.selectedId});

  final int? selectedId;

  @override
  Widget build(BuildContext context) {
    final vm = context.read<CustomerListViewModel>();
    return BlocBuilder<CustomerListViewModel, CustomerListState>(
      builder: (context, state) {
        final l10n = context.l10n;
        final Widget child = switch (state.status) {
          ViewStatus.initial ||
          ViewStatus.loading => const SkeletonList(key: ValueKey('loading')),
          ViewStatus.failure => ErrorView(
            key: const ValueKey('error'),
            failure: state.failure!,
            onRetry: vm.load,
          ),
          ViewStatus.success when state.customers.isEmpty => EmptyView(
            key: const ValueKey('empty'),
            icon: Icons.person_search_outlined,
            title: l10n.noCustomers,
            body: l10n.noCustomersHint,
          ),
          ViewStatus.success => CustomerListContent(
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
