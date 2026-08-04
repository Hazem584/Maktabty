import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktabty/core/errors/app_failure.dart';
import 'package:maktabty/core/utils/copy_with_sentinel.dart';
import 'package:maktabty/features/cashiers/domain/entities/cashier_entity.dart';
import 'package:maktabty/features/cashiers/domain/usecases/cashier_usecases.dart';

enum CashiersListStatus { initial, loading, success, failure }

class CashiersListState extends Equatable {
  final CashiersListStatus status;
  final List<CashierEntity> items;
  final int page;
  final int limit;
  final int total;
  final String search;
  final bool? activeFilter;
  final bool loadingMore;
  final bool refreshing;
  final AppFailure? failure;

  const CashiersListState({required this.status, required this.items, required this.page, required this.limit, required this.total, required this.search, required this.activeFilter, required this.loadingMore, required this.refreshing, this.failure});

  factory CashiersListState.initial() => const CashiersListState(status: CashiersListStatus.initial, items: [], page: 1, limit: 20, total: 0, search: '', activeFilter: null, loadingMore: false, refreshing: false);

  bool get reachedEnd => total > 0 && items.length >= total;

  CashiersListState copyWith({CashiersListStatus? status, List<CashierEntity>? items, int? page, int? limit, int? total, String? search, Object? activeFilter = stateFieldUnchanged, bool? loadingMore, bool? refreshing, Object? failure = stateFieldUnchanged}) => CashiersListState(status: status ?? this.status, items: items ?? this.items, page: page ?? this.page, limit: limit ?? this.limit, total: total ?? this.total, search: search ?? this.search, activeFilter: identical(activeFilter, stateFieldUnchanged) ? this.activeFilter : activeFilter as bool?, loadingMore: loadingMore ?? this.loadingMore, refreshing: refreshing ?? this.refreshing, failure: identical(failure, stateFieldUnchanged) ? this.failure : failure as AppFailure?);

  @override
  List<Object?> get props => [status, items, page, limit, total, search, activeFilter, loadingMore, refreshing, failure];
}

class CashiersListCubit extends Cubit<CashiersListState> {
  final CashierUseCases _useCases;
  Timer? _debounce;
  int _requestVersion = 0;

  CashiersListCubit(this._useCases) : super(CashiersListState.initial());

  Future<void> load({bool refresh = false}) => _fetch(page: 1, replace: true, refreshing: refresh);

  void search(String value) {
    final query = value.trim();
    if (query == state.search || isClosed) return;
    emit(state.copyWith(search: query));
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (!isClosed) _fetch(page: 1, replace: true);
    });
  }

  void filter(bool? active) {
    if (active == state.activeFilter || isClosed) return;
    emit(state.copyWith(activeFilter: active));
    _fetch(page: 1, replace: true);
  }

  Future<void> loadMore() async {
    if (state.loadingMore || state.reachedEnd || state.status == CashiersListStatus.loading) return;
    await _fetch(page: state.page + 1, replace: false);
  }

  Future<void> _fetch({required int page, required bool replace, bool refreshing = false}) async {
    final version = ++_requestVersion;
    emit(state.copyWith(status: replace && !refreshing ? CashiersListStatus.loading : state.status, items: replace && !refreshing ? const [] : state.items, loadingMore: !replace, refreshing: refreshing, failure: null));
    try {
      final result = await _useCases.getCashiers(search: state.search.isEmpty ? null : state.search, isActive: state.activeFilter, page: page, limit: state.limit);
      if (isClosed || version != _requestVersion) return;
      emit(state.copyWith(status: CashiersListStatus.success, items: replace ? result.items : [...state.items, ...result.items], page: result.page, limit: result.limit, total: result.total, loadingMore: false, refreshing: false, failure: null));
    } on AppFailure catch (failure) {
      if (!isClosed && version == _requestVersion) emit(state.copyWith(status: CashiersListStatus.failure, loadingMore: false, refreshing: false, failure: failure));
    } catch (_) {
      if (!isClosed && version == _requestVersion) emit(state.copyWith(status: CashiersListStatus.failure, loadingMore: false, refreshing: false, failure: const UnknownFailure()));
    }
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
