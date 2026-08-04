import 'dart:async';

enum AuthSessionEvent { expired, refreshed }

class AuthSessionManager {
  final StreamController<AuthSessionEvent> _controller =
      StreamController<AuthSessionEvent>.broadcast();

  Stream<AuthSessionEvent> get stream => _controller.stream;

  void notifySessionExpired() {
    if (!_controller.isClosed) {
      _controller.add(AuthSessionEvent.expired);
    }
  }

  void notifySessionRefreshed() {
    if (!_controller.isClosed) {
      _controller.add(AuthSessionEvent.refreshed);
    }
  }

  void dispose() {
    _controller.close();
  }
}
