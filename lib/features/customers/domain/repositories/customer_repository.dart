import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/customer_results.dart';

abstract interface class CustomerRepository {
  static const pageSize = 30;

  /// Customers (`customer_rank > 0`), optionally filtered by name.
  /// Offline, pages are served from the cache.
  Future<Either<Failure, CustomerPage>> getCustomers({
    String query = '',
    int offset = 0,
    int limit = pageSize,
  });

  Future<Either<Failure, CustomerDetailsResult>> getCustomerDetails(int id);

  /// Writes the phone online, or applies it locally and queues it offline.
  Future<Either<Failure, PhoneUpdateOutcome>> updatePhone(int id, String phone);

  /// Local changes (edits, sync completions) to keep screens in step.
  Stream<CustomerChange> get changes;
}
