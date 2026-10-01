import 'odoo_client.dart';
import 'odoo_parsing.dart';

/// Implements the ORM helpers on top of [callMethod], so each transport only
/// has to know how to execute one `model.method(*args, **kwargs)` call.
mixin OdooOrmMixin implements OdooClient {
  @override
  Future<List<Map<String, dynamic>>> searchRead(
    String model, {
    List<dynamic> domain = const [],
    List<String> fields = const [],
    int? limit,
    int? offset,
    String? order,
  }) async {
    final result = await callMethod(
      model,
      'search_read',
      [domain],
      {'fields': fields, 'limit': ?limit, 'offset': ?offset, 'order': ?order},
    );
    return OdooParsing.records(result);
  }

  @override
  Future<int> searchCount(String model, List<dynamic> domain) async {
    final result = await callMethod(model, 'search_count', [domain]);
    return OdooParsing.integer(result) ?? 0;
  }

  @override
  Future<List<Map<String, dynamic>>> read(
    String model,
    List<int> ids,
    List<String> fields,
  ) async {
    final result = await callMethod(model, 'read', [ids, fields]);
    return OdooParsing.records(result);
  }

  @override
  Future<bool> write(
    String model,
    List<int> ids,
    Map<String, dynamic> values,
  ) async {
    final result = await callMethod(model, 'write', [ids, values]);
    return result == true;
  }
}
