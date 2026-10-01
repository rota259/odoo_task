import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:odoo_task/core/network/fallback_odoo_client.dart';
import 'package:odoo_task/core/network/json_rpc_odoo_client.dart';
import 'package:odoo_task/core/network/json_rpc_transport.dart';
import 'package:odoo_task/core/network/odoo_endpoint.dart';
import 'package:odoo_task/core/network/xml_rpc_odoo_client.dart';
import 'package:odoo_task/core/storage/credentials_store.dart';
import 'package:odoo_task/core/storage/stored_credentials.dart';
import 'package:odoo_task/core/sync/pending_edit_queue.dart';
import 'package:odoo_task/core/sync/sync_service.dart';
import 'package:odoo_task/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:odoo_task/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:odoo_task/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:odoo_task/features/customers/data/datasources/customer_change_bus.dart';
import 'package:odoo_task/features/customers/data/datasources/customer_local_data_source.dart';
import 'package:odoo_task/features/customers/data/datasources/customer_remote_data_source.dart';
import 'package:odoo_task/features/customers/data/repositories/customer_edit_sender.dart';
import 'package:odoo_task/features/customers/data/repositories/customer_repository_impl.dart';
import 'package:odoo_task/features/sales_orders/data/datasources/sale_order_remote_data_source.dart';
import 'package:odoo_task/features/sales_orders/data/repositories/sale_order_repository_impl.dart';

import '../test/helpers/fake_connectivity.dart';
import '../test/helpers/hive_helper.dart';

/// Keystore stand-in: keeps credentials in memory.
class MemoryCredentials extends CredentialsStore {
  MemoryCredentials() : super(const FlutterSecureStorage());
  StoredCredentials? _value;
  @override
  Future<void> save(StoredCredentials c) async => _value = c;
  @override
  Future<StoredCredentials?> read() async => _value;
  @override
  Future<void> clear() async => _value = null;
}

/// The production object graph, wired against a real Odoo server.
class LiveStack {
  LiveStack(this.url);

  final String url;
  final hive = TestHive();
  final connectivity = FakeConnectivity();
  final credentials = MemoryCredentials();
  late final endpoint = OdooEndpoint(baseUrl: url);
  late FallbackOdooClient client;
  late AuthRepositoryImpl auth;
  late CustomerRepositoryImpl customers;
  late SaleOrderRepositoryImpl orders;
  late SyncService sync;

  Future<void> setUp() async {
    await hive.setUp();
    final jar = CookieJar();
    final dio = Dio()..interceptors.add(CookieManager(jar));
    client = FallbackOdooClient(
      primary: JsonRpcOdooClient(
        JsonRpcTransport(dio, endpoint),
        jar,
        credentials,
      ),
      fallback: XmlRpcOdooClient(endpoint, credentials),
    );
    final remote = CustomerRemoteDataSource(client);
    final queue = PendingEditQueue(await hive.mapBox('pending'));
    final bus = CustomerChangeBus();
    customers = CustomerRepositoryImpl(
      remote: remote,
      local: CustomerLocalDataSource(await hive.mapBox('customers')),
      queue: queue,
      connectivity: connectivity,
      bus: bus,
    );
    auth = AuthRepositoryImpl(
      remote: AuthRemoteDataSource(client),
      local: AuthLocalDataSource(await hive.mapBox('session')),
      credentials: credentials,
      endpoint: endpoint,
      cleaners: [customers],
    );
    orders = SaleOrderRepositoryImpl(
      SaleOrderRemoteDataSource(client),
      connectivity,
    );
    sync = SyncService(
      connectivity,
      queue,
      CustomerEditSender(remote, queue, bus),
    )..start();
  }

  Future<void> tearDown() async {
    await sync.dispose();
    await hive.tearDown();
  }
}
