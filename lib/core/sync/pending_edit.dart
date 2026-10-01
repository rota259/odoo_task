import 'package:equatable/equatable.dart';

/// A field change made while offline, waiting to be written to Odoo.
class PendingEdit extends Equatable {
  const PendingEdit({
    required this.partnerId,
    required this.field,
    required this.value,
    required this.createdAt,
  });

  factory PendingEdit.fromMap(Map<dynamic, dynamic> map) => PendingEdit(
    partnerId: map['partnerId'] as int,
    field: map['field'] as String,
    value: map['value'],
    createdAt: DateTime.fromMicrosecondsSinceEpoch(map['createdAt'] as int),
  );

  final int partnerId;
  final String field;
  final Object? value;
  final DateTime createdAt;

  /// Edits to the same partner + field share a key, which is what makes the
  /// queue coalesce them (only the latest value is kept).
  String get key => '$partnerId:$field';

  Map<String, dynamic> toMap() => {
    'partnerId': partnerId,
    'field': field,
    'value': value,
    'createdAt': createdAt.microsecondsSinceEpoch,
  };

  @override
  List<Object?> get props => [partnerId, field, value, createdAt];
}
