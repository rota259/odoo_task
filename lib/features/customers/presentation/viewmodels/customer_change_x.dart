import '../../domain/entities/customer.dart';
import '../../domain/entities/customer_details.dart';
import '../../domain/entities/customer_results.dart';

extension CustomerListChangeX on List<Customer> {
  List<Customer> applyChange(CustomerChange change) => [
    for (final c in this)
      c.id == change.id
          ? c.copyWith(
              phone: () => change.phone,
              hasPendingSync: change.hasPendingSync,
            )
          : c,
  ];
}

extension CustomerDetailsChangeX on CustomerDetails {
  CustomerDetails applyChange(CustomerChange change) => change.id != id
      ? this
      : copyWith(
          phone: () => change.phone,
          hasPendingSync: change.hasPendingSync,
        );
}
