// lib/core/services/reminder/notification_service.dart
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
  bool _isInitialized = false;

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
  Future<bool> initialize() async {
    if (_isInitialized) return true;

    try {
      // Initialize timezone data
      tz.initializeTimeZones();

      // Get local timezone
      final String timeZoneName = tz.local.name;
      debugPrint('Local timezone: $timeZoneName');

      // Android initialization settings with device-specific adjustments
      final AndroidInitializationSettings androidSettings =
          _getAndroidSettings();

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
      final bool? initialized = await _notificationsPlugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      if (!initialized!) {
        debugPrint('Failed to initialize notifications plugin');
        return false;
      }

      // Create notification channels for Android
      final bool channelsCreated = await _createNotificationChannels();
      if (!channelsCreated) {
        debugPrint('Warning: Failed to create notification channels');
        // Continue despite failure to create channels
      }

      // Request permissions
      final bool permissionsGranted = await _requestPermissions();
      if (!permissionsGranted) {
        debugPrint('Warning: Notification permissions not granted');
        // Continue despite permission issues
      }

      _isInitialized = true;
      return true;
    } catch (e) {
      debugPrint('Error initializing NotificationService: $e');
      return false;
    }
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
  Future<bool> _createNotificationChannels() async {
    // Skip this method on non-Android devices
    if (!_deviceSpecificService.isAndroid) return true;

    try {
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

      // lib/core/services/reminder/notification_service.dart (tiếp tục)
      final androidPlugin =
          _notificationsPlugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();

      // Create base channels
      // Bằng đoạn code sau
      await androidPlugin?.createNotificationChannel(regularChannel);
      await androidPlugin?.createNotificationChannel(importantChannel);
      await androidPlugin?.createNotificationChannel(alarmChannel);

      // For Samsung devices, create additional channels if needed
      if (_deviceSpecificService.isSamsungDevice) {
        await _createSamsungSpecificChannels(androidPlugin!);
      }

      return true;
    } catch (e) {
      debugPrint('Error creating notification channels: $e');
      return false;
    }
  }

  /// Create Samsung-specific notification channels
  Future<bool> _createSamsungSpecificChannels(
    AndroidFlutterLocalNotificationsPlugin plugin,
  ) async {
    try {
      // Samsung devices sometimes need specific channels for Edge lighting, etc.
      const samsungChannel = AndroidNotificationChannel(
        'samsung_specific_channel',
        'Samsung Special Notifications',
        description: 'Optimized notifications for Samsung devices',
        importance: Importance.high,
      );

      await plugin.createNotificationChannel(samsungChannel);
      return true;
    } catch (e) {
      debugPrint('Error creating Samsung notification channels: $e');
      return false;
    }
  }

  /// Request notification permissions
  Future<bool> _requestPermissions() async {
    try {
      // Request permissions for iOS
      if (!_deviceSpecificService.isAndroid) {
        final ios =
            _notificationsPlugin
                .resolvePlatformSpecificImplementation<
                  IOSFlutterLocalNotificationsPlugin
                >();

        final bool? result = await ios?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        return result ?? false;
      }

      // Android permissions are handled in the manifest
      return true;
    } catch (e) {
      debugPrint('Error requesting notification permissions: $e');
      return false;
    }
  }

  /// Handle notification taps
  void _onNotificationTapped(NotificationResponse response) {
    // Handle the notification tap based on the payload
    debugPrint('Notification tapped: ${response.payload}');

    // You can navigate to specific screens based on the payload
    // Example: navigatorKey.currentState?.pushNamed('/learning', arguments: response.payload);
  }

  /// Show a basic notification immediately
  Future<bool> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    bool isImportant = false,
  }) async {
    if (!_isInitialized) {
      final bool initialized = await initialize();
      if (!initialized) return false;
    }

    try {
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
      await _notificationsPlugin.show(
        id,
        title,
        body,
        details,
        payload: payload,
      );
      debugPrint('Notification shown with id: $id');
      return true;
    } catch (e) {
      debugPrint('Error showing notification: $e');
      return false;
    }
  }

  /// Schedule a notification for a specific time
  Future<bool> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
    bool isImportant = false,
    bool isAlarmStyle = false,
  }) async {
    if (!_isInitialized) {
      final bool initialized = await initialize();
      if (!initialized) return false;
    }

    try {
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

      // Convert scheduledTime to TZDateTime
      final tz.TZDateTime tzScheduledTime = tz.TZDateTime.from(
        scheduledTime,
        tz.local,
      );

      // Schedule the notification
      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tzScheduledTime,
        details,
        androidScheduleMode:
            isAlarmStyle
                ? AndroidScheduleMode.exactAllowWhileIdle
                : AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents:
            DateTimeComponents.time, // Daily at the same time
        payload: payload,
      );

      debugPrint(
        'Notification scheduled with id: $id for time: $scheduledTime',
      );
      return true;
    } catch (e) {
      debugPrint('Error scheduling notification: $e');
      return false;
    }
  }

  /// Cancel a specific notification
  Future<bool> cancelNotification(int id) async {
    try {
      await _notificationsPlugin.cancel(id);
      debugPrint('Notification cancelled with id: $id');
      return true;
    } catch (e) {
      debugPrint('Error cancelling notification $id: $e');
      return false;
    }
  }

  /// Cancel all notifications
  Future<bool> cancelAllNotifications() async {
    try {
      await _notificationsPlugin.cancelAll();
      debugPrint('All notifications cancelled');
      return true;
    } catch (e) {
      debugPrint('Error cancelling all notifications: $e');
      return false;
    }
  }

  /// Schedule a notification for the noon reminder
  Future<bool> scheduleNoonReminder() async {
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

    return scheduleNotification(
      id: noonReminderId,
      title: 'Kiểm tra lịch học tập',
      body: 'Đã đến giờ xem lại lịch học hôm nay của bạn',
      scheduledTime: effectiveTime,
      isImportant: false,
    );
  }

  /// Schedule a notification for the first evening reminder
  Future<bool> scheduleEveningFirstReminder() async {
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

    return scheduleNotification(
      id: eveningFirstReminderId,
      title: 'Nhiệm vụ học tập chưa hoàn thành',
      body: 'Bạn còn một số bài học cần hoàn thành hôm nay',
      scheduledTime: effectiveTime,
      isImportant: true,
    );
  }

  /// Schedule a notification for the second evening reminder
  Future<bool> scheduleEveningSecondReminder() async {
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

    return scheduleNotification(
      id: eveningSecondReminderId,
      title: 'Còn nhiệm vụ chưa hoàn thành!',
      body: 'Hoàn thành việc học của bạn trước khi đi ngủ',
      scheduledTime: effectiveTime,
      isImportant: true,
    );
  }

  /// Schedule a notification for the end-of-day reminder
  Future<bool> scheduleEndOfDayReminder({bool useAlarmStyle = false}) async {
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

    return scheduleNotification(
      id: endOfDayReminderId,
      title: 'Đừng bỏ lỡ việc học hôm nay!',
      body: 'Đây là lời nhắc cuối cùng cho những nhiệm vụ chưa hoàn thành',
      scheduledTime: effectiveTime,
      isImportant: true,
      isAlarmStyle: useAlarmStyle, // Use alarm style for end-of-day
    );
  }

  /// Check if service is initialized
  bool get isInitialized => _isInitialized;
}
