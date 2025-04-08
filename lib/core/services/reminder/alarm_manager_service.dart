// lib/core/services/reminder/alarm_manager_service.dart
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spaced_learning_app/core/constants/app_constants.dart';
import 'package:spaced_learning_app/core/di/service_locator.dart';
import 'package:spaced_learning_app/core/services/reminder/device_specific_service.dart';

/// Callback functions must be top-level or static
@pragma('vm:entry-point')
void noonReminderCallback() {
  _triggerBackgroundCheck(AppConstants.noonReminderCallbackId);
}

@pragma('vm:entry-point')
void eveningFirstReminderCallback() {
  _triggerBackgroundCheck(AppConstants.eveningFirstReminderCallbackId);
}

@pragma('vm:entry-point')
void eveningSecondReminderCallback() {
  _triggerBackgroundCheck(AppConstants.eveningSecondReminderCallbackId);
}

@pragma('vm:entry-point')
void endOfDayReminderCallback() {
  _triggerBackgroundCheck(AppConstants.endOfDayReminderCallbackId);
}

/// Helper function to trigger a background task from callback
@pragma('vm:entry-point')
Future<void> _triggerBackgroundCheck(int callbackId) async {
  try {
    final prefs = await SharedPreferences.getInstance();

    // Mark that this callback was triggered
    await prefs.setInt('last_triggered_callback', callbackId);
    await prefs.setInt(
      'last_triggered_time',
      DateTime.now().millisecondsSinceEpoch,
    );

    // In a real app, we would trigger a work manager task or similar to show notifications
    // For this example, we'll just set a flag that will be checked when the app is opened
    debugPrint('Alarm callback triggered: $callbackId at ${DateTime.now()}');
  } catch (e) {
    print(
      'Error in _triggerBackgroundCheck: $e',
    ); // Use print since debugPrint might not work in background
  }
}

/// Service for integrating with Android's AlarmManager for precise alarms
class AlarmManagerService {
  final DeviceSpecificService _deviceSpecificService;
  bool _isInitialized = false;

  AlarmManagerService({DeviceSpecificService? deviceSpecificService})
    : _deviceSpecificService =
          deviceSpecificService ?? serviceLocator<DeviceSpecificService>();

  /// Initialize the alarm manager service with device-specific adjustments
  Future<bool> initialize() async {
    if (_isInitialized) return true;

    try {
      // Check if running on Android
      if (!_deviceSpecificService.isAndroid) {
        debugPrint('Not on Android, using local notifications only');
        _isInitialized = true;
        return true;
      }

      // Initialize the alarm manager plugin
      final bool initialized = await AndroidAlarmManager.initialize();
      if (!initialized) {
        debugPrint('Failed to initialize AndroidAlarmManager');
        return false;
      }

      debugPrint('AlarmManager initialized successfully');

      // On Android 12+, we need to request SCHEDULE_EXACT_ALARM permission
      if (_deviceSpecificService.sdkVersion >= 31) {
        final bool permissionGranted = await _requestExactAlarmPermission();
        debugPrint('Exact alarm permission granted: $permissionGranted');
        // Continue even if permission is not granted, as we'll fall back to normal alarms
      }

      _isInitialized = true;
      return true;
    } catch (e) {
      debugPrint('Error initializing AlarmManager: $e');
      debugPrint('Falling back to local notifications only');
      return false;
    }
  }

  /// Request permission for exact alarms (Android 12+)
  Future<bool> _requestExactAlarmPermission() async {
    try {
      const methodChannel = MethodChannel('com.yourapp.device/optimization');
      final bool result = await methodChannel.invokeMethod(
        'requestExactAlarmPermission',
      );
      return result;
    } on PlatformException catch (e) {
      debugPrint('Error requesting exact alarm permission: ${e.message}');
      return false;
    } catch (e) {
      debugPrint('Unexpected error requesting exact alarm permission: $e');
      return false;
    }
  }

  /// Schedule all fixed-time alarms
  Future<bool> scheduleFixedTimeAlarms() async {
    if (!_isInitialized) {
      final bool initialized = await initialize();
      if (!initialized) return false;
    }

    if (!_deviceSpecificService.isAndroid) {
      debugPrint('Not on Android, cannot schedule alarms');
      return false;
    }

    try {
      // Create a list to track success/failure of each alarm
      final List<bool> results = await Future.wait([
        _scheduleNoonReminder(),
        _scheduleEveningFirstReminder(),
        _scheduleEveningSecondReminder(),
        _scheduleEndOfDayReminder(),
      ]);

      // Check if all alarms were scheduled successfully
      final bool allSuccessful = results.every((result) => result);
      debugPrint(
        'All fixed-time alarms scheduled successfully: $allSuccessful',
      );
      return allSuccessful;
    } catch (e) {
      debugPrint('Error scheduling fixed-time alarms: $e');
      return false;
    }
  }

  /// Schedule the noon reminder (12:30 PM)
  Future<bool> _scheduleNoonReminder() async {
    try {
      final alarmTime = _createTime(
        AppConstants.noonReminderHour,
        AppConstants.noonReminderMinute,
      );

      final bool result = await AndroidAlarmManager.periodic(
        const Duration(days: 1),
        AppConstants.noonReminderCallbackId,
        noonReminderCallback,
        startAt: alarmTime,
        exact: true,
        wakeup: true,
        rescheduleOnReboot: true,
      );

      debugPrint('Noon reminder scheduled: $result at $alarmTime');
      return result;
    } catch (e) {
      debugPrint('Error scheduling noon reminder: $e');
      return false;
    }
  }

  /// Schedule the first evening reminder (9:00 PM)
  Future<bool> _scheduleEveningFirstReminder() async {
    try {
      final alarmTime = _createTime(
        AppConstants.eveningFirstReminderHour,
        AppConstants.eveningFirstReminderMinute,
      );

      final bool result = await AndroidAlarmManager.periodic(
        const Duration(days: 1),
        AppConstants.eveningFirstReminderCallbackId,
        eveningFirstReminderCallback,
        startAt: alarmTime,
        exact: true,
        wakeup: true,
        rescheduleOnReboot: true,
      );

      debugPrint('Evening first reminder scheduled: $result at $alarmTime');
      return result;
    } catch (e) {
      debugPrint('Error scheduling evening first reminder: $e');
      return false;
    }
  }

  /// Schedule the second evening reminder (10:30 PM)
  Future<bool> _scheduleEveningSecondReminder() async {
    try {
      final alarmTime = _createTime(
        AppConstants.eveningSecondReminderHour,
        AppConstants.eveningSecondReminderMinute,
      );

      final bool result = await AndroidAlarmManager.periodic(
        const Duration(days: 1),
        AppConstants.eveningSecondReminderCallbackId,
        eveningSecondReminderCallback,
        startAt: alarmTime,
        exact: true,
        wakeup: true,
        rescheduleOnReboot: true,
      );

      debugPrint('Evening second reminder scheduled: $result at $alarmTime');
      return result;
    } catch (e) {
      debugPrint('Error scheduling evening second reminder: $e');
      return false;
    }
  }

  /// Schedule the end-of-day reminder (11:30 PM)
  Future<bool> _scheduleEndOfDayReminder() async {
    try {
      final alarmTime = _createTime(
        AppConstants.endOfDayReminderHour,
        AppConstants.endOfDayReminderMinute,
      );

      final bool result = await AndroidAlarmManager.periodic(
        const Duration(days: 1),
        AppConstants.endOfDayReminderCallbackId,
        endOfDayReminderCallback,
        startAt: alarmTime,
        exact: true,
        wakeup: true,
        rescheduleOnReboot: true,
      );

      debugPrint('End-of-day reminder scheduled: $result at $alarmTime');
      return result;
    } catch (e) {
      debugPrint('Error scheduling end-of-day reminder: $e');
      return false;
    }
  }

  /// Create a DateTime for the specified hour and minute
  DateTime _createTime(int hour, int minute) {
    final now = DateTime.now();
    var scheduledTime = DateTime(now.year, now.month, now.day, hour, minute);

    // If the time has already passed today, schedule for tomorrow
    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    return scheduledTime;
  }

  /// Cancel a specific alarm
  Future<bool> cancelAlarm(int id) async {
    try {
      if (!_deviceSpecificService.isAndroid) {
        debugPrint('Not on Android, cannot cancel alarm');
        return false;
      }

      final bool result = await AndroidAlarmManager.cancel(id);
      debugPrint('Alarm $id cancelled: $result');
      return result;
    } catch (e) {
      debugPrint('Error cancelling alarm $id: $e');
      return false;
    }
  }

  /// Cancel all alarms
  Future<bool> cancelAllAlarms() async {
    try {
      if (!_deviceSpecificService.isAndroid) {
        debugPrint('Not on Android, cannot cancel alarms');
        return false;
      }

      final List<bool> results = await Future.wait([
        cancelAlarm(AppConstants.noonReminderCallbackId),
        cancelAlarm(AppConstants.eveningFirstReminderCallbackId),
        cancelAlarm(AppConstants.eveningSecondReminderCallbackId),
        cancelAlarm(AppConstants.endOfDayReminderCallbackId),
      ]);

      final bool allSuccessful = results.every((result) => result);
      debugPrint('All alarms cancelled: $allSuccessful');
      return allSuccessful;
    } catch (e) {
      debugPrint('Error cancelling all alarms: $e');
      return false;
    }
  }

  /// Check if any alarm has been triggered recently
  Future<int?> getLastTriggeredAlarmId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt('last_triggered_callback');
    } catch (e) {
      debugPrint('Error getting last triggered alarm ID: $e');
      return null;
    }
  }

  /// Get the time of the last triggered alarm
  Future<DateTime?> getLastTriggeredTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = prefs.getInt('last_triggered_time');

      if (timestamp != null) {
        return DateTime.fromMillisecondsSinceEpoch(timestamp);
      }

      return null;
    } catch (e) {
      debugPrint('Error getting last triggered time: $e');
      return null;
    }
  }

  /// Clear the last triggered alarm data
  Future<bool> clearLastTriggeredData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('last_triggered_callback');
      await prefs.remove('last_triggered_time');
      return true;
    } catch (e) {
      debugPrint('Error clearing last triggered data: $e');
      return false;
    }
  }

  /// Check if service is initialized
  bool get isInitialized => _isInitialized;
}
