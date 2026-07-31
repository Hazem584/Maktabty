import 'package:maktabty/core/network/data_parsing_exception.dart';

enum SyncResultStatus {
  synced,
  alreadySynced,
  failed,
  stockConflict,
  idempotencyConflict,
  unknown;

  static SyncResultStatus fromApi(dynamic value) {
    return switch (value?.toString().toUpperCase()) {
      'SYNCED' => SyncResultStatus.synced,
      'ALREADY_SYNCED' => SyncResultStatus.alreadySynced,
      'FAILED' => SyncResultStatus.failed,
      'STOCK_CONFLICT' => SyncResultStatus.stockConflict,
      'IDEMPOTENCY_CONFLICT' => SyncResultStatus.idempotencyConflict,
      _ => SyncResultStatus.unknown,
    };
  }
}

class SyncSaleItemRequestModel {
  final String productId;
  final int quantity;
  final double? unitPriceOverride;

  const SyncSaleItemRequestModel({
    required this.productId,
    required this.quantity,
    required this.unitPriceOverride,
  });

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'quantity': quantity,
    if (unitPriceOverride != null) 'unitPriceOverride': unitPriceOverride,
  };
}

class SyncSaleRequestModel {
  final String clientSaleId;
  final DateTime occurredAt;
  final List<SyncSaleItemRequestModel> items;
  final String paymentMethod;
  final double? paidAmount;
  final double? cashAmount;
  final double? cardAmount;
  final double discountAmount;

  const SyncSaleRequestModel({
    required this.clientSaleId,
    required this.occurredAt,
    required this.items,
    required this.paymentMethod,
    required this.paidAmount,
    required this.cashAmount,
    required this.cardAmount,
    required this.discountAmount,
  });

  Map<String, dynamic> toJson() => {
    'clientSaleId': clientSaleId,
    'occurredAt': occurredAt.toUtc().toIso8601String(),
    'items': items.map((item) => item.toJson()).toList(growable: false),
    'paymentMethod': paymentMethod,
    if (paidAmount != null) 'paidAmount': paidAmount,
    if (cashAmount != null) 'cashAmount': cashAmount,
    if (cardAmount != null) 'cardAmount': cardAmount,
    'discountAmount': discountAmount,
  };
}

class StockConflictModel {
  final String? productId;
  final int? requestedQuantity;
  final int? availableQuantity;

  const StockConflictModel({
    required this.productId,
    required this.requestedQuantity,
    required this.availableQuantity,
  });

  factory StockConflictModel.fromJson(Map<String, dynamic> json) {
    return StockConflictModel(
      productId: json['productId']?.toString(),
      requestedQuantity: _optionalInt(json['requestedQuantity']),
      availableQuantity: _optionalInt(json['availableQuantity']),
    );
  }
}

class SyncSaleResultModel {
  final String clientSaleId;
  final SyncResultStatus status;
  final String rawStatus;
  final String? serverSaleId;
  final int? receiptNoInt;
  final String? message;
  final String? errorCode;
  final bool retryable;
  final StockConflictModel? stockConflict;
  final Map<String, dynamic>? sale;
  final Map<String, dynamic>? receipt;

  const SyncSaleResultModel({
    required this.clientSaleId,
    required this.status,
    required this.rawStatus,
    required this.serverSaleId,
    required this.receiptNoInt,
    required this.message,
    required this.errorCode,
    required this.retryable,
    required this.stockConflict,
    required this.sale,
    required this.receipt,
  });

  factory SyncSaleResultModel.fromJson(Map<String, dynamic> json) {
    const operation = 'parse POST /sales/sync result';
    final rawStatus = json['status']?.toString() ?? 'UNKNOWN';
    final stockConflict = _optionalMap(json['stockConflict']);
    return SyncSaleResultModel(
      clientSaleId: requireString(json, const [
        'clientSaleId',
      ], operation: operation),
      status: SyncResultStatus.fromApi(rawStatus),
      rawStatus: rawStatus,
      serverSaleId: json['serverSaleId']?.toString(),
      receiptNoInt: _optionalInt(json['receiptNoInt']),
      message: _safeMessage(json['message']),
      errorCode: json['errorCode']?.toString(),
      retryable: json['retryable'] == true,
      stockConflict: stockConflict == null
          ? null
          : StockConflictModel.fromJson(stockConflict),
      sale: _optionalMap(json['sale']),
      receipt: _optionalMap(json['receipt']),
    );
  }
}

class SyncSalesResponseModel {
  final List<SyncSaleResultModel> results;

  const SyncSalesResponseModel(this.results);

  factory SyncSalesResponseModel.fromJson(dynamic data) {
    dynamic rawResults = data;
    for (var depth = 0; depth < 3 && rawResults is Map; depth++) {
      final map = rawResults;
      if (map.containsKey('clientSaleId') && map.containsKey('status')) {
        rawResults = [map];
        break;
      }
      final next = map['results'] ?? map['sales'] ?? map['data'];
      if (identical(next, rawResults) || next == null) break;
      rawResults = next;
    }
    if (rawResults is! List) {
      throw const DataParsingException(
        operation: 'POST /sales/sync',
        expected: 'a list of synchronization results',
      );
    }
    return SyncSalesResponseModel(
      rawResults
          .map(
            (item) => SyncSaleResultModel.fromJson(
              requireStringMap(
                item,
                operation: 'POST /sales/sync',
                field: 'results[]',
              ),
            ),
          )
          .toList(growable: false),
    );
  }
}

int? _optionalInt(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString());
}

Map<String, dynamic>? _optionalMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) {
    try {
      return Map<String, dynamic>.from(value);
    } catch (_) {
      return null;
    }
  }
  return null;
}

String? _safeMessage(dynamic value) {
  if (value is! String || value.trim().isEmpty) return null;
  final clean = value.trim().replaceAll(RegExp(r'[\x00-\x08\x0B-\x1F]'), '');
  return clean.length <= 500 ? clean : '${clean.substring(0, 497)}...';
}
