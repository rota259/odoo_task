import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/app_settings.dart';
import '../../domain/settings_repository.dart';

/// App-wide appearance settings; the state is the [AppSettings] entity.
class SettingsViewModel extends Cubit<AppSettings> {
  SettingsViewModel(this._repository) : super(_repository.load());

  final SettingsRepository _repository;

  Future<void> setThemeMode(AppThemeMode mode) =>
      _update(state.copyWith(themeMode: mode));

  /// `null` follows the device language.
  Future<void> setLocale(String? code) =>
      _update(state.copyWith(localeCode: () => code));

  Future<void> _update(AppSettings next) async {
    if (next == state) return;
    emit(next);
    await _repository.save(next);
  }
}
