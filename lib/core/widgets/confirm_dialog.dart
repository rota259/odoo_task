import 'package:flutter/material.dart';

import '../l10n/l10n_x.dart';
import 'animated_pressable.dart';

/// Asks the user to confirm an irreversible action. Resolves to `true`
/// only when the confirm button is pressed.
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String body,
  String? confirmLabel,
}) async {
  final l10n = context.l10n;
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        AnimatedPressable(
          child: TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
        ),
        AnimatedPressable(
          child: FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmLabel ?? l10n.confirm),
          ),
        ),
      ],
    ),
  );
  return result ?? false;
}
