import 'package:flutter/material.dart';

import '../theme/app_dimens.dart';
import '../theme/app_palette.dart';
import 'animated_pressable.dart';

/// Rounded surface with a soft, low-opacity shadow (no hard borders).
class SurfaceCard extends StatelessWidget {
  const SurfaceCard({
    super.key,
    required this.child,
    this.onTap,
    this.selected = false,
    this.padding = const EdgeInsetsDirectional.all(AppDimens.lg),
  });

  final Widget child;
  final VoidCallback? onTap;
  final bool selected;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(AppDimens.cardRadius);
    final card = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: context.palette.softShadow,
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: selected ? scheme.secondaryContainer : scheme.surface,
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
    if (onTap == null) return card;
    return AnimatedPressable(scale: 0.98, child: card);
  }
}
