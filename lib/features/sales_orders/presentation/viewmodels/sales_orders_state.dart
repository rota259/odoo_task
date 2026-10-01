import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/view_status.dart';
import '../../domain/entities/sale_order.dart';

class SalesOrdersState extends Equatable {
  const SalesOrdersState({
    this.status = ViewStatus.initial,
    this.orders = const [],
    this.hasMore = false,
    this.isLoadingMore = false,
    this.failure,
  });

  final ViewStatus status;
  final List<SaleOrder> orders;
  final bool hasMore;
  final bool isLoadingMore;
  final Failure? failure;

  bool get isOffline => failure is OfflineFailure;
  bool get isEmpty => status == ViewStatus.success && orders.isEmpty;

  SalesOrdersState copyWith({
    ViewStatus? status,
    List<SaleOrder>? orders,
    bool? hasMore,
    bool? isLoadingMore,
    Failure? Function()? failure,
  }) => SalesOrdersState(
    status: status ?? this.status,
    orders: orders ?? this.orders,
    hasMore: hasMore ?? this.hasMore,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    failure: failure != null ? failure() : this.failure,
  );

  @override
  List<Object?> get props => [status, orders, hasMore, isLoadingMore, failure];
}
