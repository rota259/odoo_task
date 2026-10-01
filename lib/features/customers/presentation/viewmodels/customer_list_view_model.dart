import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/presentation/subscription_bag.dart';
import '../../../../core/presentation/view_status.dart';
import '../../domain/entities/customer_results.dart';
import '../../domain/usecases/customer_usecases.dart';
import 'customer_change_x.dart';
import 'customer_list_state.dart';

class CustomerListViewModel extends Cubit<CustomerListState>
    with SubscriptionBag<CustomerListState> {
  CustomerListViewModel({
    required GetCustomersUseCase getCustomers,
    required WatchCustomerChangesUseCase watchChanges,
    required Stream<bool> connectivityChanges,
    this.debounce = const Duration(milliseconds: 400),
  }) : _getCustomers = getCustomers,
       super(const CustomerListState()) {
    track(watchChanges().listen(_onCustomerChanged));
    track(connectivityChanges.where((on) => on).listen((_) => _onOnline()));
    onDispose(() => _debounceTimer?.cancel());
  }

  final GetCustomersUseCase _getCustomers;
  final Duration debounce;
  Timer? _debounceTimer;
  int _request = 0;

  Future<void> load() => _fetch(state.query, showLoading: true);

  Future<void> refresh() => _fetch(state.query, showLoading: false);

  /// Debounced name search.
  void search(String query) {
    _debounceTimer?.cancel();
    if (query.trim() == state.query) return;
    _debounceTimer = Timer(debounce, () => _fetch(query.trim()));
  }

  Future<void> loadMore() async {
    final idle = state.status == ViewStatus.success && !state.isLoadingMore;
    if (!state.hasMore || !idle) return;
    final request = _request;
    emit(state.copyWith(isLoadingMore: true));
    final result = await _getCustomers(
      query: state.query,
      offset: state.customers.length,
    );
    if (isClosed || request != _request) return;
    result.match(
      (_) => emit(state.copyWith(isLoadingMore: false, hasMore: false)),
      (page) => emit(
        state.copyWith(
          customers: [...state.customers, ...page.items],
          hasMore: page.hasMore,
          isLoadingMore: false,
          isOffline: page.fromCache,
        ),
      ),
    );
  }

  Future<void> _fetch(String query, {bool showLoading = true}) async {
    final request = ++_request;
    emit(
      state.copyWith(
        query: query,
        status: showLoading ? ViewStatus.loading : null,
        isLoadingMore: false,
      ),
    );
    final result = await _getCustomers(query: query);
    if (isClosed || request != _request) return;
    result.match(
      (failure) => emit(
        state.copyWith(status: ViewStatus.failure, failure: () => failure),
      ),
      (page) => emit(
        state.copyWith(
          status: ViewStatus.success,
          customers: page.items,
          hasMore: page.hasMore,
          isOffline: page.fromCache,
          failure: () => null,
        ),
      ),
    );
  }

  void _onCustomerChanged(CustomerChange change) =>
      emit(state.copyWith(customers: state.customers.applyChange(change)));

  /// Back online: replace cached data with fresh server data.
  void _onOnline() =>
      state.isOffline || state.status == ViewStatus.failure ? refresh() : null;
}
