import 'package:flutter/material.dart';

import '../../../../core/motion/motion_x.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/widgets/surface_card.dart';

/// A titled card with one selectable option per row.
class SettingsSection<T> extends StatelessWidget {
  const SettingsSection({
    super.key,
    required this.title,
    required this.selected,
    required this.options,
    required this.onChanged,
  });

  final String title;
  final T selected;

  /// value -> (label, icon)
  final Map<T, (String, IconData)> options;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(
            start: AppDimens.xs,
            bottom: AppDimens.sm,
          ),
          child: Text(title, style: theme.textTheme.titleMedium),
        ),
        SurfaceCard(
          padding: const EdgeInsetsDirectional.symmetric(
            vertical: AppDimens.xs,
          ),
          child: Column(
            children: [
              for (final MapEntry(key: value, value: (label, icon))
                  in options.entries)
                ListTile(
                  leading: Icon(icon),
                  title: Text(label),
                  selected: value == selected,
                  onTap: () => onChanged(value),
                  trailing: AnimatedSwitcher(
                    duration: context.motion(AppDimens.switchDuration),
                    child: value == selected
                        ? Icon(
                            Icons.check_circle_rounded,
                            key: const ValueKey('on'),
                            color: theme.colorScheme.secondary,
                          )
                        : const SizedBox.square(dimension: 24),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
