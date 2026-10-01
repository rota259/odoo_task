import 'package:flutter/material.dart';

import '../theme/app_dimens.dart';

/// Large screen title under the app bar.
class PageTitle extends StatelessWidget {
  const PageTitle(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) => Semantics(
    header: true,
    child: Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(
        AppDimens.lg,
        AppDimens.md,
        AppDimens.lg,
        AppDimens.xs,
      ),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(title, style: Theme.of(context).textTheme.headlineSmall),
      ),
    ),
  );
}
