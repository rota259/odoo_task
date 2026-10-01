import 'package:flutter/widgets.dart';

/// Honors the system "reduce motion" setting.
extension MotionX on BuildContext {
  bool get reduceMotion => MediaQuery.maybeDisableAnimationsOf(this) ?? false;

  /// [duration], or zero when the user asked for reduced motion.
  Duration motion(Duration duration) => reduceMotion ? Duration.zero : duration;
}
