import 'package:flutter/material.dart';

import '../motion/motion_x.dart';
import '../theme/app_dimens.dart';

/// Label / spinner / check, cross-faded.
class PrimaryButtonContent extends StatelessWidget {
  const PrimaryButtonContent({
    super.key,
    required this.label,
    required this.running,
    required this.success,
    this.icon,
  });

  final String label;
  final IconData? icon;
  final bool running;
  final bool success;

  @override
  Widget build(BuildContext context) {
    final onPrimary = Theme.of(context).colorScheme.onPrimary;
    final Widget child;
    if (running) {
      child = SizedBox.square(
        key: const ValueKey('busy'),
        dimension: 22,
        child: CircularProgressIndicator(strokeWidth: 2.4, color: onPrimary),
      );
    } else if (success) {
      child = const Icon(Icons.check_rounded, key: ValueKey('done'));
    } else {
      // scaleDown keeps the fading-out label from overflowing while the
      // button shrinks into a circle.
      child = FittedBox(
        key: const ValueKey('label'),
        fit: BoxFit.scaleDown,
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: AppDimens.lg,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20),
                const SizedBox(width: AppDimens.sm),
              ],
              Text(label, maxLines: 1),
            ],
          ),
        ),
      );
    }
    return AnimatedSwitcher(
      duration: context.motion(AppDimens.switchDuration),
      child: child,
    );
  }
}
