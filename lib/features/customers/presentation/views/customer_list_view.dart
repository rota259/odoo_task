import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/l10n_x.dart';
import '../../../../core/widgets/brand_wordmark.dart';
import '../../../../core/widgets/offline_banner.dart';
import '../../../../core/widgets/page_title.dart';
import '../../../shell/presentation/widgets/app_menu_button.dart';
import '../viewmodels/customer_list_view_model.dart';
import '../widgets/customer_list_body.dart';
import '../widgets/customer_search_field.dart';

class CustomerListView extends StatelessWidget {
  const CustomerListView({super.key, this.selectedId});

  /// Highlighted row in split view.
  final int? selectedId;

  @override
  Widget build(BuildContext context) {
    final isOffline = context.select(
      (CustomerListViewModel vm) => vm.state.isOffline,
    );
    return Scaffold(
      appBar: AppBar(
        title: const BrandWordmark(),
        actions: const [AppMenuButton()],
      ),
      body: Column(
        children: [
          OfflineBanner(visible: isOffline),
          PageTitle(context.l10n.customers),
          const CustomerSearchField(),
          Expanded(child: CustomerListBody(selectedId: selectedId)),
        ],
      ),
    );
  }
}
