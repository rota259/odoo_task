import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/l10n_x.dart';
import '../../../../core/widgets/snackbars.dart';
import '../viewmodels/sync_status_view_model.dart';

/// Shows "X changes synced" whenever the offline queue is flushed.
class SyncListener extends StatelessWidget {
  const SyncListener({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) =>
      BlocListener<SyncStatusViewModel, SyncStatusState>(
        listenWhen: (prev, next) => (next.lastResult?.synced ?? 0) > 0,
        listener: (context, state) => context.showSnack(
          context.l10n.changesSynced(state.lastResult!.synced),
          icon: Icons.cloud_done_rounded,
        ),
        child: child,
      );
}
