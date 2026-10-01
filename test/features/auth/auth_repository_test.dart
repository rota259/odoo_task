import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:odoo_task/core/error/failures.dart';
import 'package:odoo_task/core/network/odoo_endpoint.dart';
import 'package:odoo_task/core/network/odoo_exception.dart';
import 'package:odoo_task/core/network/odoo_session.dart';
import 'package:odoo_task/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:odoo_task/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:odoo_task/features/auth/data/repositories/auth_repository_impl.dart';

import '../../helpers/hive_helper.dart';
import '../../helpers/mocks.dart';
import 'auth_fixtures.dart';

void main() {
  final hive = TestHive();
  late MockOdooClient client;
  late MockCredentialsStore credentials;
  late OdooEndpoint endpoint;
  late AuthRepositoryImpl repo;

  setUpAll(() => registerFallbackValue(portalStored));
  setUp(() async {
    await hive.setUp();
    client = MockOdooClient();
    credentials = MockCredentialsStore();
    endpoint = OdooEndpoint();
    when(() => credentials.save(any())).thenAnswer((_) async {});
    when(() => credentials.clear()).thenAnswer((_) async {});
    repo = AuthRepositoryImpl(
      remote: AuthRemoteDataSource(client),
      local: AuthLocalDataSource(await hive.mapBox('session')),
      credentials: credentials,
      endpoint: endpoint,
      cleaners: const [],
    );
  });
  tearDown(hive.tearDown);

  void serverAccepts({required bool internal}) {
    when(() => client.authenticate(any(), any(), any())).thenAnswer(
      (_) async => const OdooSession(
        uid: 7,
        database: 'odoo_demo',
        login: 'portal',
        name: 'Joel Willis',
      ),
    );
    when(
      () => client.callMethod('res.users', 'has_group', ['base.group_user']),
    ).thenAnswer((_) async => internal);
  }

  test('login: resolves internal flag via has_group, saves creds', () async {
    serverAccepts(internal: false);
    final user = (await repo.login(portalRequest)).getOrElse((f) => throw f);
    expect(user.isInternal, isFalse);
    expect(user.name, 'Joel Willis');
    expect(endpoint.baseUrl, 'http://odoo:8069');
    verify(() => credentials.save(portalStored));
  });

  test('login: wrong password -> InvalidCredentialsFailure', () async {
    when(
      () => client.authenticate(any(), any(), any()),
    ).thenThrow(const OdooException.accessDenied());
    final result = await repo.login(portalRequest);
    expect(result.getLeft().toNullable(), isA<InvalidCredentialsFailure>());
    verifyNever(() => credentials.save(any()));
  });

  test('restore: no stored credentials -> Right(null)', () async {
    when(() => credentials.read()).thenAnswer((_) async => null);
    expect((await repo.restoreSession()).toNullable(), isNull);
  });

  test('restore offline: falls back to the cached profile', () async {
    serverAccepts(internal: true);
    await repo.login(portalRequest);
    when(() => credentials.read()).thenAnswer((_) async => portalStored);
    when(
      () => client.authenticate(any(), any(), any()),
    ).thenThrow(const OdooException.network());
    final user = (await repo.restoreSession()).toNullable();
    expect(user?.isInternal, isTrue);
  });

  test('logout clears server session and credentials', () async {
    when(() => client.logout()).thenAnswer((_) async {});
    await repo.logout();
    verify(() => client.logout());
    verify(() => credentials.clear());
  });
}
