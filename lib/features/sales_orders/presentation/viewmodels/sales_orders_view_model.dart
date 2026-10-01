import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/presentation/subscription_bag.dart';
import '../../../../core/presentation/view_status.dart';
import '../../domain/entities/sale_order.dart';
import '../../domain/usecases/sale_order_usecases.dart';
import 'sales_orders_state.dart';

/// Sales order list (internal users only, online only).
class SalesOrdersViewModel extends Cubit<SalesOrdersState>
    with SubscriptionBag<SalesOrdersState> {
  SalesOrdersViewModel({
    required GetSaleOrdersUseCase getOrders,
    required WatchSaleOrderUpdatesUseCase watchUpdates,
    required Stream<bool> connectivityChanges,
  }) : _getOrders = getOrders,
       super(const SalesOrdersState()) {
    track(watchUpdates().listen(_onOrderUpdated));
    track(connectivityChanges.listen(_onConnectivity));
  }

  final GetSaleOrdersUseCase _getOrders;
  int _request = 0;

  Future<void> load() => _fetch(showLoading: true);

  Future<void> refresh() => _fetch(showLoading: false);

  Future<void> loadMore() async {
    final idle = state.status == ViewStatus.success && !state.isLoadingMore;
    if (!state.hasMore || !idle) return;
    final request = _request;
    emit(state.copyWith(isLoadingMore: true));
    final result = await _getOrders(offset: state.orders.length);
    if (isClosed || request != _request) return;
    result.match(
      (_) => emit(state.copyWith(isLoadingMore: false, hasMore: false)),
      (page) => emit(
        state.copyWith(
          orders: [...state.orders, ...page.items],
          hasMore: page.hasMore,
          isLoadingMore: false,
        ),
      ),
    );
  }

  Future<void> _fetch({required bool showLoading}) async {
    final request = ++_request;
    if (showLoading) emit(state.copyWith(status: ViewStatus.loading));
    final result = await _getOrders();
    if (isClosed || request != _request) return;
    result.match(
      (failure) => emit(
        state.copyWith(status: ViewStatus.failure, failure: () => failure),
      ),
      (page) => emit(
        state.copyWith(
          status: ViewStatus.success,
          orders: page.items,
          hasMore: page.hasMore,
          isLoadingMore: false,
          failure: () => null,
        ),
      ),
    );
  }

  void _onOrderUpdated(SaleOrder order) => emit(
    state.copyWith(
      orders: [for (final o in state.orders) o.id == order.id ? order : o],
    ),
  );

  void _onConnectivity(bool online) {
    if (online && state.status != ViewStatus.success) load();
  }
}
