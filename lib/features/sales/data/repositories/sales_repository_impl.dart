import 'package:dio/dio.dart';
import 'package:maktabty/core/network/api_exceptions.dart';
import 'package:maktabty/features/sales/data/datasources/sales_remote_datasource.dart';
import 'package:maktabty/features/sales/domain/entities/payment_method.dart';
import 'package:maktabty/features/sales/domain/entities/receipt_entity.dart';
import 'package:maktabty/features/sales/domain/entities/sale_entity.dart';
import 'package:maktabty/features/sales/domain/entities/sale_item_input.dart';
import 'package:maktabty/features/sales/domain/entities/sale_response_entity.dart';
import 'package:maktabty/features/sales/domain/entities/today_sales_response_entity.dart';
import 'package:maktabty/features/sales/domain/repositories/sales_repository.dart';

class SalesRepositoryImpl implements SalesRepository {
  final SalesRemoteDataSource _remoteDataSource;

  SalesRepositoryImpl({required SalesRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<SaleResponseEntity> createSale({
    required List<SaleItemInput> items,
    required PaymentMethod paymentMethod,
    double? paidAmount,
    double? cashAmount,
    double? cardAmount,
  }) async {
    try {
      final response = await _remoteDataSource.createSale(
        items: items,
        paymentMethod: paymentMethod,
        paidAmount: paidAmount,
        cashAmount: cashAmount,
        cardAmount: cardAmount,
      );
      return response.toEntity();
    } on DioException catch (error) {
      throw ApiExceptions.fromDio(error);
    }
  }

  @override
  Future<SaleResponseEntity> createSaleByCode({
    required String code,
    required int quantity,
    required PaymentMethod paymentMethod,
    double? unitPriceOverride,
    double? paidAmount,
    double? cashAmount,
    double? cardAmount,
  }) async {
    try {
      final response = await _remoteDataSource.createSaleByCode(
        code: code,
        quantity: quantity,
        paymentMethod: paymentMethod,
        unitPriceOverride: unitPriceOverride,
        paidAmount: paidAmount,
        cashAmount: cashAmount,
        cardAmount: cardAmount,
      );
      return response.toEntity();
    } on DioException catch (error) {
      throw ApiExceptions.fromDio(error);
    }
  }

  @override
  Future<TodaySalesResponseEntity> getTodaySales({String? date}) async {
    try {
      final response = await _remoteDataSource.getTodaySales(date: date);
      return response.toEntity();
    } on DioException catch (error) {
      throw ApiExceptions.fromDio(error);
    }
  }

  @override
  Future<SaleEntity> deleteSale({required String id}) async {
    try {
      final response = await _remoteDataSource.deleteSale(id);
      return response.toEntity();
    } on DioException catch (error) {
      throw ApiExceptions.fromDio(error);
    }
  }

  @override
  Future<ReceiptEntity> getReceiptForSale(String saleId) async {
    try {
      final response = await _remoteDataSource.getReceiptForSale(saleId);
      return response.toEntity();
    } on DioException catch (error) {
      throw ApiExceptions.fromDio(error);
    }
  }
}

