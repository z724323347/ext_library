mixin ApiClientMixin {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> fetch(Future<dynamic> Function() apiCall) async {
    _isLoading = true;
    await apiCall().whenComplete(() => _isLoading = false);
  }
}
