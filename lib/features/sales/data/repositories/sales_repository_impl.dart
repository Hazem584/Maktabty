import 'dart:async';

import 'package:maktabty/core/network/app_failure_mapper.dart';
import 'package:maktabty/core/errors/app_failure.dart';
import 'package:maktabty/core/session/current_user_store.dart';
import 'package:uuid/uuid.dart';
import 'package:maktabty/features/sales/data/datasources/sales_local_datasource.dart';
import 'package:maktabty/features/sales/data/services/sales_sync_coordinator.dart';
import 'package:maktabty/features/sales/data/datasources/sales_remote_datasource.dart';
import 'package:maktabty/features/sales/domain/entities/payment_method.dart';
import 'package:maktabty/features/sales/domain/entities/receipt_entity.dart';
import 'package:maktabty/features/sales/domain/entities/sale_entity.dart';
import 'package:maktabty/features/sales/domain/entities/sale_item_input.dart';
import 'package:maktabty/features/sales/domain/entities/sale_response_entity.dart';
import 'package:maktabty/features/sales/domain/entities/today_sales_response_entity.dart';
import 'package:maktabty/features/sales/domain/entities/local_sale_entity.dart';
import 'package:maktabty/features/sales/domain/entities/product_mini_entity.dart';
import 'package:maktabty/features/sales/domain/entities/receipt_item_entity.dart';
import 'package:maktabty/features/sales/domain/entities/receipt_store_entity.dart';
import 'package:maktabty/features/sales/domain/entities/receipt_totals_entity.dart';
import 'package:maktabty/features/sales/domain/entities/sale_item_entity.dart';
import 'package:maktabty/features/sales/domain/repositories/sales_repository.dart';

class SalesRepositoryImpl implements SalesRepository {
  final SalesRemoteDataSource _remoteDataSource;
  final SalesLocalDataSource _localDataSource;
  final SalesSyncCoordinator _syncCoordinator;
  final CurrentUserStore _currentUserStore;
  final Uuid _uuid;

  SalesRepositoryImpl({
    required this._remoteDataSource,
    required SalesLocalDataSource localDataSource,
    required this._syncCoordinator,
    required this._currentUserStore,
    this._uuid = const Uuid(),
  }) : _localDataSource = localDataSource;

  @override
  Future<SaleResponseEntity> createSale({
    required List<SaleItemInput> items,
    required PaymentMethod paymentMethod,
    double? paidAmount,
    double? cashAmount,
    double? cardAmount,
  }) async {
    try {
      final ownerUserId = _currentUserStore.userId;
      if (ownerUserId == null || ownerUserId.isEmpty) {
        throw const UnauthorizedFailure();
      }
      final clientSaleId = _uuid.v4();
      final occurredAt = DateTime.now().toUtc();
      final localSale = await _localDataSource.createPendingSale(
        clientSaleId: clientSaleId,
        ownerUserId: ownerUserId,
        occurredAt: occurredAt,
        items: items,
        paymentMethod: paymentMethod,
        paidAmount: paidAmount,
        cashAmount: cashAmount,
        cardAmount: cardAmount,
      );
      unawaited(_syncCoordinator.sync(ownerUserId));
      return _toPendingResponse(localSale);
    } catch (error) {
      throw AppFailureMapper.fromException(error);
    }
  }

  @override
  Future<TodaySalesResponseEntity> getTodaySales({String? date}) async {
    try {
      final response = await _remoteDataSource.getTodaySales(date: date);
      return response.toEntity();
    } catch (error) {
      throw AppFailureMapper.fromException(error);
    }
  }

  @override
  Future<SaleEntity> deleteSale({required String id}) async {
    try {
      final response = await _remoteDataSource.deleteSale(id);
      return response.toEntity();
    } catch (error) {
      throw AppFailureMapper.fromException(error);
    }
  }

  @override
  Future<ReceiptEntity> getReceiptForSale(String saleId) async {
    try {
      final response = await _remoteDataSource.getReceiptForSale(saleId);
      return response.toEntity();
    } catch (error) {
      throw AppFailureMapper.fromException(error);
    }
  }

  SaleResponseEntity _toPendingResponse(LocalSaleEntity localSale) {
    final saleItems = localSale.items
        .map(
          (item) => SaleItemEntity(
            product: ProductMiniEntity(
              id: item.productId,
              name: item.productName,
              code: item.productCode,
            ),
            quantity: item.quantity,
            unitPrice: item.effectiveUnitPrice,
            lineTotal: item.lineTotal,
          ),
        )
        .toList(growable: false);
    final receiptItems = localSale.items
        .map(
          (item) => ReceiptItemEntity(
            productId: item.productId,
            name: item.productName,
            code: item.productCode,
            qty: item.quantity,
            unitPrice: item.effectiveUnitPrice,
            lineTotal: item.lineTotal,
          ),
        )
        .toList(growable: false);
    final sale = SaleEntity(
      id: localSale.clientSaleId,
      items: saleItems,
      totalAmount: localSale.totalAmount,
      createdAt: localSale.occurredAt,
    );
    final receipt = ReceiptEntity(
      receiptId: localSale.clientSaleId,
      receiptNo: '',
      createdAt: localSale.occurredAt,
      store: const ReceiptStoreEntity(name: ''),
      cashier: null,
      items: receiptItems,
      totalQty: localSale.items.fold<int>(
        0,
        (sum, item) => sum + item.quantity,
      ),
      distinctItems: localSale.items.length,
      totals: ReceiptTotalsEntity(
        subtotal: localSale.totalAmount + localSale.discountAmount,
        discount: localSale.discountAmount,
        total: localSale.totalAmount,
      ),
      payment: null,
      footerLines: const [],
    );
    return SaleResponseEntity(
      sale: sale,
      receipt: receipt,
      clientSaleId: localSale.clientSaleId,
      localSyncStatus: LocalSaleSyncStatus.pending,
    );
  }
}
