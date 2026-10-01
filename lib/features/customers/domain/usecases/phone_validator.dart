/// Basic phone validation: digits plus common separators, 6-20 digits.
abstract final class PhoneValidator {
  static final _allowed = RegExp(r'^\+?[0-9\s()\-./]+$');
  static const minDigits = 6;
  static const maxDigits = 20;

  /// Trims and collapses repeated whitespace.
  static String normalize(String input) =>
      input.trim().replaceAll(RegExp(r'\s+'), ' ');

  static bool isValid(String input) {
    final value = normalize(input);
    if (value.isEmpty || !_allowed.hasMatch(value)) return false;
    final digits = value.replaceAll(RegExp(r'\D'), '').length;
    return digits >= minDigits && digits <= maxDigits;
  }
}
