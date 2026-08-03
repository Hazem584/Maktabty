import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktabty/core/errors/app_failure.dart';
import 'package:maktabty/features/products/domain/entities/product_entity.dart';
import 'package:maktabty/features/products/domain/usecases/get_product_by_code_usecase.dart';
import 'package:maktabty/features/products/domain/usecases/get_product_by_id_usecase.dart';
import 'package:maktabty/features/products/presentation/cubit/product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  final GetProductByIdUseCase _getProductByIdUseCase;
  final GetProductByCodeUseCase _getProductByCodeUseCase;

  ProductDetailsCubit({
    required this._getProductByIdUseCase,
    required this._getProductByCodeUseCase,
  }) : super(ProductDetailsState.initial());

  Future<void> loadById(String id) async {
    if (isClosed) return;
    emit(
      state.copyWith(
        status: ProductDetailsStatus.loading,
        product: null,
        failure: null,
      ),
    );
    try {
      final product = await _getProductByIdUseCase(id);
      if (!isClosed) {
        emit(
          state.copyWith(
            status: ProductDetailsStatus.success,
            product: product,
            failure: null,
          ),
        );
      }
    } on AppFailure catch (failure) {
      if (!isClosed) {
        emit(
          state.copyWith(
            status: ProductDetailsStatus.failure,
            product: null,
            failure: failure,
          ),
        );
      }
    } catch (_) {
      if (!isClosed) {
        emit(
          state.copyWith(
            status: ProductDetailsStatus.failure,
            product: null,
            failure: const UnknownFailure(),
          ),
        );
      }
    }
  }

  Future<void> loadByCode(String code) async {
    if (isClosed) return;
    emit(
      state.copyWith(
        status: ProductDetailsStatus.loading,
        product: null,
        failure: null,
      ),
    );
    try {
      final product = await _getProductByCodeUseCase(code);
      if (!isClosed) {
        emit(
          state.copyWith(
            status: ProductDetailsStatus.success,
            product: product,
            failure: null,
          ),
        );
      }
    } on AppFailure catch (failure) {
      if (!isClosed) {
        emit(
          state.copyWith(
            status: ProductDetailsStatus.failure,
            product: null,
            failure: failure,
          ),
        );
      }
    } catch (_) {
      if (!isClosed) {
        emit(
          state.copyWith(
            status: ProductDetailsStatus.failure,
            product: null,
            failure: const UnknownFailure(),
          ),
        );
      }
    }
  }

  void setSelected(ProductEntity? product) {
    if (isClosed) return;
    emit(
      state.copyWith(
        status: ProductDetailsStatus.success,
        product: product,
        failure: null,
      ),
    );
  }
}
