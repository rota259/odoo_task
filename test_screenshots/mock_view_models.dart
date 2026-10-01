import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:odoo_task/features/auth/presentation/viewmodels/auth_state.dart';
import 'package:odoo_task/features/auth/presentation/viewmodels/auth_view_model.dart';
import 'package:odoo_task/features/customers/presentation/viewmodels/customer_details_state.dart';
import 'package:odoo_task/features/customers/presentation/viewmodels/customer_details_view_model.dart';
import 'package:odoo_task/features/customers/presentation/viewmodels/customer_list_state.dart';
import 'package:odoo_task/features/customers/presentation/viewmodels/customer_list_view_model.dart';
import 'package:odoo_task/features/sales_orders/presentation/viewmodels/sale_order_details_state.dart';
import 'package:odoo_task/features/sales_orders/presentation/viewmodels/sale_order_details_view_model.dart';
import 'package:odoo_task/features/sales_orders/presentation/viewmodels/sales_orders_state.dart';
import 'package:odoo_task/features/sales_orders/presentation/viewmodels/sales_orders_view_model.dart';
import 'package:odoo_task/features/settings/domain/app_settings.dart';
import 'package:odoo_task/features/settings/presentation/viewmodels/settings_view_model.dart';
import 'package:odoo_task/features/shell/presentation/viewmodels/sync_status_view_model.dart';

class MockAuthVm extends MockCubit<AuthState> implements AuthViewModel {}

class MockSettingsVm extends MockCubit<AppSettings>
    implements SettingsViewModel {}

class MockSyncVm extends MockCubit<SyncStatusState>
    implements SyncStatusViewModel {}

class MockCustomerListVm extends MockCubit<CustomerListState>
    implements CustomerListViewModel {
  MockCustomerListVm(CustomerListState s) {
    when(() => state).thenReturn(s);
    when(load).thenAnswer((_) async {});
    when(refresh).thenAnswer((_) async {});
    when(loadMore).thenAnswer((_) async {});
  }
}

class MockCustomerDetailsVm extends MockCubit<CustomerDetailsState>
    implements CustomerDetailsViewModel {
  MockCustomerDetailsVm(CustomerDetailsState s, int id) {
    when(() => state).thenReturn(s);
    when(() => customerId).thenReturn(id);
    when(load).thenAnswer((_) async {});
  }
}

class MockOrdersVm extends MockCubit<SalesOrdersState>
    implements SalesOrdersViewModel {
  MockOrdersVm(SalesOrdersState s) {
    when(() => state).thenReturn(s);
    when(load).thenAnswer((_) async {});
    when(refresh).thenAnswer((_) async {});
    when(loadMore).thenAnswer((_) async {});
  }
}

class MockOrderDetailsVm extends MockCubit<SaleOrderDetailsState>
    implements SaleOrderDetailsViewModel {
  MockOrderDetailsVm(SaleOrderDetailsState s) {
    when(() => state).thenReturn(s);
    when(load).thenAnswer((_) async {});
  }
}
