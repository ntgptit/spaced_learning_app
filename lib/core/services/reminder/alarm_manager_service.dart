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
  final prefs = await SharedPreferences.getInstance();

  // Mark that this callback was triggered
  await prefs.setInt('last_triggered_callback', callbackId);
  await prefs.setInt(
    'last_triggered_time',
    DateTime.now().millisecondsSinceEpoch,
  );

  // In a real app, we would trigger a work manager task or similar to show notifications
  // For this example, we'll just set a flag that will be checked when the app is opened
}

/// Service for integrating with Android's AlarmManager for precise alarms
class AlarmManagerService {
  final DeviceSpecificService _deviceSpecificService;

  AlarmManagerService({DeviceSpecificService? deviceSpecificService})
    : _deviceSpecificService =
          deviceSpecificService ?? serviceLocator<DeviceSpecificService>();

  /// Initialize the alarm manager service with device-specific adjustments
  Future<void> initialize() async {
    try {
      // Initialize the alarm manager plugin
      await AndroidAlarmManager.initialize();
      debugPrint('AlarmManager initialized successfully');

      // Check if we need a different approach based on device
      if (!_deviceSpecificService.isAndroid) {
        debugPrint('Not on Android, using local notifications only');
        // On iOS, we'll rely only on local notifications
        return;
      }

      // On Android 12+, we need to request SCHEDULE_EXACT_ALARM permission
      if (_deviceSpecificService.sdkVersion >= 31) {
        await _requestExactAlarmPermission();
      }
    } catch (e) {
      debugPrint('Error initializing AlarmManager: $e');
      debugPrint('Falling back to local notifications only');
    }
  }

  /// Request permission for exact alarms (Android 12+)
  Future<void> _requestExactAlarmPermission() async {
    try {
      const methodChannel = MethodChannel('com.yourapp.device/optimization');
      await methodChannel.invokeMethod('requestExactAlarmPermission');
    } catch (e) {
      debugPrint('Error requesting exact alarm permission: $e');
    }
  }

  /// Schedule all fixed-time alarms
  Future<void> scheduleFixedTimeAlarms() async {
    try {
      await _scheduleNoonReminder();
      await _scheduleEveningFirstReminder();
      await _scheduleEveningSecondReminder();
      await _scheduleEndOfDayReminder();

      debugPrint('All fixed-time alarms scheduled successfully');
    } catch (e) {
      debugPrint('Error scheduling fixed-time alarms: $e');
    }
  }

  /// Schedule the noon reminder (12:30 PM)
  Future<bool> _scheduleNoonReminder() async {
    final alarmTime = _createTime(
      AppConstants.noonReminderHour,
      AppConstants.noonReminderMinute,
    );

    return AndroidAlarmManager.periodic(
      const Duration(days: 1),
      AppConstants.noonReminderCallbackId,
      noonReminderCallback,
      startAt: alarmTime,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
    );
  }

  /// Schedule the first evening reminder (9:00 PM)
  Future<bool> _scheduleEveningFirstReminder() async {
    final alarmTime = _createTime(
      AppConstants.eveningFirstReminderHour,
      AppConstants.eveningFirstReminderMinute,
    );

    return AndroidAlarmManager.periodic(
      const Duration(days: 1),
      AppConstants.eveningFirstReminderCallbackId,
      eveningFirstReminderCallback,
      startAt: alarmTime,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
    );
  }

  /// Schedule the second evening reminder (10:30 PM)
  Future<bool> _scheduleEveningSecondReminder() async {
    final alarmTime = _createTime(
      AppConstants.eveningSecondReminderHour,
      AppConstants.eveningSecondReminderMinute,
    );

    return AndroidAlarmManager.periodic(
      const Duration(days: 1),
      AppConstants.eveningSecondReminderCallbackId,
      eveningSecondReminderCallback,
      startAt: alarmTime,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
    );
  }

  /// Schedule the end-of-day reminder (11:30 PM)
  Future<bool> _scheduleEndOfDayReminder() async {
    final alarmTime = _createTime(
      AppConstants.endOfDayReminderHour,
      AppConstants.endOfDayReminderMinute,
    );

    return AndroidAlarmManager.periodic(
      const Duration(days: 1),
      AppConstants.endOfDayReminderCallbackId,
      endOfDayReminderCallback,
      startAt: alarmTime,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
    );
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
    return AndroidAlarmManager.cancel(id);
  }

  /// Check if any alarm has been triggered recently
  Future<int?> getLastTriggeredAlarmId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('last_triggered_callback');
  }

  /// Get the time of the last triggered alarm
  Future<DateTime?> getLastTriggeredTime() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt('last_triggered_time');

    if (timestamp != null) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    }

    return null;
  }

  /// Clear the last triggered alarm data
  Future<void> clearLastTriggeredData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('last_triggered_callback');
    await prefs.remove('last_triggered_time');
  }
}
