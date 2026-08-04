class CurrentUserStore {
  String? _userId;
  String? _storeId;

  String? get userId => _userId;
  String? get storeId => _storeId;
  bool get hasTrustedScope =>
      _userId?.isNotEmpty == true && _storeId?.isNotEmpty == true;

  void setUser({required String userId, required String storeId}) {
    if (userId.isEmpty || storeId.isEmpty) return;
    _userId = userId;
    _storeId = storeId;
  }

  void clear() {
    _userId = null;
    _storeId = null;
  }
}
