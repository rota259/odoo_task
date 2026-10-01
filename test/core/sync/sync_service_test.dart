import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:odoo_task/core/error/failures.dart';
import 'package:odoo_task/core/sync/pending_edit_queue.dart';
import 'package:odoo_task/core/sync/sync_result.dart';
import 'package:odoo_task/core/sync/sync_service.dart';

import '../../helpers/factories.dart';
import '../../helpers/fake_connectivity.dart';
import '../../helpers/hive_helper.dart';
import '../../helpers/mocks.dart';

void main() {
  final hive = TestHive();
  late PendingEditQueue queue;
  late MockPendingEditSender sender;
  late FakeConnectivity connectivity;
  late SyncService sync;

  setUpAll(registerFallbacks);
  setUp(() async {
    await hive.setUp();
    queue = PendingEditQueue(await hive.mapBox('pending'));
    sender = MockPendingEditSender();
    connectivity = FakeConnectivity(online: false);
    sync = SyncService(connectivity, queue, sender);
  });
  tearDown(() async {
    await sync.dispose();
    await hive.tearDown();
  });

  void sendSucceeds() =>
      when(() => sender.send(any())).thenAnswer((_) async => const Right(unit));

  test('flushes in order and empties the queue', () async {
    sendSucceeds();
    await queue.enqueue(edit(2, 'b', 2));
    await queue.enqueue(edit(1, 'a', 1));
    final result = await sync.flush();
    expect(result, const SyncResult(synced: 2, failed: 0));
    expect(queue.length, 0);
    final sent = verify(() => sender.send(captureAny())).captured;
    expect(sent.map((e) => e.partnerId), [1, 2]);
  });

  test('partial failure keeps only the failed edits', () async {
    when(() => sender.send(any())).thenAnswer((inv) async {
      final e = inv.positionalArguments.first;
      return e.partnerId == 2
          ? const Left(ServerFailure('Validation error'))
          : const Right(unit);
    });
    for (final (i, id) in [1, 2, 3].indexed) {
      await queue.enqueue(edit(id, 'v$id', i));
    }
    final result = await sync.flush();
    expect(result, const SyncResult(synced: 2, failed: 1));
    expect(queue.all().single.partnerId, 2);
  });

  test('a network failure stops the flush and keeps the rest', () async {
    when(
      () => sender.send(any()),
    ).thenAnswer((_) async => const Left(NetworkFailure()));
    await queue.enqueue(edit(1, 'a', 1));
    await queue.enqueue(edit(2, 'b', 2));
    final result = await sync.flush();
    expect(result.synced, 0);
    expect(queue.length, 2);
    verify(() => sender.send(any())).called(1);
  });

  test('coming back online triggers a flush and reports it', () async {
    sendSucceeds();
    await queue.enqueue(edit(1, 'a', 1));
    sync.start();
    final reported = sync.results.first;
    connectivity.set(true);
    expect(await reported, const SyncResult(synced: 1, failed: 0));
    expect(queue.length, 0);
  });

  test('concurrent flushes share one run', () async {
    sendSucceeds();
    await queue.enqueue(edit(1, 'a', 1));
    final results = await Future.wait([sync.flush(), sync.flush()]);
    expect(results.first, same(results.last));
    verify(() => sender.send(any())).called(1);
  });

  test('empty queue does nothing', () async {
    expect(await sync.flush(), SyncResult.empty);
    verifyNever(() => sender.send(any()));
  });
}
