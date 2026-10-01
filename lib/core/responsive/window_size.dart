import 'package:flutter/widgets.dart';

/// Material window size classes used by the app.
enum WindowSize {
  /// < 600: phones, single pane.
  compact,

  /// 600-1024: tablets / foldables, list-detail.
  medium,

  /// > 1024: large tablets / desktop, list-detail.
  expanded;

  static const compactMax = 600.0;
  static const mediumMax = 1024.0;

  static WindowSize fromWidth(double width) {
    if (width < compactMax) return compact;
    if (width <= mediumMax) return medium;
    return expanded;
  }

  bool get isCompact => this == compact;
}

extension WindowSizeX on BuildContext {
  WindowSize get windowSize =>
      WindowSize.fromWidth(MediaQuery.sizeOf(this).width);
}
