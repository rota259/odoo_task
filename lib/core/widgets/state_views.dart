import 'package:flutter/material.dart';

import '../error/failures.dart';
import '../l10n/l10n_x.dart';
import 'animated_pressable.dart';
import 'message_view.dart';

/// Error state with a retry action. Offline failures get the offline look.
class ErrorView extends StatelessWidget {
  const ErrorView({
    super.key,
    required this.failure,
    required this.onRetry,
    this.offlineBody,
  });

  final Failure failure;
  final VoidCallback onRetry;

  /// Body text used when [failure] is an [OfflineFailure].
  final String? offlineBody;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final offline = failure is OfflineFailure;
    return MessageView(
      icon: offline ? Icons.cloud_off_rounded : Icons.error_outline_rounded,
      title: offline ? l10n.offlineTitle : failure.describe(l10n),
      body: offline ? offlineBody : null,
      action: AnimatedPressable(
        child: OutlinedButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh_rounded),
          label: Text(l10n.retry),
        ),
      ),
    );
  }
}

class EmptyView extends StatelessWidget {
  const EmptyView({
    super.key,
    required this.title,
    this.body,
    this.icon = Icons.inbox_outlined,
  });

  final String title;
  final String? body;
  final IconData icon;

  @override
  Widget build(BuildContext context) =>
      MessageView(icon: icon, title: title, body: body);
}
