import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/presentation/subscription_bag.dart';
import '../../../../core/presentation/view_status.dart';
import '../../domain/usecases/customer_usecases.dart';
import 'customer_change_x.dart';
import 'customer_details_state.dart';

class CustomerDetailsViewModel extends Cubit<CustomerDetailsState>
    with SubscriptionBag<CustomerDetailsState> {
  CustomerDetailsViewModel({
    required this.customerId,
    required GetCustomerDetailsUseCase getDetails,
    required UpdateCustomerPhoneUseCase updatePhone,
    required WatchCustomerChangesUseCase watchChanges,
  }) : _getDetails = getDetails,
       _updatePhone = updatePhone,
       super(const CustomerDetailsState()) {
    track(
      watchChanges().listen((change) {
        final details = state.details;
        if (details == null) return;
        emit(state.copyWith(details: details.applyChange(change)));
      }),
    );
  }

  final int customerId;
  final GetCustomerDetailsUseCase _getDetails;
  final UpdateCustomerPhoneUseCase _updatePhone;

  Future<void> load() async {
    emit(state.copyWith(status: ViewStatus.loading));
    final result = await _getDetails(customerId);
    if (isClosed) return;
    result.match(
      (failure) => emit(
        state.copyWith(status: ViewStatus.failure, failure: () => failure),
      ),
      (r) => emit(
        state.copyWith(
          status: ViewStatus.success,
          details: r.details,
          isOffline: r.fromCache,
          failure: () => null,
        ),
      ),
    );
  }

  Future<void> savePhone(String phone) async {
    if (state.saveStatus == ActionStatus.running) return;
    emit(
      state.copyWith(
        saveStatus: ActionStatus.running,
        saveFailure: () => null,
        saveOutcome: () => null,
      ),
    );
    final result = await _updatePhone(customerId, phone);
    if (isClosed) return;
    result.match(
      (failure) => emit(
        state.copyWith(
          saveStatus: ActionStatus.failure,
          saveFailure: () => failure,
        ),
      ),
      (outcome) => emit(
        state.copyWith(
          saveStatus: ActionStatus.success,
          saveOutcome: () => outcome,
        ),
      ),
    );
  }

  /// Called when the user edits the field again after a save.
  void resetSaveStatus() {
    if (state.saveStatus == ActionStatus.idle) return;
    emit(state.copyWith(saveStatus: ActionStatus.idle));
  }
}
