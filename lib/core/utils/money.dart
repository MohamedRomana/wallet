import 'package:intl/intl.dart';

/// Central currency / number formatting so every screen renders amounts the
/// same way.
class Money {
  Money._();

  static const String symbol = '\$';

  static final NumberFormat _full = NumberFormat.currency(
    symbol: symbol,
    decimalDigits: 2,
  );

  static final NumberFormat _compactCurrency = NumberFormat.compactCurrency(
    symbol: symbol,
    decimalDigits: 1,
  );

  /// e.g. `$1,250.00`
  static String format(num value) => _full.format(value);

  /// e.g. `-$1,250.00` / `+$1,250.00`
  static String signed(num value, {bool isIncome = true}) {
    final sign = isIncome ? '+' : '-';
    return '$sign${_full.format(value.abs())}';
  }

  /// e.g. `$1.2K` for tight spaces.
  static String compact(num value) => _compactCurrency.format(value);
}
