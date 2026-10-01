import '../../../../core/network/odoo_parsing.dart';
import '../../domain/entities/customer_details.dart';

/// Maps `res.partner` detail records (Odoo and cache) to [CustomerDetails].
abstract final class CustomerDetailsModel {
  static const fields = [
    'name',
    'phone',
    'email',
    'street',
    'street2',
    'city',
    'zip',
    'state_id',
    'country_id',
  ];

  static CustomerDetails fromOdoo(Map<String, dynamic> json) => CustomerDetails(
    id: OdooParsing.integer(json['id']) ?? 0,
    name: OdooParsing.string(json['name']) ?? '',
    phone: OdooParsing.string(json['phone']),
    email: OdooParsing.string(json['email']),
    street: OdooParsing.string(json['street']),
    street2: OdooParsing.string(json['street2']),
    city: OdooParsing.string(json['city']),
    zip: OdooParsing.string(json['zip']),
    stateName: OdooParsing.many2one(json['state_id'])?.name,
    countryName: OdooParsing.many2one(json['country_id'])?.name,
  );

  static Map<String, dynamic> toCache(CustomerDetails d) => {
    'id': d.id,
    'name': d.name,
    'phone': d.phone,
    'email': d.email,
    'street': d.street,
    'street2': d.street2,
    'city': d.city,
    'zip': d.zip,
    'state_name': d.stateName,
    'country_name': d.countryName,
  };

  static CustomerDetails fromCache(Map<dynamic, dynamic> map) =>
      CustomerDetails(
        id: map['id'] as int,
        name: map['name'] as String? ?? '',
        phone: map['phone'] as String?,
        email: map['email'] as String?,
        street: map['street'] as String?,
        street2: map['street2'] as String?,
        city: map['city'] as String?,
        zip: map['zip'] as String?,
        stateName: map['state_name'] as String?,
        countryName: map['country_name'] as String?,
      );
}
