import 'dart:convert';
import 'dart:io';

/// Independent check of server state (a second, raw admin session), so the
/// tests verify what Odoo actually stored rather than what the app thinks.
class OdooAdmin {
  OdooAdmin(this.url);

  final String url;
  final _http = HttpClient();
  String? _cookie;

  Future<dynamic> _post(String path, Map<String, dynamic> params) async {
    final req = await _http.postUrl(Uri.parse('$url$path'));
    req.headers.contentType = ContentType.json;
    if (_cookie != null) req.headers.set('Cookie', _cookie!);
    req.write(
      jsonEncode({'jsonrpc': '2.0', 'method': 'call', 'params': params}),
    );
    final res = await req.close();
    final setCookie = res.headers['set-cookie']?.first;
    if (setCookie != null) _cookie = setCookie.split(';').first;
    final body = jsonDecode(await res.transform(utf8.decoder).join()) as Map;
    if (body['error'] != null) throw StateError('${body['error']}');
    return body['result'];
  }

  Future<void> login() => _post('/web/session/authenticate', {
    'db': 'odoo_demo',
    'login': 'admin',
    'password': 'admin',
  });

  Future<dynamic> kw(String model, String method, List<dynamic> args) =>
      _post('/web/dataset/call_kw/$model/$method', {
        'model': model,
        'method': method,
        'args': args,
        'kwargs': <String, dynamic>{},
      });

  Future<Map<String, dynamic>> read(
    String model,
    int id,
    List<String> f,
  ) async => Map<String, dynamic>.from(
    (await kw(model, 'read', [
                  [id],
                  f,
                ])
                as List)
            .first
        as Map,
  );

  /// Creates a fresh quotation so the confirm test never runs out of drafts.
  Future<int> createQuotation() async {
    final partner =
        (await kw('res.partner', 'search', [
                      [
                        ['customer_rank', '>', 0],
                      ],
                    ])
                    as List)
                .first
            as int;
    final product =
        (await kw('product.product', 'search', [
                      [
                        ['sale_ok', '=', true],
                      ],
                    ])
                    as List)
                .first
            as int;
    return await kw('sale.order', 'create', [
          {
            'partner_id': partner,
            'order_line': [
              [
                0,
                0,
                {'product_id': product, 'product_uom_qty': 1},
              ],
            ],
          },
        ])
        as int;
  }
}
