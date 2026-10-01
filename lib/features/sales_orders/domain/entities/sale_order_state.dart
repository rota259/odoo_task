/// `sale.order.state` values (Odoo 17).
enum SaleOrderState {
  draft('draft'),
  sent('sent'),
  sale('sale'),
  done('done'),
  cancel('cancel'),
  unknown('');

  const SaleOrderState(this.odooValue);

  final String odooValue;

  static SaleOrderState fromOdoo(Object? value) => SaleOrderState.values
      .firstWhere((s) => s.odooValue == value, orElse: () => unknown);

  /// Quotations can be confirmed into sales orders.
  bool get canConfirm => this == draft || this == sent;
}
