import 'package:maktabty/features/sales/domain/entities/receipt_entity.dart';
import 'package:maktabty/features/sales/domain/entities/sale_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:maktabty/features/sales/domain/entities/local_sale_entity.dart';

class SaleResponseEntity extends Equatable {
  final SaleEntity sale;
  final ReceiptEntity receipt;
  final String? clientSaleId;
  final LocalSaleSyncStatus localSyncStatus;

  const SaleResponseEntity({
    required this.sale,
    required this.receipt,
    this.clientSaleId,
    this.localSyncStatus = LocalSaleSyncStatus.synced,
  });

  bool get isServerConfirmed =>
      localSyncStatus == LocalSaleSyncStatus.synced &&
      receipt.receiptNo.isNotEmpty;

  @override
  List<Object?> get props => [sale, receipt, clientSaleId, localSyncStatus];
}
