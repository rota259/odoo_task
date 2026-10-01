import 'dart:async';

import 'package:odoo_task/core/connectivity/connectivity_service.dart';

/// Controllable connectivity for tests.
class FakeConnectivity implements ConnectivityService {
  FakeConnectivity({bool online = true}) : _online = online;

  final _controller = StreamController<bool>.broadcast();
  bool _online;

  @override
  bool get isOnline => _online;

  @override
  Stream<bool> get onStatusChange => _controller.stream;

  @override
  Future<bool> checkOnline() async => _online;

  void set(bool online) {
    if (online == _online) return;
    _online = online;
    _controller.add(online);
  }

  Future<void> dispose() => _controller.close();
}
