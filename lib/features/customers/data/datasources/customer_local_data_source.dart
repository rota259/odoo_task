import 'package:hive_ce/hive.dart';

import '../../domain/entities/customer.dart';
import '../../domain/entities/customer_details.dart';
import '../models/customer_details_model.dart';
import '../models/customer_model.dart';

/// Hive cache of every customer seen in a list page or details screen.
///
/// One map per partner id; list and detail fields are merged so a list
/// refresh never drops cached detail fields.
class CustomerLocalDataSource {
  CustomerLocalDataSource(this._box);

  static const boxName = 'customers';
  final Box<Map<dynamic, dynamic>> _box;

  Future<void> saveCustomers(List<Customer> customers) => _box.putAll({
    for (final c in customers) c.id: _merge(c.id, CustomerModel.toCache(c)),
  });

  Future<void> saveDetails(CustomerDetails details) => _box.put(
    details.id,
    _merge(details.id, CustomerDetailsModel.toCache(details)),
  );

  Future<void> updatePhone(int id, String phone) async {
    final current = _box.get(id);
    if (current == null) return;
    await _box.put(id, {...current, 'phone': phone});
  }

  /// Cached customers matching [query] (case-insensitive), sorted by name.
  List<Customer> search(String query) {
    final needle = query.trim().toLowerCase();
    final all = _box.values
        .map(CustomerModel.fromCache)
        .where((c) => needle.isEmpty || c.name.toLowerCase().contains(needle));
    return all.toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }

  CustomerDetails? details(int id) {
    final map = _box.get(id);
    return map == null ? null : CustomerDetailsModel.fromCache(map);
  }

  bool get isEmpty => _box.isEmpty;

  Future<void> clear() => _box.clear();

  Map<dynamic, dynamic> _merge(int id, Map<String, dynamic> values) => {
    ...?_box.get(id),
    ...values,
  };
}
