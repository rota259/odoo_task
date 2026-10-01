import 'package:fpdart/fpdart.dart';

import '../error/failures.dart';
import 'pending_edit.dart';

/// Writes one queued edit to the server (implemented by the feature that
/// owns the data, so the sync engine stays feature-agnostic).
abstract interface class PendingEditSender {
  Future<Either<Failure, Unit>> send(PendingEdit edit);
}
