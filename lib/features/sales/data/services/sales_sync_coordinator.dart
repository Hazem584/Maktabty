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
  String? _activeOwnerUserId;
  String? _authorizedOwnerUserId;
  String? _queuedOwnerUserId;

  SalesSyncCoordinator({
    required this._localDataSource,
    required this._remoteDataSource,
  });

  Stream<SalesSyncProgress> get progress => _progressController.stream;
  bool get isRunning => _activeRun != null;

  void setActiveOwner(String? ownerUserId) {
    if (_authorizedOwnerUserId == ownerUserId) return;
    _authorizedOwnerUserId = ownerUserId;
    if (_activeRun != null && _activeOwnerUserId != ownerUserId) {
      _queuedOwnerUserId = ownerUserId;
      _activeCancelToken?.cancel('Authenticated owner changed.');
    }
  }

  Future<void> sync(String ownerUserId) {
    if (_authorizedOwnerUserId != ownerUserId) {
      return Future.value();
    }
    final active = _activeRun;
    if (active != null) {
      if (_activeOwnerUserId != ownerUserId) {
        _queuedOwnerUserId = ownerUserId;
      }
      return active;
    }

    final run = _run(ownerUserId);
    _activeRun = run;
    _activeOwnerUserId = ownerUserId;
    return run.whenComplete(() {
      if (identical(_activeRun, run)) {
        _activeRun = null;
        _activeOwnerUserId = null;
        _activeCancelToken = null;
        final queuedOwner = _queuedOwnerUserId;
        _queuedOwnerUserId = null;
        if (queuedOwner != null && queuedOwner == _authorizedOwnerUserId) {
          unawaited(sync(queuedOwner));
        }
      }
    });
  }

  Future<void> _run(String ownerUserId) async {
    var processed = 0;
    _emit(const SalesSyncProgress(isSyncing: true));
    try {
      await _localDataSource.recoverStaleSyncing(ownerUserId: ownerUserId);
      for (
        var batchIndex = 0;
        batchIndex < _maximumBatchesPerRun;
        batchIndex++
      ) {
        if (_authorizedOwnerUserId != ownerUserId) return;
        final batch = await _localDataSource.claimPendingBatch(
          ownerUserId: ownerUserId,
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
          if (_authorizedOwnerUserId != ownerUserId) {
            await _localDataSource.markBatchRetryable(
              ids,
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
              ], errorCode: 'MISSING_SYNC_RESULT');
            } else {
              await _localDataSource.applySyncResult(result);
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
              errorCode: failure.code.name.toUpperCase(),
              message: failure.serverMessage,
            );
          } else {
            await _localDataSource.markBatchRetryable(
              ids,
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
