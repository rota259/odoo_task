import 'package:equatable/equatable.dart';

class SyncResult extends Equatable {
  const SyncResult({required this.synced, required this.failed});

  static const empty = SyncResult(synced: 0, failed: 0);

  final int synced;

  /// Edits that stayed in the queue (failed or not attempted).
  final int failed;

  bool get isEmpty => synced == 0 && failed == 0;

  @override
  List<Object?> get props => [synced, failed];
}
