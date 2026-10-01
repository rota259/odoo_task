import 'dart:async';

import '../../domain/entities/customer_results.dart';

/// In-memory broadcast of local customer changes, shared by the repository
/// and the sync sender so every open screen stays consistent.
class CustomerChangeBus {
  final _controller = StreamController<CustomerChange>.broadcast();

  Stream<CustomerChange> get stream => _controller.stream;

  void emit(CustomerChange change) {
    if (!_controller.isClosed) _controller.add(change);
  }

  Future<void> dispose() => _controller.close();
}
