import '../../../../core/network/odoo_client.dart';
import '../../../../core/network/odoo_exception.dart';
import '../../domain/entities/sale_order.dart';
import '../../domain/entities/sale_order_details.dart';
import '../models/sale_order_model.dart';

class SaleOrderRemoteDataSource {
  SaleOrderRemoteDataSource(this._client);

  static const model = 'sale.order';
  static const lineModel = 'sale.order.line';
  final OdooClient _client;

  Future<List<SaleOrder>> fetchPage({
    required int offset,
    required int limit,
  }) async {
    final rows = await _client.searchRead(
      model,
      fields: SaleOrderModel.listFields,
      limit: limit,
      offset: offset,
      order: 'date_order desc, id desc',
    );
    return rows.map(SaleOrderModel.fromOdoo).toList();
  }

  Future<SaleOrderDetails> fetchDetails(int id) async {
    final orders = await _client.read(model, [id], SaleOrderModel.detailFields);
    if (orders.isEmpty) {
      throw const OdooException(OdooErrorKind.server, 'Record not found');
    }
    final lines = await _client.searchRead(
      lineModel,
      // Section and note lines carry no product or amounts.
      domain: [
        ['order_id', '=', id],
        ['display_type', '=', false],
      ],
      fields: SaleOrderModel.lineFields,
      order: 'sequence asc, id asc',
    );
    return SaleOrderModel.detailsFromOdoo(orders.first, lines);
  }

  Future<void> confirm(int id) => _client.callMethod(model, 'action_confirm', [
    [id],
  ]);
}
