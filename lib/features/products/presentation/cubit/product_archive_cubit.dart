import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktabty/core/errors/app_failure.dart';
import 'package:maktabty/features/products/domain/entities/product_entity.dart';
import 'package:maktabty/features/products/domain/usecases/archive_product_usecase.dart';
import 'package:maktabty/features/products/domain/usecases/get_product_by_id_usecase.dart';
import 'package:maktabty/features/products/domain/usecases/restore_product_usecase.dart';

enum ProductArchiveStatus { idle, submitting, archived, restored, conflict, failure }

enum ProductArchiveConflict {
  remainingStock,
  alreadyArchived,
  alreadyActive,
  unknown,
}

class ProductArchiveState extends Equatable {
  final ProductArchiveStatus status;
  final ProductEntity? product;
  final ProductArchiveConflict? conflict;
  final AppFailure? failure;

  const ProductArchiveState({
    required this.status,
    this.product,
    this.conflict,
    this.failure,
  });

  factory ProductArchiveState.idle() =>
      const ProductArchiveState(status: ProductArchiveStatus.idle);

  @override
  List<Object?> get props => [status, product, conflict, failure];
}

class ProductArchiveCubit extends Cubit<ProductArchiveState> {
  final ArchiveProductUseCase _archiveProduct;
  final RestoreProductUseCase _restoreProduct;
  final GetProductByIdUseCase _getProduct;

  ProductArchiveCubit({
    required this._archiveProduct,
    required RestoreProductUseCase restoreProduct,
    required this._getProduct,
  }) : _restoreProduct = restoreProduct,
       super(ProductArchiveState.idle());

  Future<void> archive(ArchiveProductInput input) async {
    if (state.status == ProductArchiveStatus.submitting) return;
    final reason = input.reason.trim();
    if (reason.isEmpty || reason.length > 1000) {
      emit(
        const ProductArchiveState(
          status: ProductArchiveStatus.failure,
          failure: ValidationFailure(),
        ),
      );
      return;
    }
    emit(const ProductArchiveState(status: ProductArchiveStatus.submitting));
    try {
      final product = await _archiveProduct(
        ArchiveProductInput(
          productId: input.productId,
          reason: reason,
          adjustStockToZero: input.adjustStockToZero,
        ),
      );
      if (!isClosed) {
        emit(
          ProductArchiveState(
            status: ProductArchiveStatus.archived,
            product: product,
          ),
        );
      }
    } on AppFailure catch (failure) {
      if (failure.code == FailureCode.conflict) {
        await _resolveArchiveConflict(input.productId, failure);
      } else if (!isClosed) {
        emit(
          ProductArchiveState(
            status: ProductArchiveStatus.failure,
            failure: failure,
          ),
        );
      }
    }
  }

  Future<void> restore(String productId) async {
    if (state.status == ProductArchiveStatus.submitting) return;
    emit(const ProductArchiveState(status: ProductArchiveStatus.submitting));
    try {
      final product = await _restoreProduct(id: productId);
      if (!isClosed) {
        emit(
          ProductArchiveState(
            status: ProductArchiveStatus.restored,
            product: product,
          ),
        );
      }
    } on AppFailure catch (failure) {
      if (failure.code == FailureCode.conflict) {
        await _resolveRestoreConflict(productId, failure);
      } else if (!isClosed) {
        emit(
          ProductArchiveState(
            status: ProductArchiveStatus.failure,
            failure: failure,
          ),
        );
      }
    }
  }

  Future<void> _resolveArchiveConflict(
    String productId,
    AppFailure failure,
  ) async {
    ProductEntity? current;
    try {
      current = await _getProduct(productId);
    } catch (_) {
      // The original conflict remains authoritative if refresh fails.
    }
    final message = failure.serverMessage?.toLowerCase() ?? '';
    final conflict = current?.isActive == false || message.contains('archived')
        ? ProductArchiveConflict.alreadyArchived
        : (current?.stock ?? 0) > 0 || message.contains('stock')
        ? ProductArchiveConflict.remainingStock
        : ProductArchiveConflict.unknown;
    if (!isClosed) {
      emit(
        ProductArchiveState(
          status: ProductArchiveStatus.conflict,
          product: current,
          conflict: conflict,
          failure: failure,
        ),
      );
    }
  }

  Future<void> _resolveRestoreConflict(
    String productId,
    AppFailure failure,
  ) async {
    ProductEntity? current;
    try {
      current = await _getProduct(productId);
    } catch (_) {
      // The original conflict remains authoritative if refresh fails.
    }
    final message = failure.serverMessage?.toLowerCase() ?? '';
    final conflict = current?.isActive == true || message.contains('active')
        ? ProductArchiveConflict.alreadyActive
        : ProductArchiveConflict.unknown;
    if (!isClosed) {
      emit(
        ProductArchiveState(
          status: ProductArchiveStatus.conflict,
          product: current,
          conflict: conflict,
          failure: failure,
        ),
      );
    }
  }

  void reset() {
    if (!isClosed) emit(ProductArchiveState.idle());
  }
}
