import 'package:equatable/equatable.dart';

class Customer extends Equatable {
  const Customer({
    required this.id,
    required this.name,
    this.phone,
    this.city,
    this.hasPendingSync = false,
  });

  final int id;
  final String name;
  final String? phone;
  final String? city;

  /// Has local edits that are not on the server yet.
  final bool hasPendingSync;

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    // Runes keep Arabic and other non-Latin initials intact.
    final letters = parts
        .take(2)
        .map((p) => String.fromCharCode(p.runes.first));
    return letters.join().toUpperCase();
  }

  Customer copyWith({String? Function()? phone, bool? hasPendingSync}) =>
      Customer(
        id: id,
        name: name,
        phone: phone != null ? phone() : this.phone,
        city: city,
        hasPendingSync: hasPendingSync ?? this.hasPendingSync,
      );

  @override
  List<Object?> get props => [id, name, phone, city, hasPendingSync];
}
