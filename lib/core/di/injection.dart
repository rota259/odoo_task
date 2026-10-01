import 'package:get_it/get_it.dart';

import 'register_core.dart';
import 'register_features.dart';
import 'register_view_models.dart';

final getIt = GetIt.instance;

/// Wires the whole object graph. Call once before `runApp`.
Future<void> configureDependencies() async {
  await registerCore(getIt);
  registerFeatures(getIt);
  registerViewModels(getIt);
}
