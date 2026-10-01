import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../motion/motion_x.dart';
import '../theme/app_dimens.dart';
import '../theme/app_palette.dart';

/// Shimmering placeholder rows shown while a list loads.
class SkeletonList extends StatelessWidget {
  const SkeletonList({super.key, this.itemCount = 8, this.showAvatar = true});

  final int itemCount;
  final bool showAvatar;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final list = ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsetsDirectional.all(AppDimens.lg),
      itemCount: itemCount,
      separatorBuilder: (_, _) => const SizedBox(height: AppDimens.md),
      itemBuilder: (_, _) => _SkeletonRow(showAvatar: showAvatar),
    );
    if (context.reduceMotion) return list;
    return Shimmer.fromColors(
      baseColor: palette.shimmerBase,
      highlightColor: palette.shimmerHighlight,
      child: list,
    );
  }
}

class _SkeletonRow extends StatelessWidget {
  const _SkeletonRow({required this.showAvatar});

  final bool showAvatar;

  @override
  Widget build(BuildContext context) {
    final color = context.palette.shimmerBase;
    Widget bar(double widthFactor, double height) => FractionallySizedBox(
      alignment: AlignmentDirectional.centerStart,
      widthFactor: widthFactor,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(AppDimens.xs),
        ),
      ),
    );
    return Container(
      padding: const EdgeInsetsDirectional.all(AppDimens.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppDimens.cardRadius),
      ),
      child: Row(
        children: [
          if (showAvatar) ...[
            CircleAvatar(radius: AppDimens.avatar / 2, backgroundColor: color),
            const SizedBox(width: AppDimens.md),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                bar(0.6, 14),
                const SizedBox(height: AppDimens.sm),
                bar(0.4, 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
