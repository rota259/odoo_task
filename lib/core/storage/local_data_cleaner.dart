/// Anything holding user data on the device that must be wiped on logout.
abstract interface class LocalDataCleaner {
  Future<void> clearLocalData();
}
