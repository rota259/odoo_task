import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/view_status.dart';
import '../../domain/entities/customer_details.dart';
import '../../domain/entities/customer_results.dart';

class CustomerDetailsState extends Equatable {
  const CustomerDetailsState({
    this.status = ViewStatus.initial,
    this.details,
    this.isOffline = false,
    this.failure,
    this.saveStatus = ActionStatus.idle,
    this.saveOutcome,
    this.saveFailure,
  });

  final ViewStatus status;
  final CustomerDetails? details;
  final bool isOffline;
  final Failure? failure;

  final ActionStatus saveStatus;

  /// Whether the last successful save went to Odoo or to the offline queue.
  final PhoneUpdateOutcome? saveOutcome;
  final Failure? saveFailure;

  CustomerDetailsState copyWith({
    ViewStatus? status,
    CustomerDetails? details,
    bool? isOffline,
    Failure? Function()? failure,
    ActionStatus? saveStatus,
    PhoneUpdateOutcome? Function()? saveOutcome,
    Failure? Function()? saveFailure,
  }) => CustomerDetailsState(
    status: status ?? this.status,
    details: details ?? this.details,
    isOffline: isOffline ?? this.isOffline,
    failure: failure != null ? failure() : this.failure,
    saveStatus: saveStatus ?? this.saveStatus,
    saveOutcome: saveOutcome != null ? saveOutcome() : this.saveOutcome,
    saveFailure: saveFailure != null ? saveFailure() : this.saveFailure,
  );

  @override
  List<Object?> get props => [
    status,
    details,
    isOffline,
    failure,
    saveStatus,
    saveOutcome,
    saveFailure,
  ];
}
