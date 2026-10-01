import 'package:mocktail/mocktail.dart';
import 'package:odoo_task/core/network/odoo_exception.dart';
import 'package:odoo_task/core/sync/pending_edit_queue.dart';
import 'package:odoo_task/features/customers/data/datasources/customer_change_bus.dart';
import 'package:odoo_task/features/customers/data/datasources/customer_local_data_source.dart';
import 'package:odoo_task/features/customers/data/datasources/customer_remote_data_source.dart';
import 'package:odoo_task/features/customers/data/repositories/customer_repository_impl.dart';

import '../../helpers/fake_connectivity.dart';
import '../../helpers/hive_helper.dart';
import '../../helpers/mocks.dart';

/// Real Hive cache + queue, mocked Odoo client.
class CustomerRepoHarness {
  final hive = TestHive();
  late MockOdooClient client;
  late FakeConnectivity connectivity;
  late CustomerChangeBus bus;
  late CustomerLocalDataSource local;
  late PendingEditQueue queue;
  late CustomerRemoteDataSource remote;
  late CustomerRepositoryImpl repo;

  Future<void> setUp() async {
    await hive.setUp();
    client = MockOdooClient();
    connectivity = FakeConnectivity();
    bus = CustomerChangeBus();
    local = CustomerLocalDataSource(await hive.mapBox('customers'));
    queue = PendingEditQueue(await hive.mapBox('pending'));
    remote = CustomerRemoteDataSource(client);
    repo = CustomerRepositoryImpl(
      remote: remote,
      local: local,
      queue: queue,
      connectivity: connectivity,
      bus: bus,
    );
  }

  Future<void> tearDown() async {
    await bus.dispose();
    await hive.tearDown();
  }

  void serverReturns(List<Map<String, dynamic>> rows) => when(
    () => client.searchRead(
      any(),
      domain: any(named: 'domain'),
      fields: any(named: 'fields'),
      limit: any(named: 'limit'),
      offset: any(named: 'offset'),
      order: any(named: 'order'),
    ),
  ).thenAnswer((_) async => rows);

  void serverUnreachable() => when(
    () => client.searchRead(
      any(),
      domain: any(named: 'domain'),
      fields: any(named: 'fields'),
      limit: any(named: 'limit'),
      offset: any(named: 'offset'),
      order: any(named: 'order'),
    ),
  ).thenThrow(const OdooException.network());

  void writeAnswers(Object Function() answer) =>
      when(() => client.write(any(), any(), any())).thenAnswer((_) async {
        final value = answer();
        if (value is Exception) throw value;
        return value as bool;
      });

  static Map<String, dynamic> row(
    int id,
    String name, {
    Object phone = false,
  }) => {'id': id, 'name': name, 'phone': phone, 'city': false};
}
