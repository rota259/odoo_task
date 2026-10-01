import 'package:hive_ce/hive.dart';

import 'pending_edit.dart';

/// Persistent FIFO of offline edits, stored in Hive.
///
/// Keyed by `partnerId:field`, so enqueuing a newer edit for the same field
/// replaces the older one (coalescing).
class PendingEditQueue {
  PendingEditQueue(this._box);

  static const boxName = 'pending_edits';
  final Box<Map<dynamic, dynamic>> _box;

  int get length => _box.length;

  /// Fires whenever the queue changes.
  Stream<void> get changes => _box.watch().map((_) {});

  Future<void> enqueue(PendingEdit edit) => _box.put(edit.key, edit.toMap());

  /// All edits, oldest first.
  List<PendingEdit> all() {
    final edits = _box.values.map(PendingEdit.fromMap).toList();
    edits.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return edits;
  }

  /// Removes [edit] only if it is still the stored version. A newer edit that
  /// was coalesced in while [edit] was being sent stays queued.
  Future<bool> remove(PendingEdit edit) async {
    final stored = _box.get(edit.key);
    if (stored == null || PendingEdit.fromMap(stored) != edit) return false;
    await _box.delete(edit.key);
    return true;
  }

  Set<int> pendingPartnerIds() => {
    for (final map in _box.values) map['partnerId'] as int,
  };

  bool hasPending(int partnerId) => pendingPartnerIds().contains(partnerId);

  PendingEdit? find(int partnerId, String field) {
    final stored = _box.get('$partnerId:$field');
    return stored == null ? null : PendingEdit.fromMap(stored);
  }

  Future<void> clear() => _box.clear();
}
