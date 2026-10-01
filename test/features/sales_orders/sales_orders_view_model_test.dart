import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:odoo_task/core/error/failures.dart';
import 'package:odoo_task/core/presentation/view_status.dart';
import 'package:odoo_task/features/sales_orders/domain/entities/sale_order.dart';
import 'package:odoo_task/features/sales_orders/domain/entities/sale_order_details.dart';
import 'package:odoo_task/features/sales_orders/domain/entities/sale_order_state.dart';
import 'package:odoo_task/features/sales_orders/domain/usecases/sale_order_usecases.dart';
import 'package:odoo_task/features/sales_orders/presentation/viewmodels/sales_orders_state.dart';
import 'package:odoo_task/features/sales_orders/presentation/viewmodels/sales_orders_view_model.dart';

import '../../helpers/factories.dart';
import '../../helpers/mocks.dart';

void main() {
  late MockSaleOrderRepository repo;
  late StreamController<SaleOrder> updates;
  late StreamController<bool> connectivity;

  setUp(() {
    repo = MockSaleOrderRepository();
    updates = StreamController.broadcast();
    connectivity = StreamController.broadcast();
    when(() => repo.updates).thenAnswer((_) => updates.stream);
  });

  SalesOrdersViewModel build() => SalesOrdersViewModel(
    getOrders: GetSaleOrdersUseCase(repo),
    watchUpdates: WatchSaleOrderUpdatesUseCase(repo),
    connectivityChanges: connectivity.stream,
  );

  final draft = order(1, SaleOrderState.draft);

  blocTest<SalesOrdersViewModel, SalesOrdersState>(
    'load: loading -> success',
    setUp: () => when(() => repo.getOrders()).thenAnswer(
      (_) async => Right(SaleOrderPage(items: [draft], hasMore: false)),
    ),
    build: build,
    act: (vm) => vm.load(),
    expect: () => [
      const SalesOrdersState(status: ViewStatus.loading),
      SalesOrdersState(status: ViewStatus.success, orders: [draft]),
    ],
  );

  blocTest<SalesOrdersViewModel, SalesOrdersState>(
    'offline: clear offline state, reloads when back online',
    setUp: () {
      var calls = 0;
      when(() => repo.getOrders()).thenAnswer(
        (_) async => calls++ == 0
            ? const Left(OfflineFailure())
            : Right(SaleOrderPage(items: [draft], hasMore: false)),
      );
    },
    build: build,
    act: (vm) async {
      await vm.load();
      expect(vm.state.isOffline, isTrue);
      connectivity.add(true);
    },
    wait: const Duration(milliseconds: 10),
    skip: 3,
    expect: () => [
      SalesOrdersState(status: ViewStatus.success, orders: [draft]),
    ],
  );

  blocTest<SalesOrdersViewModel, SalesOrdersState>(
    'a confirmed order replaces its row in the list',
    build: build,
    seed: () => SalesOrdersState(status: ViewStatus.success, orders: [draft]),
    act: (_) => updates.add(order(1, SaleOrderState.sale)),
    expect: () => [
      SalesOrdersState(
        status: ViewStatus.success,
        orders: [order(1, SaleOrderState.sale)],
      ),
    ],
  );
}
