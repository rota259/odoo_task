import 'package:flutter/painting.dart';

/// The 2S Home Wear palette: navy, muted yellow and off-white, plus the
/// shades derived from them. Widgets never use these directly; they read
/// from `Theme.of(context).colorScheme` or [AppPalette].
abstract final class AppColors {
  // Base brand colors.
  static const navy = Color(0xFF1E2B45);
  static const yellow = Color(0xFFE3B341);
  static const offWhite = Color(0xFFF6F3EC);

  // Light theme surfaces.
  static const lightBackground = offWhite;
  static const lightSurface = Color(0xFFFFFDF8);
  static const lightSurfaceHigh = Color(0xFFF1EDE3);
  static const lightSurfaceHighest = Color(0xFFEAE5D9);

  // Dark theme surfaces (deeper navy family).
  static const darkBackground = Color(0xFF121A2B);
  static const darkSurface = Color(0xFF1A2438);
  static const darkElevated = Color(0xFF22304A);
  static const darkElevatedHigh = Color(0xFF2A3A57);

  // Near-black navy used only for dark-mode shadows and scrims.
  static const ink = Color(0xFF05080F);

  // Muted status accents (low saturation, palette-adjacent).
  static const softGreen = Color(0xFF5E8C6A);
  static const softRed = Color(0xFFB0605A);
  static const softGreenLight = Color(0xFF9CC3A6);
  static const softRedLight = Color(0xFFE0A29C);

  // Opacity helpers used for derived text / divider tones.
  static const secondaryTextLightAlpha = 0.65;
  static const secondaryTextDarkAlpha = 0.70;
  static const dividerAlpha = 0.10;
  static const shadowAlpha = 0.08;

  static Color navyAlpha(double a) => navy.withValues(alpha: a);
  static Color offWhiteAlpha(double a) => offWhite.withValues(alpha: a);
}
