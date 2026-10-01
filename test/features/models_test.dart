import 'package:flutter_test/flutter_test.dart';
import 'package:odoo_task/features/customers/data/models/customer_details_model.dart';
import 'package:odoo_task/features/customers/data/models/customer_model.dart';
import 'package:odoo_task/features/sales_orders/data/models/sale_order_model.dart';
import 'package:odoo_task/features/sales_orders/domain/entities/sale_order_state.dart';

void main() {
  test('CustomerModel maps Odoo false to null', () {
    final c = CustomerModel.fromOdoo({
      'id': 7,
      'name': 'Acme',
      'phone': false,
      'city': false,
    });
    expect(c.id, 7);
    expect(c.phone, isNull);
    expect(c.city, isNull);
    expect(CustomerModel.fromCache(CustomerModel.toCache(c)), c);
  });

  test('CustomerDetailsModel parses many2one and empty street2', () {
    final d = CustomerDetailsModel.fromOdoo({
      'id': 10,
      'name': 'Acme Corporation',
      'phone': '(603)-996-3829',
      'email': 'acme@example.com',
      'street': '77 Santa Barbara Rd',
      'street2': false,
      'city': 'Pleasant Hill',
      'zip': '94523',
      'state_id': [13, 'California (US)'],
      'country_id': false,
    });
    expect(d.street2, isNull);
    expect(d.stateName, 'California (US)');
    expect(d.countryName, isNull);
    expect(d.addressLines, [
      '77 Santa Barbara Rd',
      '94523 Pleasant Hill',
      'California (US)',
    ]);
    expect(CustomerDetailsModel.fromCache(CustomerDetailsModel.toCache(d)), d);
  });

  test('SaleOrderModel parses a sale.order row', () {
    final o = SaleOrderModel.fromOdoo({
      'id': 1,
      'name': 'S00001',
      'partner_id': [10, 'Acme Corporation'],
      'date_order': '2026-09-01 11:29:00',
      'state': 'sent',
      'amount_total': 2001.0,
      'currency_id': [1, 'USD'],
    });
    expect(o.customerName, 'Acme Corporation');
    expect(o.state, SaleOrderState.sent);
    expect(o.state.canConfirm, isTrue);
    expect(o.currencyCode, 'USD');
    expect(o.date!.toUtc(), DateTime.utc(2026, 9, 1, 11, 29));
  });

  test('SaleOrderModel tolerates false everywhere', () {
    final o = SaleOrderModel.fromOdoo({
      'id': 2,
      'name': 'S00002',
      'partner_id': false,
      'date_order': false,
      'state': 'weird',
      'amount_total': false,
      'currency_id': false,
    });
    expect(o.customerName, isNull);
    expect(o.date, isNull);
    expect(o.state, SaleOrderState.unknown);
    expect(o.amountTotal, 0);
  });

  test('order line falls back to the description without product', () {
    final line = SaleOrderModel.lineFromOdoo({
      'id': 3,
      'product_id': false,
      'name': 'Custom work',
      'product_uom_qty': 2.0,
      'price_unit': 10,
      'price_subtotal': 20.0,
    });
    expect(line.productName, 'Custom work');
    expect(line.priceUnit, 10.0);
  });
}
