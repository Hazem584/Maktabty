import 'package:maktabty/core/network/data_parsing_exception.dart';

Map<String, dynamic> unwrapObject(
  Object? value, {
  required String operation,
  List<String> keys = const ['data'],
}) {
  final root = requireStringMap(value, operation: operation);
  for (final key in keys) {
    final candidate = root[key];
    if (candidate is Map) {
      return requireStringMap(candidate, operation: operation, field: key);
    }
  }
  return root;
}

Map<String, dynamic> paginationObject(
  Object? value, {
  required String operation,
}) {
  if (value is List) return <String, dynamic>{'data': value};
  return requireStringMap(value, operation: operation);
}

List<Object?> unwrapList(Object? value, {required String operation}) {
  if (value is List) return value.cast<Object?>();
  final root = requireStringMap(value, operation: operation);
  final candidate = root['data'] ?? root['items'] ?? root['results'];
  if (candidate is List) return candidate.cast<Object?>();
  throw DataParsingException(
    operation: operation,
    expected: 'JSON array or paginated JSON object',
    field: 'data',
  );
}

String? optionalString(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value == null) return null;
  final text = value.toString().trim();
  return text.isEmpty ? null : text;
}

double? optionalDoubleValue(
  Map<String, dynamic> json,
  String key, {
  required String operation,
}) {
  final value = json[key];
  if (value == null) return null;
  if (value is num && value.isFinite) return value.toDouble();
  if (value is String) {
    final parsed = double.tryParse(value.trim());
    if (parsed != null && parsed.isFinite) return parsed;
  }
  throw DataParsingException(
    operation: operation,
    expected: 'number, numeric string, or null',
    field: key,
  );
}

int? optionalIntValue(
  Map<String, dynamic> json,
  String key, {
  required String operation,
}) {
  final value = json[key];
  if (value == null) return null;
  if (value is int) return value;
  if (value is num && value.isFinite && value == value.truncate()) {
    return value.toInt();
  }
  return int.tryParse(value.toString());
}

bool optionalBoolValue(Map<String, dynamic> json, String key, bool fallback) {
  final value = json[key];
  if (value is bool) return value;
  if (value is num) return value != 0;
  if (value is String) {
    if (value.toLowerCase() == 'true') return true;
    if (value.toLowerCase() == 'false') return false;
  }
  return fallback;
}

DateTime? tolerantDateTime(Map<String, dynamic> json, String key) {
  final value = json[key];
  return value is String ? DateTime.tryParse(value) : null;
}

({int page, int limit, int total}) paginationMeta(
  Map<String, dynamic> json, {
  required int itemCount,
}) {
  final raw = json['meta'] ?? json['pagination'];
  final meta = raw is Map ? Map<String, dynamic>.from(raw) : json;
  int parse(Object? value, int fallback) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }

  return (
    page: parse(meta['page'], 1),
    limit: parse(meta['limit'] ?? meta['pageSize'], 20),
    total: parse(meta['total'] ?? meta['totalCount'], itemCount),
  );
}
