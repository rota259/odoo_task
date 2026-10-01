import 'package:flutter/material.dart';

import '../../../../core/l10n/app_format.dart';
import '../../../../core/l10n/l10n_x.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/widgets/surface_card.dart';
import '../../domain/entities/sale_order.dart';
import 'sale_status_chip.dart';

/// Header: customer, date and status of the order.
class OrderSummaryCard extends StatelessWidget {
  const OrderSummaryCard({super.key, required this.order});

  final SaleOrder order;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final date = order.date;
    return SurfaceCard(
      child: Column(
        children: [
          _Row(
            label: l10n.customer,
            child: Text(order.customerName ?? l10n.emptyValue),
          ),
          const Divider(height: AppDimens.xl),
          _Row(
            label: l10n.orderDate,
            child: Text(
              date == null
                  ? l10n.emptyValue
                  : AppFormat.dateTime(date, context.localeTag),
            ),
          ),
          const Divider(height: AppDimens.xl),
          _Row(
            label: l10n.status,
            child: SaleStatusChip(state: order.state),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(child: Text(label, style: theme.textTheme.labelMedium)),
        const SizedBox(width: AppDimens.md),
        Flexible(
          flex: 2,
          child: Align(
            alignment: AlignmentDirectional.centerEnd,
            child: DefaultTextStyle.merge(
              style: theme.textTheme.titleSmall,
              textAlign: TextAlign.end,
              child: child,
            ),
          ),
        ),
      ],
    );
  }
}
