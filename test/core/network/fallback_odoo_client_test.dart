import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:odoo_task/core/network/fallback_odoo_client.dart';
import 'package:odoo_task/core/network/odoo_exception.dart';
import 'package:odoo_task/core/network/odoo_session.dart';

import '../../helpers/mocks.dart';

const _session = OdooSession(uid: 2, database: 'db', login: 'admin');

void main() {
  late MockOdooClient primary;
  late MockOdooClient fallback;
  late FallbackOdooClient client;

  setUp(() {
    primary = MockOdooClient();
    fallback = MockOdooClient();
    client = FallbackOdooClient(primary: primary, fallback: fallback);
  });

  test('uses JSON-RPC while it works', () async {
    when(
      () => primary.authenticate(any(), any(), any()),
    ).thenAnswer((_) async => _session);
    await client.authenticate('db', 'admin', 'admin');
    verifyNever(() => fallback.authenticate(any(), any(), any()));
    expect(client.isUsingFallback, isFalse);
  });

  test('transport failure switches to XML-RPC for the session', () async {
    when(
      () => primary.callMethod(any(), any(), any(), any()),
    ).thenThrow(const OdooException.transport('404'));
    when(
      () => fallback.callMethod(any(), any(), any(), any()),
    ).thenAnswer((_) async => 3);

    expect(await client.callMethod('m', 'search_count', []), 3);
    expect(await client.callMethod('m', 'search_count', []), 3);
    expect(client.isUsingFallback, isTrue);
    // JSON-RPC is not retried once the switch happened.
    verify(() => primary.callMethod(any(), any(), any(), any())).called(1);
  });

  test('wrong credentials never trigger the fallback', () async {
    when(
      () => primary.authenticate(any(), any(), any()),
    ).thenThrow(const OdooException.accessDenied());
    await expectLater(
      client.authenticate('db', 'admin', 'bad'),
      throwsA(isA<OdooException>()),
    );
    verifyNever(() => fallback.authenticate(any(), any(), any()));
    expect(client.isUsingFallback, isFalse);
  });

  test('network outages never trigger the fallback', () async {
    when(
      () => primary.callMethod(any(), any(), any(), any()),
    ).thenThrow(const OdooException.network());
    await expectLater(
      client.callMethod('m', 'x', []),
      throwsA(isA<OdooException>()),
    );
    verifyNever(() => fallback.callMethod(any(), any(), any(), any()));
  });

  test('logout resets the transport choice', () async {
    when(
      () => primary.callMethod(any(), any(), any(), any()),
    ).thenThrow(const OdooException.transport('404'));
    when(
      () => fallback.callMethod(any(), any(), any(), any()),
    ).thenAnswer((_) async => 1);
    when(() => primary.logout()).thenAnswer((_) async {});
    when(() => fallback.logout()).thenAnswer((_) async {});
    await client.callMethod('m', 'x', []);
    await client.logout();
    expect(client.isUsingFallback, isFalse);
  });
}
