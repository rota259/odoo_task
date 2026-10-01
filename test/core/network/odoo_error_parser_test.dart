import 'package:flutter_test/flutter_test.dart';
import 'package:odoo_task/core/network/odoo_error_parser.dart';
import 'package:odoo_task/core/network/odoo_exception.dart';

Map<String, dynamic> _error(int code, String name, String message) => {
  'code': code,
  'message': 'Odoo Server Error',
  'data': {'name': name, 'message': message},
};

void main() {
  group('fromJsonRpc (payloads captured from Odoo 17)', () {
    test('AccessDenied -> accessDenied', () {
      final e = OdooErrorParser.fromJsonRpc(
        _error(200, 'odoo.exceptions.AccessDenied', 'Access Denied'),
      );
      expect(e.kind, OdooErrorKind.accessDenied);
    });

    test('missing database -> databaseNotFound', () {
      final e = OdooErrorParser.fromJsonRpc(
        _error(
          200,
          'psycopg2.OperationalError',
          'connection failed: FATAL:  database "nope" does not exist',
        ),
      );
      expect(e.kind, OdooErrorKind.databaseNotFound);
    });

    test('code 100 -> sessionExpired', () {
      final e = OdooErrorParser.fromJsonRpc(
        _error(100, 'odoo.http.SessionExpiredException', 'Session expired'),
      );
      expect(e.kind, OdooErrorKind.sessionExpired);
      expect(e.code, 100);
    });

    test('business errors keep error.data.message', () {
      final e = OdooErrorParser.fromJsonRpc(
        _error(
          200,
          'odoo.exceptions.UserError',
          'The following orders are not in a state requiring confirmation',
        ),
      );
      expect(e.kind, OdooErrorKind.server);
      expect(e.message, startsWith('The following orders'));
      expect(e.name, 'odoo.exceptions.UserError');
    });

    test('malformed error object still yields a server error', () {
      expect(OdooErrorParser.fromJsonRpc('boom').kind, OdooErrorKind.server);
    });
  });

  group('fromXmlRpcFault', () {
    test('plain business fault keeps the whole message', () {
      final e = OdooErrorParser.fromXmlRpcFault(
        2,
        'Record does not exist or has been deleted.\n(Record: x)',
      );
      expect(e.kind, OdooErrorKind.server);
      expect(e.message, contains('Record does not exist'));
    });

    test('traceback fault keeps its last line and is classified', () {
      final e = OdooErrorParser.fromXmlRpcFault(
        1,
        'Traceback (most recent call last):\n  File "x"\n'
        'psycopg2.OperationalError: database "nope" does not exist',
      );
      expect(e.kind, OdooErrorKind.databaseNotFound);
      expect(e.message, startsWith('psycopg2.OperationalError'));
    });

    test('Access Denied fault', () {
      final e = OdooErrorParser.fromXmlRpcFault(3, 'Access Denied');
      expect(e.kind, OdooErrorKind.accessDenied);
    });
  });
}
