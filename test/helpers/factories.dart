import 'package:odoo_task/core/sync/pending_edit.dart';
import 'package:odoo_task/features/sales_orders/domain/entities/sale_order.dart';
import 'package:odoo_task/features/sales_orders/domain/entities/sale_order_details.dart';
import 'package:odoo_task/features/sales_orders/domain/entities/sale_order_state.dart';

PendingEdit edit(int id, String value, int minute, {String field = 'phone'}) =>
    PendingEdit(
      partnerId: id,
      field: field,
      value: value,
      createdAt: DateTime(2026, 10, 1, 12, minute),
    );

SaleOrder order(int id, SaleOrderState state) => SaleOrder(
  id: id,
  name: 'S0000$id',
  customerName: 'Acme',
  state: state,
  amountTotal: 10,
);

SaleOrderDetails details(SaleOrderState s) => SaleOrderDetails(
  order: order(1, s),
  amountUntaxed: 8,
  amountTax: 2,
  lines: const [],
);
