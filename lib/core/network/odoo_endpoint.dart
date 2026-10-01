/// Mutable server location shared by both transports.
///
/// Defaults come from `--dart-define=ODOO_URL=... --dart-define=ODOO_DB=...`
/// and can be changed from the login screen's "Server settings".
class OdooEndpoint {
  OdooEndpoint({String? baseUrl, String? database})
    : baseUrl = normalize(baseUrl ?? defaultUrl),
      database = database ?? defaultDatabase;

  static const defaultUrl = String.fromEnvironment(
    'ODOO_URL',
    defaultValue: 'http://10.0.2.2:8069',
  );
  static const defaultDatabase = String.fromEnvironment(
    'ODOO_DB',
    defaultValue: 'odoo_demo',
  );

  String baseUrl;
  String database;

  void update({required String baseUrl, required String database}) {
    this.baseUrl = normalize(baseUrl);
    this.database = database.trim();
  }

  Uri resolve(String path) => Uri.parse('$baseUrl$path');

  /// Trims whitespace and trailing slashes.
  static String normalize(String url) =>
      url.trim().replaceFirst(RegExp(r'/+$'), '');
}
