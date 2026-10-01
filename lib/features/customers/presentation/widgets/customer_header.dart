import 'package:flutter/material.dart';

import '../../../../core/motion/motion_x.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/widgets/initials_avatar.dart';
import '../../domain/entities/customer.dart';
import 'customer_hero.dart';
import 'pending_sync_badge.dart';

/// Avatar (Hero target from the list) + name + pending marker.
class CustomerHeader extends StatelessWidget {
  const CustomerHeader({
    super.key,
    required this.id,
    required this.name,
    required this.pending,
  });

  static const avatarSize = 64.0;

  final int id;
  final String? name;
  final bool pending;

  @override
  Widget build(BuildContext context) {
    final text = name;
    if (text == null || text.isEmpty) return const SizedBox.shrink();
    final initials = Customer(id: id, name: text).initials;
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(
        AppDimens.lg,
        AppDimens.lg,
        AppDimens.lg,
        AppDimens.sm,
      ),
      child: Row(
        children: [
          Hero(
            tag: CustomerHero.avatarTag(id),
            child: InitialsAvatar(initials: initials, size: avatarSize),
          ),
          const SizedBox(width: AppDimens.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text, style: Theme.of(context).textTheme.headlineSmall),
                AnimatedSize(
                  duration: context.motion(AppDimens.switchDuration),
                  alignment: AlignmentDirectional.topStart,
                  child: pending
                      ? const Padding(
                          padding: EdgeInsetsDirectional.only(
                            top: AppDimens.xs,
                          ),
                          child: PendingSyncBadge(),
                        )
                      : const SizedBox(width: double.infinity),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
