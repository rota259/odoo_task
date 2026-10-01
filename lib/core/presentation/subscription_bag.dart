import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

/// Cancels tracked subscriptions (and runs dispose hooks) when the
/// ViewModel closes.
mixin SubscriptionBag<S> on Cubit<S> {
  final _subscriptions = <StreamSubscription<Object?>>[];
  final _disposers = <void Function()>[];

  void track(StreamSubscription<Object?> subscription) =>
      _subscriptions.add(subscription);

  void onDispose(void Function() disposer) => _disposers.add(disposer);

  @override
  Future<void> close() async {
    for (final s in _subscriptions) {
      await s.cancel();
    }
    _subscriptions.clear();
    for (final dispose in _disposers) {
      dispose();
    }
    return super.close();
  }
}
