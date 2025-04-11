import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class DeviceSpecificService {
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  bool _isSamsungDevice = false;
  bool _isS23Ultra = false;
  String? _deviceModel;
  String? _manufacturer;
  int _sdkVersion = 0;
  bool _isInitialized = false;

  Future<bool> initialize() async {
    if (_isInitialized) return true;

    try {
      if (isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;

        _deviceModel = androidInfo.model;
        _manufacturer = androidInfo.manufacturer;
        _sdkVersion = androidInfo.version.sdkInt;

        _isSamsungDevice = _manufacturer?.toLowerCase() == 'samsung';

        _isS23Ultra =
            _isSamsungDevice &&
            (_deviceModel?.toLowerCase().contains('sm-s918') ?? false);

        debugPrint(
          'Device detected: $_manufacturer $_deviceModel (SDK: $_sdkVersion)',
        );

        if (_isSamsungDevice) {
          await _applySamsungOptimizations();
        } else {
          await _applyGeneralOptimizations();
        }

        _isInitialized = true;
        return true;
      } else {
        _isInitialized = true;
        return true;
      }
    } catch (e) {
      debugPrint('Error detecting device: $e');
      return false;
    }
  }

  Future<void> _applySamsungOptimizations() async {
    try {
      final bool batteryOptResult =
          await _requestBatteryOptimizationExclusion();
      debugPrint('Battery optimization request result: $batteryOptResult');

      if (_isS23Ultra) {
        final bool s23Result = await _configureS23UltraFeatures();
        debugPrint('S23 Ultra specific optimizations result: $s23Result');
      } else {
        final bool samsungResult = await _configureGeneralSamsungFeatures();
        debugPrint('General Samsung optimizations result: $samsungResult');
      }
    } catch (e) {
      debugPrint('Error applying Samsung optimizations: $e');
    }
  }

  Future<void> _applyGeneralOptimizations() async {
    try {
      final bool batteryOptResult =
          await _requestBatteryOptimizationExclusion();
      debugPrint('Battery optimization request result: $batteryOptResult');

      if (_sdkVersion >= 31) {
        final bool android12Result = await _configureAndroid12Features();
        debugPrint('Android 12+ optimizations result: $android12Result');
      } else if (_sdkVersion >= 26) {
        final bool olderAndroidResult = await _configureOlderAndroidFeatures();
        debugPrint('Android 8-11 optimizations result: $olderAndroidResult');
      }
    } catch (e) {
      debugPrint('Error applying general optimizations: $e');
    }
  }

  Future<bool> _configureOlderAndroidFeatures() async {
    debugPrint('Configuring for Android $_sdkVersion');
    return true;
  }

  Future<bool> _configureAndroid12Features() async {
    try {
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

  Future<bool> _configureGeneralSamsungFeatures() async {
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

  Future<bool> _requestBatteryOptimizationExclusion() async {
    try {
      final status = await Permission.ignoreBatteryOptimizations.status;

      if (status.isGranted) {
        debugPrint('Battery optimization already disabled');
        return true;
      }

      final result = await Permission.ignoreBatteryOptimizations.request();
      final bool isGranted = result.isGranted;

      debugPrint('Battery optimization exclusion request result: $isGranted');
      return isGranted;
    } catch (e) {
      debugPrint('Error requesting battery optimization exclusion: $e');
      return false;
    }
  }

  Future<bool> _configureS23UltraFeatures() async {
    bool overallSuccess = true;

    try {
      const methodChannel = MethodChannel('com.yourapp.samsung/optimization');

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

      bool hasEdgePanel = false;
      try {
        hasEdgePanel = await methodChannel.invokeMethod('hasEdgePanel');
        debugPrint('Device has Edge Panel: $hasEdgePanel');
      } on PlatformException catch (e) {
        debugPrint('Failed to check Edge Panel availability: ${e.message}');
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

  bool get isAndroid {
    return defaultTargetPlatform == TargetPlatform.android;
  }

  bool get isSamsungDevice => _isSamsungDevice;

  bool get isS23Ultra => _isS23Ultra;

  String? get deviceModel => _deviceModel;

  int get sdkVersion => _sdkVersion;

  String? get manufacturer => _manufacturer;

  bool get isInitialized => _isInitialized;
}
