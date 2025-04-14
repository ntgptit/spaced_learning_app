// lib/core/services/platform/device_settings_service.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DeviceSettingsService {
  static const MethodChannel _channel = MethodChannel(
    'com.example.spaced_learning_app.device/optimization',
  );

  // Kiểm tra xem ứng dụng có quyền đặt alarm chính xác (Android 12+)
  Future<bool> hasExactAlarmPermission() async {
    try {
      final bool hasPermission = await _channel.invokeMethod(
        'hasExactAlarmPermission',
      );
      return hasPermission;
    } on PlatformException catch (e) {
      debugPrint('Error checking exact alarm permission: ${e.message}');
      return false;
    }
  }

  // Kiểm tra xem ứng dụng có đang được bỏ qua tối ưu hóa pin
  Future<bool> isIgnoringBatteryOptimizations() async {
    try {
      final bool isIgnoring = await _channel.invokeMethod(
        'isIgnoringBatteryOptimizations',
      );
      return isIgnoring;
    } on PlatformException catch (e) {
      debugPrint('Error checking battery optimization status: ${e.message}');
      return false;
    }
  }

  // Yêu cầu quyền đặt alarm chính xác (Android 12+)
  Future<bool> requestExactAlarmPermission() async {
    try {
      final bool result = await _channel.invokeMethod(
        'requestExactAlarmPermission',
      );
      return result;
    } on PlatformException catch (e) {
      debugPrint('Error requesting exact alarm permission: ${e.message}');
      return false;
    }
  }

  // Yêu cầu bỏ qua tối ưu hóa pin
  Future<bool> requestBatteryOptimization() async {
    try {
      final bool result = await _channel.invokeMethod(
        'requestBatteryOptimization',
      );
      return result;
    } on PlatformException catch (e) {
      debugPrint('Error requesting battery optimization: ${e.message}');
      return false;
    }
  }

  // Mở cài đặt để vô hiệu hóa ứng dụng ngủ (dành riêng cho các thiết bị cụ thể)
  Future<bool> disableSleepingApps() async {
    try {
      final bool result = await _channel.invokeMethod('disableSleepingApps');
      return result;
    } on PlatformException catch (e) {
      debugPrint('Error disabling sleeping apps: ${e.message}');
      return false;
    }
  }

  // Lấy thông tin thiết bị
  Future<Map<String, dynamic>> getDeviceInfo() async {
    try {
      final Map<dynamic, dynamic> info = await _channel.invokeMethod(
        'getDeviceInfo',
      );
      return Map<String, dynamic>.from(info);
    } on PlatformException catch (e) {
      debugPrint('Error getting device info: ${e.message}');
      return {};
    }
  }
}
