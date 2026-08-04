import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:maktabty/features/sales/data/services/sales_sync_coordinator.dart';

class ConnectivitySyncTrigger {
  final Connectivity _connectivity;
  final SalesSyncCoordinator _coordinator;

  StreamSubscription<List<ConnectivityResult>>? _subscription;
  String? _ownerUserId;
  String? _storeId;

  ConnectivitySyncTrigger({
    required this._coordinator,
    Connectivity? connectivity,
  }) : _connectivity = connectivity ?? Connectivity();

  Future<void> start({required String storeId, required String ownerUserId}) async {
    _storeId = storeId;
    _ownerUserId = ownerUserId;
    _subscription ??= _connectivity.onConnectivityChanged.listen(_onChanged);
    final current = await _connectivity.checkConnectivity();
    if (_hasNetworkInterface(current)) {
      unawaited(_coordinator.sync(storeId: storeId, ownerUserId: ownerUserId));
    }
  }

  Future<void> stop() async {
    _ownerUserId = null;
    _storeId = null;
    await _subscription?.cancel();
    _subscription = null;
  }

  void _onChanged(List<ConnectivityResult> results) {
    final owner = _ownerUserId;
    final store = _storeId;
    if (owner != null && store != null && _hasNetworkInterface(results)) {
      unawaited(_coordinator.sync(storeId: store, ownerUserId: owner));
    }
  }

  bool _hasNetworkInterface(List<ConnectivityResult> results) {
    return results.isNotEmpty &&
        results.any((result) => result != ConnectivityResult.none);
  }

  Future<void> dispose() => stop();
}
