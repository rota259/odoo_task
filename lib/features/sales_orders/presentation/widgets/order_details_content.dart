import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimens.dart';
import '../../domain/entities/sale_order_details.dart';
import 'order_lines_card.dart';
import 'order_summary_card.dart';
import 'order_totals_card.dart';

class OrderDetailsContent extends StatelessWidget {
  const OrderDetailsContent({super.key, required this.details});

  final SaleOrderDetails details;

  @override
  Widget build(BuildContext context) => Align(
    alignment: AlignmentDirectional.topStart,
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: AppDimens.contentMaxWidth),
      child: ListView(
        padding: const EdgeInsetsDirectional.all(AppDimens.lg),
        children: [
          OrderSummaryCard(order: details.order),
          const SizedBox(height: AppDimens.md),
          OrderLinesCard(
            lines: details.lines,
            currencyCode: details.order.currencyCode,
          ),
          const SizedBox(height: AppDimens.md),
          OrderTotalsCard(details: details),
        ],
      ),
    ),
  );
}
