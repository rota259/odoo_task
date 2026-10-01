import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/l10n_x.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../auth/presentation/viewmodels/auth_view_model.dart';
import '../../domain/app_settings.dart';
import '../viewmodels/settings_view_model.dart';
import '../widgets/account_card.dart';
import '../widgets/settings_section.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final settings = context.watch<SettingsViewModel>();
    final user = context.select((AuthViewModel vm) => vm.state.user);
    final state = settings.state;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: Align(
        alignment: AlignmentDirectional.topStart,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppDimens.contentMaxWidth,
          ),
          child: ListView(
            padding: const EdgeInsetsDirectional.all(AppDimens.lg),
            children: [
              SettingsSection<AppThemeMode>(
                title: l10n.appearance,
                selected: state.themeMode,
                onChanged: settings.setThemeMode,
                options: {
                  AppThemeMode.system: (
                    l10n.themeSystem,
                    Icons.brightness_auto_outlined,
                  ),
                  AppThemeMode.light: (
                    l10n.themeLight,
                    Icons.light_mode_outlined,
                  ),
                  AppThemeMode.dark: (l10n.themeDark, Icons.dark_mode_outlined),
                },
              ),
              const SizedBox(height: AppDimens.xl),
              SettingsSection<String?>(
                title: l10n.language,
                selected: state.localeCode,
                onChanged: settings.setLocale,
                options: {
                  null: (l10n.languageSystem, Icons.phone_android_outlined),
                  AppLanguages.english: (
                    l10n.languageEnglish,
                    Icons.translate_rounded,
                  ),
                  AppLanguages.arabic: (
                    l10n.languageArabic,
                    Icons.translate_rounded,
                  ),
                },
              ),
              if (user != null) ...[
                const SizedBox(height: AppDimens.xl),
                AccountCard(user: user),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
