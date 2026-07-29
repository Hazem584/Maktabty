import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:maktabty/core/network/api_exceptions.dart';
import 'package:maktabty/features/sales/data/datasources/sales_remote_datasource.dart';
import 'package:maktabty/features/sales/data/models/product_mini_model.dart';
import 'package:maktabty/features/sales/data/models/receipt_model.dart';
import 'package:maktabty/features/sales/data/models/receipt_store_model.dart';
import 'package:maktabty/features/sales/data/models/receipt_totals_model.dart';
import 'package:maktabty/features/sales/data/models/sale_item_model.dart';
import 'package:maktabty/features/sales/data/models/sale_model.dart';
import 'package:maktabty/features/sales/data/models/sale_response_model.dart';
import 'package:maktabty/features/sales/data/models/today_sales_response_model.dart';
import 'package:maktabty/features/sales/data/models/today_sales_summary_model.dart';
import 'package:maktabty/features/sales/data/models/user_mini_model.dart';
import 'package:maktabty/features/sales/data/repositories/sales_repository_impl.dart';
import 'package:maktabty/features/sales/domain/entities/payment_method.dart';
import 'package:maktabty/features/sales/domain/entities/sale_item_input.dart';

class MockSalesRemoteDataSource extends Mock implements SalesRemoteDataSource {}

void main() {
  late MockSalesRemoteDataSource remoteDataSource;
  late SalesRepositoryImpl repository;

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

  final saleResponseModel = SaleResponseModel(
    sale: saleModel,
    receipt: receiptModel,
  );

  final todayResponseModel = TodaySalesResponseModel(
    data: [saleModel],
    summary: const TodaySalesSummaryModel(totalAmount: 20, itemsCount: 2),
  );

  setUp(() {
    remoteDataSource = MockSalesRemoteDataSource();
    repository = SalesRepositoryImpl(remoteDataSource: remoteDataSource);
  });

  test('createSale returns SaleResponseEntity', () async {
    final items = [
      const SaleItemInput(productId: 'p1', quantity: 2, unitPriceOverride: 10),
    ];

    when(
      () => remoteDataSource.createSale(
        items: items,
        paymentMethod: PaymentMethod.cash,
        paidAmount: any(named: 'paidAmount'),
        cashAmount: any(named: 'cashAmount'),
        cardAmount: any(named: 'cardAmount'),
      ),
    ).thenAnswer((_) async => saleResponseModel);

    final result = await repository.createSale(
      items: items,
      paymentMethod: PaymentMethod.cash,
    );

    expect(result.sale.id, saleModel.id);
    expect(result.sale.totalAmount, saleModel.totalAmount);
    expect(result.receipt.receiptNo, receiptModel.receiptNo);
  });

  test('createSale throws ApiException on DioException', () async {
    final items = [const SaleItemInput(productId: 'p1', quantity: 1)];

    when(
      () => remoteDataSource.createSale(
        items: items,
        paymentMethod: PaymentMethod.cash,
        paidAmount: any(named: 'paidAmount'),
        cashAmount: any(named: 'cashAmount'),
        cardAmount: any(named: 'cardAmount'),
      ),
    ).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: '/sales'),
        response: Response(
          requestOptions: RequestOptions(path: '/sales'),
          statusCode: 500,
        ),
        type: DioExceptionType.badResponse,
      ),
    );

    expect(
      () => repository.createSale(
        items: items,
        paymentMethod: PaymentMethod.cash,
      ),
      throwsA(isA<ApiException>()),
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
