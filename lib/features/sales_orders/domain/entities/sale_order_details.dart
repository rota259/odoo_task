import 'package:equatable/equatable.dart';

import 'sale_order.dart';

class SaleOrderLine extends Equatable {
  const SaleOrderLine({
    required this.id,
    required this.productName,
    required this.quantity,
    required this.priceUnit,
    required this.subtotal,
  });

  final int id;
  final String productName;
  final double quantity;
  final double priceUnit;
  final double subtotal;

  @override
  List<Object?> get props => [id, productName, quantity, priceUnit, subtotal];
}

class SaleOrderDetails extends Equatable {
  const SaleOrderDetails({
    required this.order,
    required this.amountUntaxed,
    required this.amountTax,
    required this.lines,
  });

  final SaleOrder order;
  final double amountUntaxed;
  final double amountTax;
  final List<SaleOrderLine> lines;

  @override
  List<Object?> get props => [order, amountUntaxed, amountTax, lines];
}

class SaleOrderPage extends Equatable {
  const SaleOrderPage({required this.items, required this.hasMore});

  final List<SaleOrder> items;
  final bool hasMore;

  @override
  List<Object?> get props => [items, hasMore];
}
