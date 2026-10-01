import 'package:flutter/material.dart';

import 'app_color_schemes.dart';
import 'app_dimens.dart';
import 'app_palette.dart';
import 'app_text_theme.dart';

abstract final class AppTheme {
  static ThemeData get light => _build(AppColorSchemes.light, AppPalette.light);
  static ThemeData get dark => _build(AppColorSchemes.dark, AppPalette.dark);

  static ThemeData _build(ColorScheme scheme, AppPalette palette) {
    final text = AppTextTheme.build(scheme);
    final control = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppDimens.controlRadius),
    );
    OutlineInputBorder border(Color c) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimens.controlRadius),
      borderSide: BorderSide(color: c),
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: AppTextTheme.fontFamily,
      textTheme: text,
      scaffoldBackgroundColor: palette.background,
      extensions: [palette],
      appBarTheme: AppBarTheme(
        backgroundColor: palette.background,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: palette.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: text.titleLarge,
      ),
      cardTheme: CardThemeData(
        color: scheme.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.cardRadius),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(AppDimens.buttonHeight),
          shape: control,
          textStyle: text.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: control,
          side: BorderSide(color: scheme.outline),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(shape: control),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surface,
        border: border(scheme.outlineVariant),
        enabledBorder: border(scheme.outlineVariant),
        focusedBorder: border(scheme.primary),
        errorBorder: border(scheme.error),
        contentPadding: const EdgeInsetsDirectional.symmetric(
          horizontal: AppDimens.lg,
          vertical: AppDimens.md,
        ),
      ),
      dividerTheme: DividerThemeData(color: scheme.outlineVariant, space: 1),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: control,
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: text.bodyMedium?.copyWith(
          color: scheme.onInverseSurface,
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: palette.background,
        indicatorColor: scheme.secondaryContainer,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surface,
        indicatorColor: scheme.secondaryContainer,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
