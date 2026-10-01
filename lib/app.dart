import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_dimens.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/viewmodels/auth_view_model.dart';
import 'features/settings/domain/app_settings.dart';
import 'features/settings/presentation/viewmodels/settings_view_model.dart';
import 'features/shell/presentation/viewmodels/sync_status_view_model.dart';
import 'features/shell/presentation/widgets/sync_listener.dart';
import 'l10n/generated/app_localizations.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final GoRouter _router = createRouter(getIt<AuthViewModel>());

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider.value(value: getIt<AuthViewModel>()),
      BlocProvider.value(value: getIt<SettingsViewModel>()),
      BlocProvider.value(value: getIt<SyncStatusViewModel>()),
    ],
    child: BlocBuilder<SettingsViewModel, AppSettings>(
      builder: (context, settings) => MaterialApp.router(
        onGenerateTitle: (context) => AppLocalizations.of(context).appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: switch (settings.themeMode) {
          AppThemeMode.system => ThemeMode.system,
          AppThemeMode.light => ThemeMode.light,
          AppThemeMode.dark => ThemeMode.dark,
        },
        themeAnimationDuration: AppDimens.themeDuration,
        themeAnimationCurve: Curves.easeInOut,
        locale: settings.localeCode == null
            ? null
            : Locale(settings.localeCode!),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        routerConfig: _router,
        builder: (context, child) => SyncListener(child: child!),
      ),
    ),
  );
}
