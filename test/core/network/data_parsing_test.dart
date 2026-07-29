import 'package:flutter_test/flutter_test.dart';
import 'package:maktabty/core/network/data_parsing_exception.dart';
import 'package:maktabty/features/products/data/models/product_model.dart';
import 'package:maktabty/features/reports/data/models/daily_report_model.dart';
import 'package:maktabty/features/reports/data/models/monthly_report_model.dart';
import 'package:maktabty/features/sales/data/models/receipt_model.dart';
import 'package:maktabty/features/sales/data/models/sale_model.dart';
import 'package:maktabty/features/sales/data/models/sale_response_model.dart';

void main() {
  final validProduct = <String, dynamic>{
    'id': 'product-1',
    'name': 'Notebook',
    'price': '12.50',
    'stock': '4',
    'createdAt': '2026-07-01T10:00:00Z',
  };
  final validSale = <String, dynamic>{
    'id': 'sale-1',
    'items': [
      {
        'product': {'id': 'product-1', 'name': 'Notebook'},
        'quantity': '2',
        'unitPrice': '12.50',
        'lineTotal': 25,
      },
    ],
    'totalAmount': '25',
    'createdAt': '2026-07-01T10:00:00Z',
  };
  final validReceipt = <String, dynamic>{
    'receiptNo': 'R-1',
    'createdAt': '2026-07-01T10:00:00Z',
    'store': {'name': 'Configured Store'},
    'items': <dynamic>[],
    'totals': {'subtotal': '25', 'total': 25},
  };

  test('valid product keeps tolerant numeric string parsing', () {
    final product = ProductModel.fromJson(validProduct);
    expect(product.price, 12.5);
    expect(product.stock, 4);
  });

  test('alternative dynamic map types are converted safely', () {
    final dynamicMap = <dynamic, dynamic>{
      'id': 'product-1',
      'name': 'Notebook',
      'price': 12.5,
      'stock': 4,
    };
    final product = ProductModel.fromJson(
      requireStringMap(dynamicMap, operation: 'test product'),
    );
    expect(product.id, 'product-1');
  });

  test('missing required product field throws typed contract error', () {
    final malformed = Map<String, dynamic>.from(validProduct)..remove('id');
    expect(
      () => ProductModel.fromJson(malformed),
      throwsA(isA<DataParsingException>()),
    );
  });

  test('invalid product number throws typed contract error', () {
    final malformed = Map<String, dynamic>.from(validProduct)
      ..['price'] = 'not-a-number';
    expect(
      () => ProductModel.fromJson(malformed),
      throwsA(isA<DataParsingException>()),
    );
  });

  test('invalid optional product date is not silently discarded', () {
    final malformed = Map<String, dynamic>.from(validProduct)
      ..['createdAt'] = 'not-a-date';
    expect(
      () => ProductModel.fromJson(malformed),
      throwsA(isA<DataParsingException>()),
    );
  });

  test('malformed sale cannot become an empty sale entity', () {
    final malformed = Map<String, dynamic>.from(validSale)..remove('id');
    expect(
      () => SaleModel.fromJson(malformed),
      throwsA(isA<DataParsingException>()),
    );
  });

  test('sale response requires both the sale and receipt contracts', () {
    expect(
      () => SaleResponseModel.fromJson({'sale': validSale}),
      throwsA(isA<DataParsingException>()),
    );
    expect(
      SaleResponseModel.fromJson({
        'sale': validSale,
        'receipt': validReceipt,
      }).sale.id,
      'sale-1',
    );
  });

  test('malformed receipt cannot become an empty receipt', () {
    final malformed = Map<String, dynamic>.from(validReceipt)
      ..remove('receiptNo');
    expect(
      () => ReceiptModel.fromJson(malformed),
      throwsA(isA<DataParsingException>()),
    );
  });

  test('malformed daily and monthly reports throw typed errors', () {
    expect(
      () => DailyReportModel.fromJson({
        'date': '2026-07-01',
        'totalSalesAmount': 'invalid',
        'totalOrders': 1,
        'totalItemsSold': 2,
        'topProducts': [],
      }),
      throwsA(isA<DataParsingException>()),
    );
    expect(
      () => MonthlyReportModel.fromJson({
        'month': '2026-07',
        'totalSalesAmount': 100,
        'totalOrders': 1,
        'totalItemsSold': 2,
        'dailyBreakdown': 'not-a-list',
      }),
      throwsA(isA<DataParsingException>()),
    );
  });

  test('valid reports still parse', () {
    expect(
      DailyReportModel.fromJson({
        'date': '2026-07-01',
        'totalSalesAmount': '100',
        'totalOrders': '1',
        'totalItemsSold': 2,
        'topProducts': [],
      }).totalSalesAmount,
      100,
    );
    expect(
      MonthlyReportModel.fromJson({
        'month': '2026-07',
        'totalSalesAmount': 100,
        'totalOrders': 1,
        'totalItemsSold': 2,
        'dailyBreakdown': [],
      }).month,
      '2026-07',
    );
  });

  test('completely unexpected response type throws typed error', () {
    expect(
      () =>
          requireStringMap(<dynamic>['unexpected'], operation: 'GET /products'),
      throwsA(isA<DataParsingException>()),
    );
  });
}
