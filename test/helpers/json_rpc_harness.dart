import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:odoo_task/core/network/json_rpc_odoo_client.dart';
import 'package:odoo_task/core/network/json_rpc_transport.dart';
import 'package:odoo_task/core/network/odoo_endpoint.dart';

import 'fake_http_adapter.dart';
import 'mocks.dart';

/// Payloads captured from Odoo 17.
const authOk = {
  'result': {'uid': 2, 'db': 'odoo_demo', 'name': 'Mitchell Admin'},
};
const sessionExpired = {
  'error': {
    'code': 100,
    'message': 'Odoo Session Expired',
    'data': {'name': 'odoo.http.SessionExpiredException', 'message': 'x'},
  },
};

JsonRpcOdooClient buildJsonRpcClient(
  FakeHttpAdapter http,
  MockCredentialsStore credentials,
) => JsonRpcOdooClient(
  JsonRpcTransport(
    Dio()..httpClientAdapter = http,
    OdooEndpoint(baseUrl: 'http://odoo:8069/'),
  ),
  CookieJar(),
  credentials,
);
