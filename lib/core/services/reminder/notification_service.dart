import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:spaced_learning_app/core/constants/app_constants.dart';
import 'package:spaced_learning_app/core/di/service_locator.dart';
import 'package:spaced_learning_app/core/services/reminder/device_specific_service.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Service for handling local notifications in the app
class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  late final DeviceSpecificService _deviceSpecificService;

  NotificationService({DeviceSpecificService? deviceSpecificService})
    : _deviceSpecificService =
          deviceSpecificService ?? serviceLocator<DeviceSpecificService>();

  // Channel IDs
  static const String regularChannelId = 'spaced_learning_reminders';
  static const String importantChannelId =
      'spaced_learning_important_reminders';
  static const String alarmChannelId = 'spaced_learning_alarms';

  // Notification IDs
  static const int noonReminderId = 1001;
  static const int eveningFirstReminderId = 1002;
  static const int eveningSecondReminderId = 1003;
  static const int endOfDayReminderId = 1004;

  /// Initialize the notification service based on device
  Future<void> initialize() async {
    // Initialize timezone data
    tz.initializeTimeZones();

    // Android initialization settings with device-specific adjustments
    final AndroidInitializationSettings androidSettings = _getAndroidSettings();

    // iOS initialization settings
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // Initialize settings
    final initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // Initialize plugin
    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create notification channels for Android
    await _createNotificationChannels();

    // Request permissions
    await _requestPermissions();
  }

  /// Get Android settings based on device type
  AndroidInitializationSettings _getAndroidSettings() {
    // Different icon or setup based on device manufacturer or Android version
    if (_deviceSpecificService.isSamsungDevice) {
      // Samsung-specific settings
      return const AndroidInitializationSettings('app_icon_samsung');
    } else {
      // Default settings
      return const AndroidInitializationSettings('app_icon');
    }
  }

  /// Create notification channels with device-specific adjustments
  Future<void> _createNotificationChannels() async {
    // Skip this method on non-Android devices
    if (!_deviceSpecificService.isAndroid) return;

    // Base channels for all Android devices
    const regularChannel = AndroidNotificationChannel(
      regularChannelId,
      'Learning Reminders',
      description: 'Reminders for your daily learning schedule',
      importance: Importance.high,
    );

    const importantChannel = AndroidNotificationChannel(
      importantChannelId,
      'Important Reminders',
      description: 'Urgent reminders for unfinished learning tasks',
      importance: Importance.high,
      sound: RawResourceAndroidNotificationSound('notification_sound'),
    );

    const alarmChannel = AndroidNotificationChannel(
      alarmChannelId,
      'Learning Alarms',
      description: 'Alarm-style reminders for critical learning tasks',
      importance: Importance.max,
      sound: RawResourceAndroidNotificationSound('alarm_sound'),
      playSound: true,
      enableVibration: true,
    );

    final androidPlugin =
        _notificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    if (androidPlugin != null) {
      // Create base channels
      await androidPlugin.createNotificationChannels([
        regularChannel,
        importantChannel,
        alarmChannel,
      ]);

      // For Samsung devices, create additional channels if needed
      if (_deviceSpecificService.isSamsungDevice) {
        await _createSamsungSpecificChannels(androidPlugin);
      }
    }
  }

  /// Create Samsung-specific notification channels
  Future<void> _createSamsungSpecificChannels(
    AndroidFlutterLocalNotificationsPlugin plugin,
  ) async {
    // Samsung devices sometimes need specific channels for Edge lighting, etc.
    const samsungChannel = AndroidNotificationChannel(
      'samsung_specific_channel',
      'Samsung Special Notifications',
      description: 'Optimized notifications for Samsung devices',
      importance: Importance.high,
    );

    await plugin.createNotificationChannel(samsungChannel);
  }

  /// Request notification permissions
  Future<void> _requestPermissions() async {
    // Request permissions for iOS
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    // Additional Android permissions are handled in the manifest
  }

  /// Handle notification taps
  void _onNotificationTapped(NotificationResponse response) {
    // Handle the notification tap based on the payload
    debugPrint('Notification tapped: ${response.payload}');

    // You can navigate to specific screens based on the payload
    // Example: navigatorKey.currentState?.pushNamed('/learning', arguments: response.payload);
  }

  /// Show a basic notification immediately
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    bool isImportant = false,
  }) async {
    // Create Android-specific details
    final androidDetails = AndroidNotificationDetails(
      isImportant ? importantChannelId : regularChannelId,
      isImportant ? 'Important Reminders' : 'Learning Reminders',
      channelDescription:
          isImportant
              ? 'Urgent reminders for unfinished learning tasks'
              : 'Reminders for your daily learning schedule',
      importance: isImportant ? Importance.max : Importance.high,
      priority: isImportant ? Priority.max : Priority.high,
      category:
          isImportant
              ? AndroidNotificationCategory.reminder
              : AndroidNotificationCategory.message,
    );

    // Create iOS-specific details
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    // Create notification details
    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Show the notification
    await _notificationsPlugin.show(id, title, body, details, payload: payload);
  }

  /// Schedule a notification for a specific time
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
    bool isImportant = false,
    bool isAlarmStyle = false,
  }) async {
    // Create Android-specific details
    final androidDetails = AndroidNotificationDetails(
      isAlarmStyle
          ? alarmChannelId
          : (isImportant ? importantChannelId : regularChannelId),
      isAlarmStyle
          ? 'Learning Alarms'
          : (isImportant ? 'Important Reminders' : 'Learning Reminders'),
      channelDescription:
          isAlarmStyle
              ? 'Alarm-style reminders for critical learning tasks'
              : (isImportant
                  ? 'Urgent reminders for unfinished learning tasks'
                  : 'Reminders for your daily learning schedule'),
      importance:
          isAlarmStyle
              ? Importance.max
              : (isImportant ? Importance.max : Importance.high),
      priority:
          isAlarmStyle
              ? Priority.max
              : (isImportant ? Priority.max : Priority.high),
      category:
          isAlarmStyle
              ? AndroidNotificationCategory.alarm
              : (isImportant
                  ? AndroidNotificationCategory.reminder
                  : AndroidNotificationCategory.message),
      fullScreenIntent: isAlarmStyle, // Full screen intent for alarm-style
      sound:
          isAlarmStyle
              ? const RawResourceAndroidNotificationSound('alarm_sound')
              : (isImportant
                  ? const RawResourceAndroidNotificationSound(
                    'notification_sound',
                  )
                  : null),
    );

    // Create iOS-specific details
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    // Create notification details
    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Schedule the notification
    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      details,
      androidScheduleMode:
          isAlarmStyle
              ? AndroidScheduleMode.exactAllowWhileIdle
              : AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents:
          DateTimeComponents.time, // Daily at the same time
      payload: payload,
    );
  }

  /// Cancel a specific notification
  Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  /// Schedule a notification for the noon reminder
  Future<void> scheduleNoonReminder() async {
    final now = DateTime.now();
    final scheduledTime = DateTime(
      now.year,
      now.month,
      now.day,
      AppConstants.noonReminderHour,
      AppConstants.noonReminderMinute,
    );

    // If the time has already passed today, schedule for tomorrow
    final effectiveTime =
        scheduledTime.isBefore(now)
            ? scheduledTime.add(const Duration(days: 1))
            : scheduledTime;

    await scheduleNotification(
      id: noonReminderId,
      title: 'Kiểm tra lịch học tập',
      body: 'Đã đến giờ xem lại lịch học hôm nay của bạn',
      scheduledTime: effectiveTime,
      isImportant: false,
    );
  }

  /// Schedule a notification for the first evening reminder
  Future<void> scheduleEveningFirstReminder() async {
    final now = DateTime.now();
    final scheduledTime = DateTime(
      now.year,
      now.month,
      now.day,
      AppConstants.eveningFirstReminderHour,
      AppConstants.eveningFirstReminderMinute,
    );

    // If the time has already passed today, schedule for tomorrow
    final effectiveTime =
        scheduledTime.isBefore(now)
            ? scheduledTime.add(const Duration(days: 1))
            : scheduledTime;

    await scheduleNotification(
      id: eveningFirstReminderId,
      title: 'Nhiệm vụ học tập chưa hoàn thành',
      body: 'Bạn còn một số bài học cần hoàn thành hôm nay',
      scheduledTime: effectiveTime,
      isImportant: true,
    );
  }

  /// Schedule a notification for the second evening reminder
  Future<void> scheduleEveningSecondReminder() async {
    final now = DateTime.now();
    final scheduledTime = DateTime(
      now.year,
      now.month,
      now.day,
      AppConstants.eveningSecondReminderHour,
      AppConstants.eveningSecondReminderMinute,
    );

    // If the time has already passed today, schedule for tomorrow
    final effectiveTime =
        scheduledTime.isBefore(now)
            ? scheduledTime.add(const Duration(days: 1))
            : scheduledTime;

    await scheduleNotification(
      id: eveningSecondReminderId,
      title: 'Còn nhiệm vụ chưa hoàn thành!',
      body: 'Hoàn thành việc học của bạn trước khi đi ngủ',
      scheduledTime: effectiveTime,
      isImportant: true,
    );
  }

  /// Schedule a notification for the end-of-day reminder
  Future<void> scheduleEndOfDayReminder() async {
    final now = DateTime.now();
    final scheduledTime = DateTime(
      now.year,
      now.month,
      now.day,
      AppConstants.endOfDayReminderHour,
      AppConstants.endOfDayReminderMinute,
    );

    // If the time has already passed today, schedule for tomorrow
    final effectiveTime =
        scheduledTime.isBefore(now)
            ? scheduledTime.add(const Duration(days: 1))
            : scheduledTime;

    await scheduleNotification(
      id: endOfDayReminderId,
      title: 'Đừng bỏ lỡ việc học hôm nay!',
      body: 'Đây là lời nhắc cuối cùng cho những nhiệm vụ chưa hoàn thành',
      scheduledTime: effectiveTime,
      isImportant: true,
      isAlarmStyle: true, // Use alarm style for end-of-day
    );
  }
}
