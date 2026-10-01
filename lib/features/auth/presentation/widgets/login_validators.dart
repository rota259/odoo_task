import '../../../../l10n/generated/app_localizations.dart';

/// Form validators for the login screen (return a message or `null`).
abstract final class LoginValidators {
  static String? required(String? value, AppLocalizations l10n) =>
      (value == null || value.trim().isEmpty) ? l10n.fieldRequired : null;

  static String? url(String? value, AppLocalizations l10n) {
    final missing = required(value, l10n);
    if (missing != null) return missing;
    final uri = Uri.tryParse(value!.trim());
    final ok =
        uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
    return ok ? null : l10n.invalidUrl;
  }
}
