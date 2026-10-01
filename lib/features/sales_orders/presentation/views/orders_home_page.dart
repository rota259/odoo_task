import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_x.dart';
import '../../../../core/responsive/window_size.dart';
import '../../../../core/widgets/message_view.dart';
import 'orders_list_view.dart';

/// `/orders`: the list on phones, a hint in the detail pane otherwise.
class OrdersHomePage extends StatelessWidget {
  const OrdersHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    if (context.windowSize.isCompact) return const OrdersListView();
    return Scaffold(
      body: MessageView(
        icon: Icons.receipt_long_outlined,
        title: context.l10n.selectOrder,
      ),
    );
  }
}
