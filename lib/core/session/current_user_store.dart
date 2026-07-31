class CurrentUserStore {
  String? _userId;

  String? get userId => _userId;

  void setUser(String userId) {
    _userId = userId;
  }

  void clear() {
    _userId = null;
  }
}
