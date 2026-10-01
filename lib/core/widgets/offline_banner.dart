import 'package:flutter/material.dart';

import '../l10n/l10n_x.dart';
import '../motion/motion_x.dart';
import '../theme/app_dimens.dart';

/// "Offline – showing cached data" strip that slides in/out from the top.
class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key, required this.visible, this.message});

  final bool visible;
  final String? message;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final duration = context.motion(AppDimens.switchDuration);
    return ClipRect(
      child: AnimatedAlign(
        alignment: AlignmentDirectional.bottomCenter,
        heightFactor: visible ? 1 : 0,
        duration: duration,
        curve: Curves.easeOutCubic,
        child: AnimatedSlide(
          offset: visible ? Offset.zero : const Offset(0, -1),
          duration: duration,
          curve: Curves.easeOutCubic,
          child: Semantics(
            liveRegion: true,
            child: Container(
              width: double.infinity,
              color: scheme.secondaryContainer,
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: AppDimens.lg,
                vertical: AppDimens.sm,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.cloud_off_rounded,
                    size: 18,
                    color: scheme.onSecondaryContainer,
                  ),
                  const SizedBox(width: AppDimens.sm),
                  Expanded(
                    child: Text(
                      message ?? context.l10n.offlineBanner,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: scheme.onSecondaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
