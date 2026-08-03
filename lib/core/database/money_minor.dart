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

  static int? fromText(String? value) {
    final text = value?.trim();
    if (text == null || text.isEmpty) return null;
    final match = RegExp(r'^([+-]?)(\d+)(?:[.,](\d{0,2}))?$').firstMatch(text);
    if (match == null) return null;
    final whole = int.tryParse(match.group(2)!);
    if (whole == null) return null;
    final fraction = (match.group(3) ?? '').padRight(2, '0');
    final cents = fraction.isEmpty ? 0 : int.tryParse(fraction);
    if (cents == null) return null;
    final minor = whole * 100 + cents;
    return match.group(1) == '-' ? -minor : minor;
  }

  static String format(int value) {
    final sign = value < 0 ? '-' : '';
    final absolute = value.abs();
    return '$sign${absolute ~/ 100}.${(absolute % 100).toString().padLeft(2, '0')}';
  }
}
