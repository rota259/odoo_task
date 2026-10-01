import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'status_tone.dart';

/// Brand tokens that do not fit into [ColorScheme].
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.brandYellow,
    required this.background,
    required this.softShadow,
    required this.shimmerBase,
    required this.shimmerHighlight,
    required this.neutral,
    required this.info,
    required this.success,
    required this.danger,
  });

  final Color brandYellow;
  final Color background;
  final Color softShadow;
  final Color shimmerBase;
  final Color shimmerHighlight;
  final StatusTone neutral;
  final StatusTone info;
  final StatusTone success;
  final StatusTone danger;

  static final light = AppPalette(
    brandYellow: AppColors.yellow,
    background: AppColors.lightBackground,
    softShadow: AppColors.navyAlpha(AppColors.shadowAlpha),
    shimmerBase: AppColors.lightSurfaceHigh,
    shimmerHighlight: AppColors.lightSurface,
    neutral: StatusTone(AppColors.navyAlpha(0.08), AppColors.navy),
    info: StatusTone(AppColors.yellow.withValues(alpha: 0.24), AppColors.navy),
    success: StatusTone(
      AppColors.softGreen.withValues(alpha: 0.16),
      AppColors.softGreen,
    ),
    danger: StatusTone(
      AppColors.softRed.withValues(alpha: 0.14),
      AppColors.softRed,
    ),
  );

  static final dark = AppPalette(
    brandYellow: AppColors.yellow,
    background: AppColors.darkBackground,
    softShadow: AppColors.ink.withValues(alpha: 0.35),
    shimmerBase: AppColors.darkSurface,
    shimmerHighlight: AppColors.darkElevated,
    neutral: StatusTone(AppColors.offWhiteAlpha(0.10), AppColors.offWhite),
    info: StatusTone(
      AppColors.yellow.withValues(alpha: 0.20),
      AppColors.yellow,
    ),
    success: StatusTone(
      AppColors.softGreenLight.withValues(alpha: 0.16),
      AppColors.softGreenLight,
    ),
    danger: StatusTone(
      AppColors.softRedLight.withValues(alpha: 0.16),
      AppColors.softRedLight,
    ),
  );

  @override
  AppPalette copyWith() => this;

  @override
  AppPalette lerp(AppPalette? other, double t) {
    if (other == null) return this;
    Color c(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppPalette(
      brandYellow: c(brandYellow, other.brandYellow),
      background: c(background, other.background),
      softShadow: c(softShadow, other.softShadow),
      shimmerBase: c(shimmerBase, other.shimmerBase),
      shimmerHighlight: c(shimmerHighlight, other.shimmerHighlight),
      neutral: neutral.lerp(other.neutral, t),
      info: info.lerp(other.info, t),
      success: success.lerp(other.success, t),
      danger: danger.lerp(other.danger, t),
    );
  }
}

extension AppPaletteX on BuildContext {
  AppPalette get palette => Theme.of(this).extension<AppPalette>()!;
}
