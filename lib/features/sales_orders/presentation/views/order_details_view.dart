import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/l10n_x.dart';
import '../../../../core/presentation/view_status.dart';
import '../../../../core/responsive/window_size.dart';
import '../../../../core/widgets/skeleton_list.dart';
import '../../../../core/widgets/state_switcher.dart';
import '../../../../core/widgets/state_views.dart';
import '../../domain/entities/sale_order.dart';
import '../viewmodels/sale_order_details_state.dart';
import '../viewmodels/sale_order_details_view_model.dart';
import '../widgets/confirm_order_bar.dart';
import '../widgets/order_details_content.dart';
import '../widgets/order_hero.dart';

class OrderDetailsView extends StatelessWidget {
  const OrderDetailsView({super.key, this.preview});

  final SaleOrder? preview;

  @override
  Widget build(BuildContext context) {
    final vm = context.read<SaleOrderDetailsViewModel>();
    return BlocBuilder<SaleOrderDetailsViewModel, SaleOrderDetailsState>(
      builder: (context, state) {
        final order = state.details?.order ?? preview;
        final Widget body = switch (state.status) {
          ViewStatus.initial || ViewStatus.loading => const SkeletonList(
            key: ValueKey('loading'),
            itemCount: 4,
            showAvatar: false,
          ),
          ViewStatus.failure => ErrorView(
            key: const ValueKey('error'),
            failure: state.failure!,
            offlineBody: context.l10n.salesOfflineBody,
            onRetry: vm.load,
          ),
          ViewStatus.success => OrderDetailsContent(
            key: const ValueKey('data'),
            details: state.details!,
          ),
        };
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: context.windowSize.isCompact,
            title: order == null
                ? null
                : OrderNumberHero(
                    orderId: order.id,
                    number: order.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
          ),
          body: StateSwitcher(child: body),
          bottomNavigationBar: const ConfirmOrderBar(),
        );
      },
    );
  }
}
