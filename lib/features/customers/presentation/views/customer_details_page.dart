import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../viewmodels/customer_details_view_model.dart';
import '../viewmodels/customer_list_view_model.dart';
import 'customer_details_view.dart';

/// Route entry for `/customers/:id`: creates the screen's ViewModel.
class CustomerDetailsPage extends StatelessWidget {
  const CustomerDetailsPage({super.key, required this.customerId});

  final int customerId;

  @override
  Widget build(BuildContext context) {
    // The list row (if loaded) lets the header and Hero render instantly.
    final preview = context
        .read<CustomerListViewModel>()
        .state
        .customers
        .where((c) => c.id == customerId)
        .firstOrNull;
    return BlocProvider(
      create: (_) =>
          getIt<CustomerDetailsViewModel>(param1: customerId)..load(),
      child: CustomerDetailsView(preview: preview),
    );
  }
}
