import 'package:flutter/material.dart';

import '../theme/app_dimens.dart';
import 'window_size.dart';

/// Single pane on compact screens; list (start) + detail (end) otherwise.
///
/// Heroes in the list are disabled in split mode: both panes are visible at
/// once, so a flight would be meaningless (and tags would clash).
class MasterDetailLayout extends StatelessWidget {
  const MasterDetailLayout({
    super.key,
    required this.master,
    required this.detail,
  });

  final Widget master;
  final Widget detail;

  @override
  Widget build(BuildContext context) {
    if (context.windowSize.isCompact) return detail;
    final expanded = context.windowSize == WindowSize.expanded;
    return Row(
      children: [
        SizedBox(
          width: expanded
              ? AppDimens.listPaneWidth + 60
              : AppDimens.listPaneWidth,
          child: HeroMode(enabled: false, child: master),
        ),
        const VerticalDivider(width: 1),
        Expanded(child: detail),
      ],
    );
  }
}
