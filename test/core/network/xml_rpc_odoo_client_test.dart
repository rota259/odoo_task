import 'package:flutter_test/flutter_test.dart';
import 'package:odoo_task/core/network/odoo_endpoint.dart';
import 'package:odoo_task/core/network/odoo_exception.dart';
import 'package:odoo_task/core/network/xml_rpc_odoo_client.dart';
import 'package:xml_rpc/client.dart' as xml_rpc;

import '../../helpers/mocks.dart';

void main() {
  final calls = <(String, String, List<dynamic>)>[];
  late List<Object?> answers;

  XmlRpcOdooClient build() => XmlRpcOdooClient(
    OdooEndpoint(baseUrl: 'http://odoo:8069'),
    MockCredentialsStore(),
    call: (url, method, params) async {
      calls.add((url.path, method, params));
      final next = answers.removeAt(0);
      if (next is xml_rpc.Fault) throw next;
      return next;
    },
  );

  setUp(calls.clear);

  test('authenticate hits /xmlrpc/2/common and keeps the uid', () async {
    answers = [6, true];
    final client = build();
    final session = await client.authenticate('odoo_demo', 'demo', 'demo');
    expect(session.uid, 6);
    expect(calls.single.$1, '/xmlrpc/2/common');

    await client.callMethod('res.users', 'has_group', ['base.group_user']);
    final (path, method, params) = calls.last;
    expect(path, '/xmlrpc/2/object');
    expect(method, 'execute_kw');
    expect(params.take(5), ['odoo_demo', 6, 'demo', 'res.users', 'has_group']);
  });

  test('wrong credentials (Odoo answers false) -> accessDenied', () async {
    answers = [false];
    expect(
      () => build().authenticate('odoo_demo', 'demo', 'bad'),
      throwsA(
        isA<OdooException>().having(
          (e) => e.kind,
          'kind',
          OdooErrorKind.accessDenied,
        ),
      ),
    );
  });

  test('faults become OdooException; false values pass through', () async {
    answers = [
      2,
      [
        {'id': 1, 'street2': false},
      ],
      xml_rpc.Fault(2, 'Record does not exist or has been deleted.'),
    ];
    final client = build();
    await client.authenticate('odoo_demo', 'admin', 'admin');
    final rows = await client.read('res.partner', [1], ['street2']);
    expect(rows.single['street2'], false);
    expect(
      () => client.write('res.partner', [1], {'phone': '1'}),
      throwsA(
        isA<OdooException>().having(
          (e) => e.message,
          'msg',
          contains('does not exist'),
        ),
      ),
    );
  });
}
