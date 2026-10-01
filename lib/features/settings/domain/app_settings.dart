import 'package:equatable/equatable.dart';

enum AppThemeMode { system, light, dark }

/// Languages the app ships with; `null` locale code follows the device.
abstract final class AppLanguages {
  static const english = 'en';
  static const arabic = 'ar';
  static const supported = [english, arabic];
}

class AppSettings extends Equatable {
  const AppSettings({this.themeMode = AppThemeMode.system, this.localeCode});

  final AppThemeMode themeMode;

  /// `null` = follow the device language.
  final String? localeCode;

  AppSettings copyWith({
    AppThemeMode? themeMode,
    String? Function()? localeCode,
  }) => AppSettings(
    themeMode: themeMode ?? this.themeMode,
    localeCode: localeCode != null ? localeCode() : this.localeCode,
  );

  @override
  List<Object?> get props => [themeMode, localeCode];
}
