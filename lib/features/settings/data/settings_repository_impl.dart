import 'package:hive_ce/hive.dart';

import '../domain/app_settings.dart';
import '../domain/settings_repository.dart';

/// Persists appearance preferences in Hive. Survives logout on purpose:
/// they belong to the device, not to the Odoo account.
class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(this._box);

  static const boxName = 'settings';
  static const _themeKey = 'theme_mode';
  static const _localeKey = 'locale';
  final Box<String> _box;

  @override
  AppSettings load() {
    final theme = AppThemeMode.values.firstWhere(
      (m) => m.name == _box.get(_themeKey),
      orElse: () => AppThemeMode.system,
    );
    final locale = _box.get(_localeKey);
    return AppSettings(
      themeMode: theme,
      localeCode: AppLanguages.supported.contains(locale) ? locale : null,
    );
  }

  @override
  Future<void> save(AppSettings settings) async {
    await _box.put(_themeKey, settings.themeMode.name);
    final locale = settings.localeCode;
    if (locale == null) {
      await _box.delete(_localeKey);
    } else {
      await _box.put(_localeKey, locale);
    }
  }
}
