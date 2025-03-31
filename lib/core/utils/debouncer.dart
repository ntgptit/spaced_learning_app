import 'dart:async';

import 'package:flutter/foundation.dart';

/// A class that provides functionality to debounce operations
/// This helps prevent rapid successive calls to expensive operations
class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  /// Run the specified callback after waiting for the debounce duration
  /// If run is called again before the duration completes, the timer resets
  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  /// Cancel any pending operations
  void cancel() {
    _timer?.cancel();
  }

  /// Clean up resources when no longer needed
  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}
