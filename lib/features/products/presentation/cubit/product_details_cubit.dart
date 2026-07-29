import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktabty/core/network/api_exceptions.dart';
import 'package:maktabty/features/products/domain/entities/product_entity.dart';
import 'package:maktabty/features/products/domain/usecases/get_product_by_code_usecase.dart';
import 'package:maktabty/features/products/domain/usecases/get_product_by_id_usecase.dart';
import 'package:maktabty/features/products/presentation/cubit/product_details_state.dart';
import 'package:maktabty/features/products/presentation/cubit/products_error_mapper.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  final GetProductByIdUseCase _getProductByIdUseCase;
  final GetProductByCodeUseCase _getProductByCodeUseCase;

  ProductDetailsCubit({
    required GetProductByIdUseCase getProductByIdUseCase,
    required GetProductByCodeUseCase getProductByCodeUseCase,
  }) : _getProductByIdUseCase = getProductByIdUseCase,
       _getProductByCodeUseCase = getProductByCodeUseCase,
       super(ProductDetailsState.initial());

  Future<void> loadById(String id) async {
    emit(state.copyWith(status: ProductDetailsStatus.loading, message: null));
    try {
      final product = await _getProductByIdUseCase(id);
      emit(
        state.copyWith(status: ProductDetailsStatus.success, product: product),
      );
    } on ApiException catch (error) {
      emit(
        state.copyWith(
          status: ProductDetailsStatus.failure,
          message: mapProductError(error),
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: ProductDetailsStatus.failure,
          message: 'Something went wrong. Please try again.',
        ),
      );
    }
  }

  Future<void> loadByCode(String code) async {
    emit(state.copyWith(status: ProductDetailsStatus.loading, message: null));
    try {
      final product = await _getProductByCodeUseCase(code);
      emit(
        state.copyWith(status: ProductDetailsStatus.success, product: product),
      );
    } on ApiException catch (error) {
      emit(
        state.copyWith(
          status: ProductDetailsStatus.failure,
          message: mapProductError(error),
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: ProductDetailsStatus.failure,
          message: 'Something went wrong. Please try again.',
        ),
      );
    }
  }

  void setSelected(ProductEntity? product) {
    emit(
      state.copyWith(
        status: ProductDetailsStatus.success,
        product: product,
        message: null,
      ),
    );
  }
}
