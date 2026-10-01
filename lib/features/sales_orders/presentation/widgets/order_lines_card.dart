import 'package:flutter/material.dart';

import '../../../../core/l10n/app_format.dart';
import '../../../../core/l10n/data_direction.dart';
import '../../../../core/l10n/l10n_x.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/widgets/surface_card.dart';
import '../../domain/entities/sale_order_details.dart';

class OrderLinesCard extends StatelessWidget {
  const OrderLinesCard({super.key, required this.lines, this.currencyCode});

  final List<SaleOrderLine> lines;
  final String? currencyCode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.orderLines, style: theme.textTheme.titleMedium),
          const SizedBox(height: AppDimens.sm),
          if (lines.isEmpty)
            Text(l10n.noLines, style: theme.textTheme.bodySmall)
          else
            for (final (i, line) in lines.indexed) ...[
              if (i > 0) const Divider(height: AppDimens.lg),
              _LineRow(line: line, currencyCode: currencyCode),
            ],
        ],
      ),
    );
  }
}

class _LineRow extends StatelessWidget {
  const _LineRow({required this.line, this.currencyCode});

  final SaleOrderLine line;
  final String? currencyCode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = context.localeTag;
    final qtyPrice = context.l10n.lineQtyPrice(
      AppFormat.quantity(line.quantity, locale),
      AppFormat.money(line.priceUnit, locale, currencyCode),
    );
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                line.productName,
                style: theme.textTheme.bodyLarge,
                textDirection: dataDirection(line.productName),
              ),
              Text(qtyPrice, style: theme.textTheme.bodySmall),
            ],
          ),
        ),
        const SizedBox(width: AppDimens.md),
        Text(
          AppFormat.money(line.subtotal, locale, currencyCode),
          style: theme.textTheme.titleSmall,
        ),
      ],
    );
  }
}
