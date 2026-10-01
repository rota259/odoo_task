import 'package:get_it/get_it.dart';

import '../../features/sales_orders/data/datasources/sale_order_remote_data_source.dart';
import '../../features/sales_orders/data/repositories/sale_order_repository_impl.dart';
import '../../features/sales_orders/domain/repositories/sale_order_repository.dart';
import '../../features/sales_orders/domain/usecases/sale_order_usecases.dart';

void registerSalesOrders(GetIt getIt) {
  getIt
    ..registerSingleton<SaleOrderRepository>(
      SaleOrderRepositoryImpl(SaleOrderRemoteDataSource(getIt()), getIt()),
    )
    ..registerFactory(() => GetSaleOrdersUseCase(getIt()))
    ..registerFactory(() => GetSaleOrderDetailsUseCase(getIt()))
    ..registerFactory(() => ConfirmSaleOrderUseCase(getIt()))
    ..registerFactory(() => WatchSaleOrderUpdatesUseCase(getIt()));
}
