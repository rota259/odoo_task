import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/view_status.dart';
import '../../domain/entities/sale_order_details.dart';

class SaleOrderDetailsState extends Equatable {
  const SaleOrderDetailsState({
    this.status = ViewStatus.initial,
    this.details,
    this.failure,
    this.confirmStatus = ActionStatus.idle,
    this.confirmFailure,
  });

  final ViewStatus status;
  final SaleOrderDetails? details;
  final Failure? failure;
  final ActionStatus confirmStatus;
  final Failure? confirmFailure;

  bool get canConfirm => details?.order.state.canConfirm ?? false;

  SaleOrderDetailsState copyWith({
    ViewStatus? status,
    SaleOrderDetails? details,
    Failure? Function()? failure,
    ActionStatus? confirmStatus,
    Failure? Function()? confirmFailure,
  }) => SaleOrderDetailsState(
    status: status ?? this.status,
    details: details ?? this.details,
    failure: failure != null ? failure() : this.failure,
    confirmStatus: confirmStatus ?? this.confirmStatus,
    confirmFailure: confirmFailure != null
        ? confirmFailure()
        : this.confirmFailure,
  );

  @override
  List<Object?> get props => [
    status,
    details,
    failure,
    confirmStatus,
    confirmFailure,
  ];
}
