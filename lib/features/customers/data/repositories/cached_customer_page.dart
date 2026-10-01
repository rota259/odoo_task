import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/sync/pending_edit_queue.dart';
import '../../domain/entities/customer_results.dart';
import '../datasources/customer_local_data_source.dart';
import 'pending_overlay.dart';

extension CachedCustomerPage on CustomerLocalDataSource {
  /// Offline page: filters and paginates the cache locally. Fails with
  /// [OfflineFailure] only when nothing at all has been cached yet.
  Either<Failure, CustomerPage> cachedPage(
    PendingEditQueue queue, {
    required String query,
    required int offset,
    required int limit,
  }) {
    final all = search(query);
    if (all.isEmpty && query.isEmpty && offset == 0) {
      return const Left(OfflineFailure());
    }
    final end = (offset + limit).clamp(0, all.length);
    final start = offset.clamp(0, end);
    return Right(
      CustomerPage(
        items: all.sublist(start, end).map(queue.overlayCustomer).toList(),
        hasMore: end < all.length,
        fromCache: true,
      ),
    );
  }
}
