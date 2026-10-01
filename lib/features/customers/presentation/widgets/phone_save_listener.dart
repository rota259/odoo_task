import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/l10n_x.dart';
import '../../../../core/presentation/view_status.dart';
import '../../../../core/widgets/snackbars.dart';
import '../../domain/entities/customer_results.dart';
import '../viewmodels/customer_details_state.dart';
import '../viewmodels/customer_details_view_model.dart';

/// Snackbars for phone save results (synced, queued offline, or error).
class PhoneSaveListener extends StatelessWidget {
  const PhoneSaveListener({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) =>
      BlocListener<CustomerDetailsViewModel, CustomerDetailsState>(
        listenWhen: (a, b) => a.saveStatus != b.saveStatus,
        listener: (context, state) {
          final l10n = context.l10n;
          switch (state.saveStatus) {
            case ActionStatus.success:
              final queued = state.saveOutcome == PhoneUpdateOutcome.queued;
              context.showSnack(
                queued ? l10n.phoneSavedOffline : l10n.phoneSaved,
                icon: queued
                    ? Icons.cloud_queue_rounded
                    : Icons.check_circle_outline_rounded,
              );
            case ActionStatus.failure:
              context.showSnack(
                state.saveFailure!.describe(l10n),
                icon: Icons.error_outline_rounded,
              );
            case ActionStatus.idle || ActionStatus.running:
              break;
          }
        },
        child: child,
      );
}
