import 'package:maktabty/features/sales/data/models/receipt_cashier_model.dart';
import 'package:maktabty/features/sales/data/models/receipt_item_model.dart';
import 'package:maktabty/features/sales/data/models/receipt_payment_model.dart';
import 'package:maktabty/features/sales/data/models/receipt_store_model.dart';
import 'package:maktabty/features/sales/data/models/receipt_totals_model.dart';
import 'package:maktabty/features/sales/domain/entities/receipt_entity.dart';
import 'package:maktabty/core/network/data_parsing_exception.dart';

class ReceiptModel {
  final String receiptId;
  final String receiptNo;
  final DateTime? createdAt;
  final String? displayDate;
  final String? displayTime;
  final String? currency;
  final ReceiptStoreModel store;
  final ReceiptCashierModel? cashier;
  final List<ReceiptItemModel> items;
  final int? totalQty;
  final int? distinctItems;
  final ReceiptTotalsModel totals;
  final ReceiptPaymentModel? payment;
  final List<String> footerLines;

  const ReceiptModel({
    this.receiptId = '',
    required this.receiptNo,
    required this.createdAt,
    this.displayDate,
    this.displayTime,
    this.currency,
    required this.store,
    required this.cashier,
    required this.items,
    this.totalQty,
    this.distinctItems,
    required this.totals,
    required this.payment,
    required this.footerLines,
  });

  factory ReceiptModel.fromJson(Map<String, dynamic> json) {
    const operation = 'parse receipt';
    final store = ReceiptStoreModel.fromJson(
      requireStringMap(json['store'], operation: operation, field: 'store'),
    );

    final cashierData = json['cashier'];
    ReceiptCashierModel? cashier;
    if (cashierData is Map<String, dynamic>) {
      cashier = ReceiptCashierModel.fromJson(cashierData);
    } else if (cashierData is Map) {
      cashier = ReceiptCashierModel.fromJson(
        Map<String, dynamic>.from(cashierData),
      );
    }

    final items = requireList(json, 'items', operation: operation)
        .map(
          (item) => ReceiptItemModel.fromJson(
            requireStringMap(item, operation: operation, field: 'items[]'),
          ),
        )
        .toList(growable: false);

    final totals = ReceiptTotalsModel.fromJson(
      requireStringMap(json['totals'], operation: operation, field: 'totals'),
    );

    final paymentData = json['payment'];
    ReceiptPaymentModel? payment;
    if (paymentData is Map<String, dynamic>) {
      payment = ReceiptPaymentModel.fromJson(paymentData);
    } else if (paymentData is Map) {
      payment = ReceiptPaymentModel.fromJson(
        Map<String, dynamic>.from(paymentData),
      );
    }

    final rawFooter = json['footerLines'] ?? json['footer'];
    List<String> footerLines = const [];
    if (rawFooter is List) {
      footerLines = rawFooter.map((line) => line.toString()).toList();
    }

    final itemsSummary = json['itemsSummary'];
    int? totalQty;
    int? distinctItems;
    if (itemsSummary is Map<String, dynamic>) {
      totalQty = _toInt(itemsSummary['totalQty']);
      distinctItems = _toInt(itemsSummary['distinctItems']);
    } else if (itemsSummary is Map) {
      final summary = Map<String, dynamic>.from(itemsSummary);
      totalQty = _toInt(summary['totalQty']);
      distinctItems = _toInt(summary['distinctItems']);
    }

    return ReceiptModel(
      receiptId: (json['receiptId'] ?? json['receipt_id'] ?? '').toString(),
      receiptNo: requireString(json, const [
        'receiptNo',
        'receipt_no',
      ], operation: operation),
      createdAt: requireDateTime(json, const [
        'createdAt',
      ], operation: operation),
      displayDate: json['displayDate']?.toString(),
      displayTime: json['displayTime']?.toString(),
      currency: json['currency']?.toString(),
      store: store,
      cashier: cashier,
      items: items,
      totalQty: totalQty,
      distinctItems: distinctItems,
      totals: totals,
      payment: payment,
      footerLines: footerLines,
    );
  }

  ReceiptEntity toEntity() {
    return ReceiptEntity(
      receiptId: receiptId,
      receiptNo: receiptNo,
      createdAt: createdAt,
      displayDate: displayDate,
      displayTime: displayTime,
      currency: currency,
      store: store.toEntity(),
      cashier: cashier?.toEntity(),
      items: items.map((item) => item.toEntity()).toList(),
      totalQty: totalQty,
      distinctItems: distinctItems,
      totals: totals.toEntity(),
      payment: payment?.toEntity(),
      footerLines: footerLines,
    );
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }
}
