import 'package:flutter/material.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/l10n/l10n_x.dart';
import '../../../../core/motion/motion_x.dart';
import '../../../../core/theme/app_dimens.dart';

/// Animated inline error under the login fields.
class LoginErrorBanner extends StatelessWidget {
  const LoginErrorBanner({super.key, required this.failure});

  final Failure? failure;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final f = failure;
    return AnimatedSize(
      duration: context.motion(AppDimens.switchDuration),
      curve: Curves.easeOutCubic,
      alignment: AlignmentDirectional.topCenter,
      child: f == null
          ? const SizedBox(width: double.infinity)
          : Container(
              key: const Key('login_error'),
              margin: const EdgeInsetsDirectional.only(top: AppDimens.md),
              padding: const EdgeInsetsDirectional.all(AppDimens.md),
              decoration: BoxDecoration(
                color: scheme.errorContainer,
                borderRadius: BorderRadius.circular(AppDimens.controlRadius),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline_rounded, color: scheme.error),
                  const SizedBox(width: AppDimens.sm),
                  Expanded(
                    child: Semantics(
                      liveRegion: true,
                      child: Text(
                        f.describe(context.l10n),
                        style: TextStyle(color: scheme.onErrorContainer),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
