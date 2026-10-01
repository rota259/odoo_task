import 'package:get_it/get_it.dart';

import '../../features/customers/data/datasources/customer_change_bus.dart';
import '../../features/customers/data/datasources/customer_local_data_source.dart';
import '../../features/customers/data/datasources/customer_remote_data_source.dart';
import '../../features/customers/data/repositories/customer_edit_sender.dart';
import '../../features/customers/data/repositories/customer_repository_impl.dart';
import '../../features/customers/domain/repositories/customer_repository.dart';
import '../../features/customers/domain/usecases/customer_usecases.dart';
import '../storage/local_data_cleaner.dart';
import '../sync/pending_edit_sender.dart';
import 'register_core.dart';

const customerSender = 'customerSender';
const customerCleaner = 'customerCleaner';

void registerCustomers(GetIt getIt) {
  final remote = CustomerRemoteDataSource(getIt());
  final bus = CustomerChangeBus();
  final repository = CustomerRepositoryImpl(
    remote: remote,
    local: CustomerLocalDataSource(getIt<MapBox>(instanceName: 'customers')),
    queue: getIt(),
    connectivity: getIt(),
    bus: bus,
  );
  getIt
    ..registerSingleton<CustomerRepository>(repository)
    ..registerSingleton<LocalDataCleaner>(
      repository,
      instanceName: customerCleaner,
    )
    ..registerSingleton<PendingEditSender>(
      CustomerEditSender(remote, getIt(), bus),
      instanceName: customerSender,
    )
    ..registerFactory(() => GetCustomersUseCase(getIt()))
    ..registerFactory(() => GetCustomerDetailsUseCase(getIt()))
    ..registerFactory(() => UpdateCustomerPhoneUseCase(getIt()))
    ..registerFactory(() => WatchCustomerChangesUseCase(getIt()));
}
