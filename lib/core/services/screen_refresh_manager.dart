// lib/core/services/screen_refresh_manager.dart
import 'package:flutter/material.dart';

class ScreenRefreshManager {
  static final ScreenRefreshManager _instance =
      ScreenRefreshManager._internal();

  factory ScreenRefreshManager() => _instance;

  ScreenRefreshManager._internal();

  // Lưu trữ các callback refresh cho mỗi screen path
  final Map<String, List<VoidCallback>> _refreshCallbacks = {};

  // Đăng ký callback refresh cho một screen path
  void registerRefreshCallback(String screenPath, VoidCallback callback) {
    if (!_refreshCallbacks.containsKey(screenPath)) {
      _refreshCallbacks[screenPath] = [];
    }
    if (!_refreshCallbacks[screenPath]!.contains(callback)) {
      _refreshCallbacks[screenPath]!.add(callback);
    }
  }

  // Hủy đăng ký callback refresh
  void unregisterRefreshCallback(String screenPath, VoidCallback callback) {
    if (_refreshCallbacks.containsKey(screenPath)) {
      _refreshCallbacks[screenPath]!.remove(callback);
      if (_refreshCallbacks[screenPath]!.isEmpty) {
        _refreshCallbacks.remove(screenPath);
      }
    }
  }

  // Gọi tất cả callback refresh cho một screen path
  void refreshScreen(String screenPath) {
    debugPrint('Refreshing screen: $screenPath');
    if (_refreshCallbacks.containsKey(screenPath)) {
      for (var callback in _refreshCallbacks[screenPath]!) {
        callback();
      }
    }
  }

  // Gọi tất cả callback refresh cho tất cả các screen path bắt đầu bằng prefix
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

  // Gọi tất cả callback refresh cho tất cả các screen
  void refreshAllScreens() {
    _refreshCallbacks.forEach((path, callbacks) {
      debugPrint('Refreshing all screens: $path');
      for (var callback in callbacks) {
        callback();
      }
    });
  }
}
