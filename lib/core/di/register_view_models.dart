import 'package:get_it/get_it.dart';

import '../../features/auth/presentation/viewmodels/auth_view_model.dart';
import '../../features/customers/presentation/viewmodels/customer_details_view_model.dart';
import '../../features/customers/presentation/viewmodels/customer_list_view_model.dart';
import '../../features/sales_orders/presentation/viewmodels/sale_order_details_view_model.dart';
import '../../features/sales_orders/presentation/viewmodels/sales_orders_view_model.dart';
import '../../features/settings/presentation/viewmodels/settings_view_model.dart';
import '../../features/shell/presentation/viewmodels/sync_status_view_model.dart';
import '../connectivity/connectivity_service.dart';
import '../sync/sync_service.dart';

void registerViewModels(GetIt getIt) {
  Stream<bool> connectivity() => getIt<ConnectivityService>().onStatusChange;
  getIt
    // App-wide ViewModels live as long as the app.
    ..registerLazySingleton(
      () => AuthViewModel(
        login: getIt(),
        restoreSession: getIt(),
        logout: getIt(),
        sync: getIt(),
      ),
    )
    ..registerLazySingleton(() => SettingsViewModel(getIt()))
    ..registerLazySingleton(
      () => SyncStatusViewModel(getIt<SyncService>().results),
    )
    // Screen ViewModels are created (and closed) by their views.
    ..registerFactory(
      () => CustomerListViewModel(
        getCustomers: getIt(),
        watchChanges: getIt(),
        connectivityChanges: connectivity(),
      ),
    )
    ..registerFactoryParam<CustomerDetailsViewModel, int, void>(
      (id, _) => CustomerDetailsViewModel(
        customerId: id,
        getDetails: getIt(),
        updatePhone: getIt(),
        watchChanges: getIt(),
      ),
    )
    ..registerFactory(
      () => SalesOrdersViewModel(
        getOrders: getIt(),
        watchUpdates: getIt(),
        connectivityChanges: connectivity(),
      ),
    )
    ..registerFactoryParam<SaleOrderDetailsViewModel, int, void>(
      (id, _) => SaleOrderDetailsViewModel(
        orderId: id,
        getDetails: getIt(),
        confirmOrder: getIt(),
      ),
    );
}
