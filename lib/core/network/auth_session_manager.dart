import 'dart:async';

import 'package:maktabty/core/errors/app_failure.dart';

enum AuthSessionEventType { expired, accountDisabled, refreshed }

class AuthSessionEvent {
  final AuthSessionEventType type;
  final int generation;
  final AppFailure? failure;

  const AuthSessionEvent._({
    required this.type,
    required this.generation,
    this.failure,
  });

  factory AuthSessionEvent.expired({
    required int generation,
    AppFailure failure = const UnauthorizedFailure(),
  }) {
    return AuthSessionEvent._(
      type: failure is AccountDisabledFailure
          ? AuthSessionEventType.accountDisabled
          : AuthSessionEventType.expired,
      generation: generation,
      failure: failure,
    );
  }

  factory AuthSessionEvent.refreshed({required int generation}) {
    return AuthSessionEvent._(
      type: AuthSessionEventType.refreshed,
      generation: generation,
    );
  }
}

class AuthSessionManager {
  final StreamController<AuthSessionEvent> _controller =
      StreamController<AuthSessionEvent>.broadcast();

  Future<void> _mutationQueue = Future<void>.value();
  int _generation = 0;

  Stream<AuthSessionEvent> get stream => _controller.stream;
  int get currentGeneration => _generation;

  bool isCurrent(int expectedGeneration) {
    return expectedGeneration == _generation;
  }

  Future<int> establishSession(
    Future<void> Function() persistSession,
  ) {
    return _synchronized(() async {
      _generation++;
      final establishedGeneration = _generation;
      await persistSession();
      return establishedGeneration;
    });
  }

  Future<int?> establishSessionIfCurrent({
    required int expectedGeneration,
    required Future<void> Function() persistSession,
  }) {
    return _synchronized(() async {
      if (!isCurrent(expectedGeneration)) return null;
      _generation++;
      final establishedGeneration = _generation;
      await persistSession();
      return establishedGeneration;
    });
  }

  Future<bool> updateSessionIfCurrent({
    required int expectedGeneration,
    required Future<void> Function() updateSession,
  }) {
    return _synchronized(() async {
      if (!isCurrent(expectedGeneration)) return false;
      await updateSession();
      return true;
    });
  }

  Future<bool> invalidateSessionIfCurrent({
    required int expectedGeneration,
    required Future<void> Function() clearSession,
    AppFailure failure = const UnauthorizedFailure(),
  }) {
    return _synchronized(() async {
      if (!isCurrent(expectedGeneration)) return false;

      _generation++;
      final invalidatedGeneration = _generation;
      await clearSession();
      if (!_controller.isClosed) {
        _controller.add(
          AuthSessionEvent.expired(
            generation: invalidatedGeneration,
            failure: failure,
          ),
        );
      }
      return true;
    });
  }

  Future<int> endSession(Future<void> Function() clearSession) {
    return _synchronized(() async {
      _generation++;
      final endedGeneration = _generation;
      await clearSession();
      return endedGeneration;
    });
  }

  void notifySessionRefreshed(int expectedGeneration) {
    if (isCurrent(expectedGeneration) && !_controller.isClosed) {
      _controller.add(
        AuthSessionEvent.refreshed(generation: expectedGeneration),
      );
    }
  }

  Future<void> dispose() {
    return _controller.close();
  }

  Future<T> _synchronized<T>(Future<T> Function() action) {
    final completer = Completer<T>();
    _mutationQueue = _mutationQueue.then((_) async {
      try {
        completer.complete(await action());
      } catch (error, stackTrace) {
        completer.completeError(error, stackTrace);
      }
    });
    return completer.future;
  }
}
