import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_x.dart';
import '../../../../core/responsive/window_size.dart';
import '../../../../core/widgets/message_view.dart';
import 'customer_list_view.dart';

/// `/customers`: the list on phones; a "pick a customer" hint in the detail
/// pane on larger screens (the list itself lives in [CustomersPane]).
class CustomersHomePage extends StatelessWidget {
  const CustomersHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    if (context.windowSize.isCompact) return const CustomerListView();
    return Scaffold(
      body: MessageView(
        icon: Icons.person_search_outlined,
        title: context.l10n.selectCustomer,
      ),
    );
  }
}
