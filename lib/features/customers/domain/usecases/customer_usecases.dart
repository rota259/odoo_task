import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/customer_results.dart';
import '../repositories/customer_repository.dart';
import 'phone_validator.dart';

class GetCustomersUseCase {
  const GetCustomersUseCase(this._repository);
  final CustomerRepository _repository;

  Future<Either<Failure, CustomerPage>> call({
    String query = '',
    int offset = 0,
  }) => _repository.getCustomers(query: query.trim(), offset: offset);
}

class GetCustomerDetailsUseCase {
  const GetCustomerDetailsUseCase(this._repository);
  final CustomerRepository _repository;

  Future<Either<Failure, CustomerDetailsResult>> call(int id) =>
      _repository.getCustomerDetails(id);
}

class UpdateCustomerPhoneUseCase {
  const UpdateCustomerPhoneUseCase(this._repository);
  final CustomerRepository _repository;

  Future<Either<Failure, PhoneUpdateOutcome>> call(int id, String phone) {
    final normalized = PhoneValidator.normalize(phone);
    if (!PhoneValidator.isValid(normalized)) {
      return Future.value(const Left(ValidationFailure()));
    }
    return _repository.updatePhone(id, normalized);
  }
}

class WatchCustomerChangesUseCase {
  const WatchCustomerChangesUseCase(this._repository);
  final CustomerRepository _repository;

  Stream<CustomerChange> call() => _repository.changes;
}
