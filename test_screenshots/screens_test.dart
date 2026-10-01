// Renders every screen for visual review and the README.
// Run: flutter test test_screenshots --update-goldens
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:odoo_task/core/presentation/view_status.dart';
import 'package:odoo_task/features/auth/presentation/viewmodels/auth_state.dart';
import 'package:odoo_task/features/customers/presentation/viewmodels/customer_details_state.dart';
import 'package:odoo_task/features/customers/presentation/viewmodels/customer_list_state.dart';
import 'package:odoo_task/features/sales_orders/presentation/viewmodels/sale_order_details_state.dart';
import 'package:odoo_task/features/sales_orders/presentation/viewmodels/sales_orders_state.dart';
import 'package:odoo_task/features/settings/domain/app_settings.dart';

import 'fixtures.dart';
import 'harness.dart';

const phone = Size(390, 844);
const tablet = Size(1280, 800);

final signedIn = Scene(
  auth: const AuthState(status: AuthStatus.authenticated, user: admin),
  list: const CustomerListState(
    status: ViewStatus.success,
    customers: customers,
  ),
  details: const CustomerDetailsState(
    status: ViewStatus.success,
    details: acmeDetails,
  ),
  orders: SalesOrdersState(status: ViewStatus.success, orders: orders),
  order: SaleOrderDetailsState(
    status: ViewStatus.success,
    details: orderDetails,
  ),
);

final offline = Scene(
  auth: signedIn.auth,
  list: signedIn.list.copyWith(isOffline: true),
);

final screens = <String, (Scene, String)>{
  'login': (
    Scene(auth: const AuthState(status: AuthStatus.unauthenticated)),
    '/login',
  ),
  'customers': (signedIn, '/customers'),
  'customers_offline': (offline, '/customers'),
  'customer_details': (signedIn, '/customers/14'),
  'orders': (signedIn, '/orders'),
  'order_details': (signedIn, '/orders/1'),
  'settings': (signedIn, '/settings'),
};

void main() {
  setUpAll(loadFonts);

  for (final (theme, mode) in [
    ('light', AppThemeMode.light),
    ('dark', AppThemeMode.dark),
  ]) {
    for (final lang in ['en', 'ar']) {
      final settings = AppSettings(themeMode: mode, localeCode: lang);
      for (final MapEntry(key: name, value: (scene, path)) in screens.entries) {
        testWidgets('$name $theme $lang phone', (t) async {
          await shoot(
            t,
            name: 'phone/${name}_${theme}_$lang',
            scene: scene,
            location: path,
            size: phone,
            settings: settings,
          );
        });
      }
      for (final (name, path) in [
        ('customers_split', '/customers/14'),
        ('orders_split', '/orders/1'),
      ]) {
        testWidgets('$name $theme $lang tablet', (t) async {
          await shoot(
            t,
            name: 'tablet/${name}_${theme}_$lang',
            scene: signedIn,
            location: path,
            size: tablet,
            settings: settings,
          );
        });
      }
    }
  }
}
