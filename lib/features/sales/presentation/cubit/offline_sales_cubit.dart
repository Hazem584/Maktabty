import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maktabty/core/network/app_failure_mapper.dart';
import 'package:maktabty/core/session/current_user_store.dart';
import 'package:maktabty/features/sales/data/datasources/sales_local_datasource.dart';
import 'package:maktabty/features/sales/data/services/connectivity_sync_trigger.dart';
import 'package:maktabty/features/sales/data/services/sales_sync_coordinator.dart';
import 'package:maktabty/features/sales/domain/entities/local_sale_entity.dart';
import 'package:maktabty/features/sales/domain/entities/receipt_entity.dart';
import 'package:maktabty/features/sales/domain/usecases/get_receipt_for_sale_usecase.dart';
import 'package:maktabty/features/sales/presentation/cubit/offline_sales_state.dart';

class OfflineSalesCubit extends Cubit<OfflineSalesState> {
  final SalesLocalDataSource _localDataSource;
  final SalesSyncCoordinator _coordinator;
  final ConnectivitySyncTrigger _connectivityTrigger;
  final CurrentUserStore _currentUserStore;
  final GetReceiptForSaleUseCase _getReceiptForSaleUseCase;

  StreamSubscription<List<LocalSaleEntity>>? _salesSubscription;
  StreamSubscription<SalesSyncProgress>? _progressSubscription;

  OfflineSalesCubit({
    required this._localDataSource,
    required this._coordinator,
    required this._connectivityTrigger,
    required this._currentUserStore,
    required this._getReceiptForSaleUseCase,
  }) : super(OfflineSalesState.initial()) {
    _progressSubscription = _coordinator.progress.listen((progress) {
      if (isClosed) return;
      emit(
        state.copyWith(
          isSyncing: progress.isSyncing,
          processed: progress.processed,
          lastSyncFailureCode: progress.lastFailureCode,
          clearFailure: progress.lastFailureCode == null,
        ),
      );
    });
  }

  Future<void> authenticate(String ownerUserId) async {
    if (isClosed || ownerUserId.isEmpty) return;
    _coordinator.setActiveOwner(ownerUserId);
    _currentUserStore.setUser(ownerUserId);
    await _salesSubscription?.cancel();
    final otherOwnerCount = await _localDataSource.unsyncedCountForOtherOwners(
      ownerUserId,
    );
    if (!isClosed) {
      emit(
        OfflineSalesState.initial().copyWith(
          ownerUserId: ownerUserId,
          otherOwnerUnsyncedCount: otherOwnerCount,
        ),
      );
    }
    _salesSubscription = _localDataSource
        .watchSalesForOwner(ownerUserId)
        .listen(
          (sales) {
            if (isClosed || state.ownerUserId != ownerUserId) return;
            final pendingCount = sales
                .where(
                  (sale) =>
                      sale.syncStatus == LocalSaleSyncStatus.pending ||
                      sale.syncStatus == LocalSaleSyncStatus.syncing,
                )
                .length;
            emit(state.copyWith(sales: sales, pendingCount: pendingCount));
          },
          onError: (Object error) {
            if (isClosed) return;
            final failure = AppFailureMapper.fromException(error);
            emit(state.copyWith(lastSyncFailureCode: failure.code));
          },
        );
    await _connectivityTrigger.start(ownerUserId);
    unawaited(_coordinator.sync(ownerUserId));
  }

  Future<void> signOut() async {
    _coordinator.setActiveOwner(null);
    _currentUserStore.clear();
    await _connectivityTrigger.stop();
    await _salesSubscription?.cancel();
    _salesSubscription = null;
    if (!isClosed) emit(OfflineSalesState.initial());
  }

  Future<void> syncNow() async {
    final owner = state.ownerUserId;
    if (owner == null || state.isSyncing) return;
    await _coordinator.sync(owner);
  }

  Future<bool> retry(String clientSaleId) async {
    final owner = state.ownerUserId;
    if (owner == null || state.isSyncing) return false;
    try {
      final queued = await _localDataSource.retrySale(
        clientSaleId: clientSaleId,
        ownerUserId: owner,
      );
      if (queued) unawaited(_coordinator.sync(owner));
      return queued;
    } catch (error) {
      final failure = AppFailureMapper.fromException(error);
      if (!isClosed) {
        emit(state.copyWith(lastSyncFailureCode: failure.code));
      }
      return false;
    }
  }

  Future<ReceiptEntity?> loadConfirmedReceipt(LocalSaleEntity sale) async {
    if (sale.syncStatus != LocalSaleSyncStatus.synced) return null;
    if (sale.confirmedReceipt != null) return sale.confirmedReceipt;
    final serverSaleId = sale.serverSaleId;
    if (serverSaleId == null || serverSaleId.isEmpty) return null;
    try {
      return await _getReceiptForSaleUseCase(serverSaleId);
    } catch (error) {
      final failure = AppFailureMapper.fromException(error);
      if (!isClosed) {
        emit(state.copyWith(lastSyncFailureCode: failure.code));
      }
      return null;
    }
  }

  @override
  Future<void> close() async {
    await _salesSubscription?.cancel();
    await _progressSubscription?.cancel();
    await _connectivityTrigger.stop();
    await super.close();
  }
}
