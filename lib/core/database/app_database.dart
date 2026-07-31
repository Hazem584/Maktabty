import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

class CachedProducts extends Table {
  TextColumn get productId => text()();
  TextColumn get name => text()();
  TextColumn get code => text().nullable()();
  IntColumn get sellingPriceMinor => integer()();
  IntColumn get serverStock => integer()();
  IntColumn get reservedStock => integer().withDefault(const Constant(0))();
  TextColumn get category => text().nullable()();
  DateTimeColumn get serverUpdatedAt => dateTime().nullable()();
  DateTimeColumn get lastCachedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {productId};
}

class OfflineSales extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get clientSaleId => text().unique()();
  TextColumn get ownerUserId => text()();
  DateTimeColumn get occurredAt => dateTime()();
  TextColumn get paymentMethod => text()();
  IntColumn get paidAmountMinor => integer().nullable()();
  IntColumn get cashAmountMinor => integer().nullable()();
  IntColumn get cardAmountMinor => integer().nullable()();
  IntColumn get discountAmountMinor =>
      integer().withDefault(const Constant(0))();
  TextColumn get syncStatus => text()();
  BoolColumn get reservationActive =>
      boolean().withDefault(const Constant(true))();
  TextColumn get serverSaleId => text().nullable()();
  IntColumn get receiptNoInt => integer().nullable()();
  IntColumn get syncAttempts => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastSyncAttemptAt => dateTime().nullable()();
  DateTimeColumn get nextRetryAt => dateTime().nullable()();
  TextColumn get lastErrorCode => text().nullable()();
  TextColumn get lastErrorMessage => text().nullable()();
  TextColumn get conflictProductId => text().nullable()();
  IntColumn get conflictRequestedQuantity => integer().nullable()();
  IntColumn get conflictAvailableQuantity => integer().nullable()();
  TextColumn get saleJson => text().nullable()();
  TextColumn get receiptJson => text().nullable()();
  DateTimeColumn get createdLocallyAt => dateTime()();
  DateTimeColumn get updatedLocallyAt => dateTime()();
}

class OfflineSaleItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get clientSaleId =>
      text().references(OfflineSales, #clientSaleId)();
  TextColumn get productId => text()();
  TextColumn get productName => text()();
  TextColumn get productCode => text().nullable()();
  IntColumn get quantity => integer()();
  IntColumn get unitPriceOverrideMinor => integer().nullable()();
  IntColumn get sellingPriceMinor => integer()();
}

@DriftDatabase(tables: [CachedProducts, OfflineSales, OfflineSaleItems])
class AppDatabase extends _$AppDatabase {
  AppDatabase()
    : super(
        driftDatabase(
          name: 'maktabty_offline',
          native: const DriftNativeOptions(shareAcrossIsolates: true),
        ),
      );

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async {
      await migrator.createAll();
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_offline_sales_owner_status '
        'ON offline_sales (owner_user_id, sync_status, next_retry_at)',
      );
      await customStatement(
        'CREATE INDEX IF NOT EXISTS idx_offline_sale_items_client '
        'ON offline_sale_items (client_sale_id)',
      );
      await customStatement(
        'CREATE UNIQUE INDEX IF NOT EXISTS idx_cached_products_code '
        'ON cached_products (code) WHERE code IS NOT NULL',
      );
    },
    onUpgrade: (migrator, from, to) async {
      // Future versions must add explicit, non-destructive migration steps.
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
