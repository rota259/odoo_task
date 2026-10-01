import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:odoo_task/core/error/failures.dart';

import '../../helpers/factories.dart';
import 'customer_repo_harness.dart';

void main() {
  final h = CustomerRepoHarness();
  setUp(h.setUp);
  tearDown(h.tearDown);

  test('online: fetches with customer_rank + ilike and caches', () async {
    h.serverReturns([CustomerRepoHarness.row(1, 'Acme')]);
    final page = (await h.repo.getCustomers(
      query: 'ac',
    )).getOrElse((f) => throw f);
    expect(page.items.single.name, 'Acme');
    expect(page.fromCache, isFalse);
    expect(page.hasMore, isFalse);
    final domain = verify(
      () => h.client.searchRead(
        'res.partner',
        domain: captureAny(named: 'domain'),
        fields: any(named: 'fields'),
        limit: 30,
        offset: 0,
        order: any(named: 'order'),
      ),
    ).captured.single;
    expect(domain, [
      ['customer_rank', '>', 0],
      ['name', 'ilike', 'ac'],
    ]);
    expect(h.local.search('').single.name, 'Acme');
  });

  test('offline: serves the cache, filtered locally', () async {
    h.serverReturns([
      CustomerRepoHarness.row(1, 'Acme'),
      CustomerRepoHarness.row(2, 'Azure Interior'),
    ]);
    await h.repo.getCustomers();
    h.connectivity.set(false);
    final page = (await h.repo.getCustomers(
      query: 'azu',
    )).getOrElse((f) => throw f);
    expect(page.fromCache, isTrue);
    expect(page.items.map((c) => c.name), ['Azure Interior']);
  });

  test('server unreachable while "online" falls back to cache', () async {
    h.serverReturns([CustomerRepoHarness.row(1, 'Acme')]);
    await h.repo.getCustomers();
    h.serverUnreachable();
    final page = (await h.repo.getCustomers()).getOrElse((f) => throw f);
    expect(page.fromCache, isTrue);
  });

  test('offline with an empty cache -> OfflineFailure', () async {
    h.connectivity.set(false);
    final result = await h.repo.getCustomers();
    expect(result.getLeft().toNullable(), isA<OfflineFailure>());
  });

  test('pending edits are overlaid on server data', () async {
    h.serverReturns([CustomerRepoHarness.row(1, 'Acme', phone: '000')]);
    await h.queue.enqueue(edit(1, '999', 0));
    final page = (await h.repo.getCustomers()).getOrElse((f) => throw f);
    expect(page.items.single.phone, '999');
    expect(page.items.single.hasPendingSync, isTrue);
  });

  test('details: offline uses cached details', () async {
    when(() => h.client.read(any(), any(), any())).thenAnswer(
      (_) async => [
        {...CustomerRepoHarness.row(1, 'Acme'), 'email': 'a@b.c'},
      ],
    );
    await h.repo.getCustomerDetails(1);
    h.connectivity.set(false);
    final r = (await h.repo.getCustomerDetails(1)).getOrElse((f) => throw f);
    expect(r.fromCache, isTrue);
    expect(r.details.email, 'a@b.c');
  });
}
