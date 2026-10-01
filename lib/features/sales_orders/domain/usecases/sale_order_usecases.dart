import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/sale_order.dart';
import '../entities/sale_order_details.dart';
import '../repositories/sale_order_repository.dart';

class GetSaleOrdersUseCase {
  const GetSaleOrdersUseCase(this._repository);
  final SaleOrderRepository _repository;

  Future<Either<Failure, SaleOrderPage>> call({int offset = 0}) =>
      _repository.getOrders(offset: offset);
}

class GetSaleOrderDetailsUseCase {
  const GetSaleOrderDetailsUseCase(this._repository);
  final SaleOrderRepository _repository;

  Future<Either<Failure, SaleOrderDetails>> call(int id) =>
      _repository.getOrderDetails(id);
}

class ConfirmSaleOrderUseCase {
  const ConfirmSaleOrderUseCase(this._repository);
  final SaleOrderRepository _repository;

  Future<Either<Failure, SaleOrderDetails>> call(int id) =>
      _repository.confirmOrder(id);
}

class WatchSaleOrderUpdatesUseCase {
  const WatchSaleOrderUpdatesUseCase(this._repository);
  final SaleOrderRepository _repository;

  Stream<SaleOrder> call() => _repository.updates;
}
