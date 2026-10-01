/// Spacing, radii and durations shared across the UI.
abstract final class AppDimens {
  static const cardRadius = 16.0;
  static const controlRadius = 14.0;
  static const chipRadius = 10.0;

  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const xxl = 32.0;

  static const avatar = 44.0;
  static const buttonHeight = 52.0;
  static const loginMaxWidth = 420.0;
  static const listPaneWidth = 380.0;
  static const contentMaxWidth = 720.0;

  static const pressDuration = Duration(milliseconds: 120);
  static const switchDuration = Duration(milliseconds: 250);
  static const themeDuration = Duration(milliseconds: 300);
  static const staggerStep = Duration(milliseconds: 40);
  static const staggerItem = Duration(milliseconds: 240);
  static const maxStaggered = 4;
  static const searchDebounce = Duration(milliseconds: 400);
}
