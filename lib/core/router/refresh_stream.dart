import 'dart:async';

import 'package:flutter/foundation.dart';

/// Re-runs go_router redirects whenever [stream] emits.
class RefreshStream extends ChangeNotifier {
  RefreshStream(Stream<Object?> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<Object?> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
