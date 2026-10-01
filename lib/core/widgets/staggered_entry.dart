import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../motion/motion_x.dart';
import '../theme/app_dimens.dart';

/// Fade + slide-in for list items on first load. The delay is capped so a
/// whole screen settles within ~400ms.
class StaggeredEntry extends StatelessWidget {
  const StaggeredEntry({
    super.key,
    required this.index,
    required this.animate,
    required this.child,
  });

  final int index;

  /// False for items appended later (pagination) or re-built on scroll.
  final bool animate;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!animate || context.reduceMotion) return child;
    final step = index.clamp(0, AppDimens.maxStaggered);
    return child
        .animate(delay: AppDimens.staggerStep * step)
        .fadeIn(duration: AppDimens.staggerItem, curve: Curves.easeOut)
        .slideY(
          begin: 0.08,
          end: 0,
          duration: AppDimens.staggerItem,
          curve: Curves.easeOutCubic,
        );
  }
}
