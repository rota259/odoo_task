import 'dart:io';

import 'package:xml_rpc/client.dart' as xml_rpc;

import 'odoo_error_parser.dart';
import 'odoo_exception.dart';

/// Signature of a raw XML-RPC call; injectable for tests.
typedef XmlRpcCall =
    Future<dynamic> Function(Uri url, String method, List<dynamic> params);

/// Wraps `package:xml_rpc` and normalizes its errors to [OdooException].
Future<dynamic> guardedXmlRpcCall(
  XmlRpcCall call,
  Uri url,
  String method,
  List<dynamic> params,
) async {
  try {
    return await call(url, method, params);
  } on xml_rpc.Fault catch (f) {
    throw OdooErrorParser.fromXmlRpcFault(f.code, f.text);
  } on IOException catch (e) {
    // SocketException, HttpException and http's ClientException.
    throw OdooException.network(e.toString());
  } on OdooException {
    rethrow;
  } on Object catch (e) {
    // Non-200 statuses (xml_rpc throws the raw http.Response) and
    // unparsable bodies (XmlException): the endpoint is not XML-RPC.
    throw OdooException.transport('XML-RPC endpoint error: $e');
  }
}

/// Default implementation backed by `package:xml_rpc`.
Future<dynamic> defaultXmlRpcCall(
  Uri url,
  String method,
  List<dynamic> params,
) => xml_rpc.call(url, method, params);
