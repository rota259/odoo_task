// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => '2S Home Wear';

  @override
  String get brandShort => '2S';

  @override
  String get brandRest => ' Home Wear';

  @override
  String get loginTitle => 'Welcome back';

  @override
  String get loginSubtitle => 'Sign in with your Odoo account';

  @override
  String get username => 'Username';

  @override
  String get password => 'Password';

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get signIn => 'Sign in';

  @override
  String get serverSettings => 'Server settings';

  @override
  String get serverUrl => 'Server URL';

  @override
  String get database => 'Database';

  @override
  String get fieldRequired => 'This field is required';

  @override
  String get invalidUrl => 'Enter a valid http(s) URL';

  @override
  String get errorWrongCredentials => 'Wrong username or password.';

  @override
  String get errorUnreachable =>
      'Can\'t reach the server. Check the URL and your connection.';

  @override
  String get errorWrongDatabase => 'Database not found on this server.';

  @override
  String get errorSessionExpired =>
      'Your session expired. Please sign in again.';

  @override
  String get errorUnknown => 'Something went wrong. Please try again.';

  @override
  String get errorOffline => 'You\'re offline.';

  @override
  String get customers => 'Customers';

  @override
  String get salesOrders => 'Sales Orders';

  @override
  String get settings => 'Settings';

  @override
  String get logout => 'Log out';

  @override
  String get logoutConfirmTitle => 'Log out?';

  @override
  String get logoutConfirmBody =>
      'Your cached data and pending offline edits on this device will be removed.';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get retry => 'Retry';

  @override
  String get save => 'Save';

  @override
  String get menu => 'Menu';

  @override
  String get searchCustomers => 'Search customers by name';

  @override
  String get clearSearch => 'Clear search';

  @override
  String get noCustomers => 'No customers found';

  @override
  String get noCustomersHint => 'Try a different search or pull to refresh.';

  @override
  String get offlineBanner => 'Offline – showing cached data';

  @override
  String get offlineTitle => 'You\'re offline';

  @override
  String get salesOfflineBody =>
      'Sales orders need a connection. They\'ll be here when you\'re back online.';

  @override
  String get pendingSync => 'Pending sync';

  @override
  String get emptyValue => '—';

  @override
  String get customerDetails => 'Customer details';

  @override
  String get phone => 'Phone';

  @override
  String get email => 'Email';

  @override
  String get address => 'Address';

  @override
  String get editPhone => 'Edit phone';

  @override
  String get invalidPhone =>
      'Enter a valid phone number (digits, spaces, + - ( ) only)';

  @override
  String get phoneSaved => 'Phone number saved';

  @override
  String get phoneSavedOffline =>
      'Saved offline – will sync when you\'re back online';

  @override
  String get selectCustomer => 'Select a customer to see the details';

  @override
  String get selectOrder => 'Select an order to see the details';

  @override
  String changesSynced(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count changes synced',
      one: '1 change synced',
    );
    return '$_temp0';
  }

  @override
  String get noOrders => 'No sales orders yet';

  @override
  String get orderLines => 'Order lines';

  @override
  String get orderDate => 'Order date';

  @override
  String get customer => 'Customer';

  @override
  String get status => 'Status';

  @override
  String get untaxedAmount => 'Untaxed amount';

  @override
  String get taxes => 'Taxes';

  @override
  String get total => 'Total';

  @override
  String get noLines => 'This order has no lines.';

  @override
  String lineQtyPrice(String qty, String price) {
    return '$qty × $price';
  }

  @override
  String get confirmOrder => 'Confirm order';

  @override
  String get confirmOrderTitle => 'Confirm this order?';

  @override
  String confirmOrderBody(String order) {
    return '$order will become a sales order. This can\'t be undone from the app.';
  }

  @override
  String get orderConfirmed => 'Order confirmed';

  @override
  String get stateDraft => 'Quotation';

  @override
  String get stateSent => 'Quotation Sent';

  @override
  String get stateSale => 'Sales Order';

  @override
  String get stateDone => 'Locked';

  @override
  String get stateCancel => 'Cancelled';

  @override
  String get stateUnknown => 'Unknown';

  @override
  String get appearance => 'Appearance';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get language => 'Language';

  @override
  String get languageSystem => 'Device language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageArabic => 'العربية';

  @override
  String get account => 'Account';

  @override
  String signedInAs(String name) {
    return 'Signed in as $name';
  }

  @override
  String accountLine(String login, String database) {
    return '$login · $database';
  }

  @override
  String get internalUser => 'Internal user';

  @override
  String get portalUser => 'Portal user';

  @override
  String get back => 'Back';
}
