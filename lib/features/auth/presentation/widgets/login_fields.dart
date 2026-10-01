import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_x.dart';
import '../../../../core/theme/app_dimens.dart';
import 'login_validators.dart';

/// Username + password (with visibility toggle).
class LoginFields extends StatefulWidget {
  const LoginFields({
    super.key,
    required this.username,
    required this.password,
    required this.onSubmit,
  });

  final TextEditingController username;
  final TextEditingController password;
  final VoidCallback onSubmit;

  @override
  State<LoginFields> createState() => _LoginFieldsState();
}

class _LoginFieldsState extends State<LoginFields> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          key: const Key('login_username'),
          controller: widget.username,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.username],
          autocorrect: false,
          decoration: InputDecoration(
            labelText: l10n.username,
            prefixIcon: const Icon(Icons.person_outline_rounded),
          ),
          validator: (v) => LoginValidators.required(v, l10n),
        ),
        const SizedBox(height: AppDimens.md),
        TextFormField(
          key: const Key('login_password'),
          controller: widget.password,
          obscureText: _obscure,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.password],
          onFieldSubmitted: (_) => widget.onSubmit(),
          decoration: InputDecoration(
            labelText: l10n.password,
            prefixIcon: const Icon(Icons.lock_outline_rounded),
            suffixIcon: IconButton(
              tooltip: _obscure ? l10n.showPassword : l10n.hidePassword,
              icon: Icon(
                _obscure
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
              onPressed: () => setState(() => _obscure = !_obscure),
            ),
          ),
          validator: (v) => LoginValidators.required(v, l10n),
        ),
      ],
    );
  }
}
