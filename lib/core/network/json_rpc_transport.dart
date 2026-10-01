import 'dart:convert';

import 'package:dio/dio.dart';

import 'odoo_endpoint.dart';
import 'odoo_error_parser.dart';
import 'odoo_exception.dart';

/// Posts JSON-RPC 2.0 envelopes and unwraps `result` / `error`.
///
/// Anything that is not a JSON-RPC answer (404, HTML page, garbage) is
/// reported as [OdooErrorKind.transport] so the caller can fall back.
class JsonRpcTransport {
  JsonRpcTransport(this._dio, this._endpoint);

  final Dio _dio;
  final OdooEndpoint _endpoint;

  Future<dynamic> post(String path, Map<String, dynamic> params) async {
    final Response<String> response;
    try {
      response = await _dio.postUri<String>(
        _endpoint.resolve(path),
        data: {'jsonrpc': '2.0', 'method': 'call', 'params': params},
        options: Options(
          responseType: ResponseType.plain,
          contentType: Headers.jsonContentType,
          validateStatus: (_) => true,
        ),
      );
    } on DioException catch (e) {
      throw OdooException.network(e.message ?? e.type.name);
    }
    final status = response.statusCode ?? 0;
    final body = _decode(response.data);
    if (body == null) {
      throw OdooException.transport('HTTP $status: not a JSON-RPC response');
    }
    if (body.containsKey('error')) {
      throw OdooErrorParser.fromJsonRpc(body['error']);
    }
    if (status != 200 || !body.containsKey('result')) {
      throw OdooException.transport('HTTP $status: unexpected payload');
    }
    return body['result'];
  }

  Map<String, dynamic>? _decode(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      return decoded is Map<String, dynamic> ? decoded : null;
    } on FormatException {
      return null;
    }
  }
}
