import '../../../../core/sync/pending_edit_queue.dart';
import '../../domain/entities/customer.dart';
import '../../domain/entities/customer_details.dart';

/// Applies queued (unsynced) phone edits on top of server/cached data, so
/// the user always sees their latest value plus a "pending sync" marker.
extension PendingOverlay on PendingEditQueue {
  static const phoneField = 'phone';

  Customer overlayCustomer(Customer c) {
    final edit = find(c.id, phoneField);
    if (edit == null) return c;
    return c.copyWith(phone: () => edit.value as String?, hasPendingSync: true);
  }

  CustomerDetails overlayDetails(CustomerDetails d) {
    final edit = find(d.id, phoneField);
    if (edit == null) return d;
    return d.copyWith(phone: () => edit.value as String?, hasPendingSync: true);
  }
}
