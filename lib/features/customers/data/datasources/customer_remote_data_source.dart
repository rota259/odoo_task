import '../../../../core/network/odoo_client.dart';
import '../../../../core/network/odoo_exception.dart';
import '../../domain/entities/customer.dart';
import '../../domain/entities/customer_details.dart';
import '../models/customer_details_model.dart';
import '../models/customer_model.dart';

class CustomerRemoteDataSource {
  CustomerRemoteDataSource(this._client);

  static const model = 'res.partner';
  static const baseDomain = [
    ['customer_rank', '>', 0],
  ];
  final OdooClient _client;

  Future<List<Customer>> fetchPage({
    required String query,
    required int offset,
    required int limit,
  }) async {
    final rows = await _client.searchRead(
      model,
      domain: [
        ...baseDomain,
        if (query.isNotEmpty) ['name', 'ilike', query],
      ],
      fields: CustomerModel.fields,
      limit: limit,
      offset: offset,
      order: 'name asc, id asc',
    );
    return rows.map(CustomerModel.fromOdoo).toList();
  }

  Future<CustomerDetails> fetchDetails(int id) async {
    final rows = await _client.read(model, [id], CustomerDetailsModel.fields);
    if (rows.isEmpty) {
      throw const OdooException(OdooErrorKind.server, 'Record not found');
    }
    return CustomerDetailsModel.fromOdoo(rows.first);
  }

  Future<void> writeFields(int id, Map<String, dynamic> values) async {
    final ok = await _client.write(model, [id], values);
    if (!ok) {
      throw const OdooException(OdooErrorKind.server, 'Update rejected');
    }
  }
}
