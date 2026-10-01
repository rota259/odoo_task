import 'package:flutter/material.dart';

import '../theme/app_dimens.dart';

/// Small leading icon + single-line text (list row metadata).
class IconText extends StatelessWidget {
  const IconText({
    super.key,
    required this.icon,
    required this.text,
    this.style,
    this.textDirection,
  });

  final IconData icon;
  final String text;
  final TextStyle? style;
  final TextDirection? textDirection;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, size: 14, color: style?.color),
      const SizedBox(width: AppDimens.xs),
      Flexible(
        child: Text(
          text,
          style: style,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textDirection: textDirection,
        ),
      ),
    ],
  );
}
