import 'package:equatable/equatable.dart';

class CustomerDetails extends Equatable {
  const CustomerDetails({
    required this.id,
    required this.name,
    this.phone,
    this.email,
    this.street,
    this.street2,
    this.city,
    this.zip,
    this.stateName,
    this.countryName,
    this.hasPendingSync = false,
  });

  final int id;
  final String name;
  final String? phone;
  final String? email;
  final String? street;
  final String? street2;
  final String? city;
  final String? zip;
  final String? stateName;
  final String? countryName;
  final bool hasPendingSync;

  /// Postal address, one line per non-empty part.
  List<String> get addressLines {
    String? join(List<String?> parts, String sep) {
      final kept = parts.whereType<String>().where((p) => p.isNotEmpty);
      return kept.isEmpty ? null : kept.join(sep);
    }

    return [
      street,
      street2,
      join([zip, city], ' '),
      join([stateName, countryName], ', '),
    ].whereType<String>().where((l) => l.isNotEmpty).toList();
  }

  CustomerDetails copyWith({String? Function()? phone, bool? hasPendingSync}) =>
      CustomerDetails(
        id: id,
        name: name,
        phone: phone != null ? phone() : this.phone,
        email: email,
        street: street,
        street2: street2,
        city: city,
        zip: zip,
        stateName: stateName,
        countryName: countryName,
        hasPendingSync: hasPendingSync ?? this.hasPendingSync,
      );

  @override
  List<Object?> get props => [
    id,
    name,
    phone,
    email,
    street,
    street2,
    city,
    zip,
    stateName,
    countryName,
    hasPendingSync,
  ];
}
