import 'package:fpdart/fpdart.dart';

import '../../../../core/connectivity/connectivity_service.dart';
import '../../../../core/error/failure_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/sync/pending_edit.dart';
import '../../../../core/sync/pending_edit_queue.dart';
import '../../domain/entities/customer_results.dart';
import '../datasources/customer_change_bus.dart';
import '../datasources/customer_local_data_source.dart';
import '../datasources/customer_remote_data_source.dart';
import 'pending_overlay.dart';

/// Online-first phone update with an optimistic offline path.
mixin CustomerPhoneWriter {
  CustomerRemoteDataSource get remote;
  CustomerLocalDataSource get local;
  PendingEditQueue get queue;
  ConnectivityService get connectivity;
  CustomerChangeBus get bus;

  /// Clock, overridable in tests.
  DateTime now() => DateTime.now();

  Future<Either<Failure, PhoneUpdateOutcome>> updatePhone(
    int id,
    String phone,
  ) async {
    const field = PendingOverlay.phoneField;
    if (connectivity.isOnline) {
      final result = await guard(() => remote.writeFields(id, {field: phone}));
      final failure = result.getLeft().toNullable();
      if (failure == null) {
        // An older queued value must not overwrite this one later.
        final stale = queue.find(id, field);
        if (stale != null) await queue.remove(stale);
        await _applyLocally(id, phone, pending: false);
        return const Right(PhoneUpdateOutcome.synced);
      }
      if (failure is! NetworkFailure) return Left(failure);
    }
    await queue.enqueue(
      PendingEdit(partnerId: id, field: field, value: phone, createdAt: now()),
    );
    await _applyLocally(id, phone, pending: true);
    return const Right(PhoneUpdateOutcome.queued);
  }

  Future<void> _applyLocally(int id, String phone, {required bool pending}) {
    bus.emit(CustomerChange(id: id, phone: phone, hasPendingSync: pending));
    return local.updatePhone(id, phone);
  }
}
