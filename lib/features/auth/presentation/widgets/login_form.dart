import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/l10n/l10n_x.dart';
import '../../../../core/network/odoo_endpoint.dart';
import '../../../../core/presentation/view_status.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../domain/entities/login_request.dart';
import '../viewmodels/auth_state.dart';
import '../viewmodels/auth_view_model.dart';
import 'login_error_banner.dart';
import 'login_fields.dart';
import 'server_settings_section.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _url = TextEditingController(text: OdooEndpoint.defaultUrl);
  final _database = TextEditingController(text: OdooEndpoint.defaultDatabase);
  bool _serverExpanded = false;

  @override
  void dispose() {
    for (final c in [_username, _password, _url, _database]) {
      c.dispose();
    }
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) {
      // Invalid server fields are hidden when collapsed: reveal them.
      setState(() => _serverExpanded = true);
      return;
    }
    context.read<AuthViewModel>().login(
      LoginRequest(
        baseUrl: _url.text,
        database: _database.text,
        login: _username.text.trim(),
        password: _password.text,
      ),
    );
  }

  bool _isServerIssue(AuthState s) =>
      s.failure is DatabaseNotFoundFailure || s.failure is NetworkFailure;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthViewModel, AuthState>(
      // Server problems: reveal the server settings so they can be fixed.
      listenWhen: (a, b) => a.failure != b.failure && _isServerIssue(b),
      listener: (_, _) => setState(() => _serverExpanded = true),
      builder: (context, state) => Form(
        key: _formKey,
        child: AutofillGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LoginFields(
                username: _username,
                password: _password,
                onSubmit: _submit,
              ),
              ServerSettingsSection(
                expanded: _serverExpanded,
                onToggle: () =>
                    setState(() => _serverExpanded = !_serverExpanded),
                url: _url,
                database: _database,
              ),
              LoginErrorBanner(failure: state.failure),
              const SizedBox(height: AppDimens.lg),
              PrimaryButton(
                label: context.l10n.signIn,
                icon: Icons.login_rounded,
                status: state.isSubmitting
                    ? ActionStatus.running
                    : ActionStatus.idle,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
