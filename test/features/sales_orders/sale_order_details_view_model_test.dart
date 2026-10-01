import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:odoo_task/core/error/failures.dart';
import 'package:odoo_task/core/presentation/view_status.dart';
import 'package:odoo_task/features/sales_orders/domain/entities/sale_order_state.dart';
import 'package:odoo_task/features/sales_orders/domain/usecases/sale_order_usecases.dart';
import 'package:odoo_task/features/sales_orders/presentation/viewmodels/sale_order_details_state.dart';
import 'package:odoo_task/features/sales_orders/presentation/viewmodels/sale_order_details_view_model.dart';

import '../../helpers/factories.dart';
import '../../helpers/mocks.dart';

void main() {
  late MockSaleOrderRepository repo;
  setUp(() => repo = MockSaleOrderRepository());

  SaleOrderDetailsViewModel build() => SaleOrderDetailsViewModel(
    orderId: 1,
    getDetails: GetSaleOrderDetailsUseCase(repo),
    confirmOrder: ConfirmSaleOrderUseCase(repo),
  );

  final quotation = SaleOrderDetailsState(
    status: ViewStatus.success,
    details: details(SaleOrderState.draft),
  );

  blocTest<SaleOrderDetailsViewModel, SaleOrderDetailsState>(
    'load fetches header, lines and totals',
    setUp: () => when(
      () => repo.getOrderDetails(1),
    ).thenAnswer((_) async => Right(details(SaleOrderState.sent))),
    build: build,
    act: (vm) => vm.load(),
    expect: () => [
      const SaleOrderDetailsState(status: ViewStatus.loading),
      SaleOrderDetailsState(
        status: ViewStatus.success,
        details: details(SaleOrderState.sent),
      ),
    ],
  );

  blocTest<SaleOrderDetailsViewModel, SaleOrderDetailsState>(
    'confirm turns the quotation into a sales order',
    setUp: () => when(
      () => repo.confirmOrder(1),
    ).thenAnswer((_) async => Right(details(SaleOrderState.sale))),
    build: build,
    seed: () => quotation,
    act: (vm) => vm.confirm(),
    expect: () => [
      quotation.copyWith(confirmStatus: ActionStatus.running),
      SaleOrderDetailsState(
        status: ViewStatus.success,
        details: details(SaleOrderState.sale),
        confirmStatus: ActionStatus.success,
      ),
    ],
    verify: (vm) => expect(vm.state.canConfirm, isFalse),
  );

  blocTest<SaleOrderDetailsViewModel, SaleOrderDetailsState>(
    'confirm failure keeps the order and exposes the Odoo message',
    setUp: () => when(
      () => repo.confirmOrder(1),
    ).thenAnswer((_) async => const Left(ServerFailure('Not allowed'))),
    build: build,
    seed: () => quotation,
    act: (vm) => vm.confirm(),
    skip: 1,
    expect: () => [
      quotation.copyWith(
        confirmStatus: ActionStatus.failure,
        confirmFailure: () => const ServerFailure('Not allowed'),
      ),
    ],
  );

  blocTest<SaleOrderDetailsViewModel, SaleOrderDetailsState>(
    'confirm is a no-op for orders that are not quotations',
    build: build,
    seed: () => SaleOrderDetailsState(
      status: ViewStatus.success,
      details: details(SaleOrderState.sale),
    ),
    act: (vm) => vm.confirm(),
    expect: () => <SaleOrderDetailsState>[],
    verify: (_) => verifyNever(() => repo.confirmOrder(any())),
  );
}
