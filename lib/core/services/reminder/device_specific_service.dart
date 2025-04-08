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

  /// Initialize the service and detect device type
  Future<void> initialize() async {
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
      }
    } catch (e) {
      debugPrint('Error detecting device: $e');
    }
  }

  /// Apply Samsung-specific optimizations
  Future<void> _applySamsungOptimizations() async {
    try {
      // Request battery optimization exclusion (works for all devices)
      await _requestBatteryOptimizationExclusion();

      // Samsung-specific features
      if (_isS23Ultra) {
        await _configureS23UltraFeatures();
      } else {
        // For other Samsung devices
        await _configureGeneralSamsungFeatures();
      }
    } catch (e) {
      debugPrint('Error applying Samsung optimizations: $e');
    }
  }

  /// Apply optimizations for non-Samsung devices
  Future<void> _applyGeneralOptimizations() async {
    try {
      // Request battery optimization exclusion
      await _requestBatteryOptimizationExclusion();

      // Apply optimizations based on Android version
      if (_sdkVersion >= 31) {
        // Android 12+
        await _configureAndroid12Features();
      } else if (_sdkVersion >= 26) {
        // Android 8-11
        await _configureOlderAndroidFeatures();
      }
    } catch (e) {
      debugPrint('Error applying general optimizations: $e');
    }
  }

  /// Configure features for older Android versions
  Future<void> _configureOlderAndroidFeatures() async {
    // No special config needed, but can be used for version-specific needs
    debugPrint('Configuring for Android $_sdkVersion');
  }

  /// Configure features for Android 12+
  Future<void> _configureAndroid12Features() async {
    try {
      // Schedule exact alarms permission request
      // This is needed on Android 12+ devices
      const methodChannel = MethodChannel('com.yourapp.device/optimization');
      await methodChannel.invokeMethod('requestExactAlarmPermission');
    } on PlatformException catch (e) {
      debugPrint('Failed to configure Android 12 features: ${e.message}');
    }
  }

  /// Configure features for other Samsung devices
  Future<void> _configureGeneralSamsungFeatures() async {
    // General Samsung optimizations that work across devices
    try {
      const methodChannel = MethodChannel('com.yourapp.device/optimization');
      await methodChannel.invokeMethod('disableSleepingApps');
    } on PlatformException catch (e) {
      debugPrint('Failed to configure Samsung features: ${e.message}');
    }
  }

  /// Request battery optimization exclusion using method channel
  Future<void> _requestBatteryOptimizationExclusion() async {
    try {
      // Check if permission is already granted
      final status = await Permission.ignoreBatteryOptimizations.status;

      if (status.isGranted) {
        debugPrint('Battery optimization already disabled');
        return;
      }

      // Request permission
      final result = await Permission.ignoreBatteryOptimizations.request();

      debugPrint('Battery optimization exclusion request result: $result');
    } catch (e) {
      debugPrint('Error requesting battery optimization exclusion: $e');
    }
  }

  /// Configure specific features for Samsung S23 Ultra
  Future<void> _configureS23UltraFeatures() async {
    try {
      // Use method channel to communicate with native code
      const methodChannel = MethodChannel('com.yourapp.samsung/optimization');

      // Try to disable Game Optimizer for this app
      await methodChannel.invokeMethod('disableGameOptimizer');

      // Configure Edge Panel integration if available
      final bool hasEdgePanel = await methodChannel.invokeMethod(
        'hasEdgePanel',
      );

      if (hasEdgePanel) {
        await methodChannel.invokeMethod('registerEdgePanelProvider');
      }
    } on PlatformException catch (e) {
      debugPrint('Failed to configure S23 Ultra features: ${e.message}');
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
}
