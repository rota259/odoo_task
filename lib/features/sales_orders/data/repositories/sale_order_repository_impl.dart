import 'dart:async';

import 'package:fpdart/fpdart.dart';

import '../../../../core/connectivity/connectivity_service.dart';
import '../../../../core/error/failure_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/sale_order.dart';
import '../../domain/entities/sale_order_details.dart';
import '../../domain/repositories/sale_order_repository.dart';
import '../datasources/sale_order_remote_data_source.dart';

class SaleOrderRepositoryImpl implements SaleOrderRepository {
  SaleOrderRepositoryImpl(this._remote, this._connectivity);

  final SaleOrderRemoteDataSource _remote;
  final ConnectivityService _connectivity;
  final _updates = StreamController<SaleOrder>.broadcast();

  @override
  Stream<SaleOrder> get updates => _updates.stream;

  @override
  Future<Either<Failure, SaleOrderPage>> getOrders({
    int offset = 0,
    int limit = SaleOrderRepository.pageSize,
  }) => _online(() async {
    final items = await _remote.fetchPage(offset: offset, limit: limit);
    return SaleOrderPage(items: items, hasMore: items.length == limit);
  });

  @override
  Future<Either<Failure, SaleOrderDetails>> getOrderDetails(int id) =>
      _online(() => _remote.fetchDetails(id));

  @override
  Future<Either<Failure, SaleOrderDetails>> confirmOrder(int id) =>
      _online(() async {
        await _remote.confirm(id);
        final details = await _remote.fetchDetails(id);
        _updates.add(details.order);
        return details;
      });

  Future<Either<Failure, T>> _online<T>(Future<T> Function() action) async {
    if (!_connectivity.isOnline) return const Left(OfflineFailure());
    final result = await guard(action);
    // Sales orders have no cache: an unreachable server means offline.
    return result.mapLeft(
      (f) => f is NetworkFailure ? const OfflineFailure() : f,
    );
  }
}
