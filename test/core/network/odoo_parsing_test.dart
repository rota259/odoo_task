import 'package:flutter_test/flutter_test.dart';
import 'package:odoo_task/core/network/many2one.dart';
import 'package:odoo_task/core/network/odoo_parsing.dart';

void main() {
  group('OdooParsing.string', () {
    test('returns text, trimmed', () {
      expect(OdooParsing.string('  Acme '), 'Acme');
    });

    test('maps Odoo false, null and blanks to null', () {
      expect(OdooParsing.string(false), isNull);
      expect(OdooParsing.string(null), isNull);
      expect(OdooParsing.string('   '), isNull);
    });
  });

  group('OdooParsing.many2one', () {
    test('parses [id, "Display Name"]', () {
      expect(
        OdooParsing.many2one([13, 'California (US)']),
        const Many2One(13, 'California (US)'),
      );
    });

    test('returns null for false and malformed values', () {
      expect(OdooParsing.many2one(false), isNull);
      expect(OdooParsing.many2one([]), isNull);
      expect(OdooParsing.many2one(['x', 'y']), isNull);
    });
  });

  group('numbers', () {
    test('integer accepts int/double, rejects false', () {
      expect(OdooParsing.integer(4), 4);
      expect(OdooParsing.integer(4.0), 4);
      expect(OdooParsing.integer(false), isNull);
    });

    test('decimal defaults to 0 for false', () {
      expect(OdooParsing.decimal(12.5), 12.5);
      expect(OdooParsing.decimal(3), 3.0);
      expect(OdooParsing.decimal(false), 0);
    });
  });

  group('OdooParsing.dateTime', () {
    test('parses Odoo UTC datetimes', () {
      final parsed = OdooParsing.dateTime('2026-10-01 11:25:25')!;
      expect(parsed.toUtc(), DateTime.utc(2026, 10, 1, 11, 25, 25));
    });

    test('returns null for false or garbage', () {
      expect(OdooParsing.dateTime(false), isNull);
      expect(OdooParsing.dateTime('not a date'), isNull);
    });
  });

  test('records keeps only map rows', () {
    final rows = OdooParsing.records([
      {'id': 1},
      false,
      {'id': 2},
    ]);
    expect(rows.map((r) => r['id']), [1, 2]);
    expect(OdooParsing.records(false), isEmpty);
  });
}
