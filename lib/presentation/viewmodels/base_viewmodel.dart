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
    if (!_isLoading) {
      _isLoading = true;
      debugPrint('${runtimeType.toString()}: beginLoading()');
      notifyListeners();
    }
  }

  void endLoading() {
    if (_isLoading) {
      _isLoading = false;
      debugPrint('${runtimeType.toString()}: endLoading()');
      notifyListeners();
    }
  }

  void setError(String? message) {
    if (_errorMessage != message) {
      _errorMessage = message;
      debugPrint('${runtimeType.toString()}: setError($message)');
      notifyListeners();
    }
  }

  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      debugPrint('${runtimeType.toString()}: clearError()');
      notifyListeners();
    }
  }

  void updateLastUpdated() {
    _lastUpdated = DateTime.now();
    debugPrint('${runtimeType.toString()}: updateLastUpdated($_lastUpdated)');
  }

  void setInitialized(bool initialized) {
    if (_isInitialized != initialized) {
      _isInitialized = initialized;
      debugPrint('${runtimeType.toString()}: setInitialized($initialized)');
      notifyListeners();
    }
  }

  bool beginRefresh() {
    if (_isRefreshing) return false;

    _isRefreshing = true;
    beginLoading();
    debugPrint('${runtimeType.toString()}: beginRefresh()');
    return true;
  }

  void endRefresh({bool successful = true}) {
    _isRefreshing = false;
    if (successful) {
      updateLastUpdated();
    }
    endLoading();
    debugPrint(
      '${runtimeType.toString()}: endRefresh(successful: $successful)',
    );
  }

  void handleError(dynamic error, {String prefix = 'An error occurred'}) {
    final errorMessage = error is Exception
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

  /// Runs async operation safely with error handling, loading state management
  /// and optional timestamp updates
  ///
  /// [action] - The async function to execute
  /// [errorPrefix] - Prefix for error messages
  /// [handleLoading] - Whether to manage loading state
  /// [updateTimestamp] - Whether to update the lastUpdated timestamp
  Future<T?> safeCall<T>({
    required Future<T> Function() action,
    String errorPrefix = 'Operation failed',
    bool handleLoading = true,
    bool updateTimestamp = true,
    bool notifyAtStart = true,
  }) async {
    if (handleLoading) {
      _isLoading = true;
      if (notifyAtStart) {
        notifyListeners();
      }
    }

    clearError();
    if (notifyAtStart) {
      notifyListeners();
    }

    try {
      final result = await action();
      if (updateTimestamp) {
        updateLastUpdated();
      }
      return result;
    } catch (e) {
      handleError(e, prefix: errorPrefix);
      return null;
    } finally {
      if (handleLoading) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }
}
