import 'package:flutter/material.dart';

import '../../../../core/responsive/master_detail_layout.dart';
import 'customer_list_view.dart';

/// Shell of the customers branch: on medium/expanded screens the list stays
/// on the start side while [child] (the branch navigator) shows details.
class CustomersPane extends StatelessWidget {
  const CustomersPane({super.key, required this.child, this.selectedId});

  final Widget child;
  final int? selectedId;

  @override
  Widget build(BuildContext context) => MasterDetailLayout(
    master: CustomerListView(selectedId: selectedId),
    detail: child,
  );
}
