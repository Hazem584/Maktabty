import 'dart:convert';

class TextSanitizer {
  const TextSanitizer._();

  static String fixMojibake(String input) {
    if (input.isEmpty || !_looksLikeMojibake(input)) {
      return input;
    }
    try {
      return utf8.decode(latin1.encode(input));
    } catch (_) {
      return input;
    }
  }

  static bool _looksLikeMojibake(String input) {
    return input.contains('\u00D8') ||
        input.contains('\u00D9') ||
        input.contains('\u00DA') ||
        input.contains('\u00DB') ||
        input.contains('\u00C3') ||
        input.contains('\u00C2');
  }
}
