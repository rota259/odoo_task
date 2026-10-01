import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:odoo_task/core/error/failures.dart';
import 'package:odoo_task/core/network/odoo_exception.dart';
import 'package:odoo_task/features/customers/data/repositories/customer_edit_sender.dart';
import 'package:odoo_task/features/customers/domain/entities/customer_results.dart';

import '../../helpers/factories.dart';
import 'customer_repo_harness.dart';

void main() {
  final h = CustomerRepoHarness();
  setUp(() async {
    await h.setUp();
    h.serverReturns([CustomerRepoHarness.row(1, 'Acme', phone: '000')]);
    await h.repo.getCustomers();
  });
  tearDown(h.tearDown);

  test('online: writes to Odoo, updates cache, emits change', () async {
    h.writeAnswers(() => true);
    final change = h.repo.changes.first;
    final r = await h.repo.updatePhone(1, '123456');
    expect(r.toNullable(), PhoneUpdateOutcome.synced);
    verify(() => h.client.write('res.partner', [1], {'phone': '123456'}));
    expect(h.local.search('').single.phone, '123456');
    expect((await change).hasPendingSync, isFalse);
    expect(h.queue.length, 0);
  });

  test('online write drops an older queued value for the field', () async {
    await h.queue.enqueue(edit(1, 'stale', 0));
    h.writeAnswers(() => true);
    await h.repo.updatePhone(1, '123456');
    expect(h.queue.length, 0);
  });

  test('offline: optimistic cache update + queued edit', () async {
    h.connectivity.set(false);
    final r = await h.repo.updatePhone(1, '555 1234');
    expect(r.toNullable(), PhoneUpdateOutcome.queued);
    expect(h.local.search('').single.phone, '555 1234');
    expect(h.queue.find(1, 'phone')!.value, '555 1234');
    verifyNever(() => h.client.write(any(), any(), any()));
  });

  test('network error while online also queues', () async {
    h.writeAnswers(() => const OdooException.network());
    final r = await h.repo.updatePhone(1, '555 1234');
    expect(r.toNullable(), PhoneUpdateOutcome.queued);
    expect(h.queue.length, 1);
  });

  test('Odoo errors surface and nothing is queued', () async {
    h.writeAnswers(
      () => const OdooException(OdooErrorKind.server, 'Invalid phone'),
    );
    final r = await h.repo.updatePhone(1, '555 1234');
    expect(r.getLeft().toNullable(), const ServerFailure('Invalid phone'));
    expect(h.queue.length, 0);
    expect(h.local.search('').single.phone, '000');
  });

  test('edit sender writes the queued value and clears the flag', () async {
    h.writeAnswers(() => true);
    final queued = edit(1, '777777', 0);
    await h.queue.enqueue(queued);
    final change = h.repo.changes.first;
    final sender = CustomerEditSender(h.remote, h.queue, h.bus);
    expect((await sender.send(queued)).isRight(), isTrue);
    verify(() => h.client.write('res.partner', [1], {'phone': '777777'}));
    expect(await change, isA<CustomerChange>());
    expect((await change).hasPendingSync, isFalse);
  });
}
