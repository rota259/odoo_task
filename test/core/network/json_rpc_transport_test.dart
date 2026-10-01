import 'package:flutter_test/flutter_test.dart';
import 'package:odoo_task/core/network/json_rpc_odoo_client.dart';
import 'package:odoo_task/core/network/odoo_exception.dart';

import '../../helpers/fake_http_adapter.dart';
import '../../helpers/json_rpc_harness.dart';
import '../../helpers/mocks.dart';

void main() {
  late FakeHttpAdapter http;
  late JsonRpcOdooClient client;

  setUp(() {
    http = FakeHttpAdapter();
    client = buildJsonRpcClient(http, MockCredentialsStore());
  });

  test('404 / HTML answers are transport errors', () async {
    http.replyRaw('<html>Not Found</html>', status: 404);
    expect(
      () => client.searchCount('res.partner', const []),
      throwsA(isA<OdooException>().having((e) => e.isTransport, 't', true)),
    );
  });

  test('an HTML page with HTTP 200 is a transport error too', () async {
    http.replyRaw('<html>Login proxy</html>');
    expect(
      () => client.searchCount('res.partner', const []),
      throwsA(isA<OdooException>().having((e) => e.isTransport, 't', true)),
    );
  });
}
