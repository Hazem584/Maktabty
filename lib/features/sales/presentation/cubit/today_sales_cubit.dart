import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktabty/core/network/api_exceptions.dart';
import 'package:maktabty/features/sales/domain/entities/receipt_entity.dart';
import 'package:maktabty/features/sales/domain/entities/sale_entity.dart';
import 'package:maktabty/features/sales/domain/entities/today_sales_response_entity.dart';
import 'package:maktabty/features/sales/domain/entities/today_sales_summary_entity.dart';
import 'package:maktabty/features/sales/domain/usecases/delete_sale_usecase.dart';
import 'package:maktabty/features/sales/domain/usecases/get_receipt_for_sale_usecase.dart';
import 'package:maktabty/features/sales/domain/usecases/get_today_sales_usecase.dart';
import 'package:maktabty/features/sales/presentation/cubit/sales_error_mapper.dart';
import 'package:maktabty/features/sales/presentation/cubit/today_sales_state.dart';

class TodaySalesCubit extends Cubit<TodaySalesState> {
  final GetTodaySalesUseCase _getTodaySalesUseCase;
  final GetReceiptForSaleUseCase _getReceiptForSaleUseCase;
  final DeleteSaleUseCase _deleteSaleUseCase;

  TodaySalesCubit({
    required GetTodaySalesUseCase getTodaySalesUseCase,
    required GetReceiptForSaleUseCase getReceiptForSaleUseCase,
    required DeleteSaleUseCase deleteSaleUseCase,
  }) : _getTodaySalesUseCase = getTodaySalesUseCase,
       _getReceiptForSaleUseCase = getReceiptForSaleUseCase,
       _deleteSaleUseCase = deleteSaleUseCase,
       super(TodaySalesState.initial());

  Future<void> load({String? date}) async {
    if (state.status == TodaySalesStatus.loading) return;
    if (isClosed) return;
    emit(state.copyWith(status: TodaySalesStatus.loading, message: null));

    try {
      final response = await _getTodaySalesUseCase(date: date);
      if (isClosed) return;
      emit(
        state.copyWith(status: TodaySalesStatus.success, response: response),
      );
    } on ApiException catch (error) {
      if (isClosed) return;
      emit(
        state.copyWith(
          status: TodaySalesStatus.failure,
          message: mapSalesError(error),
        ),
      );
    } catch (_) {
      if (isClosed) return;
      emit(
        state.copyWith(
          status: TodaySalesStatus.failure,
          message: 'Something went wrong. Please try again.',
        ),
      );
    }
  }

  Future<ReceiptEntity> getReceiptForSale(String saleId) async {
    try {
      return await _getReceiptForSaleUseCase(saleId);
    } on ApiException catch (error) {
      throw mapSalesError(error);
    } catch (_) {
      throw 'Something went wrong. Please try again.';
    }
  }

  Future<void> deleteSale(String saleId) async {
    try {
      await _deleteSaleUseCase(id: saleId);
      _removeSaleFromState(saleId);
    } on ApiException catch (error) {
      if (error.statusCode == 404) {
        _removeSaleFromState(saleId);
        return;
      }
      throw mapSalesError(error);
    } catch (_) {
      throw 'Something went wrong. Please try again.';
    }
  }

  void _removeSaleFromState(String saleId) {
    final response = state.response;
    if (response == null) return;
    SaleEntity? removedSale;
    for (final sale in response.data) {
      if (sale.id == saleId) {
        removedSale = sale;
        break;
      }
    }
    if (removedSale == null) return;

    final updatedSales = response.data
        .where((sale) => sale.id != saleId)
        .toList();
    final totalAmountRaw =
        response.summary.totalAmount - removedSale.totalAmount;
    final totalAmount = totalAmountRaw < 0 ? 0.0 : totalAmountRaw;
    int itemsCount = response.summary.itemsCount;
    if (removedSale.items.isNotEmpty) {
      final removedItems = removedSale.items.fold(
        0,
        (sum, item) => sum + item.quantity,
      );
      itemsCount = itemsCount - removedItems;
      if (itemsCount < 0) itemsCount = 0;
    }

    emit(
      state.copyWith(
        response: TodaySalesResponseEntity(
          data: updatedSales,
          summary: TodaySalesSummaryEntity(
            totalAmount: totalAmount,
            itemsCount: itemsCount,
          ),
        ),
      ),
    );
  }
}
