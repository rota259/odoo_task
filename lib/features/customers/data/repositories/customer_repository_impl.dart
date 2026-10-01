import 'package:fpdart/fpdart.dart';

import '../../../../core/connectivity/connectivity_service.dart';
import '../../../../core/error/failure_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/storage/local_data_cleaner.dart';
import '../../../../core/sync/pending_edit_queue.dart';
import '../../domain/entities/customer_results.dart';
import '../../domain/repositories/customer_repository.dart';
import '../datasources/customer_change_bus.dart';
import '../datasources/customer_local_data_source.dart';
import '../datasources/customer_remote_data_source.dart';
import 'cached_customer_page.dart';
import 'customer_phone_writer.dart';
import 'pending_overlay.dart';

class CustomerRepositoryImpl
    with CustomerPhoneWriter
    implements CustomerRepository, LocalDataCleaner {
  CustomerRepositoryImpl({
    required this.remote,
    required this.local,
    required this.queue,
    required this.connectivity,
    required this.bus,
  });

  @override
  final CustomerRemoteDataSource remote;
  @override
  final CustomerLocalDataSource local;
  @override
  final PendingEditQueue queue;
  @override
  final ConnectivityService connectivity;
  @override
  final CustomerChangeBus bus;

  @override
  Stream<CustomerChange> get changes => bus.stream;

  @override
  Future<Either<Failure, CustomerPage>> getCustomers({
    String query = '',
    int offset = 0,
    int limit = CustomerRepository.pageSize,
  }) async {
    if (!connectivity.isOnline) return _cached(query, offset, limit);
    final result = await guard(
      () => remote.fetchPage(query: query, offset: offset, limit: limit),
    );
    final items = result.toNullable();
    if (items == null) {
      final failure = result.getLeft().toNullable()!;
      if (failure is NetworkFailure) return _cached(query, offset, limit);
      return Left(failure);
    }
    await local.saveCustomers(items);
    return Right(
      CustomerPage(
        items: items.map(queue.overlayCustomer).toList(),
        hasMore: items.length == limit,
      ),
    );
  }

  @override
  Future<Either<Failure, CustomerDetailsResult>> getCustomerDetails(
    int id,
  ) async {
    if (connectivity.isOnline) {
      final result = await guard(() => remote.fetchDetails(id));
      final details = result.toNullable();
      if (details != null) {
        await local.saveDetails(details);
        return Right(CustomerDetailsResult(queue.overlayDetails(details)));
      }
      final failure = result.getLeft().toNullable()!;
      if (failure is! NetworkFailure) return Left(failure);
    }
    final cached = local.details(id);
    if (cached == null) return const Left(OfflineFailure());
    final details = queue.overlayDetails(cached);
    return Right(CustomerDetailsResult(details, fromCache: true));
  }

  Either<Failure, CustomerPage> _cached(String q, int offset, int limit) =>
      local.cachedPage(queue, query: q, offset: offset, limit: limit);

  @override
  Future<void> clearLocalData() async {
    await local.clear();
    await queue.clear();
  }
}
