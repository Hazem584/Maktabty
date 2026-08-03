import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktabty/core/errors/app_failure.dart';
import 'package:maktabty/features/purchases/domain/entities/purchase_entities.dart';
import 'package:maktabty/features/purchases/domain/usecases/purchase_usecases.dart';
import 'package:maktabty/features/suppliers/domain/entities/supplier_entities.dart';
import 'package:maktabty/features/suppliers/domain/usecases/supplier_usecases.dart';

enum SupplierDetailsStatus { initial, loading, success, failure }
class SupplierDetailsState extends Equatable {
  final SupplierDetailsStatus status;
  final SupplierEntity? supplier;
  final SupplierStatementEntity? statement;
  final List<SupplierPaymentEntity> payments;
  final List<PurchaseInvoiceEntity> purchases;
  final AppFailure? failure;
  const SupplierDetailsState({required this.status, this.supplier, this.statement, this.payments = const [], this.purchases = const [], this.failure});
  @override List<Object?> get props => [status, supplier, statement, payments, purchases, failure];
}

class SupplierDetailsCubit extends Cubit<SupplierDetailsState> {
  final SupplierUseCases _suppliers;
  final PurchaseUseCases _purchases;
  SupplierDetailsCubit(this._suppliers, this._purchases) : super(const SupplierDetailsState(status: SupplierDetailsStatus.initial));
  Future<void> load(String id, {DateTime? from, DateTime? to}) async {
    emit(SupplierDetailsState(status: SupplierDetailsStatus.loading, supplier: state.supplier, statement: state.statement, payments: state.payments, purchases: state.purchases));
    try {
      final values = await Future.wait<Object>([_suppliers.getSupplier(id), _suppliers.getStatement(id, from: from, to: to), _suppliers.getPayments(id), _purchases.getPurchases(supplierId: id, page: 1, limit: 20)]);
      if (!isClosed) emit(SupplierDetailsState(status: SupplierDetailsStatus.success, supplier: values[0] as SupplierEntity, statement: values[1] as SupplierStatementEntity, payments: values[2] as List<SupplierPaymentEntity>, purchases: (values[3] as PaginatedPurchasesEntity).items));
    } on AppFailure catch (failure) { if (!isClosed) emit(SupplierDetailsState(status: SupplierDetailsStatus.failure, supplier: state.supplier, statement: state.statement, payments: state.payments, purchases: state.purchases, failure: failure)); }
  }
}
