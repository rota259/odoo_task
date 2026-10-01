import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:odoo_task/core/error/failures.dart';
import 'package:odoo_task/core/presentation/view_status.dart';
import 'package:odoo_task/features/customers/domain/entities/customer.dart';
import 'package:odoo_task/features/customers/domain/entities/customer_results.dart';
import 'package:odoo_task/features/customers/domain/usecases/customer_usecases.dart';
import 'package:odoo_task/features/customers/presentation/viewmodels/customer_list_state.dart';
import 'package:odoo_task/features/customers/presentation/viewmodels/customer_list_view_model.dart';

import '../../helpers/mocks.dart';

List<Customer> _people(int from, int count) => [
  for (var i = from; i < from + count; i++) Customer(id: i, name: 'C$i'),
];

void main() {
  late MockCustomerRepository repo;
  late StreamController<CustomerChange> changes;

  setUp(() {
    repo = MockCustomerRepository();
    changes = StreamController.broadcast();
    when(() => repo.changes).thenAnswer((_) => changes.stream);
  });
  tearDown(() => changes.close());

  CustomerListViewModel build() => CustomerListViewModel(
    getCustomers: GetCustomersUseCase(repo),
    watchChanges: WatchCustomerChangesUseCase(repo),
    connectivityChanges: const Stream.empty(),
    debounce: Duration.zero,
  );

  blocTest<CustomerListViewModel, CustomerListState>(
    'failure state carries the failure',
    setUp: () => when(
      () => repo.getCustomers(query: '', offset: 0),
    ).thenAnswer((_) async => const Left(OfflineFailure())),
    build: build,
    act: (vm) => vm.load(),
    skip: 1,
    expect: () => [
      const CustomerListState(
        status: ViewStatus.failure,
        failure: OfflineFailure(),
      ),
    ],
  );

  blocTest<CustomerListViewModel, CustomerListState>(
    'local edits update the row and its pending flag',
    build: build,
    seed: () =>
        CustomerListState(status: ViewStatus.success, customers: _people(1, 1)),
    act: (_) => changes.add(
      const CustomerChange(id: 1, phone: '555', hasPendingSync: true),
    ),
    expect: () => [
      const CustomerListState(
        status: ViewStatus.success,
        customers: [
          Customer(id: 1, name: 'C1', phone: '555', hasPendingSync: true),
        ],
      ),
    ],
  );
}
