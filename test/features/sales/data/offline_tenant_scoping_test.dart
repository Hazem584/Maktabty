import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:maktabty/core/database/app_database.dart';
import 'package:maktabty/features/products/data/datasources/products_local_datasource.dart';
import 'package:maktabty/features/products/domain/entities/product_entity.dart';
import 'package:maktabty/features/sales/data/datasources/sales_local_datasource.dart';
import 'package:maktabty/features/sales/domain/entities/local_sale_entity.dart';
import 'package:maktabty/features/sales/domain/entities/payment_method.dart';
import 'package:maktabty/features/sales/domain/entities/sale_item_input.dart';

void main() {
  late AppDatabase database;
  late ProductsLocalDataSource products;
  late SalesLocalDataSource sales;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    products = ProductsLocalDataSource(database);
    sales = SalesLocalDataSource(database);
  });

  tearDown(() => database.close());

  test('stores read only their own cached products even for the same product id', () async {
    await products.cacheProducts(const [ProductEntity(id: 'product-1', name: 'Store A Product', price: 10, stock: 5)], storeId: 'store-a', reconcileActiveCatalog: true);
    await products.cacheProducts(const [ProductEntity(id: 'product-1', name: 'Store B Product', price: 20, stock: 9)], storeId: 'store-b', reconcileActiveCatalog: true);
    final storeA = await products.getProducts(storeId: 'store-a');
    final storeB = await products.getProducts(storeId: 'store-b');
    expect(storeA.items.single.name, 'Store A Product');
    expect(storeB.items.single.name, 'Store B Product');
  });

  test('pending sales remain partitioned by store and creating user', () async {
    await products.cacheProducts(const [ProductEntity(id: 'product-1', name: 'Product', price: 10, stock: 5)], storeId: 'store-a', reconcileActiveCatalog: true);
    await sales.createPendingSale(clientSaleId: 'stable-client-sale-id', storeId: 'store-a', ownerUserId: 'user-a', occurredAt: DateTime.utc(2026, 8, 4), items: const [SaleItemInput(productId: 'product-1', quantity: 1)], paymentMethod: PaymentMethod.cash);

    final userASales = await sales.watchSalesForOwner(storeId: 'store-a', ownerUserId: 'user-a').first;
    final userBSales = await sales.watchSalesForOwner(storeId: 'store-a', ownerUserId: 'user-b').first;
    final storeBSales = await sales.watchSalesForOwner(storeId: 'store-b', ownerUserId: 'user-a').first;
    expect(userASales.single.clientSaleId, 'stable-client-sale-id');
    expect(userBSales, isEmpty);
    expect(storeBSales, isEmpty);

    final wrongUserBatch = await sales.claimPendingBatch(storeId: 'store-a', ownerUserId: 'user-b');
    final wrongStoreBatch = await sales.claimPendingBatch(storeId: 'store-b', ownerUserId: 'user-a');
    expect(wrongUserBatch, isEmpty);
    expect(wrongStoreBatch, isEmpty);
  });

  test('legacy unowned pending data is quarantined and not assigned', () async {
    final now = DateTime.utc(2026, 8, 4);
    await database.into(database.offlineSales).insert(
      OfflineSalesCompanion.insert(
        clientSaleId: 'legacy-client-id',
        ownerUserId: 'legacy-user',
        occurredAt: now,
        paymentMethod: PaymentMethod.cash.apiValue,
        syncStatus: LocalSaleSyncStatus.pending.databaseValue,
        createdLocallyAt: now,
        updatedLocallyAt: now,
      ),
    );
    expect(await sales.unownedUnsyncedCount(), 1);
    expect(await sales.watchSalesForOwner(storeId: 'store-a', ownerUserId: 'legacy-user').first, isEmpty);
    expect(await sales.claimPendingBatch(storeId: 'store-a', ownerUserId: 'legacy-user'), isEmpty);
  });
}
