import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

/// Online/offline signal for the app.
abstract interface class ConnectivityService {
  /// Last known state (updated by [onStatusChange]).
  bool get isOnline;

  /// Emits only when the state actually changes.
  Stream<bool> get onStatusChange;

  Future<bool> checkOnline();
}

class ConnectivityPlusService implements ConnectivityService {
  ConnectivityPlusService([Connectivity? connectivity])
    : _connectivity = connectivity ?? Connectivity() {
    _subscription = _connectivity.onConnectivityChanged.listen(_update);
    unawaited(checkOnline());
  }

  final Connectivity _connectivity;
  final _controller = StreamController<bool>.broadcast();
  late final StreamSubscription<List<ConnectivityResult>> _subscription;
  bool _isOnline = true;

  @override
  bool get isOnline => _isOnline;

  @override
  Stream<bool> get onStatusChange => _controller.stream;

  @override
  Future<bool> checkOnline() async {
    _update(await _connectivity.checkConnectivity());
    return _isOnline;
  }

  void _update(List<ConnectivityResult> results) {
    final online = results.any((r) => r != ConnectivityResult.none);
    if (online == _isOnline) return;
    _isOnline = online;
    _controller.add(online);
  }

  Future<void> dispose() async {
    await _subscription.cancel();
    await _controller.close();
  }
}
