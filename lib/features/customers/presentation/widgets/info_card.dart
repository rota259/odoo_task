import 'package:flutter/material.dart';

import '../../../../core/l10n/data_direction.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/widgets/surface_card.dart';

/// Read-only labeled value(s) with a leading icon.
class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    required this.icon,
    required this.label,
    required this.lines,
  });

  final IconData icon;
  final String label;
  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SurfaceCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: AppDimens.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: theme.textTheme.labelMedium),
                const SizedBox(height: AppDimens.xs),
                for (final line in lines)
                  // Hugs its content at the layout's start edge while
                  // keeping the data's own direction.
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: SelectableText(
                      line,
                      style: theme.textTheme.bodyLarge,
                      textDirection: dataDirection(line),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
