import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:odoo_task/core/presentation/view_status.dart';
import 'package:odoo_task/features/customers/domain/entities/customer_details.dart';
import 'package:odoo_task/features/customers/domain/entities/customer_results.dart';
import 'package:odoo_task/features/customers/domain/usecases/customer_usecases.dart';
import 'package:odoo_task/features/customers/presentation/viewmodels/customer_details_state.dart';
import 'package:odoo_task/features/customers/presentation/viewmodels/customer_details_view_model.dart';

import '../../helpers/mocks.dart';

const _details = CustomerDetails(id: 1, name: 'Acme', phone: '000000');

void main() {
  late MockCustomerRepository repo;

  setUp(() {
    repo = MockCustomerRepository();
    when(() => repo.changes).thenAnswer((_) => const Stream.empty());
  });

  CustomerDetailsViewModel build() => CustomerDetailsViewModel(
    customerId: 1,
    getDetails: GetCustomerDetailsUseCase(repo),
    updatePhone: UpdateCustomerPhoneUseCase(repo),
    watchChanges: WatchCustomerChangesUseCase(repo),
  );

  blocTest<CustomerDetailsViewModel, CustomerDetailsState>(
    'load shows cached details flagged as offline',
    setUp: () => when(() => repo.getCustomerDetails(1)).thenAnswer(
      (_) async =>
          const Right(CustomerDetailsResult(_details, fromCache: true)),
    ),
    build: build,
    act: (vm) => vm.load(),
    expect: () => [
      const CustomerDetailsState(status: ViewStatus.loading),
      const CustomerDetailsState(
        status: ViewStatus.success,
        details: _details,
        isOffline: true,
      ),
    ],
  );
}
