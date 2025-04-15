// lib/core/services/platform/device_settings_service.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DeviceSettingsService {
  static const MethodChannel _channel = MethodChannel(
    'com.example.spaced_learning_app.device/optimization',
  );

  // Kiểm tra xem ứng dụng có quyền đặt alarm chính xác (Android 12+)
  Future<bool> hasExactAlarmPermission() async {
    if (!Platform.isAndroid) {
      return true; // Mặc định true cho các platform khác Android
    }

    try {
      final bool hasPermission = await _channel.invokeMethod(
        'hasExactAlarmPermission',
      );
      return hasPermission;
    } on PlatformException catch (e) {
      debugPrint('Error checking exact alarm permission: ${e.message}');
      return false;
    } on MissingPluginException {
      debugPrint('Device optimization plugin not available');
      return false;
    } catch (e) {
      debugPrint('Unexpected error checking exact alarm permission: $e');
      return false;
    }
  }

  // Kiểm tra xem ứng dụng có đang được bỏ qua tối ưu hóa pin
  Future<bool> isIgnoringBatteryOptimizations() async {
    if (!Platform.isAndroid) {
      return true; // Mặc định true cho các platform khác Android
    }

    try {
      final bool isIgnoring = await _channel.invokeMethod(
        'isIgnoringBatteryOptimizations',
      );
      return isIgnoring;
    } on PlatformException catch (e) {
      debugPrint('Error checking battery optimization status: ${e.message}');
      return false;
    } on MissingPluginException {
      debugPrint('Device optimization plugin not available');
      return false;
    } catch (e) {
      debugPrint('Unexpected error checking battery optimization: $e');
      return false;
    }
  }

  // Yêu cầu quyền đặt alarm chính xác (Android 12+)
  Future<bool> requestExactAlarmPermission() async {
    if (!Platform.isAndroid) {
      return true; // Mặc định true cho các platform khác Android
    }

    try {
      final bool result = await _channel.invokeMethod(
        'requestExactAlarmPermission',
      );
      return result;
    } on PlatformException catch (e) {
      debugPrint('Error requesting exact alarm permission: ${e.message}');
      return false;
    } on MissingPluginException {
      debugPrint('Device optimization plugin not available');
      return false;
    } catch (e) {
      debugPrint('Unexpected error requesting exact alarm permission: $e');
      return false;
    }
  }

  // Yêu cầu bỏ qua tối ưu hóa pin
  Future<bool> requestBatteryOptimization() async {
    if (!Platform.isAndroid) {
      return true; // Mặc định true cho các platform khác Android
    }

    try {
      final bool result = await _channel.invokeMethod(
        'requestBatteryOptimization',
      );
      return result;
    } on PlatformException catch (e) {
      debugPrint('Error requesting battery optimization: ${e.message}');
      return false;
    } on MissingPluginException {
      debugPrint('Device optimization plugin not available');
      return false;
    } catch (e) {
      debugPrint('Unexpected error requesting battery optimization: $e');
      return false;
    }
  }

  // Mở cài đặt để vô hiệu hóa ứng dụng ngủ (dành riêng cho các thiết bị cụ thể)
  Future<bool> disableSleepingApps() async {
    if (!Platform.isAndroid) {
      return true; // Mặc định true cho các platform khác Android
    }

    try {
      final bool result = await _channel.invokeMethod('disableSleepingApps');
      return result;
    } on PlatformException catch (e) {
      debugPrint('Error disabling sleeping apps: ${e.message}');
      return false;
    } on MissingPluginException {
      debugPrint('Device optimization plugin not available');
      return false;
    } catch (e) {
      debugPrint('Unexpected error disabling sleeping apps: $e');
      return false;
    }
  }

  // Lấy thông tin thiết bị
  Future<Map<String, dynamic>> getDeviceInfo() async {
    if (!Platform.isAndroid) {
      return {
        'sdkVersion': 0,
        'manufacturer': Platform.operatingSystem,
        'model': Platform.operatingSystemVersion,
      };
    }

    try {
      final Map<dynamic, dynamic> info = await _channel.invokeMethod(
        'getDeviceInfo',
      );
      return Map<String, dynamic>.from(info);
    } on PlatformException catch (e) {
      debugPrint('Error getting device info: ${e.message}');
      return {'sdkVersion': 0, 'manufacturer': 'Unknown', 'model': 'Unknown'};
    } on MissingPluginException {
      debugPrint('Device optimization plugin not available');
      return {'sdkVersion': 0, 'manufacturer': 'Unknown', 'model': 'Unknown'};
    } catch (e) {
      debugPrint('Unexpected error getting device info: $e');
      return {'sdkVersion': 0, 'manufacturer': 'Unknown', 'model': 'Unknown'};
    }
  }
}
