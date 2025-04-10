// lib/presentation/viewmodels/base_viewmodel.dart
import 'package:flutter/foundation.dart';

/// A base class for all ViewModels that provides common functionality
/// for loading state, error handling, and other shared behaviors.
abstract class BaseViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  DateTime? _lastUpdated;
  bool _isInitialized = false;
  bool _isRefreshing = false;

  /// Flag indicating if the ViewModel is currently loading data
  bool get isLoading => _isLoading;

  /// Error message if any operation has failed
  String? get errorMessage => _errorMessage;

  /// The time when data was last successfully updated
  DateTime? get lastUpdated => _lastUpdated;

  /// Flag indicating if the ViewModel has been initialized
  bool get isInitialized => _isInitialized;

  /// Flag indicating if a refresh operation is in progress
  bool get isRefreshing => _isRefreshing;

  /// Set the loading state and notify listeners if state changes
  void setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }

  /// Begin a loading operation with safe state management
  void beginLoading() {
    final wasLoading = _isLoading;
    _isLoading = true;
    if (!wasLoading) {
      notifyListeners();
    }
  }

  /// End a loading operation and notify listeners
  void endLoading() {
    _isLoading = false;
    notifyListeners();
  }

  /// Set the error message and notify listeners
  void setError(String? message) {
    if (_errorMessage != message) {
      _errorMessage = message;
      notifyListeners();
    }
  }

  /// Clear the error message if one exists and notify listeners
  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  /// Update the lastUpdated timestamp to now
  void updateLastUpdated() {
    _lastUpdated = DateTime.now();
  }

  /// Mark ViewModel as initialized
  void setInitialized(bool initialized) {
    if (_isInitialized != initialized) {
      _isInitialized = initialized;
      notifyListeners();
    }
  }

  /// Begin a refresh operation
  bool beginRefresh() {
    if (_isRefreshing) return false;
    _isRefreshing = true;
    beginLoading();
    return true;
  }

  /// End a refresh operation
  void endRefresh({bool successful = true}) {
    _isRefreshing = false;
    if (successful) {
      updateLastUpdated();
    }
    endLoading();
  }

  /// Handle loading error with consistent pattern
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

  /// Check if data should be refreshed based on last update time
  bool shouldRefresh({Duration threshold = const Duration(minutes: 5)}) {
    if (_lastUpdated == null) return true;
    final now = DateTime.now();
    return now.difference(_lastUpdated!) > threshold;
  }

  /// Safe execution of async operation with proper state management
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
