import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_x.dart';
import '../../../../core/motion/motion_x.dart';
import '../../../../core/theme/app_dimens.dart';
import 'login_validators.dart';

/// Collapsible Server URL + Database fields. The fields stay mounted while
/// collapsed so the form still validates them.
class ServerSettingsSection extends StatelessWidget {
  const ServerSettingsSection({
    super.key,
    required this.expanded,
    required this.onToggle,
    required this.url,
    required this.database,
  });

  final bool expanded;
  final VoidCallback onToggle;
  final TextEditingController url;
  final TextEditingController database;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final duration = context.motion(AppDimens.switchDuration);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppDimens.sm),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: TextButton.icon(
            key: const Key('server_settings_toggle'),
            onPressed: onToggle,
            icon: const Icon(Icons.dns_outlined, size: 18),
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(l10n.serverSettings),
                AnimatedRotation(
                  turns: expanded ? 0.5 : 0,
                  duration: duration,
                  child: const Icon(Icons.expand_more_rounded, size: 20),
                ),
              ],
            ),
          ),
        ),
        ClipRect(
          child: AnimatedAlign(
            alignment: AlignmentDirectional.topCenter,
            heightFactor: expanded ? 1 : 0,
            duration: duration,
            curve: Curves.easeOutCubic,
            child: Padding(
              padding: const EdgeInsetsDirectional.only(top: AppDimens.sm),
              child: Column(
                children: [
                  TextFormField(
                    key: const Key('login_url'),
                    controller: url,
                    enabled: expanded,
                    keyboardType: TextInputType.url,
                    autocorrect: false,
                    textDirection: TextDirection.ltr,
                    decoration: InputDecoration(
                      labelText: l10n.serverUrl,
                      prefixIcon: const Icon(Icons.link_rounded),
                    ),
                    validator: (v) => LoginValidators.url(v, l10n),
                  ),
                  const SizedBox(height: AppDimens.md),
                  TextFormField(
                    key: const Key('login_database'),
                    controller: database,
                    enabled: expanded,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: l10n.database,
                      prefixIcon: const Icon(Icons.storage_rounded),
                    ),
                    validator: (v) => LoginValidators.required(v, l10n),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
