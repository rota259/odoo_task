import 'package:flutter_test/flutter_test.dart';
import 'package:odoo_task/core/sync/pending_edit.dart';
import 'package:odoo_task/core/sync/pending_edit_queue.dart';

import '../../helpers/factories.dart';
import '../../helpers/hive_helper.dart';

void main() {
  final hive = TestHive();
  late PendingEditQueue queue;

  setUp(() async {
    await hive.setUp();
    queue = PendingEditQueue(await hive.mapBox('pending'));
  });
  tearDown(hive.tearDown);

  test('coalesces edits to the same partner + field (latest wins)', () async {
    await queue.enqueue(edit(1, '111', 0));
    await queue.enqueue(edit(1, '222', 5));
    expect(queue.length, 1);
    expect(queue.find(1, 'phone')!.value, '222');
  });

  test('keeps different partners / fields separately', () async {
    await queue.enqueue(edit(1, 'a', 0));
    await queue.enqueue(edit(2, 'b', 1));
    await queue.enqueue(edit(1, 'c', 2, field: 'email'));
    expect(queue.length, 3);
    expect(queue.pendingPartnerIds(), {1, 2});
  });

  test('all() returns edits oldest first', () async {
    await queue.enqueue(edit(3, 'c', 30));
    await queue.enqueue(edit(1, 'a', 10));
    await queue.enqueue(edit(2, 'b', 20));
    expect(queue.all().map((e) => e.partnerId), [1, 2, 3]);
  });

  test('coalescing moves the edit to its newest position', () async {
    await queue.enqueue(edit(1, 'a', 10));
    await queue.enqueue(edit(2, 'b', 20));
    await queue.enqueue(edit(1, 'a2', 30));
    expect(queue.all().map((e) => e.value), ['b', 'a2']);
  });

  test('remove() ignores a stale version (newer edit coalesced)', () async {
    final first = edit(1, 'old', 0);
    await queue.enqueue(first);
    await queue.enqueue(edit(1, 'new', 1));
    expect(await queue.remove(first), isFalse);
    expect(queue.find(1, 'phone')!.value, 'new');
  });

  test('survives reopening the box (persistence)', () async {
    await queue.enqueue(edit(9, 'x', 0));
    final restored = queue.all().single;
    expect(PendingEdit.fromMap(restored.toMap()), restored);
  });

  test('clear() empties the queue', () async {
    await queue.enqueue(edit(1, 'a', 0));
    await queue.clear();
    expect(queue.length, 0);
  });
}
