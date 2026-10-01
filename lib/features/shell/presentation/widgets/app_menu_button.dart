import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n_x.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../../auth/presentation/viewmodels/auth_view_model.dart';

enum _MenuAction { settings, logout }

/// App bar overflow menu: Settings and Log out.
class AppMenuButton extends StatelessWidget {
  const AppMenuButton({super.key});

  Future<void> _onSelected(BuildContext context, _MenuAction action) async {
    switch (action) {
      case _MenuAction.settings:
        await context.push(Routes.settings);
      case _MenuAction.logout:
        final l10n = context.l10n;
        final auth = context.read<AuthViewModel>();
        final confirmed = await showConfirmDialog(
          context,
          title: l10n.logoutConfirmTitle,
          body: l10n.logoutConfirmBody,
          confirmLabel: l10n.logout,
        );
        if (confirmed) await auth.logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return PopupMenuButton<_MenuAction>(
      tooltip: l10n.menu,
      icon: const Icon(Icons.more_vert_rounded),
      onSelected: (a) => _onSelected(context, a),
      itemBuilder: (_) => [
        PopupMenuItem(
          value: _MenuAction.settings,
          child: ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: Text(l10n.settings),
            contentPadding: EdgeInsets.zero,
          ),
        ),
        PopupMenuItem(
          value: _MenuAction.logout,
          child: ListTile(
            leading: const Icon(Icons.logout_rounded),
            title: Text(l10n.logout),
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }
}
