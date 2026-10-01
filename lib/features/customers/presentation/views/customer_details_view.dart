import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/l10n_x.dart';
import '../../../../core/presentation/view_status.dart';
import '../../../../core/responsive/window_size.dart';
import '../../../../core/widgets/offline_banner.dart';
import '../../../../core/widgets/skeleton_list.dart';
import '../../../../core/widgets/state_switcher.dart';
import '../../../../core/widgets/state_views.dart';
import '../../domain/entities/customer.dart';
import '../viewmodels/customer_details_state.dart';
import '../viewmodels/customer_details_view_model.dart';
import '../widgets/customer_details_content.dart';
import '../widgets/customer_header.dart';
import '../widgets/phone_save_listener.dart';

class CustomerDetailsView extends StatelessWidget {
  const CustomerDetailsView({super.key, this.preview});

  /// Row from the list, shown while the full record loads.
  final Customer? preview;

  @override
  Widget build(BuildContext context) {
    final vm = context.read<CustomerDetailsViewModel>();
    return PhoneSaveListener(
      child: BlocBuilder<CustomerDetailsViewModel, CustomerDetailsState>(
        builder: (context, state) {
          final details = state.details;
          final Widget body = switch (state.status) {
            ViewStatus.initial || ViewStatus.loading => const SkeletonList(
              key: ValueKey('loading'),
              itemCount: 3,
              showAvatar: false,
            ),
            ViewStatus.failure => ErrorView(
              key: const ValueKey('error'),
              failure: state.failure!,
              onRetry: vm.load,
            ),
            ViewStatus.success => CustomerDetailsContent(
              key: const ValueKey('data'),
              details: details!,
            ),
          };
          return Scaffold(
            appBar: AppBar(
              // Split view: the list is beside us, no back arrow needed.
              automaticallyImplyLeading: context.windowSize.isCompact,
              title: Text(context.l10n.customerDetails),
            ),
            body: Column(
              children: [
                OfflineBanner(visible: state.isOffline),
                CustomerHeader(
                  id: vm.customerId,
                  name: details?.name ?? preview?.name,
                  pending:
                      details?.hasPendingSync ??
                      preview?.hasPendingSync ??
                      false,
                ),
                Expanded(child: StateSwitcher(child: body)),
              ],
            ),
          );
        },
      ),
    );
  }
}
