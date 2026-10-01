import 'package:odoo_task/features/auth/domain/entities/auth_user.dart';
import 'package:odoo_task/features/customers/domain/entities/customer.dart';
import 'package:odoo_task/features/customers/domain/entities/customer_details.dart';
import 'package:odoo_task/features/sales_orders/domain/entities/sale_order.dart';
import 'package:odoo_task/features/sales_orders/domain/entities/sale_order_details.dart';
import 'package:odoo_task/features/sales_orders/domain/entities/sale_order_state.dart';

/// Data shaped like the Odoo 17 demo database.
const admin = AuthUser(
  uid: 2,
  name: 'Mitchell Admin',
  login: 'admin',
  database: 'odoo_demo',
  baseUrl: 'http://10.0.2.2:8069',
  isInternal: true,
);

const customers = [
  Customer(
    id: 10,
    name: 'Acme Corporation',
    phone: '(603)-996-3829',
    city: 'Pleasant Hill',
  ),
  Customer(id: 11, name: 'Addison Olson', phone: '(223)-399-7637'),
  Customer(
    id: 14,
    name: 'Azure Interior',
    phone: '+1 555 0100',
    city: 'Fremont',
    hasPendingSync: true,
  ),
  Customer(id: 15, name: 'Billy Fox', city: 'Tracy'),
  Customer(id: 16, name: 'Brandon Freeman', phone: '(355)-687-3262'),
  Customer(id: 17, name: 'Chester Reed', phone: '(979)-904-8902'),
  Customer(id: 18, name: 'Colleen Diaz', city: 'Fremont'),
  Customer(id: 19, name: 'Deco Addict', phone: '(603)-996-3829'),
];

const acmeDetails = CustomerDetails(
  id: 14,
  name: 'Azure Interior',
  phone: '+1 555 0100',
  email: 'azure.Interior24@example.com',
  street: '4557 De Silva St',
  city: 'Fremont',
  zip: '94538',
  stateName: 'California (US)',
  countryName: 'United States',
  hasPendingSync: true,
);

SaleOrder _o(int id, String partner, SaleOrderState s, double total, int day) =>
    SaleOrder(
      id: id,
      name: 'S000${id.toString().padLeft(2, '0')}',
      customerName: partner,
      state: s,
      amountTotal: total,
      date: DateTime(2026, 9, day, 11, 29),
      currencyCode: 'USD',
    );

final orders = [
  _o(1, 'Acme Corporation', SaleOrderState.draft, 2001, 30),
  _o(19, 'Gemini Furniture', SaleOrderState.sent, 2001, 28),
  _o(16, 'Gemini Furniture', SaleOrderState.sale, 1364.48, 25),
  _o(7, 'Deco Addict', SaleOrderState.done, 377.5, 20),
  _o(8, 'Lumber Inc', SaleOrderState.cancel, 405, 12),
];

final orderDetails = SaleOrderDetails(
  order: orders.first,
  amountUntaxed: 1740,
  amountTax: 261,
  lines: const [
    SaleOrderLine(
      id: 1,
      productName: '[FURN_6666] Acoustic Bloc Screens',
      quantity: 3,
      priceUnit: 295,
      subtotal: 885,
    ),
    SaleOrderLine(
      id: 2,
      productName: '[FURN_8888] Office Lamp',
      quantity: 5,
      priceUnit: 145,
      subtotal: 725,
    ),
  ],
);
