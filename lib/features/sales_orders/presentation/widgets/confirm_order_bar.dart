import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/l10n_x.dart';
import '../../../../core/motion/motion_x.dart';
import '../../../../core/presentation/view_status.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/snackbars.dart';
import '../viewmodels/sale_order_details_state.dart';
import '../viewmodels/sale_order_details_view_model.dart';

/// "Confirm order" action, only for quotations (draft / sent). Slides away
/// once the order is confirmed.
class ConfirmOrderBar extends StatelessWidget {
  const ConfirmOrderBar({super.key});

  Future<void> _confirm(BuildContext context, String number) async {
    final l10n = context.l10n;
    final vm = context.read<SaleOrderDetailsViewModel>();
    final ok = await showConfirmDialog(
      context,
      title: l10n.confirmOrderTitle,
      body: l10n.confirmOrderBody(number),
      confirmLabel: l10n.confirmOrder,
    );
    if (ok) await vm.confirm();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SaleOrderDetailsViewModel, SaleOrderDetailsState>(
      listenWhen: (a, b) => a.confirmStatus != b.confirmStatus,
      listener: (context, state) {
        final l10n = context.l10n;
        if (state.confirmStatus == ActionStatus.success) {
          context.showSnack(l10n.orderConfirmed, icon: Icons.verified_rounded);
        } else if (state.confirmStatus == ActionStatus.failure) {
          context.showSnack(
            state.confirmFailure!.describe(l10n),
            icon: Icons.error_outline_rounded,
          );
        }
      },
      builder: (context, state) {
        final details = state.details;
        final running = state.confirmStatus == ActionStatus.running;
        final visible = details != null && (state.canConfirm || running);
        return AnimatedSize(
          duration: context.motion(AppDimens.switchDuration),
          curve: Curves.easeOutCubic,
          child: !visible
              ? const SizedBox(width: double.infinity)
              : SafeArea(
                  minimum: const EdgeInsets.all(AppDimens.lg),
                  child: Center(
                    heightFactor: 1,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: AppDimens.loginMaxWidth,
                      ),
                      child: PrimaryButton(
                        key: const Key('confirm_order'),
                        label: context.l10n.confirmOrder,
                        icon: Icons.task_alt_rounded,
                        status: state.confirmStatus,
                        onPressed: () => _confirm(context, details.order.name),
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }
}
