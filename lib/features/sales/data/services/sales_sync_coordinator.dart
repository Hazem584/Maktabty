import 'dart:async';

import 'package:dio/dio.dart';
import 'package:maktabty/core/errors/app_failure.dart';
import 'package:maktabty/core/network/app_failure_mapper.dart';
import 'package:maktabty/features/sales/data/datasources/sales_local_datasource.dart';
import 'package:maktabty/features/sales/data/datasources/sales_remote_datasource.dart';

class SalesSyncProgress {
  final bool isSyncing;
  final int processed;
  final int totalInRun;
  final FailureCode? lastFailureCode;

  const SalesSyncProgress({
    required this.isSyncing,
    this.processed = 0,
    this.totalInRun = 0,
    this.lastFailureCode,
  });
}

class SalesSyncCoordinator {
  static const int _maximumBatchesPerRun = 20;

  final SalesLocalDataSource _localDataSource;
  final SalesRemoteDataSource _remoteDataSource;
  final StreamController<SalesSyncProgress> _progressController =
      StreamController<SalesSyncProgress>.broadcast();

  Future<void>? _activeRun;
  CancelToken? _activeCancelToken;
  _SyncScope? _activeScope;
  _SyncScope? _authorizedScope;
  _SyncScope? _queuedScope;

  SalesSyncCoordinator({
    required this._localDataSource,
    required this._remoteDataSource,
  });

  Stream<SalesSyncProgress> get progress => _progressController.stream;
  bool get isRunning => _activeRun != null;

  void setActiveScope(String? storeId, String? ownerUserId) {
    final scope = storeId == null || ownerUserId == null
        ? null
        : _SyncScope(storeId, ownerUserId);
    if (_authorizedScope == scope) return;
    _authorizedScope = scope;
    if (_activeRun != null && _activeScope != scope) {
      _queuedScope = scope;
      _activeCancelToken?.cancel('Authenticated owner changed.');
    }
  }

  Future<void> sync({required String storeId, required String ownerUserId}) {
    final scope = _SyncScope(storeId, ownerUserId);
    if (_authorizedScope != scope) {
      return Future.value();
    }
    final active = _activeRun;
    if (active != null) {
      if (_activeScope != scope) {
        _queuedScope = scope;
      }
      return active;
    }

    final run = _run(scope);
    _activeRun = run;
    _activeScope = scope;
    return run.whenComplete(() {
      if (identical(_activeRun, run)) {
        _activeRun = null;
        _activeScope = null;
        _activeCancelToken = null;
        final queuedScope = _queuedScope;
        _queuedScope = null;
        if (queuedScope != null && queuedScope == _authorizedScope) {
          unawaited(
            sync(
              storeId: queuedScope.storeId,
              ownerUserId: queuedScope.ownerUserId,
            ),
          );
        }
      }
    });
  }

  Future<void> _run(_SyncScope scope) async {
    var processed = 0;
    _emit(const SalesSyncProgress(isSyncing: true));
    try {
      await _localDataSource.recoverStaleSyncing(
        storeId: scope.storeId,
        ownerUserId: scope.ownerUserId,
      );
      for (
        var batchIndex = 0;
        batchIndex < _maximumBatchesPerRun;
        batchIndex++
      ) {
        if (_authorizedScope != scope) return;
        final batch = await _localDataSource.claimPendingBatch(
          storeId: scope.storeId,
          ownerUserId: scope.ownerUserId,
        );
        if (batch.isEmpty) break;

        final ids = batch.map((sale) => sale.clientSaleId).toList();
        try {
          final cancelToken = CancelToken();
          _activeCancelToken = cancelToken;
          final response = await _remoteDataSource.syncSales(
            batch.map(_localDataSource.toSyncRequest).toList(growable: false),
            cancelToken: cancelToken,
          );
          if (_authorizedScope != scope) {
            await _localDataSource.markBatchRetryable(
              ids,
              storeId: scope.storeId,
              ownerUserId: scope.ownerUserId,
              errorCode: 'OWNER_CHANGED',
            );
            return;
          }
          final byClientId = {
            for (final result in response.results) result.clientSaleId: result,
          };
          for (final sale in batch) {
            final result = byClientId[sale.clientSaleId];
            if (result == null) {
              await _localDataSource.markBatchRetryable([
                sale.clientSaleId,
              ], storeId: scope.storeId, ownerUserId: scope.ownerUserId, errorCode: 'MISSING_SYNC_RESULT');
            } else {
              await _localDataSource.applySyncResult(
                result,
                storeId: scope.storeId,
                ownerUserId: scope.ownerUserId,
              );
            }
            processed++;
            _emit(
              SalesSyncProgress(
                isSyncing: true,
                processed: processed,
                totalInRun: processed + batch.length,
              ),
            );
          }
        } catch (error) {
          final failure = AppFailureMapper.fromException(error);
          if (_isPermanentBatchFailure(failure)) {
            await _localDataSource.markBatchPermanent(
              ids,
              storeId: scope.storeId,
              ownerUserId: scope.ownerUserId,
              errorCode: failure.code.name.toUpperCase(),
              message: failure.serverMessage,
            );
          } else {
            await _localDataSource.markBatchRetryable(
              ids,
              storeId: scope.storeId,
              ownerUserId: scope.ownerUserId,
              errorCode: failure.code.name.toUpperCase(),
              message: failure.serverMessage,
            );
          }
          _emit(
            SalesSyncProgress(
              isSyncing: false,
              processed: processed,
              totalInRun: processed + batch.length,
              lastFailureCode: failure.code,
            ),
          );
          return;
        }
      }
      _emit(
        SalesSyncProgress(
          isSyncing: false,
          processed: processed,
          totalInRun: processed,
        ),
      );
    } catch (error) {
      final failure = AppFailureMapper.fromException(error);
      _emit(
        SalesSyncProgress(
          isSyncing: false,
          processed: processed,
          totalInRun: processed,
          lastFailureCode: failure.code,
        ),
      );
    }
  }

  bool _isPermanentBatchFailure(AppFailure failure) {
    return failure.code == FailureCode.validation ||
        failure.code == FailureCode.forbidden;
  }

  void _emit(SalesSyncProgress progress) {
    if (!_progressController.isClosed) {
      _progressController.add(progress);
    }
  }

  Future<void> dispose() => _progressController.close();
}

class _SyncScope {
  final String storeId;
  final String ownerUserId;

  const _SyncScope(this.storeId, this.ownerUserId);

  @override
  bool operator ==(Object other) =>
      other is _SyncScope &&
      other.storeId == storeId &&
      other.ownerUserId == ownerUserId;

  @override
  int get hashCode => Object.hash(storeId, ownerUserId);
}
