import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktabty/core/errors/app_failure.dart';
import 'package:maktabty/features/suppliers/domain/entities/supplier_entities.dart';
import 'package:maktabty/features/suppliers/domain/usecases/supplier_usecases.dart';

enum SuppliersListStatus { initial, loading, success, failure }

class SuppliersListState extends Equatable {
  final SuppliersListStatus status;
  final List<SupplierEntity> items;
  final int page;
  final int limit;
  final int total;
  final String search;
  final bool? activeFilter;
  final bool loadingMore;
  final bool refreshing;
  final AppFailure? failure;
  const SuppliersListState({required this.status, required this.items, required this.page, required this.limit, required this.total, required this.search, required this.activeFilter, required this.loadingMore, required this.refreshing, this.failure});
  factory SuppliersListState.initial() => const SuppliersListState(status: SuppliersListStatus.initial, items: [], page: 1, limit: 20, total: 0, search: '', activeFilter: true, loadingMore: false, refreshing: false);
  bool get reachedEnd => items.length >= total && total > 0;
  SuppliersListState copyWith({SuppliersListStatus? status, List<SupplierEntity>? items, int? page, int? limit, int? total, String? search, Object? activeFilter = _unset, bool? loadingMore, bool? refreshing, Object? failure = _unset}) => SuppliersListState(status: status ?? this.status, items: items ?? this.items, page: page ?? this.page, limit: limit ?? this.limit, total: total ?? this.total, search: search ?? this.search, activeFilter: identical(activeFilter, _unset) ? this.activeFilter : activeFilter as bool?, loadingMore: loadingMore ?? this.loadingMore, refreshing: refreshing ?? this.refreshing, failure: identical(failure, _unset) ? this.failure : failure as AppFailure?);
  @override
  List<Object?> get props => [status, items, page, limit, total, search, activeFilter, loadingMore, refreshing, failure];
}

const _unset = Object();

class SuppliersListCubit extends Cubit<SuppliersListState> {
  final SupplierUseCases _useCases;
  Timer? _debounce;
  int _requestVersion = 0;
  SuppliersListCubit(this._useCases) : super(SuppliersListState.initial());

  Future<void> load({bool refresh = false}) => _fetch(page: 1, replace: true, refreshing: refresh);
  void search(String value) {
    final query = value.trim();
    emit(state.copyWith(search: query));
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () => _fetch(page: 1, replace: true));
  }
  void filter(bool? active) {
    emit(state.copyWith(activeFilter: active));
    _fetch(page: 1, replace: true);
  }
  Future<void> loadMore() async {
    if (state.loadingMore || state.reachedEnd || state.status == SuppliersListStatus.loading) return;
    await _fetch(page: state.page + 1, replace: false);
  }

  Future<void> _fetch({required int page, required bool replace, bool refreshing = false}) async {
    final version = ++_requestVersion;
    emit(state.copyWith(status: replace && !refreshing ? SuppliersListStatus.loading : state.status, items: replace && !refreshing ? const [] : state.items, loadingMore: !replace, refreshing: refreshing, failure: null));
    try {
      final result = await _useCases.getSuppliers(search: state.search.isEmpty ? null : state.search, isActive: state.activeFilter, page: page, limit: state.limit);
      if (isClosed || version != _requestVersion) return;
      emit(state.copyWith(status: SuppliersListStatus.success, items: replace ? result.items : [...state.items, ...result.items], page: result.page, limit: result.limit, total: result.total, loadingMore: false, refreshing: false, failure: null));
    } on AppFailure catch (failure) {
      if (!isClosed && version == _requestVersion) emit(state.copyWith(status: SuppliersListStatus.failure, loadingMore: false, refreshing: false, failure: failure));
    }
  }

  @override
  Future<void> close() { _debounce?.cancel(); return super.close(); }
}
