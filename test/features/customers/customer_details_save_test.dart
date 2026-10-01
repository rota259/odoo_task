import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:odoo_task/core/error/failures.dart';
import 'package:odoo_task/core/presentation/view_status.dart';
import 'package:odoo_task/features/customers/domain/entities/customer_details.dart';
import 'package:odoo_task/features/customers/domain/entities/customer_results.dart';
import 'package:odoo_task/features/customers/domain/usecases/customer_usecases.dart';
import 'package:odoo_task/features/customers/presentation/viewmodels/customer_details_state.dart';
import 'package:odoo_task/features/customers/presentation/viewmodels/customer_details_view_model.dart';

import '../../helpers/mocks.dart';

const _details = CustomerDetails(id: 1, name: 'Acme', phone: '000000');
const _loaded = CustomerDetailsState(
  status: ViewStatus.success,
  details: _details,
);

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
    'savePhone online -> success / synced',
    setUp: () => when(
      () => repo.updatePhone(1, '+1 555 0100'),
    ).thenAnswer((_) async => const Right(PhoneUpdateOutcome.synced)),
    build: build,
    seed: () => _loaded,
    act: (vm) => vm.savePhone('  +1 555   0100 '),
    expect: () => [
      const CustomerDetailsState(
        status: ViewStatus.success,
        details: _details,
        saveStatus: ActionStatus.running,
      ),
      const CustomerDetailsState(
        status: ViewStatus.success,
        details: _details,
        saveStatus: ActionStatus.success,
        saveOutcome: PhoneUpdateOutcome.synced,
      ),
    ],
  );

  blocTest<CustomerDetailsViewModel, CustomerDetailsState>(
    'savePhone surfaces the Odoo error',
    setUp: () => when(
      () => repo.updatePhone(any(), any()),
    ).thenAnswer((_) async => const Left(ServerFailure('Rejected'))),
    build: build,
    seed: () => _loaded,
    act: (vm) => vm.savePhone('123456'),
    skip: 1,
    expect: () => [
      const CustomerDetailsState(
        status: ViewStatus.success,
        details: _details,
        saveStatus: ActionStatus.failure,
        saveFailure: ServerFailure('Rejected'),
      ),
    ],
  );

  blocTest<CustomerDetailsViewModel, CustomerDetailsState>(
    'invalid phone is rejected before reaching the repository',
    build: build,
    seed: () => _loaded,
    act: (vm) => vm.savePhone('abc'),
    skip: 1,
    expect: () => [
      const CustomerDetailsState(
        status: ViewStatus.success,
        details: _details,
        saveStatus: ActionStatus.failure,
        saveFailure: ValidationFailure(),
      ),
    ],
    verify: (_) => verifyNever(() => repo.updatePhone(any(), any())),
  );
}
