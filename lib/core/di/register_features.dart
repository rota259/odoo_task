import 'package:get_it/get_it.dart';

import '../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/auth_usecases.dart';
import '../../features/settings/data/settings_repository_impl.dart';
import '../../features/settings/domain/settings_repository.dart';
import '../sync/sync_service.dart';
import 'register_core.dart';
import 'register_customers.dart';
import 'register_sales_orders.dart';

void registerFeatures(GetIt getIt) {
  registerCustomers(getIt);
  registerSalesOrders(getIt);

  getIt
    ..registerSingleton<SettingsRepository>(SettingsRepositoryImpl(getIt()))
    ..registerSingleton(
      SyncService(getIt(), getIt(), getIt(instanceName: customerSender)),
    )
    ..registerSingleton<AuthRepository>(
      AuthRepositoryImpl(
        remote: AuthRemoteDataSource(getIt()),
        local: AuthLocalDataSource(getIt<MapBox>(instanceName: 'session')),
        credentials: getIt(),
        endpoint: getIt(),
        cleaners: [getIt(instanceName: customerCleaner)],
      ),
    )
    ..registerFactory(() => LoginUseCase(getIt()))
    ..registerFactory(() => RestoreSessionUseCase(getIt()))
    ..registerFactory(() => LogoutUseCase(getIt()));
}
