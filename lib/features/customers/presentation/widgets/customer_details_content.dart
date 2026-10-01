import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_x.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../domain/entities/customer_details.dart';
import 'info_card.dart';
import 'phone_editor_card.dart';

class CustomerDetailsContent extends StatelessWidget {
  const CustomerDetailsContent({super.key, required this.details});

  final CustomerDetails details;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final address = details.addressLines;
    return Align(
      alignment: AlignmentDirectional.topStart,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppDimens.contentMaxWidth),
        child: ListView(
          padding: const EdgeInsetsDirectional.all(AppDimens.lg),
          children: [
            PhoneEditorCard(
              key: ValueKey('phone-${details.id}'),
              phone: details.phone,
            ),
            const SizedBox(height: AppDimens.md),
            InfoCard(
              icon: Icons.mail_outline_rounded,
              label: l10n.email,
              lines: [details.email ?? l10n.emptyValue],
            ),
            const SizedBox(height: AppDimens.md),
            InfoCard(
              icon: Icons.place_outlined,
              label: l10n.address,
              lines: address.isEmpty ? [l10n.emptyValue] : address,
            ),
          ],
        ),
      ),
    );
  }
}
