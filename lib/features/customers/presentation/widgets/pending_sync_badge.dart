import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_x.dart';
import '../../../../core/theme/app_dimens.dart';

/// Marks a customer with local edits that have not reached Odoo yet.
class PendingSyncBadge extends StatelessWidget {
  const PendingSyncBadge({super.key, this.compact = false});

  /// Icon only (list rows); otherwise icon + label.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final label = context.l10n.pendingSync;
    final icon = Icon(
      Icons.cloud_upload_outlined,
      size: 16,
      color: scheme.onSecondaryContainer,
    );
    return Tooltip(
      message: label,
      child: Semantics(
        label: label,
        excludeSemantics: true,
        child: Container(
          key: const Key('pending_sync_badge'),
          margin: const EdgeInsetsDirectional.symmetric(
            horizontal: AppDimens.xs,
          ),
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: AppDimens.sm,
            vertical: AppDimens.xs,
          ),
          decoration: BoxDecoration(
            color: scheme.secondaryContainer,
            borderRadius: BorderRadius.circular(AppDimens.chipRadius),
          ),
          child: compact
              ? icon
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    icon,
                    const SizedBox(width: AppDimens.xs),
                    Text(
                      label,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: scheme.onSecondaryContainer,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
