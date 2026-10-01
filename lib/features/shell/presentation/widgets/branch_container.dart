import 'package:flutter/material.dart';

import '../../../../core/motion/motion_x.dart';
import '../../../../core/theme/app_dimens.dart';

/// Keeps every branch navigator alive (like an IndexedStack) but
/// cross-fades when the selected branch changes.
class BranchContainer extends StatelessWidget {
  const BranchContainer({
    super.key,
    required this.index,
    required this.children,
  });

  final int index;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final duration = context.motion(AppDimens.switchDuration);
    return Stack(
      children: [
        for (var i = 0; i < children.length; i++)
          _Branch(active: i == index, duration: duration, child: children[i]),
      ],
    );
  }
}

class _Branch extends StatelessWidget {
  const _Branch({
    required this.active,
    required this.duration,
    required this.child,
  });

  final bool active;
  final Duration duration;
  final Widget child;

  @override
  Widget build(BuildContext context) => Positioned.fill(
    // The fade sits above TickerMode so the outgoing branch can still
    // animate out; at opacity 0 the hidden branch is not painted at all.
    child: AnimatedOpacity(
      opacity: active ? 1 : 0,
      duration: duration,
      curve: Curves.easeInOut,
      child: IgnorePointer(
        ignoring: !active,
        child: TickerMode(
          enabled: active,
          child: ExcludeSemantics(excluding: !active, child: child),
        ),
      ),
    ),
  );
}
