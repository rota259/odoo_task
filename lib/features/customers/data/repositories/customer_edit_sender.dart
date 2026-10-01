import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/sync/pending_edit.dart';
import '../../../../core/sync/pending_edit_queue.dart';
import '../../../../core/sync/pending_edit_sender.dart';
import '../../domain/entities/customer_results.dart';
import '../datasources/customer_change_bus.dart';
import '../datasources/customer_remote_data_source.dart';

/// Sends queued partner edits for the [SyncService] (last write wins:
/// the queued value simply overwrites whatever is on the server).
class CustomerEditSender implements PendingEditSender {
  CustomerEditSender(this._remote, this._queue, this._bus);

  final CustomerRemoteDataSource _remote;
  final PendingEditQueue _queue;
  final CustomerChangeBus _bus;

  @override
  Future<Either<Failure, Unit>> send(PendingEdit edit) async {
    final result = await guard(
      () => _remote.writeFields(edit.partnerId, {edit.field: edit.value}),
    );
    if (result.isRight()) {
      // Still pending if a newer edit was coalesced in meanwhile.
      final newer = _queue.find(edit.partnerId, edit.field);
      final stillPending = newer != null && newer != edit;
      _bus.emit(
        CustomerChange(
          id: edit.partnerId,
          phone: (stillPending ? newer.value : edit.value) as String?,
          hasPendingSync: stillPending,
        ),
      );
    }
    return result.map((_) => unit);
  }
}
