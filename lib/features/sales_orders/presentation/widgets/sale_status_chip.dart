import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_x.dart';
import '../../../../core/motion/motion_x.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_palette.dart';
import '../../domain/entities/sale_order_state.dart';
import 'sale_state_x.dart';

/// Colored status chip; animates color and label when the state changes
/// (e.g. Quotation -> Sales Order after confirming).
class SaleStatusChip extends StatelessWidget {
  const SaleStatusChip({super.key, required this.state});

  static const _duration = Duration(milliseconds: 400);
  final SaleOrderState state;

  @override
  Widget build(BuildContext context) {
    final tone = state.tone(context.palette);
    final duration = context.motion(_duration);
    final label = state.label(context.l10n);
    return AnimatedContainer(
      duration: duration,
      curve: Curves.easeOutCubic,
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppDimens.md,
        vertical: AppDimens.xs,
      ),
      decoration: BoxDecoration(
        color: tone.background,
        borderRadius: BorderRadius.circular(AppDimens.chipRadius),
      ),
      child: AnimatedSize(
        duration: duration,
        child: AnimatedSwitcher(
          duration: duration,
          child: Text(
            label,
            key: ValueKey(state),
            maxLines: 1,
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(color: tone.foreground),
          ),
        ),
      ),
    );
  }
}
