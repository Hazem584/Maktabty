import 'dart:convert';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:maktabty/core/database/app_database.dart';
import 'package:maktabty/core/database/database_exception.dart';
import 'package:maktabty/core/database/money_minor.dart';
import 'package:maktabty/features/sales/data/models/receipt_model.dart';
import 'package:maktabty/features/sales/data/models/sync_sale_models.dart';
import 'package:maktabty/features/sales/domain/entities/local_sale_entity.dart';
import 'package:maktabty/features/sales/domain/entities/payment_method.dart';
import 'package:maktabty/features/sales/domain/entities/sale_item_input.dart';

class SalesLocalDataSource {
  static const int maxBatchSize = 50;
  static const Duration staleSyncTimeout = Duration(minutes: 10);

  final AppDatabase _database;

  SalesLocalDataSource(this._database);

  Future<LocalSaleEntity> createPendingSale({
    required String clientSaleId,
    required String ownerUserId,
    required DateTime occurredAt,
    required List<SaleItemInput> items,
    required PaymentMethod paymentMethod,
    double? paidAmount,
    double? cashAmount,
    double? cardAmount,
    double discountAmount = 0,
  }) async {
    try {
      return await _database.transaction(() async {
        final now = DateTime.now().toUtc();
        await _database
            .into(_database.offlineSales)
            .insert(
              OfflineSalesCompanion.insert(
                clientSaleId: clientSaleId,
                ownerUserId: ownerUserId,
                occurredAt: occurredAt.toUtc(),
                paymentMethod: paymentMethod.apiValue,
                paidAmountMinor: Value(MoneyMinor.fromDouble(paidAmount)),
                cashAmountMinor: Value(MoneyMinor.fromDouble(cashAmount)),
                cardAmountMinor: Value(MoneyMinor.fromDouble(cardAmount)),
                discountAmountMinor: Value(
                  MoneyMinor.fromDouble(discountAmount) ?? 0,
                ),
                syncStatus: LocalSaleSyncStatus.pending.databaseValue,
                createdLocallyAt: now,
                updatedLocallyAt: now,
              ),
            );

        for (final item in items) {
          final cached = await _cachedProduct(item.productId);
          final available = cached == null
              ? 0
              : max(0, cached.serverStock - cached.reservedStock);
          if (item.quantity <= 0 ||
              cached == null ||
              available < item.quantity) {
            throw LocalStockException(
              productId: item.productId,
              requested: item.quantity,
              available: available,
            );
          }

          final sellingPriceMinor =
              MoneyMinor.fromDouble(item.sellingPrice) ??
              cached.sellingPriceMinor;
          await _database
              .into(_database.offlineSaleItems)
              .insert(
                OfflineSaleItemsCompanion.insert(
                  clientSaleId: clientSaleId,
                  productId: item.productId,
                  productName: item.productName ?? cached.name,
                  productCode: Value(item.productCode ?? cached.code),
                  quantity: item.quantity,
                  unitPriceOverrideMinor: Value(
                    MoneyMinor.fromDouble(item.unitPriceOverride),
                  ),
                  sellingPriceMinor: sellingPriceMinor,
                ),
              );
          await _setCachedStock(
            cached,
            reservedStock: cached.reservedStock + item.quantity,
          );
        }

        return _getSaleByClientId(clientSaleId);
      });
    } on LocalStockException {
      rethrow;
    } catch (error) {
      throw LocalDatabaseException(
        operation: 'save pending sale',
        cause: error,
      );
    }
  }

  Stream<List<LocalSaleEntity>> watchSalesForOwner(String ownerUserId) {
    final query = _database.select(_database.offlineSales)
      ..where((table) => table.ownerUserId.equals(ownerUserId))
      ..orderBy([(table) => OrderingTerm.desc(table.occurredAt)]);
    return query.watch().asyncMap((rows) async {
      final sales = <LocalSaleEntity>[];
      for (final row in rows) {
        sales.add(await _hydrate(row));
      }
      return sales;
    });
  }

  Future<int> pendingCountForOwner(String ownerUserId) async {
    final count = _database.offlineSales.id.count();
    final query = _database.selectOnly(_database.offlineSales)
      ..addColumns([count])
      ..where(
        _database.offlineSales.ownerUserId.equals(ownerUserId) &
            _database.offlineSales.syncStatus.isIn([
              LocalSaleSyncStatus.pending.databaseValue,
              LocalSaleSyncStatus.syncing.databaseValue,
              LocalSaleSyncStatus.failed.databaseValue,
            ]),
      );
    final row = await query.getSingle();
    return row.read(count) ?? 0;
  }

  Future<int> unsyncedCountForOtherOwners(String ownerUserId) async {
    final count = _database.offlineSales.id.count();
    final query = _database.selectOnly(_database.offlineSales)
      ..addColumns([count])
      ..where(
        _database.offlineSales.ownerUserId.equals(ownerUserId).not() &
            _database.offlineSales.syncStatus.isNotIn([
              LocalSaleSyncStatus.synced.databaseValue,
            ]),
      );
    final row = await query.getSingle();
    return row.read(count) ?? 0;
  }

  Future<void> recoverStaleSyncing({required String ownerUserId}) async {
    final cutoff = DateTime.now().toUtc().subtract(staleSyncTimeout);
    await (_database.update(_database.offlineSales)..where(
          (table) =>
              table.ownerUserId.equals(ownerUserId) &
              table.syncStatus.equals(
                LocalSaleSyncStatus.syncing.databaseValue,
              ) &
              (table.lastSyncAttemptAt.isNull() |
                  table.lastSyncAttemptAt.isSmallerThanValue(cutoff)),
        ))
        .write(
          OfflineSalesCompanion(
            syncStatus: Value(LocalSaleSyncStatus.pending.databaseValue),
            nextRetryAt: const Value(null),
            updatedLocallyAt: Value(DateTime.now().toUtc()),
          ),
        );
  }

  Future<List<LocalSaleEntity>> claimPendingBatch({
    required String ownerUserId,
    int limit = maxBatchSize,
  }) async {
    final safeLimit = min(limit, maxBatchSize);
    return _database.transaction(() async {
      final now = DateTime.now().toUtc();
      final query = _database.select(_database.offlineSales)
        ..where(
          (table) =>
              table.ownerUserId.equals(ownerUserId) &
              table.syncStatus.equals(
                LocalSaleSyncStatus.pending.databaseValue,
              ) &
              (table.nextRetryAt.isNull() |
                  table.nextRetryAt.isSmallerOrEqualValue(now)),
        )
        ..orderBy([(table) => OrderingTerm.asc(table.createdLocallyAt)])
        ..limit(safeLimit);
      final rows = await query.get();
      if (rows.isEmpty) return const <LocalSaleEntity>[];

      final claimed = <LocalSaleEntity>[];
      for (final row in rows) {
        await (_database.update(
          _database.offlineSales,
        )..where((table) => table.id.equals(row.id))).write(
          OfflineSalesCompanion(
            syncStatus: Value(LocalSaleSyncStatus.syncing.databaseValue),
            syncAttempts: Value(row.syncAttempts + 1),
            lastSyncAttemptAt: Value(now),
            nextRetryAt: const Value(null),
            lastErrorCode: const Value(null),
            lastErrorMessage: const Value(null),
            updatedLocallyAt: Value(now),
          ),
        );
        claimed.add(
          await _hydrate(
            row.copyWith(
              syncStatus: LocalSaleSyncStatus.syncing.databaseValue,
              syncAttempts: row.syncAttempts + 1,
              lastSyncAttemptAt: Value(now),
              nextRetryAt: const Value(null),
              lastErrorCode: const Value(null),
              lastErrorMessage: const Value(null),
              updatedLocallyAt: now,
            ),
          ),
        );
      }
      return claimed;
    });
  }

  Future<void> applySyncResult(SyncSaleResultModel result) async {
    await _database.transaction(() async {
      final sale = await _saleRow(result.clientSaleId);
      if (sale == null ||
          sale.syncStatus != LocalSaleSyncStatus.syncing.databaseValue) {
        return;
      }
      final items = await _itemRows(result.clientSaleId);
      final now = DateTime.now().toUtc();

      switch (result.status) {
        case SyncResultStatus.synced:
          await _releaseReservation(
            items,
            committedToServer: true,
            syncStartedAt: sale.lastSyncAttemptAt,
          );
          await _writeSaleResult(
            sale,
            status: LocalSaleSyncStatus.synced,
            result: result,
            reservationActive: false,
            now: now,
          );
          return;
        case SyncResultStatus.alreadySynced:
          await _releaseReservation(items, committedToServer: false);
          await _writeSaleResult(
            sale,
            status: LocalSaleSyncStatus.synced,
            result: result,
            reservationActive: false,
            now: now,
          );
          return;
        case SyncResultStatus.stockConflict:
          await _releaseReservation(items, committedToServer: false);
          final conflict = result.stockConflict;
          if (conflict?.productId != null &&
              conflict?.availableQuantity != null) {
            final cached = await _cachedProduct(conflict!.productId!);
            if (cached != null) {
              await _setCachedStock(
                cached,
                serverStock: max(0, conflict.availableQuantity!),
              );
            }
          }
          await _writeSaleResult(
            sale,
            status: LocalSaleSyncStatus.stockConflict,
            result: result,
            reservationActive: false,
            now: now,
          );
          return;
        case SyncResultStatus.idempotencyConflict:
          await _releaseReservation(items, committedToServer: false);
          await _writeSaleResult(
            sale,
            status: LocalSaleSyncStatus.idempotencyConflict,
            result: result,
            reservationActive: false,
            now: now,
          );
          return;
        case SyncResultStatus.failed:
          if (result.retryable) {
            await _markRetryable(
              sale,
              errorCode: result.errorCode ?? 'SYNC_FAILED',
              message: result.message,
            );
          } else {
            await _releaseReservation(items, committedToServer: false);
            await _writeSaleResult(
              sale,
              status: LocalSaleSyncStatus.failed,
              result: result,
              reservationActive: false,
              now: now,
            );
          }
          return;
        case SyncResultStatus.unknown:
          await _releaseReservation(items, committedToServer: false);
          await _writeSaleResult(
            sale,
            status: LocalSaleSyncStatus.failed,
            result: result,
            reservationActive: false,
            now: now,
            errorCode: 'UNKNOWN_SYNC_STATUS',
          );
          return;
      }
    });
  }

  Future<void> markBatchRetryable(
    Iterable<String> clientSaleIds, {
    required String errorCode,
    String? message,
  }) async {
    await _database.transaction(() async {
      for (final clientSaleId in clientSaleIds) {
        final sale = await _saleRow(clientSaleId);
        if (sale == null ||
            sale.syncStatus != LocalSaleSyncStatus.syncing.databaseValue) {
          continue;
        }
        await _markRetryable(sale, errorCode: errorCode, message: message);
      }
    });
  }

  Future<void> markBatchPermanent(
    Iterable<String> clientSaleIds, {
    required String errorCode,
    String? message,
  }) async {
    for (final clientSaleId in clientSaleIds) {
      await applySyncResult(
        SyncSaleResultModel(
          clientSaleId: clientSaleId,
          status: SyncResultStatus.failed,
          rawStatus: 'FAILED',
          serverSaleId: null,
          receiptNoInt: null,
          message: message,
          errorCode: errorCode,
          retryable: false,
          stockConflict: null,
          sale: null,
          receipt: null,
        ),
      );
    }
  }

  Future<bool> retrySale({
    required String clientSaleId,
    required String ownerUserId,
  }) async {
    return _database.transaction(() async {
      final sale = await _saleRow(clientSaleId);
      if (sale == null ||
          sale.ownerUserId != ownerUserId ||
          !LocalSaleSyncStatus.fromDatabase(sale.syncStatus).canRetry) {
        return false;
      }
      if (!sale.reservationActive) {
        final items = await _itemRows(clientSaleId);
        for (final item in items) {
          final cached = await _cachedProduct(item.productId);
          final available = cached == null
              ? 0
              : max(0, cached.serverStock - cached.reservedStock);
          if (cached == null || available < item.quantity) {
            throw LocalStockException(
              productId: item.productId,
              requested: item.quantity,
              available: available,
            );
          }
        }
        for (final item in items) {
          final cached = await _cachedProduct(item.productId);
          await _setCachedStock(
            cached!,
            reservedStock: cached.reservedStock + item.quantity,
          );
        }
      }
      await (_database.update(
        _database.offlineSales,
      )..where((table) => table.id.equals(sale.id))).write(
        OfflineSalesCompanion(
          syncStatus: Value(LocalSaleSyncStatus.pending.databaseValue),
          reservationActive: const Value(true),
          nextRetryAt: const Value(null),
          lastErrorCode: const Value(null),
          lastErrorMessage: const Value(null),
          updatedLocallyAt: Value(DateTime.now().toUtc()),
        ),
      );
      return true;
    });
  }

  SyncSaleRequestModel toSyncRequest(LocalSaleEntity sale) {
    return SyncSaleRequestModel(
      clientSaleId: sale.clientSaleId,
      occurredAt: sale.occurredAt,
      items: sale.items
          .map(
            (item) => SyncSaleItemRequestModel(
              productId: item.productId,
              quantity: item.quantity,
              unitPriceOverride: item.unitPriceOverride,
            ),
          )
          .toList(growable: false),
      paymentMethod: sale.paymentMethod.apiValue,
      paidAmount: sale.paidAmount,
      cashAmount: sale.cashAmount,
      cardAmount: sale.cardAmount,
      discountAmount: sale.discountAmount,
    );
  }

  Future<LocalSaleEntity> _getSaleByClientId(String clientSaleId) async {
    final row = await _saleRow(clientSaleId);
    if (row == null) {
      throw const LocalDatabaseException(operation: 'read saved sale');
    }
    return _hydrate(row);
  }

  Future<OfflineSale?> _saleRow(String clientSaleId) {
    final query = _database.select(_database.offlineSales)
      ..where((table) => table.clientSaleId.equals(clientSaleId));
    return query.getSingleOrNull();
  }

  Future<List<OfflineSaleItem>> _itemRows(String clientSaleId) {
    final query = _database.select(_database.offlineSaleItems)
      ..where((table) => table.clientSaleId.equals(clientSaleId))
      ..orderBy([(table) => OrderingTerm.asc(table.id)]);
    return query.get();
  }

  Future<CachedProduct?> _cachedProduct(String productId) {
    final query = _database.select(_database.cachedProducts)
      ..where((table) => table.productId.equals(productId));
    return query.getSingleOrNull();
  }

  Future<void> _setCachedStock(
    CachedProduct product, {
    int? serverStock,
    int? reservedStock,
  }) {
    return (_database.update(
      _database.cachedProducts,
    )..where((table) => table.productId.equals(product.productId))).write(
      CachedProductsCompanion(
        serverStock: Value(serverStock ?? product.serverStock),
        reservedStock: Value(reservedStock ?? product.reservedStock),
      ),
    );
  }

  Future<void> _releaseReservation(
    List<OfflineSaleItem> items, {
    required bool committedToServer,
    DateTime? syncStartedAt,
  }) async {
    for (final item in items) {
      final cached = await _cachedProduct(item.productId);
      if (cached == null) continue;
      final cacheMayAlreadyContainServerChange =
          syncStartedAt != null && !cached.lastCachedAt.isBefore(syncStartedAt);
      await _setCachedStock(
        cached,
        serverStock: committedToServer && !cacheMayAlreadyContainServerChange
            ? max(0, cached.serverStock - item.quantity)
            : cached.serverStock,
        reservedStock: max(0, cached.reservedStock - item.quantity),
      );
    }
  }

  Future<void> _markRetryable(
    OfflineSale sale, {
    required String errorCode,
    String? message,
  }) async {
    final now = DateTime.now().toUtc();
    final exponent = min(max(sale.syncAttempts - 1, 0), 6);
    final delaySeconds = min(15 * pow(2, exponent).toInt(), 15 * 60);
    await (_database.update(
      _database.offlineSales,
    )..where((table) => table.id.equals(sale.id))).write(
      OfflineSalesCompanion(
        syncStatus: Value(LocalSaleSyncStatus.pending.databaseValue),
        nextRetryAt: Value(now.add(Duration(seconds: delaySeconds))),
        lastErrorCode: Value(errorCode),
        lastErrorMessage: Value(message),
        updatedLocallyAt: Value(now),
      ),
    );
  }

  Future<void> _writeSaleResult(
    OfflineSale sale, {
    required LocalSaleSyncStatus status,
    required SyncSaleResultModel result,
    required bool reservationActive,
    required DateTime now,
    String? errorCode,
  }) {
    return (_database.update(
      _database.offlineSales,
    )..where((table) => table.id.equals(sale.id))).write(
      OfflineSalesCompanion(
        syncStatus: Value(status.databaseValue),
        reservationActive: Value(reservationActive),
        serverSaleId: Value(result.serverSaleId),
        receiptNoInt: Value(result.receiptNoInt),
        nextRetryAt: const Value(null),
        lastErrorCode: Value(errorCode ?? result.errorCode),
        lastErrorMessage: Value(result.message),
        conflictProductId: Value(result.stockConflict?.productId),
        conflictRequestedQuantity: Value(
          result.stockConflict?.requestedQuantity,
        ),
        conflictAvailableQuantity: Value(
          result.stockConflict?.availableQuantity,
        ),
        saleJson: Value(result.sale == null ? null : jsonEncode(result.sale)),
        receiptJson: Value(
          result.receipt == null ? null : jsonEncode(result.receipt),
        ),
        updatedLocallyAt: Value(now),
      ),
    );
  }

  Future<LocalSaleEntity> _hydrate(OfflineSale sale) async {
    final itemRows = await _itemRows(sale.clientSaleId);
    ReceiptModel? receipt;
    if (sale.receiptJson != null) {
      try {
        final value = jsonDecode(sale.receiptJson!);
        if (value is Map) {
          receipt = ReceiptModel.fromJson(Map<String, dynamic>.from(value));
        }
      } catch (_) {
        receipt = null;
      }
    }
    return LocalSaleEntity(
      localId: sale.id,
      clientSaleId: sale.clientSaleId,
      ownerUserId: sale.ownerUserId,
      occurredAt: sale.occurredAt.toUtc(),
      paymentMethod: PaymentMethodX.fromApi(sale.paymentMethod),
      paidAmount: MoneyMinor.toDouble(sale.paidAmountMinor),
      cashAmount: MoneyMinor.toDouble(sale.cashAmountMinor),
      cardAmount: MoneyMinor.toDouble(sale.cardAmountMinor),
      discountAmount: MoneyMinor.toDouble(sale.discountAmountMinor) ?? 0,
      syncStatus: LocalSaleSyncStatus.fromDatabase(sale.syncStatus),
      serverSaleId: sale.serverSaleId,
      receiptNoInt: sale.receiptNoInt,
      syncAttempts: sale.syncAttempts,
      lastSyncAttemptAt: sale.lastSyncAttemptAt?.toUtc(),
      lastErrorCode: sale.lastErrorCode,
      lastErrorMessage: sale.lastErrorMessage,
      conflictProductId: sale.conflictProductId,
      conflictRequestedQuantity: sale.conflictRequestedQuantity,
      conflictAvailableQuantity: sale.conflictAvailableQuantity,
      createdLocallyAt: sale.createdLocallyAt.toUtc(),
      updatedLocallyAt: sale.updatedLocallyAt.toUtc(),
      items: itemRows
          .map(
            (item) => LocalSaleItemEntity(
              productId: item.productId,
              productName: item.productName,
              productCode: item.productCode,
              quantity: item.quantity,
              sellingPrice: MoneyMinor.toDouble(item.sellingPriceMinor) ?? 0,
              unitPriceOverride: MoneyMinor.toDouble(
                item.unitPriceOverrideMinor,
              ),
            ),
          )
          .toList(growable: false),
      confirmedReceipt: receipt?.toEntity(),
    );
  }
}
