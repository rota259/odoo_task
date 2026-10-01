import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:odoo_task/app.dart';
import 'package:odoo_task/core/di/injection.dart';
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

import 'mock_view_models.dart';

Future<void> loadFonts() async {
  final cairo = FontLoader('Cairo');
  for (final w in ['Regular', 'Medium', 'SemiBold', 'Bold']) {
    cairo.addFont(rootBundle.load('assets/fonts/Cairo-$w.ttf'));
  }
  await cairo.load();
  final root = Platform.environment['FLUTTER_ROOT']!;
  final icons = File(
    '$root/bin/cache/artifacts/material_fonts/materialicons-regular.otf',
  ).readAsBytes().then((b) => ByteData.view(b.buffer));
  await (FontLoader('MaterialIcons')..addFont(icons)).load();
}

class Scene {
  Scene({
    required this.auth,
    this.list = const CustomerListState(),
    this.details = const CustomerDetailsState(),
    this.orders = const SalesOrdersState(),
    this.order = const SaleOrderDetailsState(),
  });

  final AuthState auth;
  final CustomerListState list;
  final CustomerDetailsState details;
  final SalesOrdersState orders;
  final SaleOrderDetailsState order;

  void register(AppSettings settings) {
    getIt.reset(dispose: false);
    final authVm = MockAuthVm();
    when(() => authVm.state).thenReturn(auth);
    final settingsVm = MockSettingsVm();
    when(() => settingsVm.state).thenReturn(settings);
    final syncVm = MockSyncVm();
    when(() => syncVm.state).thenReturn(const SyncStatusState());
    getIt
      ..registerSingleton<AuthViewModel>(authVm)
      ..registerSingleton<SettingsViewModel>(settingsVm)
      ..registerSingleton<SyncStatusViewModel>(syncVm)
      ..registerFactory<CustomerListViewModel>(() => MockCustomerListVm(list))
      ..registerFactory<SalesOrdersViewModel>(() => MockOrdersVm(orders))
      ..registerFactoryParam<CustomerDetailsViewModel, int, void>(
        (id, _) => MockCustomerDetailsVm(details, id),
      )
      ..registerFactoryParam<SaleOrderDetailsViewModel, int, void>(
        (_, _) => MockOrderDetailsVm(order),
      );
  }
}

/// Renders the real app at [location] and writes `screenshots/<name>.png`.
Future<void> shoot(
  WidgetTester t, {
  required String name,
  required Scene scene,
  required String location,
  required Size size,
  AppSettings settings = const AppSettings(),
}) async {
  t.view
    ..physicalSize = size * 2
    ..devicePixelRatio = 2;
  scene.register(settings);
  debugDisableShadows = false; // real soft shadows instead of test outlines
  await t.pumpWidget(const App());
  await t.pump(const Duration(milliseconds: 50));
  final ctx = t.element(find.byType(Navigator).first);
  GoRouter.of(ctx).go(location);
  for (var i = 0; i < 12; i++) {
    await t.pump(const Duration(milliseconds: 100));
  }
  await expectLater(
    find.byType(App),
    matchesGoldenFile('../screenshots/$name.png'),
  );
  debugDisableShadows = true;
}
