class MoneyMinor {
  const MoneyMinor._();

  static int? fromDouble(double? value) {
    if (value == null) return null;
    if (!value.isFinite) {
      throw const FormatException('Money value must be finite.');
    }
    return (value * 100).round();
  }

  static double? toDouble(int? value) {
    if (value == null) return null;
    return value / 100;
  }
}
