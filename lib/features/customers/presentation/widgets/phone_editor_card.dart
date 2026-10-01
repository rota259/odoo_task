import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/l10n_x.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/surface_card.dart';
import '../../domain/usecases/phone_validator.dart';
import '../viewmodels/customer_details_view_model.dart';

/// Editable phone number with validation and an animated Save button.
class PhoneEditorCard extends StatefulWidget {
  const PhoneEditorCard({super.key, required this.phone});

  final String? phone;

  @override
  State<PhoneEditorCard> createState() => _PhoneEditorCardState();
}

class _PhoneEditorCardState extends State<PhoneEditorCard> {
  final _formKey = GlobalKey<FormState>();
  late final _controller = TextEditingController(text: widget.phone ?? '');

  bool get _dirty => _controller.text.trim() != (widget.phone ?? '');

  @override
  void didUpdateWidget(PhoneEditorCard old) {
    super.didUpdateWidget(old);
    // Adopt external updates (e.g. after sync) unless the user is editing.
    if (old.phone != widget.phone && _controller.text.trim() == old.phone) {
      _controller.text = widget.phone ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();
    context.read<CustomerDetailsViewModel>().savePhone(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final status = context.select(
      (CustomerDetailsViewModel vm) => vm.state.saveStatus,
    );
    return SurfaceCard(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              key: const Key('phone_field'),
              controller: _controller,
              keyboardType: TextInputType.phone,
              textDirection: TextDirection.ltr,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _dirty ? _save() : null,
              onChanged: (_) {
                context.read<CustomerDetailsViewModel>().resetSaveStatus();
                setState(() {});
              },
              decoration: InputDecoration(
                labelText: l10n.phone,
                prefixIcon: const Icon(Icons.phone_outlined),
              ),
              validator: (v) =>
                  PhoneValidator.isValid(v ?? '') ? null : l10n.invalidPhone,
            ),
            const SizedBox(height: AppDimens.md),
            PrimaryButton(
              key: const Key('phone_save'),
              label: l10n.save,
              icon: Icons.save_outlined,
              status: status,
              onPressed: _dirty ? _save : null,
            ),
          ],
        ),
      ),
    );
  }
}
