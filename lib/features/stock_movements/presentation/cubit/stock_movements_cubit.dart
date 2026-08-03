import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktabty/core/errors/app_failure.dart';
import 'package:maktabty/features/stock_movements/domain/entities/stock_movement_entities.dart';
import 'package:maktabty/features/stock_movements/domain/repositories/stock_movements_repository.dart';

enum StockMovementsStatus { initial, loading, success, failure }
class StockMovementsState extends Equatable {
  final StockMovementsStatus status;
  final List<StockMovementEntity> items;
  final int page;
  final int total;
  final bool loadingMore;
  final String? productId;
  final StockMovementType? type;
  final String? purchaseId;
  final String? saleId;
  final DateTime? from;
  final DateTime? to;
  final AppFailure? failure;
  const StockMovementsState({required this.status, required this.items, required this.page, required this.total, required this.loadingMore, this.productId, this.type, this.purchaseId, this.saleId, this.from, this.to, this.failure});
  factory StockMovementsState.initial() => const StockMovementsState(status: StockMovementsStatus.initial, items: [], page: 1, total: 0, loadingMore: false);
  StockMovementsState copyWith({StockMovementsStatus? status, List<StockMovementEntity>? items, int? page, int? total, bool? loadingMore, Object? productId = _marker, Object? type = _marker, Object? purchaseId = _marker, Object? saleId = _marker, Object? from = _marker, Object? to = _marker, Object? failure = _marker}) => StockMovementsState(status: status ?? this.status, items: items ?? this.items, page: page ?? this.page, total: total ?? this.total, loadingMore: loadingMore ?? this.loadingMore, productId: identical(productId, _marker) ? this.productId : productId as String?, type: identical(type, _marker) ? this.type : type as StockMovementType?, purchaseId: identical(purchaseId, _marker) ? this.purchaseId : purchaseId as String?, saleId: identical(saleId, _marker) ? this.saleId : saleId as String?, from: identical(from, _marker) ? this.from : from as DateTime?, to: identical(to, _marker) ? this.to : to as DateTime?, failure: identical(failure, _marker) ? this.failure : failure as AppFailure?);
  @override List<Object?> get props => [status, items, page, total, loadingMore, productId, type, purchaseId, saleId, from, to, failure];
}
const _marker = Object();

class StockMovementsCubit extends Cubit<StockMovementsState> {
  final StockMovementsRepository _repository;
  int _requestVersion = 0;
  StockMovementsCubit(this._repository) : super(StockMovementsState.initial());
  Future<void> load({bool replace = true}) async {
    if (state.loadingMore || (!replace && state.total > 0 && state.items.length >= state.total)) return;
    final version = ++_requestVersion;
    emit(state.copyWith(status: replace ? StockMovementsStatus.loading : state.status, items: replace ? const [] : state.items, loadingMore: !replace, failure: null));
    try {
      final result = await _repository.getMovements(productId: state.productId, type: state.type, purchaseInvoiceId: state.purchaseId, saleId: state.saleId, from: state.from, to: state.to, page: replace ? 1 : state.page + 1, limit: 20);
      if (!isClosed && version == _requestVersion) emit(state.copyWith(status: StockMovementsStatus.success, items: replace ? result.items : [...state.items, ...result.items], page: result.page, total: result.total, loadingMore: false));
    } on AppFailure catch (failure) { if (!isClosed && version == _requestVersion) emit(state.copyWith(status: StockMovementsStatus.failure, loadingMore: false, failure: failure)); }
  }
  void filters({String? productId, StockMovementType? type, String? purchaseId, String? saleId, DateTime? from, DateTime? to}) { emit(state.copyWith(productId: productId, type: type, purchaseId: purchaseId, saleId: saleId, from: from, to: to)); load(); }
}
