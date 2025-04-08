// lib/core/services/reminder/device_specific_service.dart
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

/// Service for handling device-specific optimizations, particularly for Samsung devices
class DeviceSpecificService {
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  // Device info
  bool _isSamsungDevice = false;
  bool _isS23Ultra = false;
  String? _deviceModel;
  String? _manufacturer;
  int _sdkVersion = 0;
  bool _isInitialized = false;

  /// Initialize the service and detect device type
  Future<bool> initialize() async {
    if (_isInitialized) return true;

    try {
      // Check if we're on Android
      if (isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;

        // Store basic device info
        _deviceModel = androidInfo.model;
        _manufacturer = androidInfo.manufacturer;
        _sdkVersion = androidInfo.version.sdkInt;

        _isSamsungDevice = _manufacturer?.toLowerCase() == 'samsung';

        // Check if it's S23 Ultra
        _isS23Ultra =
            _isSamsungDevice &&
            (_deviceModel?.toLowerCase().contains('sm-s918') ?? false);

        debugPrint(
          'Device detected: $_manufacturer $_deviceModel (SDK: $_sdkVersion)',
        );

        // Apply optimizations based on device type
        if (_isSamsungDevice) {
          await _applySamsungOptimizations();
        } else {
          await _applyGeneralOptimizations();
        }

        _isInitialized = true;
        return true;
      } else {
        // Not Android, mark as initialized but don't apply Android-specific optimizations
        _isInitialized = true;
        return true;
      }
    } catch (e) {
      debugPrint('Error detecting device: $e');
      return false;
    }
  }

  /// Apply Samsung-specific optimizations
  Future<void> _applySamsungOptimizations() async {
    try {
      // Request battery optimization exclusion (works for all devices)
      final bool batteryOptResult =
          await _requestBatteryOptimizationExclusion();
      debugPrint('Battery optimization request result: $batteryOptResult');

      // Samsung-specific features
      if (_isS23Ultra) {
        final bool s23Result = await _configureS23UltraFeatures();
        debugPrint('S23 Ultra specific optimizations result: $s23Result');
      } else {
        // For other Samsung devices
        final bool samsungResult = await _configureGeneralSamsungFeatures();
        debugPrint('General Samsung optimizations result: $samsungResult');
      }
    } catch (e) {
      debugPrint('Error applying Samsung optimizations: $e');
    }
  }

  /// Apply optimizations for non-Samsung devices
  Future<void> _applyGeneralOptimizations() async {
    try {
      // Request battery optimization exclusion
      final bool batteryOptResult =
          await _requestBatteryOptimizationExclusion();
      debugPrint('Battery optimization request result: $batteryOptResult');

      // Apply optimizations based on Android version
      if (_sdkVersion >= 31) {
        // Android 12+
        final bool android12Result = await _configureAndroid12Features();
        debugPrint('Android 12+ optimizations result: $android12Result');
      } else if (_sdkVersion >= 26) {
        // Android 8-11
        final bool olderAndroidResult = await _configureOlderAndroidFeatures();
        debugPrint('Android 8-11 optimizations result: $olderAndroidResult');
      }
    } catch (e) {
      debugPrint('Error applying general optimizations: $e');
    }
  }

  /// Configure features for older Android versions
  Future<bool> _configureOlderAndroidFeatures() async {
    // No special config needed, but can be used for version-specific needs
    debugPrint('Configuring for Android $_sdkVersion');
    return true;
  }

  /// Configure features for Android 12+
  Future<bool> _configureAndroid12Features() async {
    try {
      // Schedule exact alarms permission request
      // This is needed on Android 12+ devices
      const methodChannel = MethodChannel(
        'com.example.spaced_learning_app.device/optimization',
      );
      final bool result = await methodChannel.invokeMethod(
        'requestExactAlarmPermission',
      );
      return result;
    } on PlatformException catch (e) {
      debugPrint('Failed to configure Android 12 features: ${e.message}');
      return false;
    } catch (e) {
      debugPrint('Unexpected error configuring Android 12 features: $e');
      return false;
    }
  }

  /// Configure features for other Samsung devices
  Future<bool> _configureGeneralSamsungFeatures() async {
    // General Samsung optimizations that work across devices
    try {
      const methodChannel = MethodChannel('com.yourapp.device/optimization');
      final bool result = await methodChannel.invokeMethod(
        'disableSleepingApps',
      );
      return result;
    } on PlatformException catch (e) {
      debugPrint('Failed to configure Samsung features: ${e.message}');
      return false;
    } catch (e) {
      debugPrint('Unexpected error configuring Samsung features: $e');
      return false;
    }
  }

  /// Request battery optimization exclusion using method channel
  Future<bool> _requestBatteryOptimizationExclusion() async {
    try {
      // Check if permission is already granted
      final status = await Permission.ignoreBatteryOptimizations.status;

      if (status.isGranted) {
        debugPrint('Battery optimization already disabled');
        return true;
      }

      // Request permission
      final result = await Permission.ignoreBatteryOptimizations.request();
      final bool isGranted = result.isGranted;

      debugPrint('Battery optimization exclusion request result: $isGranted');
      return isGranted;
    } catch (e) {
      debugPrint('Error requesting battery optimization exclusion: $e');
      return false;
    }
  }

  /// Configure specific features for Samsung S23 Ultra
  Future<bool> _configureS23UltraFeatures() async {
    bool overallSuccess = true;

    try {
      // Use method channel to communicate with native code
      const methodChannel = MethodChannel('com.yourapp.samsung/optimization');

      // Try to disable Game Optimizer for this app
      try {
        final bool gameOptimizerResult = await methodChannel.invokeMethod(
          'disableGameOptimizer',
        );
        debugPrint('Game Optimizer disabled: $gameOptimizerResult');
        if (!gameOptimizerResult) overallSuccess = false;
      } on PlatformException catch (e) {
        debugPrint('Failed to disable Game Optimizer: ${e.message}');
        overallSuccess = false;
      }

      // Configure Edge Panel integration if available
      bool hasEdgePanel = false;
      try {
        hasEdgePanel = await methodChannel.invokeMethod('hasEdgePanel');
        debugPrint('Device has Edge Panel: $hasEdgePanel');
      } on PlatformException catch (e) {
        debugPrint('Failed to check Edge Panel availability: ${e.message}');
        // Default to false if there's an error
      }

      if (hasEdgePanel) {
        try {
          final bool edgePanelResult = await methodChannel.invokeMethod(
            'registerEdgePanelProvider',
          );
          debugPrint('Edge Panel registration: $edgePanelResult');
          if (!edgePanelResult) overallSuccess = false;
        } on PlatformException catch (e) {
          debugPrint('Failed to register Edge Panel provider: ${e.message}');
          overallSuccess = false;
        }
      }

      return overallSuccess;
    } catch (e) {
      debugPrint('Error configuring S23 Ultra features: $e');
      return false;
    }
  }

  /// Check if the device is running Android
  bool get isAndroid {
    return defaultTargetPlatform == TargetPlatform.android;
  }

  /// Check if the device is a Samsung device
  bool get isSamsungDevice => _isSamsungDevice;

  /// Check if the device is a Samsung S23 Ultra
  bool get isS23Ultra => _isS23Ultra;

  /// Get the device model
  String? get deviceModel => _deviceModel;

  /// Get the Android SDK version
  int get sdkVersion => _sdkVersion;

  /// Get the device manufacturer
  String? get manufacturer => _manufacturer;

  /// Check if service is initialized
  bool get isInitialized => _isInitialized;
}
