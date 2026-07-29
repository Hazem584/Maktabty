class DataParsingException implements Exception {
  final String operation;
  final String expected;
  final String? field;

  const DataParsingException({
    required this.operation,
    required this.expected,
    this.field,
  });

  @override
  String toString() {
    final fieldContext = field == null ? '' : ', field: $field';
    return 'DataParsingException(operation: $operation, '
        'expected: $expected$fieldContext)';
  }
}

Map<String, dynamic> requireStringMap(
  dynamic value, {
  required String operation,
  String? field,
}) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) {
    try {
      return Map<String, dynamic>.from(value);
    } catch (_) {
      // Fall through to a safe contract error.
    }
  }
  throw DataParsingException(
    operation: operation,
    expected: 'JSON object',
    field: field,
  );
}

String requireString(
  Map<String, dynamic> json,
  List<String> keys, {
  required String operation,
  bool allowEmpty = false,
}) {
  for (final key in keys) {
    final value = json[key];
    if (value is String && (allowEmpty || value.trim().isNotEmpty)) {
      return value;
    }
  }
  throw DataParsingException(
    operation: operation,
    expected: allowEmpty ? 'string' : 'non-empty string',
    field: keys.join(' or '),
  );
}

double requireDouble(
  Map<String, dynamic> json,
  List<String> keys, {
  required String operation,
}) {
  for (final key in keys) {
    final value = json[key];
    if (value is num) return value.toDouble();
    if (value is String) {
      final parsed = double.tryParse(value);
      if (parsed != null && parsed.isFinite) return parsed;
    }
  }
  throw DataParsingException(
    operation: operation,
    expected: 'number or numeric string',
    field: keys.join(' or '),
  );
}

int requireInt(
  Map<String, dynamic> json,
  List<String> keys, {
  required String operation,
}) {
  for (final key in keys) {
    final value = json[key];
    if (value is int) return value;
    if (value is num && value.isFinite && value == value.truncate()) {
      return value.toInt();
    }
    if (value is String) {
      final parsed = int.tryParse(value);
      if (parsed != null) return parsed;
    }
  }
  throw DataParsingException(
    operation: operation,
    expected: 'integer or integer string',
    field: keys.join(' or '),
  );
}

DateTime requireDateTime(
  Map<String, dynamic> json,
  List<String> keys, {
  required String operation,
}) {
  for (final key in keys) {
    final value = json[key];
    if (value is String) {
      final parsed = DateTime.tryParse(value);
      if (parsed != null) return parsed;
    }
  }
  throw DataParsingException(
    operation: operation,
    expected: 'ISO-8601 date string',
    field: keys.join(' or '),
  );
}

DateTime? optionalDateTime(
  Map<String, dynamic> json,
  String key, {
  required String operation,
}) {
  final value = json[key];
  if (value == null) return null;
  if (value is String) {
    final parsed = DateTime.tryParse(value);
    if (parsed != null) return parsed;
  }
  throw DataParsingException(
    operation: operation,
    expected: 'ISO-8601 date string',
    field: key,
  );
}

List<dynamic> requireList(
  Map<String, dynamic> json,
  String key, {
  required String operation,
}) {
  final value = json[key];
  if (value is List) return value;
  throw DataParsingException(
    operation: operation,
    expected: 'JSON array',
    field: key,
  );
}
