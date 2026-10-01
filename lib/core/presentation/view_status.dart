/// Lifecycle of data loaded by a ViewModel.
enum ViewStatus { initial, loading, success, failure }

/// Lifecycle of a user-triggered action (save, confirm...).
enum ActionStatus { idle, running, success, failure }
