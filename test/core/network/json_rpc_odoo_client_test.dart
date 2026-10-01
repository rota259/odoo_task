import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:odoo_task/core/network/json_rpc_odoo_client.dart';
import 'package:odoo_task/core/network/odoo_exception.dart';
import 'package:odoo_task/core/storage/stored_credentials.dart';

import '../../helpers/fake_http_adapter.dart';
import '../../helpers/json_rpc_harness.dart';
import '../../helpers/mocks.dart';

void main() {
  late FakeHttpAdapter http;
  late MockCredentialsStore credentials;
  late JsonRpcOdooClient client;

  setUp(() {
    http = FakeHttpAdapter();
    credentials = MockCredentialsStore();
    client = buildJsonRpcClient(http, credentials);
  });

  test('authenticate posts to /web/session/authenticate', () async {
    http.reply(authOk);
    final session = await client.authenticate('odoo_demo', 'admin', 'admin');
    expect(session.uid, 2);
    expect(session.name, 'Mitchell Admin');
    expect(http.requests.single.uri.path, '/web/session/authenticate');
    expect(http.bodies.single['params'], containsPair('login', 'admin'));
  });

  test('searchRead uses /web/dataset/call_kw/{model}/{method}', () async {
    http.reply({
      'result': [
        {'id': 1, 'name': 'A'},
      ],
    });
    final rows = await client.searchRead(
      'res.partner',
      domain: [
        ['customer_rank', '>', 0],
      ],
      fields: ['name'],
      limit: 30,
      offset: 0,
    );
    expect(rows.single['name'], 'A');
    expect(
      http.requests.single.uri.path,
      '/web/dataset/call_kw/res.partner/search_read',
    );
    final params = http.bodies.single['params'] as Map;
    expect(params['method'], 'search_read');
    expect(params['kwargs'], containsPair('limit', 30));
  });

  test('error responses throw OdooException with data.message', () async {
    http.reply({
      'error': {
        'code': 200,
        'message': 'Odoo Server Error',
        'data': {'name': 'odoo.exceptions.UserError', 'message': 'Nope'},
      },
    });
    expect(
      () => client.callMethod('sale.order', 'action_confirm', [
        [1],
      ]),
      throwsA(isA<OdooException>().having((e) => e.message, 'msg', 'Nope')),
    );
  });

  test('expired session: silent re-auth then one retry', () async {
    when(() => credentials.read()).thenAnswer(
      (_) async => const StoredCredentials(
        baseUrl: 'http://odoo:8069',
        database: 'odoo_demo',
        login: 'admin',
        password: 'admin',
      ),
    );
    http
      ..reply(sessionExpired)
      ..reply(authOk)
      ..reply({'result': 5});
    final count = await client.searchCount('res.partner', const []);
    expect(count, 5);
    expect(http.requests.map((r) => r.uri.path), [
      '/web/dataset/call_kw/res.partner/search_count',
      '/web/session/authenticate',
      '/web/dataset/call_kw/res.partner/search_count',
    ]);
  });
}
