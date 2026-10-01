import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/presentation/subscription_bag.dart';
import '../../../../core/sync/sync_result.dart';

class SyncStatusState extends Equatable {
  const SyncStatusState({this.lastResult, this.sequence = 0});

  final SyncResult? lastResult;

  /// Increments on every flush so identical results still notify.
  final int sequence;

  @override
  List<Object?> get props => [lastResult, sequence];
}

/// Exposes sync outcomes so the shell can show "X changes synced".
class SyncStatusViewModel extends Cubit<SyncStatusState>
    with SubscriptionBag<SyncStatusState> {
  SyncStatusViewModel(Stream<SyncResult> results)
    : super(const SyncStatusState()) {
    track(
      results.listen(
        (r) =>
            emit(SyncStatusState(lastResult: r, sequence: state.sequence + 1)),
      ),
    );
  }
}
