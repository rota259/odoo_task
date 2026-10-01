import 'package:equatable/equatable.dart';

import 'sale_order_state.dart';

class SaleOrder extends Equatable {
  const SaleOrder({
    required this.id,
    required this.name,
    required this.customerName,
    required this.state,
    required this.amountTotal,
    this.date,
    this.currencyCode,
  });

  final int id;

  /// Order reference, e.g. `S00012`.
  final String name;
  final String? customerName;
  final DateTime? date;
  final SaleOrderState state;
  final double amountTotal;

  /// ISO currency code (e.g. `USD`) when known.
  final String? currencyCode;

  @override
  List<Object?> get props => [
    id,
    name,
    customerName,
    date,
    state,
    amountTotal,
    currencyCode,
  ];
}
