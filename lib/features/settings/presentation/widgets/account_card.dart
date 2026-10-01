import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_x.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/widgets/surface_card.dart';
import '../../../auth/domain/entities/auth_user.dart';

class AccountCard extends StatelessWidget {
  const AccountCard({super.key, required this.user});

  final AuthUser user;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(
            start: AppDimens.xs,
            bottom: AppDimens.sm,
          ),
          child: Text(l10n.account, style: theme.textTheme.titleMedium),
        ),
        SurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.signedInAs(user.name)),
              const SizedBox(height: AppDimens.xs),
              Text(
                l10n.accountLine(user.login, user.database),
                style: theme.textTheme.bodySmall,
                textDirection: TextDirection.ltr,
              ),
              Text(
                user.baseUrl,
                style: theme.textTheme.bodySmall,
                textDirection: TextDirection.ltr,
              ),
              const SizedBox(height: AppDimens.sm),
              Chip(
                avatar: Icon(
                  user.isInternal ? Icons.badge_outlined : Icons.public,
                  size: 18,
                ),
                label: Text(
                  user.isInternal ? l10n.internalUser : l10n.portalUser,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
