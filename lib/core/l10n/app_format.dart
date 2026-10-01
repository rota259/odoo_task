import 'package:intl/intl.dart';

/// Locale-aware date / number formatting (`intl`).
abstract final class AppFormat {
  static String dateTime(DateTime value, String locale) =>
      DateFormat.yMMMd(locale).add_jm().format(value);

  static String money(double value, String locale, String? currencyCode) =>
      NumberFormat.simpleCurrency(
        locale: locale,
        name: currencyCode,
      ).format(value);

  static String quantity(double value, String locale) =>
      NumberFormat.decimalPattern(locale).format(value);
}
