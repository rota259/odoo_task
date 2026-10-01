import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'app.dart';
import 'core/di/injection.dart';
import 'core/sync/sync_service.dart';
import 'core/widgets/brand_wordmark.dart';
import 'features/auth/presentation/viewmodels/auth_view_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  BrandWordmark.hasLogo = await _bundlesLogo();

  // Flush offline edits whenever connectivity returns...
  getIt<SyncService>().start();
  // ...and try auto-login (which also flushes once signed in).
  unawaited(getIt<AuthViewModel>().restore());

  runApp(const App());
}

Future<bool> _bundlesLogo() async {
  final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
  return manifest.listAssets().contains(BrandWordmark.logoAsset);
}
