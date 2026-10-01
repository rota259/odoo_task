import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'stored_credentials.dart';

/// Persists login credentials in the platform keystore so the app can
/// re-authenticate silently when the Odoo session expires.
class CredentialsStore {
  CredentialsStore(this._storage);

  static const _key = 'odoo_credentials';
  final FlutterSecureStorage _storage;
  StoredCredentials? _cache;

  Future<void> save(StoredCredentials credentials) async {
    _cache = credentials;
    await _storage.write(key: _key, value: jsonEncode(credentials.toJson()));
  }

  Future<StoredCredentials?> read() async {
    if (_cache != null) return _cache;
    try {
      final raw = await _storage.read(key: _key);
      if (raw == null) return null;
      final json = jsonDecode(raw);
      if (json is! Map<String, dynamic>) return null;
      return _cache = StoredCredentials.fromJson(json);
    } on Object {
      // Corrupted keystore entry (e.g. restored backup): treat as logged out.
      return null;
    }
  }

  Future<void> clear() async {
    _cache = null;
    await _storage.delete(key: _key);
  }
}
