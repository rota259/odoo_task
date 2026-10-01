import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/sale_order.dart';
import '../entities/sale_order_details.dart';

/// Online-only access to `sale.order`. Offline calls fail fast with
/// `OfflineFailure`.
abstract interface class SaleOrderRepository {
  static const pageSize = 20;

  Future<Either<Failure, SaleOrderPage>> getOrders({
    int offset = 0,
    int limit = pageSize,
  });

  Future<Either<Failure, SaleOrderDetails>> getOrderDetails(int id);

  /// Calls `action_confirm` and returns the refreshed order.
  Future<Either<Failure, SaleOrderDetails>> confirmOrder(int id);

  /// Orders updated locally (e.g. after confirmation).
  Stream<SaleOrder> get updates;
}
