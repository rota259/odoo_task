import 'package:flutter/material.dart';

import '../../../../core/l10n/app_format.dart';
import '../../../../core/l10n/l10n_x.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/widgets/surface_card.dart';
import '../../domain/entities/sale_order_details.dart';

class OrderTotalsCard extends StatelessWidget {
  const OrderTotalsCard({super.key, required this.details});

  final SaleOrderDetails details;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final locale = context.localeTag;
    final currency = details.order.currencyCode;
    String money(double v) => AppFormat.money(v, locale, currency);
    return SurfaceCard(
      child: Column(
        children: [
          _TotalRow(
            label: l10n.untaxedAmount,
            value: money(details.amountUntaxed),
          ),
          const SizedBox(height: AppDimens.sm),
          _TotalRow(label: l10n.taxes, value: money(details.amountTax)),
          const Divider(height: AppDimens.xl),
          _TotalRow(
            label: l10n.total,
            value: money(details.order.amountTotal),
            style: theme.textTheme.titleLarge,
          ),
        ],
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  const _TotalRow({required this.label, required this.value, this.style});

  final String label;
  final String value;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final base = style ?? Theme.of(context).textTheme.bodyLarge;
    return Row(
      children: [
        Expanded(child: Text(label, style: base)),
        Text(value, style: base),
      ],
    );
  }
}
