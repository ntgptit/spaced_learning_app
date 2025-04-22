import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:spaced_learning_app/core/constants/app_constants.dart';
import 'package:spaced_learning_app/core/di/service_locator.dart';
import 'package:spaced_learning_app/core/services/reminder/device_specific_service.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  late final DeviceSpecificService _deviceSpecificService;
  bool _isInitialized = false;
  bool _timezonesInitialized = false;

  NotificationService({DeviceSpecificService? deviceSpecificService})
    : _deviceSpecificService =
          deviceSpecificService ?? serviceLocator<DeviceSpecificService>();

  static const String regularChannelId = 'spaced_learning_reminders';
  static const String importantChannelId =
      'spaced_learning_important_reminders';
  static const String alarmChannelId = 'spaced_learning_alarms';

  static const int noonReminderId = 1001;
  static const int eveningFirstReminderId = 1002;
  static const int eveningSecondReminderId = 1003;
  static const int endOfDayReminderId = 1004;

  Future<bool> initialize() async {
    if (_isInitialized) return true;

    try {
      if (!await _initializeTimezones()) {
        debugPrint('Warning: Failed to initialize timezones');
      }

      if (kIsWeb) {
        debugPrint(
          'Running on web platform, skipping native notification setup',
        );
        _isInitialized = true;
        return true;
      }

      if (!await _initializeNotifications()) {
        debugPrint('Failed to initialize notifications plugin');
        return false;
      }

      if (_deviceSpecificService.isAndroid) {
        if (!await _createNotificationChannels()) {
          debugPrint('Warning: Failed to create notification channels');
        }
      }

      if (!await _requestPermissions()) {
        debugPrint('Warning: Notification permissions not granted');
      }

      _isInitialized = true;
      return true;
    } catch (e) {
      debugPrint('Error initializing NotificationService: $e');
      return false;
    }
  }

  Future<bool> _initializeTimezones() async {
    if (_timezonesInitialized) return true;

    try {
      tz.initializeTimeZones();
      final String timeZoneName = tz.local.name;
      debugPrint('Local timezone: $timeZoneName');
      _timezonesInitialized = true;
      return true;
    } catch (e) {
      debugPrint('Error initializing timezone data: $e');
      return false;
    }
  }

  Future<bool> _initializeNotifications() async {
    try {
      final AndroidInitializationSettings androidSettings =
          _getAndroidSettings();

      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      final initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      final bool? initialized = await _notificationsPlugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      return initialized ?? false;
    } catch (e) {
      debugPrint('Error initializing notifications: $e');
      return false;
    }
  }

  AndroidInitializationSettings _getAndroidSettings() {
    return const AndroidInitializationSettings('ic_launcher');
  }

  Future<bool> _createNotificationChannels() async {
    if (!_deviceSpecificService.isAndroid) return true;

    try {
      final androidPlugin = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

      if (androidPlugin == null) {
        return false;
      }

      // Create regular channel
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          regularChannelId,
          'Learning Reminders',
          description: 'Reminders for your daily learning schedule',
          importance: Importance.high,
        ),
      );

      // Create important channel
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          importantChannelId,
          'Important Reminders',
          description: 'Urgent reminders for unfinished learning tasks',
          importance: Importance.high,
          sound: RawResourceAndroidNotificationSound('notification_sound'),
        ),
      );

      // Create alarm channel
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          alarmChannelId,
          'Learning Alarms',
          description: 'Alarm-style reminders for critical learning tasks',
          importance: Importance.max,
          sound: RawResourceAndroidNotificationSound('alarm_sound'),
          playSound: true,
          enableVibration: true,
        ),
      );

      // Create Samsung-specific channels if needed
      if (_deviceSpecificService.isSamsungDevice) {
        await _createSamsungSpecificChannels(androidPlugin);
      }

      return true;
    } catch (e) {
      debugPrint('Error creating notification channels: $e');
      return false;
    }
  }

  Future<bool> _createSamsungSpecificChannels(
    AndroidFlutterLocalNotificationsPlugin androidPlugin,
  ) async {
    try {
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          'samsung_specific_channel',
          'Samsung Special Notifications',
          description: 'Optimized notifications for Samsung devices',
          importance: Importance.high,
        ),
      );
      return true;
    } catch (e) {
      debugPrint('Error creating Samsung notification channels: $e');
      return false;
    }
  }

  Future<bool> _requestPermissions() async {
    try {
      if (!_deviceSpecificService.isAndroid) {
        final ios = _notificationsPlugin
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >();

        if (ios == null) {
          return false;
        }

        final bool? result = await ios.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        return result ?? false;
      }

      return true;
    } catch (e) {
      debugPrint('Error requesting notification permissions: $e');
      return false;
    }
  }

  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('Notification tapped: ${response.payload}');
  }

  Future<bool> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    bool isImportant = false,
  }) async {
    if (kIsWeb) {
      debugPrint('Notifications not supported on web platform');
      return false;
    }

    if (!_isInitialized) {
      final bool initialized = await initialize();
      if (!initialized) return false;
    }

    try {
      final androidDetails = AndroidNotificationDetails(
        isImportant ? importantChannelId : regularChannelId,
        isImportant ? 'Important Reminders' : 'Learning Reminders',
        channelDescription: isImportant
            ? 'Urgent reminders for unfinished learning tasks'
            : 'Reminders for your daily learning schedule',
        importance: isImportant ? Importance.max : Importance.high,
        priority: isImportant ? Priority.max : Priority.high,
        category: isImportant
            ? AndroidNotificationCategory.reminder
            : AndroidNotificationCategory.message,
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      final details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

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

  Future<bool> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
    bool isImportant = false,
    bool isAlarmStyle = false,
  }) async {
    if (kIsWeb) {
      debugPrint('Scheduled notifications not supported on web platform');
      return false;
    }

    if (!_isInitialized) {
      final bool initialized = await initialize();
      if (!initialized) return false;
    }

    if (!_timezonesInitialized) {
      debugPrint('Timezones not initialized, cannot schedule notification');
      return false;
    }

    try {
      final notificationDetails = _getNotificationDetails(
        isImportant,
        isAlarmStyle,
      );
      final tzScheduledTime = _convertToTZDateTime(scheduledTime);

      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tzScheduledTime,
        notificationDetails,
        androidScheduleMode: _getAndroidScheduleMode(isAlarmStyle),
        matchDateTimeComponents: DateTimeComponents.time,
        // Daily at the same time
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

  NotificationDetails _getNotificationDetails(
    bool isImportant,
    bool isAlarmStyle,
  ) {
    final androidDetails = AndroidNotificationDetails(
      isAlarmStyle
          ? alarmChannelId
          : (isImportant ? importantChannelId : regularChannelId),
      isAlarmStyle
          ? 'Learning Alarms'
          : (isImportant ? 'Important Reminders' : 'Learning Reminders'),
      channelDescription: isAlarmStyle
          ? 'Alarm-style reminders for critical learning tasks'
          : (isImportant
                ? 'Urgent reminders for unfinished learning tasks'
                : 'Reminders for your daily learning schedule'),
      importance: isAlarmStyle
          ? Importance.max
          : (isImportant ? Importance.max : Importance.high),
      priority: isAlarmStyle
          ? Priority.max
          : (isImportant ? Priority.max : Priority.high),
      category: isAlarmStyle
          ? AndroidNotificationCategory.alarm
          : (isImportant
                ? AndroidNotificationCategory.reminder
                : AndroidNotificationCategory.message),
      fullScreenIntent: isAlarmStyle,
      // Full screen intent for alarm-style
      sound: isAlarmStyle
          ? const RawResourceAndroidNotificationSound('alarm_sound')
          : (isImportant
                ? const RawResourceAndroidNotificationSound(
                    'notification_sound',
                  )
                : null),
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    return NotificationDetails(android: androidDetails, iOS: iosDetails);
  }

  tz.TZDateTime _convertToTZDateTime(DateTime scheduledTime) {
    try {
      return tz.TZDateTime.from(scheduledTime, tz.local);
    } catch (e) {
      debugPrint('Error converting to TZ datetime: $e');
      return tz.TZDateTime.from(scheduledTime, tz.UTC);
    }
  }

  AndroidScheduleMode _getAndroidScheduleMode(bool isAlarmStyle) {
    return isAlarmStyle
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.exactAllowWhileIdle;
  }

  Future<bool> cancelNotification(int id) async {
    if (kIsWeb) {
      debugPrint('Notifications not supported on web platform');
      return false;
    }

    if (!_isInitialized) {
      debugPrint(
        'Notification service not initialized, skipping cancel notification',
      );
      return false;
    }

    try {
      await _notificationsPlugin.cancel(id);
      debugPrint('Notification cancelled with id: $id');
      return true;
    } catch (e) {
      debugPrint('Error cancelling notification $id: $e');
      return false;
    }
  }

  Future<bool> cancelAllNotifications() async {
    if (kIsWeb) {
      debugPrint('Notifications not supported on web platform');
      return false;
    }

    if (!_isInitialized) {
      debugPrint(
        'Notification service not initialized, skipping cancel all notifications',
      );
      return false;
    }

    try {
      await _notificationsPlugin.cancelAll();
      debugPrint('All notifications cancelled');
      return true;
    } catch (e) {
      debugPrint('Error cancelling all notifications: $e');
      return false;
    }
  }

  Future<bool> scheduleNoonReminder() async {
    final now = DateTime.now();
    final scheduledTime = _getScheduledTime(
      now,
      AppConstants.noonReminderHour,
      AppConstants.noonReminderMinute,
    );

    return scheduleNotification(
      id: noonReminderId,
      title: 'Kiểm tra lịch học tập',
      body: 'Đã đến giờ xem lại lịch học hôm nay của bạn',
      scheduledTime: scheduledTime,
      isImportant: false,
    );
  }

  DateTime _getScheduledTime(DateTime now, int hour, int minute) {
    final scheduledTime = DateTime(now.year, now.month, now.day, hour, minute);

    return scheduledTime.isBefore(now)
        ? scheduledTime.add(const Duration(days: 1))
        : scheduledTime;
  }

  Future<bool> scheduleEveningFirstReminder() async {
    final now = DateTime.now();
    final scheduledTime = _getScheduledTime(
      now,
      AppConstants.eveningFirstReminderHour,
      AppConstants.eveningFirstReminderMinute,
    );

    return scheduleNotification(
      id: eveningFirstReminderId,
      title: 'Nhiệm vụ học tập chưa hoàn thành',
      body: 'Bạn còn một số bài học cần hoàn thành hôm nay',
      scheduledTime: scheduledTime,
      isImportant: true,
    );
  }

  Future<bool> scheduleEveningSecondReminder() async {
    final now = DateTime.now();
    final scheduledTime = _getScheduledTime(
      now,
      AppConstants.eveningSecondReminderHour,
      AppConstants.eveningSecondReminderMinute,
    );

    return scheduleNotification(
      id: eveningSecondReminderId,
      title: 'Còn nhiệm vụ chưa hoàn thành!',
      body: 'Hoàn thành việc học của bạn trước khi đi ngủ',
      scheduledTime: scheduledTime,
      isImportant: true,
    );
  }

  Future<bool> scheduleEndOfDayReminder({bool useAlarmStyle = false}) async {
    final now = DateTime.now();
    final scheduledTime = _getScheduledTime(
      now,
      AppConstants.endOfDayReminderHour,
      AppConstants.endOfDayReminderMinute,
    );

    return scheduleNotification(
      id: endOfDayReminderId,
      title: 'Đừng bỏ lỡ việc học hôm nay!',
      body: 'Đây là lời nhắc cuối cùng cho những nhiệm vụ chưa hoàn thành',
      scheduledTime: scheduledTime,
      isImportant: true,
      isAlarmStyle: useAlarmStyle, // Use alarm style for end-of-day
    );
  }

  bool get isInitialized => _isInitialized;

  bool get timezonesInitialized => _timezonesInitialized;
}
