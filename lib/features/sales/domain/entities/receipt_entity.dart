import 'package:maktabty/features/sales/domain/entities/receipt_cashier_entity.dart';
import 'package:maktabty/features/sales/domain/entities/receipt_item_entity.dart';
import 'package:maktabty/features/sales/domain/entities/receipt_payment_entity.dart';
import 'package:maktabty/features/sales/domain/entities/receipt_store_entity.dart';
import 'package:maktabty/features/sales/domain/entities/receipt_totals_entity.dart';

class ReceiptEntity {
  final String receiptId;
  final String receiptNo;
  final DateTime? createdAt;
  final String? displayDate;
  final String? displayTime;
  final String? currency;
  final ReceiptStoreEntity store;
  final ReceiptCashierEntity? cashier;
  final List<ReceiptItemEntity> items;
  final int? totalQty;
  final int? distinctItems;
  final ReceiptTotalsEntity totals;
  final ReceiptPaymentEntity? payment;
  final List<String> footerLines;

  const ReceiptEntity({
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
}
