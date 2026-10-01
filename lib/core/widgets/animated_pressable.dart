import 'package:flutter/material.dart';

import '../motion/motion_x.dart';
import '../theme/app_dimens.dart';

/// Press feedback for any tappable: scales to ~0.96 with a slight fade.
class AnimatedPressable extends StatefulWidget {
  const AnimatedPressable({
    super.key,
    required this.child,
    this.enabled = true,
    this.scale = 0.96,
  });

  final Widget child;
  final bool enabled;
  final double scale;

  @override
  State<AnimatedPressable> createState() => _AnimatedPressableState();
}

class _AnimatedPressableState extends State<AnimatedPressable> {
  bool _pressed = false;

  void _set(bool value) {
    if (!widget.enabled || value == _pressed) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final duration = context.motion(AppDimens.pressDuration);
    // A passive Listener keeps the child's own gesture handling intact.
    return Listener(
      onPointerDown: (_) => _set(true),
      onPointerUp: (_) => _set(false),
      onPointerCancel: (_) => _set(false),
      child: AnimatedScale(
        scale: _pressed ? widget.scale : 1,
        duration: duration,
        curve: Curves.easeOut,
        child: AnimatedOpacity(
          opacity: _pressed ? 0.85 : 1,
          duration: duration,
          curve: Curves.easeOut,
          child: widget.child,
        ),
      ),
    );
  }
}
