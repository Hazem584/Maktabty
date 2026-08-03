import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktabty/core/errors/app_failure.dart';
import 'package:maktabty/features/purchases/domain/entities/purchase_entities.dart';
import 'package:maktabty/features/purchases/domain/usecases/purchase_usecases.dart';

enum PurchasesListStatus { initial, loading, success, failure }
class PurchasesListState extends Equatable {
  final PurchasesListStatus status;
  final List<PurchaseInvoiceEntity> items;
  final int page;
  final int total;
  final bool loadingMore;
  final bool refreshing;
  final String search;
  final String? supplierId;
  final PurchaseStatus? filterStatus;
  final DateTime? from;
  final DateTime? to;
  final AppFailure? failure;
  const PurchasesListState({required this.status, required this.items, required this.page, required this.total, required this.loadingMore, required this.refreshing, required this.search, this.supplierId, this.filterStatus, this.from, this.to, this.failure});
  factory PurchasesListState.initial() => const PurchasesListState(status: PurchasesListStatus.initial, items: [], page: 1, total: 0, loadingMore: false, refreshing: false, search: '');
  bool get reachedEnd => total > 0 && items.length >= total;
  PurchasesListState copyWith({PurchasesListStatus? status, List<PurchaseInvoiceEntity>? items, int? page, int? total, bool? loadingMore, bool? refreshing, String? search, Object? supplierId = _none, Object? filterStatus = _none, Object? from = _none, Object? to = _none, Object? failure = _none}) => PurchasesListState(status: status ?? this.status, items: items ?? this.items, page: page ?? this.page, total: total ?? this.total, loadingMore: loadingMore ?? this.loadingMore, refreshing: refreshing ?? this.refreshing, search: search ?? this.search, supplierId: identical(supplierId, _none) ? this.supplierId : supplierId as String?, filterStatus: identical(filterStatus, _none) ? this.filterStatus : filterStatus as PurchaseStatus?, from: identical(from, _none) ? this.from : from as DateTime?, to: identical(to, _none) ? this.to : to as DateTime?, failure: identical(failure, _none) ? this.failure : failure as AppFailure?);
  @override List<Object?> get props => [status, items, page, total, loadingMore, refreshing, search, supplierId, filterStatus, from, to, failure];
}
const _none = Object();

class PurchasesListCubit extends Cubit<PurchasesListState> {
  final PurchaseUseCases _useCases;
  Timer? _debounce;
  int _version = 0;
  PurchasesListCubit(this._useCases) : super(PurchasesListState.initial());
  Future<void> load({bool refresh = false}) => _fetch(1, true, refresh: refresh);
  void search(String text) { emit(state.copyWith(search: text.trim())); _debounce?.cancel(); _debounce = Timer(const Duration(milliseconds: 350), () => _fetch(1, true)); }
  void filters({String? supplierId, PurchaseStatus? status, DateTime? from, DateTime? to}) { emit(state.copyWith(supplierId: supplierId, filterStatus: status, from: from, to: to)); _fetch(1, true); }
  Future<void> loadMore() async { if (state.loadingMore || state.reachedEnd || state.status == PurchasesListStatus.loading) return; await _fetch(state.page + 1, false); }
  Future<void> _fetch(int page, bool replace, {bool refresh = false}) async {
    final version = ++_version;
    emit(state.copyWith(status: replace && !refresh ? PurchasesListStatus.loading : state.status, items: replace && !refresh ? const [] : state.items, loadingMore: !replace, refreshing: refresh, failure: null));
    try {
      final result = await _useCases.getPurchases(supplierId: state.supplierId, status: state.filterStatus, search: state.search.isEmpty ? null : state.search, from: state.from, to: state.to, page: page, limit: 20);
      if (!isClosed && version == _version) emit(state.copyWith(status: PurchasesListStatus.success, items: replace ? result.items : [...state.items, ...result.items], page: result.page, total: result.total, loadingMore: false, refreshing: false, failure: null));
    } on AppFailure catch (failure) { if (!isClosed && version == _version) emit(state.copyWith(status: PurchasesListStatus.failure, loadingMore: false, refreshing: false, failure: failure)); }
  }
  @override Future<void> close() { _debounce?.cancel(); return super.close(); }
}
