import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/view_status.dart';
import '../../domain/entities/customer.dart';

class CustomerListState extends Equatable {
  const CustomerListState({
    this.status = ViewStatus.initial,
    this.customers = const [],
    this.query = '',
    this.hasMore = false,
    this.isLoadingMore = false,
    this.isOffline = false,
    this.failure,
  });

  final ViewStatus status;
  final List<Customer> customers;
  final String query;
  final bool hasMore;
  final bool isLoadingMore;

  /// Showing cached data because the device is offline.
  final bool isOffline;
  final Failure? failure;

  bool get isEmpty => status == ViewStatus.success && customers.isEmpty;

  CustomerListState copyWith({
    ViewStatus? status,
    List<Customer>? customers,
    String? query,
    bool? hasMore,
    bool? isLoadingMore,
    bool? isOffline,
    Failure? Function()? failure,
  }) => CustomerListState(
    status: status ?? this.status,
    customers: customers ?? this.customers,
    query: query ?? this.query,
    hasMore: hasMore ?? this.hasMore,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    isOffline: isOffline ?? this.isOffline,
    failure: failure != null ? failure() : this.failure,
  );

  @override
  List<Object?> get props => [
    status,
    customers,
    query,
    hasMore,
    isLoadingMore,
    isOffline,
    failure,
  ];
}
