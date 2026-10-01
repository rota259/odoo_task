import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../motion/motion_x.dart';

abstract final class AppTransitions {
  static const duration = Duration(milliseconds: 300);

  /// Material fade-through: outgoing fades out, incoming fades + scales in.
  static CustomTransitionPage<void> fadeThrough(
    GoRouterState state,
    Widget child,
  ) => CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: duration,
    reverseTransitionDuration: duration,
    transitionsBuilder: (context, animation, secondary, child) {
      if (context.reduceMotion) return child;
      final enter = CurvedAnimation(
        parent: animation,
        curve: const Interval(0.3, 1, curve: Curves.easeOut),
      );
      final exit = CurvedAnimation(
        parent: secondary,
        curve: const Interval(0, 0.3, curve: Curves.easeIn),
      );
      return FadeTransition(
        opacity: ReverseAnimation(exit),
        child: FadeTransition(
          opacity: enter,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.94, end: 1).animate(enter),
            child: child,
          ),
        ),
      );
    },
  );

  /// Shared X axis: slides along the reading direction (RTL aware).
  static CustomTransitionPage<void> sharedAxis(
    GoRouterState state,
    Widget child,
  ) => CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: duration,
    reverseTransitionDuration: duration,
    transitionsBuilder: (context, animation, secondary, child) {
      if (context.reduceMotion) return child;
      final rtl = Directionality.of(context) == TextDirection.rtl;
      final dx = rtl ? -0.08 : 0.08;
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );
      return SlideTransition(
        position: Tween(begin: Offset(dx, 0), end: Offset.zero).animate(curved),
        child: FadeTransition(opacity: curved, child: child),
      );
    },
  );
}
