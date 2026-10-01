import 'many2one.dart';

/// Safe readers for Odoo field values.
///
/// Odoo returns `false` for empty fields of every type (char, many2one,
/// date...), never `null` or `""`, so plain casts would crash.
abstract final class OdooParsing {
  /// Text value, or `null` when empty (`false`, `null`, blank string).
  static String? string(Object? value) {
    if (value is! String) return null;
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  static int? integer(Object? value) => switch (value) {
    final int v => v,
    final double v => v.toInt(),
    _ => null,
  };

  static double decimal(Object? value) => switch (value) {
    final num v => v.toDouble(),
    _ => 0,
  };

  /// `[id, "Display Name"]` or `false`.
  static Many2One? many2one(Object? value) {
    if (value is! List || value.length < 2) return null;
    final id = integer(value[0]);
    final name = string(value[1]);
    if (id == null) return null;
    return Many2One(id, name ?? '');
  }

  /// Odoo datetimes are UTC strings like `2026-10-01 11:25:25`.
  static DateTime? dateTime(Object? value) {
    final text = string(value);
    if (text == null) return null;
    final iso = '${text.replaceFirst(' ', 'T')}Z';
    return DateTime.tryParse(iso)?.toLocal();
  }

  static List<Map<String, dynamic>> records(Object? value) {
    if (value is! List) return const [];
    return [
      for (final item in value)
        if (item is Map) Map<String, dynamic>.from(item),
    ];
  }
}
