import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:maktabty/core/errors/app_failure.dart';
import 'package:maktabty/core/database/database_exception.dart';
import 'package:maktabty/core/session/current_user_store.dart';
import 'package:maktabty/features/sales/data/datasources/sales_remote_datasource.dart';
import 'package:maktabty/features/sales/data/datasources/sales_local_datasource.dart';
import 'package:maktabty/features/sales/data/services/sales_sync_coordinator.dart';
import 'package:maktabty/features/sales/data/models/product_mini_model.dart';
import 'package:maktabty/features/sales/data/models/receipt_model.dart';
import 'package:maktabty/features/sales/data/models/receipt_store_model.dart';
import 'package:maktabty/features/sales/data/models/receipt_totals_model.dart';
import 'package:maktabty/features/sales/data/models/sale_item_model.dart';
import 'package:maktabty/features/sales/data/models/sale_model.dart';
import 'package:maktabty/features/sales/data/models/today_sales_response_model.dart';
import 'package:maktabty/features/sales/data/models/today_sales_summary_model.dart';
import 'package:maktabty/features/sales/data/models/user_mini_model.dart';
import 'package:maktabty/features/sales/data/repositories/sales_repository_impl.dart';
import 'package:maktabty/features/sales/domain/entities/payment_method.dart';
import 'package:maktabty/features/sales/domain/entities/sale_item_input.dart';
import 'package:maktabty/features/sales/domain/entities/local_sale_entity.dart';
import 'package:uuid/uuid.dart';

class MockSalesRemoteDataSource extends Mock implements SalesRemoteDataSource {}
class MockSalesLocalDataSource extends Mock implements SalesLocalDataSource {}
class MockSalesSyncCoordinator extends Mock
    implements SalesSyncCoordinator {}
class MockUuid extends Mock implements Uuid {}

void main() {
  late MockSalesRemoteDataSource remoteDataSource;
  late SalesRepositoryImpl repository;
  late MockSalesLocalDataSource localDataSource;
  late MockSalesSyncCoordinator syncCoordinator;
  late MockUuid uuid;
  late CurrentUserStore currentUserStore;

  final saleModel = SaleModel(
    id: 'sale-1',
    items: [
      SaleItemModel(
        product: const ProductMiniModel(
          id: 'p1',
          name: 'Notebook',
          code: 'NB-01',
        ),
        quantity: 2,
        unitPrice: 10,
        lineTotal: 20,
      ),
    ],
    totalAmount: 20,
    createdAt: DateTime(2025, 1, 1),
    user: const UserMiniModel(
      id: 'u1',
      fullName: 'Jane Doe',
      email: 'jane@example.com',
      role: 'cashier',
    ),
  );

  final receiptModel = ReceiptModel(
    receiptNo: 'R-1',
    createdAt: DateTime(2025, 1, 1),
    store: const ReceiptStoreModel(name: 'Store'),
    cashier: null,
    items: const [],
    totals: const ReceiptTotalsModel(subtotal: 20, total: 20),
    payment: null,
    footerLines: const [],
  );

  final todayResponseModel = TodaySalesResponseModel(
    data: [saleModel],
    summary: const TodaySalesSummaryModel(totalAmount: 20, itemsCount: 2),
  );

  setUpAll(() {
    registerFallbackValue(DateTime(2026));
    registerFallbackValue(PaymentMethod.cash);
  });

  setUp(() {
    remoteDataSource = MockSalesRemoteDataSource();
    localDataSource = MockSalesLocalDataSource();
    syncCoordinator = MockSalesSyncCoordinator();
    uuid = MockUuid();
    currentUserStore = CurrentUserStore()..setUser('u1');
    when(() => uuid.v4()).thenReturn('client-sale-1');
    when(() => syncCoordinator.sync(any())).thenAnswer((_) async {});
    repository = SalesRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
      syncCoordinator: syncCoordinator,
      currentUserStore: currentUserStore,
      uuid: uuid,
    );
  });

  test('createSale persists locally before returning', () async {
    final items = [
      const SaleItemInput(productId: 'p1', quantity: 2, unitPriceOverride: 10),
    ];

    when(
      () => localDataSource.createPendingSale(
        clientSaleId: 'client-sale-1',
        ownerUserId: 'u1',
        occurredAt: any(named: 'occurredAt'),
        items: items,
        paymentMethod: PaymentMethod.cash,
        paidAmount: any(named: 'paidAmount'),
        cashAmount: any(named: 'cashAmount'),
        cardAmount: any(named: 'cardAmount'),
        discountAmount: any(named: 'discountAmount'),
      ),
    ).thenAnswer(
      (_) async => LocalSaleEntity(
        localId: 1,
        clientSaleId: 'client-sale-1',
        ownerUserId: 'u1',
        occurredAt: DateTime(2026),
        paymentMethod: PaymentMethod.cash,
        paidAmount: null,
        cashAmount: null,
        cardAmount: null,
        discountAmount: 0,
        syncStatus: LocalSaleSyncStatus.pending,
        serverSaleId: null,
        receiptNoInt: null,
        syncAttempts: 0,
        lastSyncAttemptAt: null,
        lastErrorCode: null,
        lastErrorMessage: null,
        conflictProductId: null,
        conflictRequestedQuantity: null,
        conflictAvailableQuantity: null,
        createdLocallyAt: DateTime(2026),
        updatedLocallyAt: DateTime(2026),
        items: const [
          LocalSaleItemEntity(
            productId: 'p1',
            productName: 'Notebook',
            productCode: 'NB-01',
            quantity: 2,
            sellingPrice: 10,
            unitPriceOverride: 10,
          ),
        ],
        confirmedReceipt: null,
      ),
    );

    final result = await repository.createSale(
      items: items,
      paymentMethod: PaymentMethod.cash,
    );

    expect(result.sale.id, 'client-sale-1');
    expect(result.sale.totalAmount, 20);
    expect(result.receipt.receiptNo, isEmpty);
    verify(() => syncCoordinator.sync('u1')).called(1);
  });

  test('createSale maps local database errors to AppFailure', () async {
    final items = [const SaleItemInput(productId: 'p1', quantity: 1)];

    when(
      () => localDataSource.createPendingSale(
        clientSaleId: 'client-sale-1',
        ownerUserId: 'u1',
        occurredAt: any(named: 'occurredAt'),
        items: items,
        paymentMethod: PaymentMethod.cash,
        paidAmount: any(named: 'paidAmount'),
        cashAmount: any(named: 'cashAmount'),
        cardAmount: any(named: 'cardAmount'),
        discountAmount: any(named: 'discountAmount'),
      ),
    ).thenThrow(
      const LocalDatabaseException(operation: 'save pending sale'),
    );

    expect(
      () => repository.createSale(
        items: items,
        paymentMethod: PaymentMethod.cash,
      ),
      throwsA(isA<LocalDatabaseFailure>()),
    );
  });

  test('getTodaySales returns TodaySalesResponseEntity', () async {
    when(
      () => remoteDataSource.getTodaySales(date: null),
    ).thenAnswer((_) async => todayResponseModel);

    final result = await repository.getTodaySales();

    expect(result.summary.totalAmount, 20);
    expect(result.data.length, 1);
  });

  test('getReceiptForSale returns ReceiptEntity', () async {
    when(
      () => remoteDataSource.getReceiptForSale('sale-1'),
    ).thenAnswer((_) async => receiptModel);

    final result = await repository.getReceiptForSale('sale-1');

    expect(result.receiptNo, receiptModel.receiptNo);
  });
}
