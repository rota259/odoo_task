import '../../../../core/network/odoo_parsing.dart';
import '../../domain/entities/sale_order.dart';
import '../../domain/entities/sale_order_details.dart';
import '../../domain/entities/sale_order_state.dart';

abstract final class SaleOrderModel {
  static const listFields = [
    'name',
    'partner_id',
    'date_order',
    'state',
    'amount_total',
    'currency_id',
  ];
  static const detailFields = [...listFields, 'amount_untaxed', 'amount_tax'];
  static const lineFields = [
    'product_id',
    'name',
    'product_uom_qty',
    'price_unit',
    'price_subtotal',
  ];

  static SaleOrder fromOdoo(Map<String, dynamic> json) => SaleOrder(
    id: OdooParsing.integer(json['id']) ?? 0,
    name: OdooParsing.string(json['name']) ?? '',
    customerName: OdooParsing.many2one(json['partner_id'])?.name,
    date: OdooParsing.dateTime(json['date_order']),
    state: SaleOrderState.fromOdoo(json['state']),
    amountTotal: OdooParsing.decimal(json['amount_total']),
    currencyCode: OdooParsing.many2one(json['currency_id'])?.name,
  );

  static SaleOrderLine lineFromOdoo(Map<String, dynamic> json) => SaleOrderLine(
    id: OdooParsing.integer(json['id']) ?? 0,
    productName:
        OdooParsing.many2one(json['product_id'])?.name ??
        OdooParsing.string(json['name']) ??
        '',
    quantity: OdooParsing.decimal(json['product_uom_qty']),
    priceUnit: OdooParsing.decimal(json['price_unit']),
    subtotal: OdooParsing.decimal(json['price_subtotal']),
  );

  static SaleOrderDetails detailsFromOdoo(
    Map<String, dynamic> order,
    List<Map<String, dynamic>> lines,
  ) => SaleOrderDetails(
    order: fromOdoo(order),
    amountUntaxed: OdooParsing.decimal(order['amount_untaxed']),
    amountTax: OdooParsing.decimal(order['amount_tax']),
    lines: lines.map(lineFromOdoo).toList(),
  );
}
