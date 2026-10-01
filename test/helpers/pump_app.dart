import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:odoo_task/core/theme/app_theme.dart';
import 'package:odoo_task/l10n/generated/app_localizations.dart';

extension PumpApp on WidgetTester {
  /// Pumps [child] inside a themed, localized MaterialApp.
  Future<void> pumpLocalized(
    Widget child, {
    Locale locale = const Locale('en'),
    ThemeData? theme,
  }) => pumpWidget(
    MaterialApp(
      theme: theme ?? AppTheme.light,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: child,
    ),
  );
}
