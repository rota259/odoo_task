import 'package:flutter/material.dart';

/// Order number that flies between the list and the details screen.
class OrderNumberHero extends StatelessWidget {
  const OrderNumberHero({
    super.key,
    required this.orderId,
    required this.number,
    this.style,
  });

  static String tag(int id) => 'order-number-$id';

  final int orderId;
  final String number;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) => Hero(
    tag: tag(orderId),
    // Transparent Material avoids unstyled text during the flight.
    child: Material(
      type: MaterialType.transparency,
      child: Text(
        number,
        style: style,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    ),
  );
}
