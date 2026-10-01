import 'dart:async';

import 'package:flutter/material.dart';

import '../motion/motion_x.dart';
import '../presentation/view_status.dart';
import '../theme/app_dimens.dart';
import 'animated_pressable.dart';
import 'primary_button_content.dart';

/// Filled action button that morphs into a round spinner while [status] is
/// running, then shows a brief check mark on success.
class PrimaryButton extends StatefulWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.status = ActionStatus.idle,
    this.icon,
  });

  static const successHold = Duration(milliseconds: 900);

  final String label;
  final VoidCallback? onPressed;
  final ActionStatus status;
  final IconData? icon;

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _showSuccess = false;
  Timer? _timer;

  @override
  void didUpdateWidget(PrimaryButton old) {
    super.didUpdateWidget(old);
    if (old.status != ActionStatus.success &&
        widget.status == ActionStatus.success) {
      setState(() => _showSuccess = true);
      _timer?.cancel();
      _timer = Timer(PrimaryButton.successHold, () {
        if (mounted) setState(() => _showSuccess = false);
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final running = widget.status == ActionStatus.running;
    final compact = running || _showSuccess;
    final duration = context.motion(AppDimens.switchDuration);
    return LayoutBuilder(
      builder: (context, constraints) {
        final full = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : AppDimens.loginMaxWidth;
        // heightFactor: hug the button even under tall constraints
        // (e.g. a Scaffold's bottomNavigationBar slot).
        return Center(
          heightFactor: 1,
          child: AnimatedContainer(
            duration: duration,
            curve: Curves.easeOutCubic,
            width: compact ? AppDimens.buttonHeight : full,
            height: AppDimens.buttonHeight,
            child: AnimatedPressable(
              enabled: widget.onPressed != null && !compact,
              child: FilledButton(
                onPressed: compact ? () {} : widget.onPressed,
                style: FilledButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size.square(AppDimens.buttonHeight),
                ),
                child: PrimaryButtonContent(
                  label: widget.label,
                  icon: widget.icon,
                  running: running,
                  success: _showSuccess,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
