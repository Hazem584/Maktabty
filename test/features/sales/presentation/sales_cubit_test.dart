import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:maktabty/core/network/api_exceptions.dart';
import 'package:maktabty/features/sales/domain/entities/payment_method.dart';
import 'package:maktabty/features/sales/domain/entities/product_mini_entity.dart';
import 'package:maktabty/features/sales/domain/entities/receipt_entity.dart';
import 'package:maktabty/features/sales/domain/entities/receipt_store_entity.dart';
import 'package:maktabty/features/sales/domain/entities/receipt_totals_entity.dart';
import 'package:maktabty/features/sales/domain/entities/sale_entity.dart';
import 'package:maktabty/features/sales/domain/entities/sale_item_entity.dart';
import 'package:maktabty/features/sales/domain/entities/sale_response_entity.dart';
import 'package:maktabty/features/sales/domain/entities/today_sales_response_entity.dart';
import 'package:maktabty/features/sales/domain/entities/today_sales_summary_entity.dart';
import 'package:maktabty/features/sales/domain/entities/user_mini_entity.dart';
import 'package:maktabty/features/sales/domain/entities/sale_item_input.dart';
import 'package:maktabty/features/sales/domain/usecases/create_sale_usecase.dart';
import 'package:maktabty/features/sales/domain/usecases/delete_sale_usecase.dart';
import 'package:maktabty/features/sales/domain/usecases/get_receipt_for_sale_usecase.dart';
import 'package:maktabty/features/sales/domain/usecases/get_today_sales_usecase.dart';
import 'package:maktabty/features/sales/presentation/cubit/create_sale_cubit.dart';
import 'package:maktabty/features/sales/presentation/cubit/create_sale_state.dart';
import 'package:maktabty/features/sales/presentation/cubit/today_sales_cubit.dart';
import 'package:maktabty/features/sales/presentation/cubit/today_sales_state.dart';

class MockCreateSaleUseCase extends Mock implements CreateSaleUseCase {}

class MockGetTodaySalesUseCase extends Mock implements GetTodaySalesUseCase {}

class MockGetReceiptForSaleUseCase extends Mock
    implements GetReceiptForSaleUseCase {}

class MockDeleteSaleUseCase extends Mock implements DeleteSaleUseCase {}

void main() {
  setUpAll(() {
    registerFallbackValue(PaymentMethod.cash);
  });

  final sale = SaleEntity(
    id: 'sale-1',
    items: [
      SaleItemEntity(
        product: const ProductMiniEntity(id: 'p1', name: 'Pen', code: 'PEN'),
        quantity: 2,
        unitPrice: 5,
        lineTotal: 10,
      ),
    ],
    totalAmount: 10,
    createdAt: DateTime(2025, 1, 1),
    user: const UserMiniEntity(
      id: 'u1',
      fullName: 'John Doe',
      email: 'john@example.com',
      role: 'cashier',
    ),
  );

  final receipt = ReceiptEntity(
    receiptNo: 'R-1',
    createdAt: DateTime(2025, 1, 1),
    store: const ReceiptStoreEntity(name: 'Store'),
    cashier: null,
    items: const [],
    totals: const ReceiptTotalsEntity(subtotal: 10, total: 10),
    payment: null,
    footerLines: const [],
  );

  final response = SaleResponseEntity(sale: sale, receipt: receipt);

  final itemsForSuccess = [const SaleItemInput(productId: 'p1', quantity: 2)];
  final itemsForFailure = [const SaleItemInput(productId: 'p1', quantity: 1)];

  group('CreateSaleCubit', () {
    late MockCreateSaleUseCase useCase;

    setUp(() {
      useCase = MockCreateSaleUseCase();
    });

    blocTest<CreateSaleCubit, CreateSaleState>(
      'emits loading and success',
      build: () {
        when(
          () => useCase(
            items: itemsForSuccess,
            paymentMethod: any(named: 'paymentMethod'),
            paidAmount: any(named: 'paidAmount'),
            cashAmount: any(named: 'cashAmount'),
            cardAmount: any(named: 'cardAmount'),
          ),
        ).thenAnswer((_) async => response);
        return CreateSaleCubit(createSaleUseCase: useCase);
      },
      act: (cubit) => cubit.submit(items: itemsForSuccess),
      expect: () => [
        isA<CreateSaleState>().having(
          (state) => state.status,
          'status',
          CreateSaleStatus.loading,
        ),
        isA<CreateSaleState>()
            .having((state) => state.status, 'status', CreateSaleStatus.success)
            .having((state) => state.response, 'response', response)
            .having((state) => state.lastReceipt, 'lastReceipt', receipt),
      ],
    );

    blocTest<CreateSaleCubit, CreateSaleState>(
      'emits failure on ApiException',
      build: () {
        when(
          () => useCase(
            items: itemsForFailure,
            paymentMethod: PaymentMethod.cash,
            paidAmount: any(named: 'paidAmount'),
            cashAmount: any(named: 'cashAmount'),
            cardAmount: any(named: 'cardAmount'),
          ),
        ).thenThrow(const ApiException('Server error', statusCode: 500));
        return CreateSaleCubit(createSaleUseCase: useCase);
      },
      act: (cubit) => cubit.submit(items: itemsForFailure),
      expect: () => [
        isA<CreateSaleState>().having(
          (state) => state.status,
          'status',
          CreateSaleStatus.loading,
        ),
        isA<CreateSaleState>().having(
          (state) => state.status,
          'status',
          CreateSaleStatus.failure,
        ),
      ],
    );
  });

  group('TodaySalesCubit', () {
    late MockGetTodaySalesUseCase useCase;
    late MockGetReceiptForSaleUseCase receiptUseCase;
    late MockDeleteSaleUseCase deleteSaleUseCase;

    setUp(() {
      useCase = MockGetTodaySalesUseCase();
      receiptUseCase = MockGetReceiptForSaleUseCase();
      deleteSaleUseCase = MockDeleteSaleUseCase();
    });

    blocTest<TodaySalesCubit, TodaySalesState>(
      'emits loading and success',
      build: () {
        final response = TodaySalesResponseEntity(
          data: [sale],
          summary: const TodaySalesSummaryEntity(
            totalAmount: 10,
            itemsCount: 2,
          ),
        );
        when(() => useCase(date: null)).thenAnswer((_) async => response);
        return TodaySalesCubit(
          getTodaySalesUseCase: useCase,
          getReceiptForSaleUseCase: receiptUseCase,
          deleteSaleUseCase: deleteSaleUseCase,
        );
      },
      act: (cubit) => cubit.load(),
      expect: () => [
        isA<TodaySalesState>().having(
          (state) => state.status,
          'status',
          TodaySalesStatus.loading,
        ),
        isA<TodaySalesState>().having(
          (state) => state.status,
          'status',
          TodaySalesStatus.success,
        ),
      ],
    );

    blocTest<TodaySalesCubit, TodaySalesState>(
      'emits failure on ApiException',
      build: () {
        when(
          () => useCase(date: null),
        ).thenThrow(const ApiException('Unauthorized', statusCode: 401));
        return TodaySalesCubit(
          getTodaySalesUseCase: useCase,
          getReceiptForSaleUseCase: receiptUseCase,
          deleteSaleUseCase: deleteSaleUseCase,
        );
      },
      act: (cubit) => cubit.load(),
      expect: () => [
        isA<TodaySalesState>().having(
          (state) => state.status,
          'status',
          TodaySalesStatus.loading,
        ),
        isA<TodaySalesState>().having(
          (state) => state.status,
          'status',
          TodaySalesStatus.failure,
        ),
      ],
    );
  });
}
