import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/status_tone.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/entities/sale_order_state.dart';

/// Localized label and palette-derived color for each order state.
extension SaleStateX on SaleOrderState {
  String label(AppLocalizations l10n) => switch (this) {
    SaleOrderState.draft => l10n.stateDraft,
    SaleOrderState.sent => l10n.stateSent,
    SaleOrderState.sale => l10n.stateSale,
    SaleOrderState.done => l10n.stateDone,
    SaleOrderState.cancel => l10n.stateCancel,
    SaleOrderState.unknown => l10n.stateUnknown,
  };

  StatusTone tone(AppPalette palette) => switch (this) {
    SaleOrderState.draft || SaleOrderState.unknown => palette.neutral,
    SaleOrderState.sent => palette.info,
    SaleOrderState.sale || SaleOrderState.done => palette.success,
    SaleOrderState.cancel => palette.danger,
  };
}
