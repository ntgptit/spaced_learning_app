import 'package:flutter/material.dart';

class ScreenRefreshManager {
  static final ScreenRefreshManager _instance =
      ScreenRefreshManager._internal();

  factory ScreenRefreshManager() => _instance;

  ScreenRefreshManager._internal();

  final Map<String, List<VoidCallback>> _refreshCallbacks = {};

  void registerRefreshCallback(String screenPath, VoidCallback callback) {
    if (!_refreshCallbacks.containsKey(screenPath)) {
      _refreshCallbacks[screenPath] = [];
    }
    if (!_refreshCallbacks[screenPath]!.contains(callback)) {
      _refreshCallbacks[screenPath]!.add(callback);
    }
  }

  void unregisterRefreshCallback(String screenPath, VoidCallback callback) {
    if (_refreshCallbacks.containsKey(screenPath)) {
      _refreshCallbacks[screenPath]!.remove(callback);
      if (_refreshCallbacks[screenPath]!.isEmpty) {
        _refreshCallbacks.remove(screenPath);
      }
    }
  }

  void refreshScreen(String screenPath) {
    debugPrint('Refreshing screen: $screenPath');
    if (_refreshCallbacks.containsKey(screenPath)) {
      for (var callback in _refreshCallbacks[screenPath]!) {
        callback();
      }
    }
  }

  void refreshScreensWithPrefix(String prefix) {
    _refreshCallbacks.forEach((path, callbacks) {
      if (path.startsWith(prefix)) {
        debugPrint('Refreshing screen with prefix $prefix: $path');
        for (var callback in callbacks) {
          callback();
        }
      }
    });
  }

  void refreshAllScreens() {
    _refreshCallbacks.forEach((path, callbacks) {
      debugPrint('Refreshing all screens: $path');
      for (var callback in callbacks) {
        callback();
      }
    });
  }
}
