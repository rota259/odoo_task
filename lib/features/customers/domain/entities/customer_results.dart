import 'package:equatable/equatable.dart';

import 'customer.dart';
import 'customer_details.dart';

class CustomerPage extends Equatable {
  const CustomerPage({
    required this.items,
    required this.hasMore,
    this.fromCache = false,
  });

  final List<Customer> items;
  final bool hasMore;

  /// Served from the local cache because the device is offline.
  final bool fromCache;

  @override
  List<Object?> get props => [items, hasMore, fromCache];
}

class CustomerDetailsResult extends Equatable {
  const CustomerDetailsResult(this.details, {this.fromCache = false});

  final CustomerDetails details;
  final bool fromCache;

  @override
  List<Object?> get props => [details, fromCache];
}

/// How a phone update was applied.
enum PhoneUpdateOutcome {
  /// Written to Odoo right away.
  synced,

  /// Saved locally and queued; synced when back online.
  queued,
}

/// Broadcast when a customer's phone or sync flag changes locally.
class CustomerChange extends Equatable {
  const CustomerChange({
    required this.id,
    required this.phone,
    required this.hasPendingSync,
  });

  final int id;
  final String? phone;
  final bool hasPendingSync;

  @override
  List<Object?> get props => [id, phone, hasPendingSync];
}
