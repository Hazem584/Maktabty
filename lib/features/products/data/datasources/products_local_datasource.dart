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
    required bool replaceAll,
  }) async {
    final cachedAt = DateTime.now().toUtc();
    try {
      await _database.transaction(() async {
        if (replaceAll) {
          final incomingIds = products.map((product) => product.id).toSet();
          final existing = await _database
              .select(_database.cachedProducts)
              .get();
          for (final row in existing) {
            if (!incomingIds.contains(row.productId)) {
              await (_database.delete(
                _database.cachedProducts,
              )..where((table) => table.productId.equals(row.productId))).go();
            }
          }
        }

        for (final product in products) {
          final activeReservation = await _activeReservationForProduct(
            product.id,
          );
          final companion = CachedProductsCompanion(
            productId: Value(product.id),
            name: Value(product.name),
            code: Value(product.code),
            sellingPriceMinor: Value(MoneyMinor.fromDouble(product.price) ?? 0),
            serverStock: Value(product.stock),
            reservedStock: Value(activeReservation),
            category: Value(product.category),
            serverUpdatedAt: Value(product.updatedAt?.toUtc()),
            lastCachedAt: Value(cachedAt),
          );
          await _database
              .into(_database.cachedProducts)
              .insertOnConflictUpdate(companion);
        }
      });
    } catch (error) {
      throw LocalDatabaseException(operation: 'cache products', cause: error);
    }
  }

  Future<PaginatedProductsEntity> getProducts({
    String? search,
    bool? lowStock,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final normalizedSearch = search?.trim().toLowerCase();
      final query = _database.select(_database.cachedProducts)
        ..where((table) {
          Expression<bool> predicate = const Constant(true);
          if (normalizedSearch != null && normalizedSearch.isNotEmpty) {
            predicate =
                table.name.lower().contains(normalizedSearch) |
                table.code.lower().contains(normalizedSearch);
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
      final countQuery = _database.selectOnly(_database.cachedProducts)
        ..addColumns([_database.cachedProducts.productId.count()])
        ..where(() {
          final table = _database.cachedProducts;
          Expression<bool> predicate = const Constant(true);
          if (normalizedSearch != null && normalizedSearch.isNotEmpty) {
            predicate =
                table.name.lower().contains(normalizedSearch) |
                table.code.lower().contains(normalizedSearch);
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
      final countColumn = _database.cachedProducts.productId.count();
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

  Future<ProductEntity?> getProductById(String id) async {
    try {
      final query = _database.select(_database.cachedProducts)
        ..where((table) => table.productId.equals(id));
      final row = await query.getSingleOrNull();
      return row == null ? null : _toEntity(row);
    } catch (error) {
      throw LocalDatabaseException(operation: 'read product', cause: error);
    }
  }

  Future<ProductEntity?> getProductByCode(String code) async {
    try {
      final query = _database.select(_database.cachedProducts)
        ..where((table) => table.code.equals(code.trim()));
      final row = await query.getSingleOrNull();
      return row == null ? null : _toEntity(row);
    } catch (error) {
      throw LocalDatabaseException(
        operation: 'read product by code',
        cause: error,
      );
    }
  }

  Future<void> removeProduct(String id) async {
    try {
      await (_database.delete(
        _database.cachedProducts,
      )..where((table) => table.productId.equals(id))).go();
    } catch (error) {
      throw LocalDatabaseException(operation: 'remove product', cause: error);
    }
  }

  ProductEntity _toEntity(CachedProduct row) {
    final availableStock = row.serverStock - row.reservedStock;
    return ProductEntity(
      id: row.productId,
      name: row.name,
      price: MoneyMinor.toDouble(row.sellingPriceMinor) ?? 0,
      stock: availableStock < 0 ? 0 : availableStock,
      code: row.code,
      updatedAt: row.serverUpdatedAt,
      category: row.category,
    );
  }

  Future<int> _activeReservationForProduct(String productId) async {
    final itemQuery = _database.select(_database.offlineSaleItems)
      ..where((table) => table.productId.equals(productId));
    final items = await itemQuery.get();
    if (items.isEmpty) return 0;

    final clientIds = items.map((item) => item.clientSaleId).toSet();
    final saleQuery = _database.select(_database.offlineSales)
      ..where(
        (table) =>
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
