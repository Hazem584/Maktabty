import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:maktabty/features/sales/data/services/sales_sync_coordinator.dart';

class ConnectivitySyncTrigger {
  final Connectivity _connectivity;
  final SalesSyncCoordinator _coordinator;

  StreamSubscription<List<ConnectivityResult>>? _subscription;
  String? _ownerUserId;

  ConnectivitySyncTrigger({
    required SalesSyncCoordinator coordinator,
    Connectivity? connectivity,
  }) : _coordinator = coordinator,
       _connectivity = connectivity ?? Connectivity();

  Future<void> start(String ownerUserId) async {
    _ownerUserId = ownerUserId;
    _subscription ??= _connectivity.onConnectivityChanged.listen(_onChanged);
    final current = await _connectivity.checkConnectivity();
    if (_hasNetworkInterface(current)) {
      unawaited(_coordinator.sync(ownerUserId));
    }
  }

  Future<void> stop() async {
    _ownerUserId = null;
    await _subscription?.cancel();
    _subscription = null;
  }

  void _onChanged(List<ConnectivityResult> results) {
    final owner = _ownerUserId;
    if (owner != null && _hasNetworkInterface(results)) {
      unawaited(_coordinator.sync(owner));
    }
  }

  bool _hasNetworkInterface(List<ConnectivityResult> results) {
    return results.isNotEmpty &&
        results.any((result) => result != ConnectivityResult.none);
  }

  Future<void> dispose() => stop();
}
