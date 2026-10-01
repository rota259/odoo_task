import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import '../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../features/customers/data/datasources/customer_local_data_source.dart';
import '../../features/settings/data/settings_repository_impl.dart';
import '../connectivity/connectivity_service.dart';
import '../network/dio_factory.dart';
import '../network/fallback_odoo_client.dart';
import '../network/json_rpc_odoo_client.dart';
import '../network/json_rpc_transport.dart';
import '../network/odoo_client.dart';
import '../network/odoo_endpoint.dart';
import '../network/xml_rpc_odoo_client.dart';
import '../storage/credentials_store.dart';
import '../sync/pending_edit_queue.dart';

typedef MapBox = Box<Map<dynamic, dynamic>>;

Future<void> registerCore(GetIt getIt) async {
  await Hive.initFlutter();
  final boxes = await Future.wait([
    Hive.openBox<Map<dynamic, dynamic>>(CustomerLocalDataSource.boxName),
    Hive.openBox<Map<dynamic, dynamic>>(PendingEditQueue.boxName),
    Hive.openBox<Map<dynamic, dynamic>>(AuthLocalDataSource.boxName),
  ]);
  final settingsBox = await Hive.openBox<String>(
    SettingsRepositoryImpl.boxName,
  );
  getIt
    ..registerSingleton<MapBox>(boxes[0], instanceName: 'customers')
    ..registerSingleton<MapBox>(boxes[1], instanceName: 'pending')
    ..registerSingleton<MapBox>(boxes[2], instanceName: 'session')
    ..registerSingleton<Box<String>>(settingsBox);

  final jar = await DioFactory.createCookieJar();
  getIt
    ..registerSingleton<CookieJar>(jar)
    ..registerSingleton(OdooEndpoint())
    ..registerSingleton(CredentialsStore(const FlutterSecureStorage()))
    ..registerSingleton<ConnectivityService>(ConnectivityPlusService())
    ..registerSingleton(
      PendingEditQueue(getIt<MapBox>(instanceName: 'pending')),
    );

  final transport = JsonRpcTransport(DioFactory.create(jar), getIt());
  getIt.registerSingleton<OdooClient>(
    FallbackOdooClient(
      primary: JsonRpcOdooClient(transport, jar, getIt()),
      fallback: XmlRpcOdooClient(getIt(), getIt()),
    ),
  );
}
