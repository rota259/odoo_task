import 'package:flutter/material.dart';

import '../theme/app_dimens.dart';

/// Circle with a customer's initials; wrapped in a [Hero] by callers.
class InitialsAvatar extends StatelessWidget {
  const InitialsAvatar({
    super.key,
    required this.initials,
    this.size = AppDimens.avatar,
  });

  final String initials;
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        shape: BoxShape.circle,
      ),
      child: Text(
        initials,
        maxLines: 1,
        textScaler: TextScaler.noScaling,
        style: theme.textTheme.titleMedium?.copyWith(
          fontSize: size * 0.36,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}
