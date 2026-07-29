import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktabty/core/network/api_exceptions.dart';
import 'package:maktabty/features/products/domain/usecases/create_product_usecase.dart';
import 'package:maktabty/features/products/domain/usecases/update_product_usecase.dart';
import 'package:maktabty/features/products/presentation/cubit/product_form_state.dart';
import 'package:maktabty/features/products/presentation/cubit/products_error_mapper.dart';

class ProductFormCubit extends Cubit<ProductFormState> {
  final CreateProductUseCase _createProductUseCase;
  final UpdateProductUseCase _updateProductUseCase;

  ProductFormCubit({
    required CreateProductUseCase createProductUseCase,
    required UpdateProductUseCase updateProductUseCase,
  }) : _createProductUseCase = createProductUseCase,
       _updateProductUseCase = updateProductUseCase,
       super(ProductFormState.initial());

  Future<void> createProduct({
    required String name,
    required double price,
    required int stock,
    String? code,
  }) async {
    if (state.status == ProductFormStatus.loading) return;
    emit(state.copyWith(status: ProductFormStatus.loading, message: null));

    try {
      final product = await _createProductUseCase(
        name: name,
        price: price,
        stock: stock,
        code: code,
      );
      emit(state.copyWith(status: ProductFormStatus.success, product: product));
    } on ApiException catch (error) {
      emit(
        state.copyWith(
          status: ProductFormStatus.failure,
          message: mapProductError(error),
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: ProductFormStatus.failure,
          message: 'Something went wrong. Please try again.',
        ),
      );
    }
  }

  Future<void> updateProduct({
    required String id,
    String? name,
    double? price,
    int? stock,
    String? code,
  }) async {
    if (state.status == ProductFormStatus.loading) return;
    emit(state.copyWith(status: ProductFormStatus.loading, message: null));

    try {
      final product = await _updateProductUseCase(
        id: id,
        name: name,
        price: price,
        stock: stock,
        code: code,
      );
      emit(state.copyWith(status: ProductFormStatus.success, product: product));
    } on ApiException catch (error) {
      emit(
        state.copyWith(
          status: ProductFormStatus.failure,
          message: mapProductError(error),
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: ProductFormStatus.failure,
          message: 'Something went wrong. Please try again.',
        ),
      );
    }
  }

  void reset() {
    emit(ProductFormState.initial());
  }
}
