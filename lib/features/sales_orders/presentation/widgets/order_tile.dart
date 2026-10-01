import 'package:flutter/material.dart';

import '../../../../core/l10n/app_format.dart';
import '../../../../core/l10n/l10n_x.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/widgets/surface_card.dart';
import '../../domain/entities/sale_order.dart';
import 'order_hero.dart';
import 'sale_status_chip.dart';

class OrderTile extends StatelessWidget {
  const OrderTile({
    super.key,
    required this.order,
    required this.onTap,
    this.selected = false,
  });

  final SaleOrder order;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final locale = context.localeTag;
    final date = order.date;
    return SurfaceCard(
      onTap: onTap,
      selected: selected,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: OrderNumberHero(
                  orderId: order.id,
                  number: order.name,
                  style: theme.textTheme.titleMedium,
                ),
              ),
              const SizedBox(width: AppDimens.sm),
              SaleStatusChip(state: order.state),
            ],
          ),
          const SizedBox(height: AppDimens.xs),
          Text(
            order.customerName ?? l10n.emptyValue,
            style: theme.textTheme.bodyMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppDimens.xs),
          Row(
            children: [
              Expanded(
                child: Text(
                  date == null
                      ? l10n.emptyValue
                      : AppFormat.dateTime(date, locale),
                  style: theme.textTheme.bodySmall,
                ),
              ),
              Text(
                AppFormat.money(order.amountTotal, locale, order.currencyCode),
                style: theme.textTheme.titleSmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
