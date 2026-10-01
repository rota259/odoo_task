import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_x.dart';
import '../../../../core/widgets/brand_wordmark.dart';
import '../../../../core/widgets/page_title.dart';
import '../../../shell/presentation/widgets/app_menu_button.dart';
import '../widgets/orders_list_body.dart';

class OrdersListView extends StatelessWidget {
  const OrdersListView({super.key, this.selectedId});

  final int? selectedId;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const BrandWordmark(),
      actions: const [AppMenuButton()],
    ),
    body: Column(
      children: [
        PageTitle(context.l10n.salesOrders),
        Expanded(child: OrdersListBody(selectedId: selectedId)),
      ],
    ),
  );
}
