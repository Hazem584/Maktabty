import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktabty/core/errors/app_failure.dart';
import 'package:maktabty/features/products/domain/usecases/create_product_usecase.dart';
import 'package:maktabty/features/products/domain/usecases/update_product_usecase.dart';
import 'package:maktabty/features/products/presentation/cubit/product_form_state.dart';

class ProductFormCubit extends Cubit<ProductFormState> {
  final CreateProductUseCase _createProductUseCase;
  final UpdateProductUseCase _updateProductUseCase;

  ProductFormCubit({
    required this._createProductUseCase,
    required UpdateProductUseCase updateProductUseCase,
  }) : _updateProductUseCase = updateProductUseCase,
       super(ProductFormState.initial());

  Future<void> createProduct({
    required String name,
    required double price,
    required int stock,
    String? code,
  }) async {
    if (state.status == ProductFormStatus.loading) return;
    if (isClosed) return;
    emit(
      state.copyWith(
        status: ProductFormStatus.loading,
        product: null,
        failure: null,
      ),
    );

    try {
      final product = await _createProductUseCase(
        name: name,
        price: price,
        stock: stock,
        code: code,
      );
      if (!isClosed) {
        emit(
          state.copyWith(
            status: ProductFormStatus.success,
            product: product,
            failure: null,
          ),
        );
      }
    } on AppFailure catch (failure) {
      if (!isClosed) {
        emit(
          state.copyWith(
            status: ProductFormStatus.failure,
            product: null,
            failure: failure,
          ),
        );
      }
    } catch (_) {
      if (!isClosed) {
        emit(
          state.copyWith(
            status: ProductFormStatus.failure,
            product: null,
            failure: const UnknownFailure(),
          ),
        );
      }
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
    if (isClosed) return;
    emit(
      state.copyWith(
        status: ProductFormStatus.loading,
        product: null,
        failure: null,
      ),
    );

    try {
      final product = await _updateProductUseCase(
        id: id,
        name: name,
        price: price,
        stock: stock,
        code: code,
      );
      if (!isClosed) {
        emit(
          state.copyWith(
            status: ProductFormStatus.success,
            product: product,
            failure: null,
          ),
        );
      }
    } on AppFailure catch (failure) {
      if (!isClosed) {
        emit(
          state.copyWith(
            status: ProductFormStatus.failure,
            product: null,
            failure: failure,
          ),
        );
      }
    } catch (_) {
      if (!isClosed) {
        emit(
          state.copyWith(
            status: ProductFormStatus.failure,
            product: null,
            failure: const UnknownFailure(),
          ),
        );
      }
    }
  }

  void reset() {
    if (!isClosed) emit(ProductFormState.initial());
  }
}
