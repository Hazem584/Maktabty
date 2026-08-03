import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktabty/core/errors/app_failure.dart';
import 'package:maktabty/features/sales/domain/entities/receipt_entity.dart';
import 'package:maktabty/features/sales/domain/entities/sale_entity.dart';
import 'package:maktabty/features/sales/domain/entities/today_sales_response_entity.dart';
import 'package:maktabty/features/sales/domain/entities/today_sales_summary_entity.dart';
import 'package:maktabty/features/sales/domain/usecases/delete_sale_usecase.dart';
import 'package:maktabty/features/sales/domain/usecases/get_receipt_for_sale_usecase.dart';
import 'package:maktabty/features/sales/domain/usecases/get_today_sales_usecase.dart';
import 'package:maktabty/features/sales/presentation/cubit/today_sales_state.dart';

class TodaySalesCubit extends Cubit<TodaySalesState> {
  final GetTodaySalesUseCase _getTodaySalesUseCase;
  final GetReceiptForSaleUseCase _getReceiptForSaleUseCase;
  final DeleteSaleUseCase _deleteSaleUseCase;

  TodaySalesCubit({
    required this._getTodaySalesUseCase,
    required GetReceiptForSaleUseCase getReceiptForSaleUseCase,
    required this._deleteSaleUseCase,
  }) : _getReceiptForSaleUseCase = getReceiptForSaleUseCase,
       super(TodaySalesState.initial());

  Future<void> load({String? date}) async {
    if (state.status == TodaySalesStatus.loading) return;
    if (isClosed) return;
    emit(
      state.copyWith(
        status: TodaySalesStatus.loading,
        response: null,
        failure: null,
      ),
    );

    try {
      final response = await _getTodaySalesUseCase(date: date);
      if (isClosed) return;
      emit(
        state.copyWith(
          status: TodaySalesStatus.success,
          response: response,
          failure: null,
        ),
      );
    } on AppFailure catch (failure) {
      if (isClosed) return;
      emit(
        state.copyWith(
          status: TodaySalesStatus.failure,
          response: null,
          failure: failure,
        ),
      );
    } catch (_) {
      if (isClosed) return;
      emit(
        state.copyWith(
          status: TodaySalesStatus.failure,
          response: null,
          failure: const UnknownFailure(),
        ),
      );
    }
  }

  Future<ReceiptEntity> getReceiptForSale(String saleId) async {
    try {
      return await _getReceiptForSaleUseCase(saleId);
    } on AppFailure {
      rethrow;
    } catch (_) {
      throw const UnknownFailure();
    }
  }

  Future<void> deleteSale(String saleId) async {
    try {
      await _deleteSaleUseCase(id: saleId);
      _removeSaleFromState(saleId);
    } on NotFoundFailure {
      if (!isClosed) {
        _removeSaleFromState(saleId);
      }
      return;
    } on AppFailure {
      rethrow;
    } catch (_) {
      throw const UnknownFailure();
    }
  }

  void _removeSaleFromState(String saleId) {
    if (isClosed) return;
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
