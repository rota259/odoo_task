import 'package:flutter/material.dart';

extension SnackbarX on BuildContext {
  void showSnack(String message, {IconData? icon}) {
    final messenger = ScaffoldMessenger.maybeOf(this);
    if (messenger == null) return;
    final color = Theme.of(this).colorScheme.onInverseSurface;
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 12),
              ],
              Expanded(child: Text(message)),
            ],
          ),
        ),
      );
  }
}
