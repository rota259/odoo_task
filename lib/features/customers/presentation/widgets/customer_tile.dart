import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_x.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/widgets/icon_text.dart';
import '../../../../core/widgets/initials_avatar.dart';
import '../../../../core/widgets/surface_card.dart';
import '../../domain/entities/customer.dart';
import 'customer_hero.dart';
import 'pending_sync_badge.dart';

class CustomerTile extends StatelessWidget {
  const CustomerTile({
    super.key,
    required this.customer,
    required this.onTap,
    this.selected = false,
  });

  final Customer customer;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final secondary = theme.textTheme.bodySmall;
    return SurfaceCard(
      onTap: onTap,
      selected: selected,
      child: Row(
        children: [
          Hero(
            tag: CustomerHero.avatarTag(customer.id),
            child: InitialsAvatar(initials: customer.initials),
          ),
          const SizedBox(width: AppDimens.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customer.name,
                  style: theme.textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppDimens.xs),
                IconText(
                  icon: Icons.phone_outlined,
                  text: customer.phone ?? l10n.emptyValue,
                  style: secondary,
                  // Phone numbers read left-to-right even in Arabic.
                  textDirection: TextDirection.ltr,
                ),
                IconText(
                  icon: Icons.location_city_outlined,
                  text: customer.city ?? l10n.emptyValue,
                  style: secondary,
                ),
              ],
            ),
          ),
          if (customer.hasPendingSync) const PendingSyncBadge(compact: true),
          Icon(
            Icons.chevron_right_rounded,
            // matchTextDirection: mirrors automatically in RTL.
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}
