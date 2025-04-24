// lib/presentation/viewmodels/base_viewmodel.dart
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Base AsyncNotifier class that extends all common functionality
// for viewmodels with async operations
class BaseAsyncNotifier<T> extends AsyncNotifier<T> {
  @override
  Future<T> build() {
    // TODO: implement build
    throw UnimplementedError();
  }

  DateTime? lastUpdated;
  bool _isRefreshing = false;

  Future<void> refresh() async {
    if (_isRefreshing) return;

    _isRefreshing = true;
    state = const AsyncValue.loading();

    try {
      final result = await build();
      lastUpdated = DateTime.now();
      state = AsyncValue.data(result);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    } finally {
      _isRefreshing = false;
    }
  }

  Future<R> executeTask<R>(
    Future<R> Function() task, {
    bool updateOnSuccess = true,
    bool handleLoading = true,
  }) async {
    if (handleLoading) {
      state = const AsyncValue.loading();
    }

    try {
      final result = await task();
      if (updateOnSuccess) {
        lastUpdated = DateTime.now();
        await refresh();
      }
      return result;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  bool shouldRefresh({Duration threshold = const Duration(minutes: 5)}) {
    if (lastUpdated == null) return true;
    final now = DateTime.now();
    return now.difference(lastUpdated!) > threshold;
  }
}

// Mixin for notifiers that need error handling
mixin ErrorHandling {
  String? errorMessage;

  void setError(String? message) {
    errorMessage = message;
    debugPrint('${runtimeType.toString()}: setError($message)');
  }

  void clearError() {
    errorMessage = null;
    debugPrint('${runtimeType.toString()}: clearError()');
  }

  void handleError(dynamic error, {String prefix = 'An error occurred'}) {
    final errorMessage = error is Exception
        ? '$prefix: ${error.toString()}'
        : '$prefix: ${error.toString()}';

    debugPrint('Error in ${runtimeType.toString()}: $errorMessage');
    setError(errorMessage);
  }
}
