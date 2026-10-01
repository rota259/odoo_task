import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
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

  void page(String q, int offset, List<Customer> items, {bool more = false}) =>
      when(() => repo.getCustomers(query: q, offset: offset)).thenAnswer(
        (_) async => Right(CustomerPage(items: items, hasMore: more)),
      );

  CustomerListViewModel build() => CustomerListViewModel(
    getCustomers: GetCustomersUseCase(repo),
    watchChanges: WatchCustomerChangesUseCase(repo),
    connectivityChanges: const Stream.empty(),
    debounce: Duration.zero,
  );

  blocTest<CustomerListViewModel, CustomerListState>(
    'load: loading -> success',
    setUp: () => page('', 0, _people(0, 2)),
    build: build,
    act: (vm) => vm.load(),
    expect: () => [
      const CustomerListState(status: ViewStatus.loading),
      CustomerListState(status: ViewStatus.success, customers: _people(0, 2)),
    ],
  );

  blocTest<CustomerListViewModel, CustomerListState>(
    'loadMore appends the next page',
    setUp: () {
      page('', 0, _people(0, 30), more: true);
      page('', 30, _people(30, 5));
    },
    build: build,
    act: (vm) async {
      await vm.load();
      await vm.loadMore();
    },
    skip: 3,
    expect: () => [
      CustomerListState(status: ViewStatus.success, customers: _people(0, 35)),
    ],
  );

  blocTest<CustomerListViewModel, CustomerListState>(
    'search (debounced) queries by name',
    setUp: () => page('acme', 0, _people(7, 1)),
    build: build,
    act: (vm) => vm.search(' acme '),
    wait: const Duration(milliseconds: 10),
    expect: () => [
      const CustomerListState(status: ViewStatus.loading, query: 'acme'),
      CustomerListState(
        status: ViewStatus.success,
        query: 'acme',
        customers: _people(7, 1),
      ),
    ],
  );
}
