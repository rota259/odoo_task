import '../../../../core/network/odoo_parsing.dart';
import '../../domain/entities/customer.dart';

/// Maps `res.partner` list records (Odoo and cache) to [Customer].
abstract final class CustomerModel {
  static const fields = ['id', 'name', 'phone', 'city'];

  static Customer fromOdoo(Map<String, dynamic> json) => Customer(
    id: OdooParsing.integer(json['id']) ?? 0,
    name: OdooParsing.string(json['name']) ?? '',
    phone: OdooParsing.string(json['phone']),
    city: OdooParsing.string(json['city']),
  );

  /// Cache maps use plain nulls (never Odoo's `false`).
  static Map<String, dynamic> toCache(Customer c) => {
    'id': c.id,
    'name': c.name,
    'phone': c.phone,
    'city': c.city,
  };

  static Customer fromCache(Map<dynamic, dynamic> map) => Customer(
    id: map['id'] as int,
    name: map['name'] as String? ?? '',
    phone: map['phone'] as String?,
    city: map['city'] as String?,
  );
}
