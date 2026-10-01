import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:odoo_task/core/error/failures.dart';
import 'package:odoo_task/core/network/odoo_exception.dart';
import 'package:odoo_task/features/sales_orders/data/datasources/sale_order_remote_data_source.dart';
import 'package:odoo_task/features/sales_orders/data/repositories/sale_order_repository_impl.dart';
import 'package:odoo_task/features/sales_orders/domain/entities/sale_order_state.dart';

import '../../helpers/fake_connectivity.dart';
import '../../helpers/mocks.dart';

Map<String, dynamic> _order(String state) => {
  'id': 1,
  'name': 'S00001',
  'partner_id': [10, 'Acme'],
  'date_order': '2026-09-01 11:29:00',
  'state': state,
  'amount_total': 2001.0,
  'amount_untaxed': 1740.0,
  'amount_tax': 261.0,
  'currency_id': [1, 'USD'],
};

void main() {
  late MockOdooClient client;
  late FakeConnectivity connectivity;
  late SaleOrderRepositoryImpl repo;

  setUp(() {
    client = MockOdooClient();
    connectivity = FakeConnectivity();
    repo = SaleOrderRepositoryImpl(
      SaleOrderRemoteDataSource(client),
      connectivity,
    );
    when(
      () => client.searchRead(
        'sale.order.line',
        domain: any(named: 'domain'),
        fields: any(named: 'fields'),
        order: any(named: 'order'),
      ),
    ).thenAnswer((_) async => []);
  });

  test('offline -> OfflineFailure without calling Odoo', () async {
    connectivity.set(false);
    final result = await repo.getOrders();
    expect(result.getLeft().toNullable(), isA<OfflineFailure>());
    verifyZeroInteractions(client);
  });

  test('server unreachable is reported as offline', () async {
    when(
      () => client.read(any(), any(), any()),
    ).thenThrow(const OdooException.network());
    final result = await repo.getOrderDetails(1);
    expect(result.getLeft().toNullable(), isA<OfflineFailure>());
  });

  test('confirm calls action_confirm, refetches and broadcasts', () async {
    when(
      () => client.callMethod('sale.order', 'action_confirm', [
        [1],
      ]),
    ).thenAnswer((_) async => true);
    when(
      () => client.read(any(), any(), any()),
    ).thenAnswer((_) async => [_order('sale')]);
    final update = repo.updates.first;
    final details = (await repo.confirmOrder(1)).getOrElse((f) => throw f);
    expect(details.order.state, SaleOrderState.sale);
    expect((await update).state, SaleOrderState.sale);
  });

  test('confirm surfaces the Odoo error message', () async {
    when(
      () => client.callMethod(any(), any(), any(), any()),
    ).thenThrow(const OdooException(OdooErrorKind.server, 'Not a quotation'));
    final result = await repo.confirmOrder(1);
    expect(
      result.getLeft().toNullable(),
      const ServerFailure('Not a quotation'),
    );
  });
}
