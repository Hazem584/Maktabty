import 'package:drift/drift.dart';
import 'package:maktabty/core/database/app_database.dart';
import 'package:maktabty/core/database/database_exception.dart';
import 'package:maktabty/core/database/money_minor.dart';
import 'package:maktabty/features/products/domain/entities/paginated_products_entity.dart';
import 'package:maktabty/features/products/domain/entities/product_entity.dart';

class ProductsLocalDataSource {
  final AppDatabase _database;

  ProductsLocalDataSource(this._database);

  Future<void> cacheProducts(
    List<ProductEntity> products, {
    required String storeId,
    required bool reconcileActiveCatalog,
  }) async {
    if (storeId.trim().isEmpty) {
      throw const LocalDatabaseException(operation: 'cache products without store ownership');
    }
    final cachedAt = DateTime.now().toUtc();
    try {
      await _database.transaction(() async {
        if (reconcileActiveCatalog) {
          final incomingIds = products.map((product) => product.id).toSet();
          final existing = await _database
              .select(_database.tenantCachedProducts)
              .get();
          final scopedExisting = existing
              .where((row) => row.storeId == storeId)
              .toList(growable: false);
          for (final row in scopedExisting) {
            if (row.isActive && !incomingIds.contains(row.productId)) {
              await (_database.update(
                _database.tenantCachedProducts,
              )..where((table) => table.storeId.equals(storeId) & table.productId.equals(row.productId))).write(
                const TenantCachedProductsCompanion(isActive: Value(false)),
              );
            }
          }
        }

        for (final product in products) {
          final activeReservation = await _activeReservationForProduct(
            storeId,
            product.id,
          );
          final companion = TenantCachedProductsCompanion(
            storeId: Value(storeId),
            productId: Value(product.id),
            name: Value(product.name),
            code: Value(product.code),
            sellingPriceMinor: Value(MoneyMinor.fromDouble(product.price) ?? 0),
            serverStock: Value(product.stock),
            reservedStock: Value(activeReservation),
          isActive: Value(product.isActive),
          archivedAt: Value(product.archivedAt),
          archiveReason: Value(product.archiveReason),
            category: Value(product.category),
            serverUpdatedAt: Value(product.updatedAt?.toUtc()),
            lastCachedAt: Value(cachedAt),
          );
          await _database
              .into(_database.tenantCachedProducts)
              .insertOnConflictUpdate(companion);
        }
      });
    } catch (error) {
      throw LocalDatabaseException(operation: 'cache products', cause: error);
    }
  }

  Future<PaginatedProductsEntity> getProducts({
    required String storeId,
    String? search,
    bool? lowStock,
    ProductStatus status = ProductStatus.active,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final normalizedSearch = search?.trim().toLowerCase();
      final query = _database.select(_database.tenantCachedProducts)
        ..where((table) {
          Expression<bool> predicate = table.storeId.equals(storeId);
          if (status == ProductStatus.active) {
            predicate = predicate & table.isActive.equals(true);
          } else if (status == ProductStatus.archived) {
            predicate = predicate & table.isActive.equals(false);
          }
          if (normalizedSearch != null && normalizedSearch.isNotEmpty) {
            predicate =
                predicate &
                (table.name.lower().contains(normalizedSearch) |
                    table.code.lower().contains(normalizedSearch));
          }
          if (lowStock == true) {
            predicate =
                predicate &
                (table.serverStock - table.reservedStock).isSmallerOrEqualValue(
                  5,
                );
          }
          return predicate;
        })
        ..orderBy([(table) => OrderingTerm.asc(table.name)])
        ..limit(limit, offset: (page - 1) * limit);

      final rows = await query.get();
      final countQuery = _database.selectOnly(_database.tenantCachedProducts)
        ..addColumns([_database.tenantCachedProducts.productId.count()])
        ..where(() {
          final table = _database.tenantCachedProducts;
          Expression<bool> predicate = table.storeId.equals(storeId);
          if (status == ProductStatus.active) {
            predicate = predicate & table.isActive.equals(true);
          } else if (status == ProductStatus.archived) {
            predicate = predicate & table.isActive.equals(false);
          }
          if (normalizedSearch != null && normalizedSearch.isNotEmpty) {
            predicate =
                predicate &
                (table.name.lower().contains(normalizedSearch) |
                    table.code.lower().contains(normalizedSearch));
          }
          if (lowStock == true) {
            predicate =
                predicate &
                (table.serverStock - table.reservedStock).isSmallerOrEqualValue(
                  5,
                );
          }
          return predicate;
        }());
      final countRow = await countQuery.getSingle();
      final countColumn = _database.tenantCachedProducts.productId.count();
      final total = countRow.read(countColumn) ?? rows.length;

      final latestCache = rows.fold<DateTime?>(null, (latest, row) {
        if (latest == null || row.lastCachedAt.isAfter(latest)) {
          return row.lastCachedAt;
        }
        return latest;
      });

      return PaginatedProductsEntity(
        items: rows.map(_toEntity).toList(growable: false),
        page: page,
        limit: limit,
        total: total,
        isFromCache: true,
        lastCachedAt: latestCache,
      );
    } catch (error) {
      throw LocalDatabaseException(operation: 'read products', cause: error);
    }
  }

  Future<ProductEntity?> getProductById(String id, {required String storeId}) async {
    try {
      final query = _database.select(_database.tenantCachedProducts)
        ..where((table) => table.storeId.equals(storeId) & table.productId.equals(id));
      final row = await query.getSingleOrNull();
      return row == null ? null : _toEntity(row);
    } catch (error) {
      throw LocalDatabaseException(operation: 'read product', cause: error);
    }
  }

  Future<ProductEntity?> getProductByCode(String code, {required String storeId}) async {
    try {
      final query = _database.select(_database.tenantCachedProducts)
        ..where(
          (table) =>
              table.storeId.equals(storeId) &
              table.code.equals(code.trim()) &
              table.isActive.equals(true),
        );
      final row = await query.getSingleOrNull();
      return row == null ? null : _toEntity(row);
    } catch (error) {
      throw LocalDatabaseException(
        operation: 'read product by code',
        cause: error,
      );
    }
  }

  Future<void> removeProduct(String id, {required String storeId}) async {
    try {
      await (_database.delete(
        _database.tenantCachedProducts,
      )..where((table) => table.storeId.equals(storeId) & table.productId.equals(id))).go();
    } catch (error) {
      throw LocalDatabaseException(operation: 'remove product', cause: error);
    }
  }

  ProductEntity _toEntity(TenantCachedProduct row) {
    final availableStock = row.serverStock - row.reservedStock;
    return ProductEntity(
      id: row.productId,
      name: row.name,
      price: MoneyMinor.toDouble(row.sellingPriceMinor) ?? 0,
      stock: availableStock < 0 ? 0 : availableStock,
      code: row.code,
      updatedAt: row.serverUpdatedAt,
      category: row.category,
      isActive: row.isActive,
      archivedAt: row.archivedAt,
      archiveReason: row.archiveReason,
    );
  }

  Future<int> _activeReservationForProduct(String storeId, String productId) async {
    final itemQuery = _database.select(_database.offlineSaleItems)
      ..where((table) => table.productId.equals(productId));
    final items = await itemQuery.get();
    if (items.isEmpty) return 0;

    final clientIds = items.map((item) => item.clientSaleId).toSet();
    final saleQuery = _database.select(_database.offlineSales)
      ..where(
        (table) =>
            table.storeId.equals(storeId) &
            table.clientSaleId.isIn(clientIds) &
            table.reservationActive.equals(true),
      );
    final activeIds = (await saleQuery.get())
        .map((sale) => sale.clientSaleId)
        .toSet();
    var reservedQuantity = 0;
    for (final item in items) {
      if (activeIds.contains(item.clientSaleId)) {
        reservedQuantity += item.quantity;
      }
    }
    return reservedQuantity;
  }
}
