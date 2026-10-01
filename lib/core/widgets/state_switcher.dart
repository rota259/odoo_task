import 'package:flutter/material.dart';

import '../motion/motion_x.dart';
import '../theme/app_dimens.dart';

/// Cross-fades between loading / data / error / empty / offline states.
/// Give each state's child a distinct [Key] (e.g. `ValueKey(status)`).
class StateSwitcher extends StatelessWidget {
  const StateSwitcher({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => AnimatedSwitcher(
    duration: context.motion(AppDimens.switchDuration),
    switchInCurve: Curves.easeOut,
    switchOutCurve: Curves.easeIn,
    layoutBuilder: (current, previous) => Stack(
      alignment: AlignmentDirectional.topCenter,
      children: [...previous, ?current],
    ),
    child: child,
  );
}
