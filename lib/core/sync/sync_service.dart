import 'dart:async';

import '../connectivity/connectivity_service.dart';
import '../error/failures.dart';
import 'pending_edit_queue.dart';
import 'pending_edit_sender.dart';
import 'sync_result.dart';

/// Flushes the offline queue to Odoo whenever the device comes back online.
///
/// Edits are sent oldest first. Successful ones are removed, failed ones
/// stay queued. A network failure stops the flush early (the rest would
/// fail too) and the queue is retried on the next trigger: connectivity
/// coming back, app start / login, or a periodic retry while edits are
/// pending (covers "device online but server down").
/// Conflict policy: last write wins.
class SyncService {
  SyncService(
    this._connectivity,
    this._queue,
    this._sender, {
    this.retryInterval = const Duration(seconds: 30),
  });

  final Duration retryInterval;

  final ConnectivityService _connectivity;
  final PendingEditQueue _queue;
  final PendingEditSender _sender;
  final _results = StreamController<SyncResult>.broadcast();
  StreamSubscription<bool>? _subscription;
  Timer? _retryTimer;
  Future<SyncResult>? _running;

  /// Emits after every flush that attempted at least one edit.
  Stream<SyncResult> get results => _results.stream;

  void start() {
    _subscription ??= _connectivity.onStatusChange
        .where((online) => online)
        .listen((_) => flush());
    _retryTimer ??= Timer.periodic(retryInterval, (_) {
      if (_queue.length > 0 && _connectivity.isOnline) flush();
    });
  }

  /// Runs a flush; concurrent callers share the one in progress.
  Future<SyncResult> flush() =>
      _running ??= _flush().whenComplete(() => _running = null);

  Future<SyncResult> _flush() async {
    final edits = _queue.all();
    if (edits.isEmpty) return SyncResult.empty;
    var synced = 0;
    for (final edit in edits) {
      final result = await _sender.send(edit);
      final failure = result.getLeft().toNullable();
      if (failure == null) {
        await _queue.remove(edit);
        synced++;
      } else if (failure is NetworkFailure || failure is OfflineFailure) {
        break;
      }
    }
    final outcome = SyncResult(synced: synced, failed: edits.length - synced);
    if (!_results.isClosed) _results.add(outcome);
    return outcome;
  }

  Future<void> dispose() async {
    await _subscription?.cancel();
    _subscription = null;
    _retryTimer?.cancel();
    _retryTimer = null;
    await _results.close();
  }
}
