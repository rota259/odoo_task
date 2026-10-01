import 'package:flutter/material.dart';

/// Full Cairo-based type scale (bundled font, works for Arabic + English).
abstract final class AppTextTheme {
  static const fontFamily = 'Cairo';

  static TextTheme build(ColorScheme scheme) {
    final primary = scheme.onSurface;
    final secondary = scheme.onSurfaceVariant;
    TextStyle s(double size, FontWeight w, Color c, {double h = 1.35}) =>
        TextStyle(
          fontFamily: fontFamily,
          fontSize: size,
          fontWeight: w,
          height: h,
          color: c,
        );
    return TextTheme(
      displayLarge: s(52, FontWeight.w700, primary, h: 1.15),
      displayMedium: s(42, FontWeight.w700, primary, h: 1.15),
      displaySmall: s(34, FontWeight.w600, primary, h: 1.2),
      headlineLarge: s(30, FontWeight.w700, primary, h: 1.25),
      headlineMedium: s(26, FontWeight.w600, primary, h: 1.25),
      headlineSmall: s(22, FontWeight.w600, primary, h: 1.3),
      titleLarge: s(20, FontWeight.w700, primary),
      titleMedium: s(16, FontWeight.w600, primary),
      titleSmall: s(14, FontWeight.w600, primary),
      bodyLarge: s(16, FontWeight.w400, primary, h: 1.5),
      bodyMedium: s(14, FontWeight.w400, primary, h: 1.5),
      bodySmall: s(12, FontWeight.w400, secondary, h: 1.45),
      labelLarge: s(14, FontWeight.w600, primary),
      labelMedium: s(12, FontWeight.w600, secondary),
      labelSmall: s(11, FontWeight.w500, secondary),
    );
  }
}
