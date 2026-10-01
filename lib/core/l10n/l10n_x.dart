import 'package:flutter/widgets.dart';

import '../../l10n/generated/app_localizations.dart';
import '../error/failures.dart';

extension L10nX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);

  /// Current locale tag, used by `intl` formatters.
  String get localeTag => Localizations.localeOf(this).toLanguageTag();
}

extension FailureText on Failure {
  /// User-facing text. Odoo business errors keep Odoo's own message.
  String describe(AppLocalizations l10n) => switch (this) {
    InvalidCredentialsFailure() => l10n.errorWrongCredentials,
    DatabaseNotFoundFailure() => l10n.errorWrongDatabase,
    NetworkFailure() => l10n.errorUnreachable,
    OfflineFailure() => l10n.errorOffline,
    SessionExpiredFailure() => l10n.errorSessionExpired,
    ServerFailure(:final message) => message ?? l10n.errorUnknown,
    ValidationFailure() => l10n.invalidPhone,
    CacheFailure() || UnexpectedFailure() => l10n.errorUnknown,
  };
}
