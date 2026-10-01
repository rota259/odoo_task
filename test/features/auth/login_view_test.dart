import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:odoo_task/core/error/failures.dart';
import 'package:odoo_task/core/network/odoo_endpoint.dart';
import 'package:odoo_task/features/auth/domain/entities/login_request.dart';
import 'package:odoo_task/features/auth/presentation/viewmodels/auth_state.dart';
import 'package:odoo_task/features/auth/presentation/viewmodels/auth_view_model.dart';
import 'package:odoo_task/features/auth/presentation/views/login_view.dart';

import '../../helpers/mocks.dart';
import '../../helpers/pump_app.dart';

class MockAuthViewModel extends MockCubit<AuthState> implements AuthViewModel {}

void main() {
  late MockAuthViewModel vm;

  setUpAll(registerFallbacks);
  setUp(() {
    vm = MockAuthViewModel();
    when(
      () => vm.state,
    ).thenReturn(const AuthState(status: AuthStatus.unauthenticated));
    when(() => vm.login(any())).thenAnswer((_) async {});
  });

  Future<void> pump(WidgetTester tester, {Locale? locale}) =>
      tester.pumpLocalized(
        BlocProvider<AuthViewModel>.value(value: vm, child: const LoginView()),
        locale: locale ?? const Locale('en'),
      );

  testWidgets('empty submit shows validation and does not log in', (t) async {
    await pump(t);
    await t.tap(find.text('Sign in'));
    await t.pumpAndSettle();
    expect(find.text('This field is required'), findsNWidgets(2));
    verifyNever(() => vm.login(any()));
  });

  testWidgets('valid form calls login with server defaults', (t) async {
    await pump(t);
    await t.enterText(find.byKey(const Key('login_username')), ' demo ');
    await t.enterText(find.byKey(const Key('login_password')), 'demo');
    await t.tap(find.text('Sign in'));
    await t.pump();
    final request =
        verify(() => vm.login(captureAny())).captured.single as LoginRequest;
    expect(request.login, 'demo');
    expect(request.password, 'demo');
    expect(request.baseUrl, OdooEndpoint.defaultUrl);
    expect(request.database, OdooEndpoint.defaultDatabase);
  });

  testWidgets('server settings expand to URL + database fields', (t) async {
    await pump(t);
    await t.tap(find.byKey(const Key('server_settings_toggle')));
    await t.pumpAndSettle();
    final url = t.widget<TextField>(
      find.descendant(
        of: find.byKey(const Key('login_url')),
        matching: find.byType(TextField),
      ),
    );
    expect(url.enabled, isTrue);
    expect(url.controller!.text, OdooEndpoint.defaultUrl);
  });

  testWidgets('shows a clear message for wrong credentials', (t) async {
    when(() => vm.state).thenReturn(
      const AuthState(
        status: AuthStatus.unauthenticated,
        failure: InvalidCredentialsFailure(),
      ),
    );
    await pump(t);
    expect(find.text('Wrong username or password.'), findsOneWidget);
  });

  testWidgets('Arabic renders right-to-left with Arabic labels', (t) async {
    await pump(t, locale: const Locale('ar'));
    expect(find.text('تسجيل الدخول'), findsOneWidget);
    final dir = Directionality.of(t.element(find.byType(LoginView)));
    expect(dir, TextDirection.rtl);
  });
}
