import 'package:mocktail/mocktail.dart';
import 'package:odoo_task/core/network/odoo_client.dart';
import 'package:odoo_task/core/storage/credentials_store.dart';
import 'package:odoo_task/core/sync/pending_edit.dart';
import 'package:odoo_task/core/sync/pending_edit_sender.dart';
import 'package:odoo_task/core/sync/sync_service.dart';
import 'package:odoo_task/features/auth/domain/entities/login_request.dart';
import 'package:odoo_task/features/auth/domain/repositories/auth_repository.dart';
import 'package:odoo_task/features/customers/domain/repositories/customer_repository.dart';
import 'package:odoo_task/features/sales_orders/domain/repositories/sale_order_repository.dart';

class MockOdooClient extends Mock implements OdooClient {}

class MockCredentialsStore extends Mock implements CredentialsStore {}

class MockPendingEditSender extends Mock implements PendingEditSender {}

class MockSyncService extends Mock implements SyncService {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockCustomerRepository extends Mock implements CustomerRepository {}

class MockSaleOrderRepository extends Mock implements SaleOrderRepository {}

/// Call once per test file that matches on these types with `any()`.
void registerFallbacks() {
  registerFallbackValue(
    PendingEdit(
      partnerId: 0,
      field: 'phone',
      value: '',
      createdAt: DateTime(2026),
    ),
  );
  registerFallbackValue(
    const LoginRequest(baseUrl: '', database: '', login: '', password: ''),
  );
}
