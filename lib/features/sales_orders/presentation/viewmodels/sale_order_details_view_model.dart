import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/presentation/view_status.dart';
import '../../domain/usecases/sale_order_usecases.dart';
import 'sale_order_details_state.dart';

class SaleOrderDetailsViewModel extends Cubit<SaleOrderDetailsState> {
  SaleOrderDetailsViewModel({
    required this.orderId,
    required GetSaleOrderDetailsUseCase getDetails,
    required ConfirmSaleOrderUseCase confirmOrder,
  }) : _getDetails = getDetails,
       _confirmOrder = confirmOrder,
       super(const SaleOrderDetailsState());

  final int orderId;
  final GetSaleOrderDetailsUseCase _getDetails;
  final ConfirmSaleOrderUseCase _confirmOrder;

  Future<void> load() async {
    emit(state.copyWith(status: ViewStatus.loading));
    final result = await _getDetails(orderId);
    if (isClosed) return;
    result.match(
      (failure) => emit(
        state.copyWith(status: ViewStatus.failure, failure: () => failure),
      ),
      (details) => emit(
        state.copyWith(
          status: ViewStatus.success,
          details: details,
          failure: () => null,
        ),
      ),
    );
  }

  /// Confirms the quotation; the view asks for confirmation first.
  Future<void> confirm() async {
    if (!state.canConfirm || state.confirmStatus == ActionStatus.running) {
      return;
    }
    emit(
      state.copyWith(
        confirmStatus: ActionStatus.running,
        confirmFailure: () => null,
      ),
    );
    final result = await _confirmOrder(orderId);
    if (isClosed) return;
    result.match(
      (failure) => emit(
        state.copyWith(
          confirmStatus: ActionStatus.failure,
          confirmFailure: () => failure,
        ),
      ),
      (details) => emit(
        state.copyWith(details: details, confirmStatus: ActionStatus.success),
      ),
    );
  }
}
