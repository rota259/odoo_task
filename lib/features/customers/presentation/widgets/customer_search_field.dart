import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/l10n_x.dart';
import '../../../../core/theme/app_dimens.dart';
import '../viewmodels/customer_list_view_model.dart';

/// Name search; the ViewModel debounces input (400ms).
class CustomerSearchField extends StatefulWidget {
  const CustomerSearchField({super.key});

  @override
  State<CustomerSearchField> createState() => _CustomerSearchFieldState();
}

class _CustomerSearchFieldState extends State<CustomerSearchField> {
  late final TextEditingController _controller = TextEditingController(
    text: context.read<CustomerListViewModel>().state.query,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    context.read<CustomerListViewModel>().search('');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(
        AppDimens.lg,
        AppDimens.sm,
        AppDimens.lg,
        AppDimens.sm,
      ),
      child: TextField(
        key: const Key('customer_search'),
        controller: _controller,
        textInputAction: TextInputAction.search,
        onChanged: (q) {
          context.read<CustomerListViewModel>().search(q);
          setState(() {});
        },
        decoration: InputDecoration(
          hintText: l10n.searchCustomers,
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon: _controller.text.isEmpty
              ? null
              : IconButton(
                  tooltip: l10n.clearSearch,
                  icon: const Icon(Icons.close_rounded),
                  onPressed: _clear,
                ),
        ),
      ),
    );
  }
}
