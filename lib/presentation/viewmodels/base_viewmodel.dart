import 'package:flutter/foundation.dart';

abstract class BaseViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  DateTime? _lastUpdated;
  bool _isInitialized = false;
  bool _isRefreshing = false;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  DateTime? get lastUpdated => _lastUpdated;

  bool get isInitialized => _isInitialized;

  bool get isRefreshing => _isRefreshing;

  void setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }

  void beginLoading() {
    final wasLoading = _isLoading;
    _isLoading = true;
    if (!wasLoading) {
      notifyListeners();
    }
  }

  void endLoading() {
    _isLoading = false;
    notifyListeners();
  }

  void setError(String? message) {
    if (_errorMessage != message) {
      _errorMessage = message;
      notifyListeners();
    }
  }

  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  void updateLastUpdated() {
    _lastUpdated = DateTime.now();
  }

  void setInitialized(bool initialized) {
    if (_isInitialized != initialized) {
      _isInitialized = initialized;
      notifyListeners();
    }
  }

  bool beginRefresh() {
    if (_isRefreshing) return false;
    _isRefreshing = true;
    beginLoading();
    return true;
  }

  void endRefresh({bool successful = true}) {
    _isRefreshing = false;
    if (successful) {
      updateLastUpdated();
    }
    endLoading();
  }

  void handleError(dynamic error, {String prefix = 'An error occurred'}) {
    final errorMessage =
        error is Exception
            ? '$prefix: ${error.toString()}'
            : '$prefix: ${error.toString()}';

    debugPrint('Error in ${runtimeType.toString()}: $errorMessage');
    setError(errorMessage);
    _isLoading = false;
    _isRefreshing = false;
    notifyListeners();
  }

  bool shouldRefresh({Duration threshold = const Duration(minutes: 5)}) {
    if (_lastUpdated == null) return true;
    final now = DateTime.now();
    return now.difference(_lastUpdated!) > threshold;
  }

  Future<T?> safeCall<T>({
    required Future<T> Function() action,
    String errorPrefix = 'Operation failed',
    bool handleLoading = true,
    bool updateTimestamp = true,
  }) async {
    if (handleLoading) beginLoading();
    clearError();

    try {
      final result = await action();
      if (updateTimestamp) updateLastUpdated();
      return result;
    } catch (e) {
      handleError(e, prefix: errorPrefix);
      return null;
    } finally {
      if (handleLoading) endLoading();
    }
  }
}
