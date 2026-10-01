import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

/// Scripted Dio adapter: returns queued responses and records requests.
class FakeHttpAdapter implements HttpClientAdapter {
  final _responses = <(int, String, String)>[];
  final requests = <RequestOptions>[];
  final bodies = <Map<String, dynamic>>[];

  void reply(Object json, {int status = 200}) =>
      _responses.add((status, jsonEncode(json), 'application/json'));

  void replyRaw(String body, {int status = 200, String type = 'text/html'}) =>
      _responses.add((status, body, type));

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    final data = options.data;
    bodies.add(
      data is Map<String, dynamic>
          ? data
          : jsonDecode(data as String) as Map<String, dynamic>,
    );
    final (status, body, type) = _responses.removeAt(0);
    return ResponseBody.fromString(
      body,
      status,
      headers: {
        Headers.contentTypeHeader: [type],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
