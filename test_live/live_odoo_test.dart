// End-to-end checks against a running Odoo (see docker/setup_odoo.sh).
// Run: flutter test test_live --dart-define=ODOO_URL=http://localhost:8069
import 'package:flutter_test/flutter_test.dart';
import 'package:odoo_task/core/error/failures.dart';
import 'package:odoo_task/core/network/odoo_endpoint.dart';
import 'package:odoo_task/core/network/xml_rpc_odoo_client.dart';
import 'package:odoo_task/core/router/auth_guard.dart';
import 'package:odoo_task/core/router/routes.dart';
import 'package:odoo_task/features/auth/domain/entities/login_request.dart';
import 'package:odoo_task/features/auth/presentation/viewmodels/auth_state.dart';
import 'package:odoo_task/features/customers/domain/entities/customer_results.dart';
import 'package:odoo_task/features/sales_orders/domain/entities/sale_order_state.dart';

import 'live_stack.dart';
import 'odoo_admin.dart';

const url = String.fromEnvironment(
  'ODOO_URL',
  defaultValue: 'http://localhost:8069',
);

LoginRequest as(String user) => LoginRequest(
  baseUrl: url,
  database: 'odoo_demo',
  login: user,
  password: user,
);

void main() {
  final stack = LiveStack(url);
  final admin = OdooAdmin(url);
  setUp(stack.setUp);
  tearDown(stack.tearDown);
  setUpAll(admin.login);

  for (final (user, internal) in [
    ('admin', true),
    ('demo', true),
    ('portal', false),
  ]) {
    test('$user logs in; internal=$internal; orders guard agrees', () async {
      final u = (await stack.auth.login(as(user))).getOrElse((f) => throw f);
      expect(u.isInternal, internal);
      final state = AuthState(status: AuthStatus.authenticated, user: u);
      final redirect = authRedirect(state, Routes.orders);
      expect(redirect, internal ? isNull : Routes.customers);
    });
  }

  test('wrong password and wrong database are told apart', () async {
    final bad = await stack.auth.login(
      const LoginRequest(
        baseUrl: url,
        database: 'odoo_demo',
        login: 'admin',
        password: 'x',
      ),
    );
    expect(bad.getLeft().toNullable(), isA<InvalidCredentialsFailure>());
    final noDb = await stack.auth.login(
      const LoginRequest(
        baseUrl: url,
        database: 'nope',
        login: 'admin',
        password: 'admin',
      ),
    );
    expect(noDb.getLeft().toNullable(), isA<DatabaseNotFoundFailure>());
  });

  test('customers paginate and search by name', () async {
    await stack.auth.login(as('demo'));
    final p1 = (await stack.customers.getCustomers()).getOrElse((f) => throw f);
    expect(p1.items, hasLength(30));
    expect(p1.hasMore, isTrue);
    final p2 = (await stack.customers.getCustomers(
      offset: 30,
    )).getOrElse((f) => throw f);
    expect(p2.items, isNotEmpty);
    final hit = (await stack.customers.getCustomers(
      query: 'azure',
    )).getOrElse((f) => throw f);
    expect(hit.items.single.name, 'Azure Interior');
  });

  test('offline phone edit syncs to Odoo once back online', () async {
    await stack.auth.login(as('demo'));
    final azure = (await stack.customers.getCustomers(
      query: 'azure',
    )).getOrElse((f) => throw f).items.single;
    final phone = '+1 555 ${DateTime.now().millisecondsSinceEpoch % 10000}';
    stack.connectivity.set(false);
    final queued = await stack.customers.updatePhone(azure.id, phone);
    expect(queued.toNullable(), PhoneUpdateOutcome.queued);
    expect(
      (await admin.read('res.partner', azure.id, ['phone']))['phone'],
      isNot(phone),
    );

    final synced = stack.sync.results.first;
    stack.connectivity.set(true);
    expect((await synced).synced, 1);
    expect(
      (await admin.read('res.partner', azure.id, ['phone']))['phone'],
      phone,
    );
  });

  test('confirming a quotation makes it a sales order', () async {
    final id = await admin.createQuotation();
    await stack.auth.login(as('admin'));
    final d = (await stack.orders.confirmOrder(id)).getOrElse((f) => throw f);
    expect(d.order.state, SaleOrderState.sale);
    expect((await admin.read('sale.order', id, ['state']))['state'], 'sale');
  });

  test('XML-RPC fallback transport works against the same server', () async {
    final xml = XmlRpcOdooClient(OdooEndpoint(baseUrl: url), stack.credentials);
    final portal = await xml.authenticate('odoo_demo', 'portal', 'portal');
    expect(portal.uid, isPositive);
    final isInternal = await xml.callMethod('res.users', 'has_group', [
      'base.group_user',
    ]);
    expect(isInternal, isFalse);
    // Record rules: portal users only see their own partner, so count as demo.
    await xml.authenticate('odoo_demo', 'demo', 'demo');
    final count = await xml.searchCount('res.partner', [
      ['customer_rank', '>', 0],
    ]);
    expect(count, greaterThan(30));
  });
}
