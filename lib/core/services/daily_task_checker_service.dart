import 'dart:async';
import 'dart:convert';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spaced_learning_app/core/events/app_events.dart';
import 'package:spaced_learning_app/core/services/reminder/reminder_service.dart';
import 'package:spaced_learning_app/core/services/storage_service.dart';
import 'package:spaced_learning_app/domain/repositories/progress_repository.dart';

class DailyTaskChecker {
  final ProgressRepository _progressRepository;
  final StorageService _storageService;
  final EventBus _eventBus;
  final ReminderService _reminderService;
  final FlutterLocalNotificationsPlugin _notificationsPlugin;

  static const int DAILY_CHECK_ALARM_ID = 1000;
  static const String LAST_CHECK_TIME_KEY = 'last_daily_task_check_time';
  static const String LAST_CHECK_RESULT_KEY = 'last_daily_task_check_result';
  static const String LAST_CHECK_TASK_COUNT_KEY =
      'last_daily_task_check_task_count';
  static const String LAST_CHECK_ERROR_KEY = 'last_daily_task_check_error';

  DailyTaskChecker({
    required ProgressRepository progressRepository,
    required StorageService storageService,
    required EventBus eventBus,
    required ReminderService reminderService,
    required FlutterLocalNotificationsPlugin notificationsPlugin,
  }) : _progressRepository = progressRepository,
       _storageService = storageService,
       _eventBus = eventBus,
       _reminderService = reminderService,
       _notificationsPlugin = notificationsPlugin;

  // Khởi tạo và lên lịch kiểm tra hàng ngày
  Future<bool> initialize() async {
    if (kIsWeb) {
      debugPrint('Daily task checker không được hỗ trợ trên web');
      return false;
    }

    try {
      // Khởi tạo android_alarm_manager
      final initResult = await AndroidAlarmManager.initialize();
      if (!initResult) {
        debugPrint('Không thể khởi tạo AndroidAlarmManager');
        return false;
      }

      // Lên lịch kiểm tra hàng ngày vào 00:05 sáng
      final scheduledTime = _getNextScheduleTime();

      final scheduleResult = await AndroidAlarmManager.periodic(
        const Duration(days: 1),
        DAILY_CHECK_ALARM_ID,
        _dailyTaskCheckCallback,
        startAt: scheduledTime,
        exact: true,
        wakeup: true,
        rescheduleOnReboot: true,
      );

      debugPrint(
        'Đã lên lịch kiểm tra task hàng ngày vào ${scheduledTime.toString()}: $scheduleResult',
      );
      return scheduleResult;
    } catch (e) {
      debugPrint('Lỗi khi khởi tạo daily task checker: $e');
      return false;
    }
  }

  // Callback được gọi khi alarm được kích hoạt
  @pragma('vm:entry-point')
  static Future<void> _dailyTaskCheckCallback() async {
    // Lưu ý: đây là một static method vì android_alarm_manager yêu cầu một top-level hoặc static function
    // Do đó, chúng ta cần tạo lại các service cần thiết

    try {
      debugPrint('Đang thực hiện kiểm tra task hàng ngày...');

      // Lấy SharedPreferences để lưu kết quả
      final prefs = await SharedPreferences.getInstance();

      // Lấy thông tin user
      final userData = await prefs.getString('user_data');
      if (userData != null) {
        final _ = Map<String, dynamic>.from(
          const JsonDecoder().convert(userData) as Map,
        );
      }

      // Lưu thời gian kiểm tra
      final now = DateTime.now();
      await prefs.setString(LAST_CHECK_TIME_KEY, now.toIso8601String());

      // Tạm thời đánh dấu lỗi, sẽ cập nhật lại nếu thành công
      await prefs.setBool(LAST_CHECK_RESULT_KEY, false);

      // Ở đây bạn sẽ cần kết nối với API để kiểm tra nhiệm vụ đến hạn
      // Đây chỉ là phần giả lập, bạn cần thay thế bằng kết nối API thật

      // Giả sử chúng ta có 2 task đến hạn
      final hasDueTasks = true;
      final taskCount = 2;

      // Lưu kết quả kiểm tra
      await prefs.setBool(LAST_CHECK_RESULT_KEY, true);
      await prefs.setInt(LAST_CHECK_TASK_COUNT_KEY, taskCount);

      // Hiển thị thông báo về kết quả kiểm tra
      await _showResultNotification(hasDueTasks, taskCount);

      debugPrint(
        'Kiểm tra task hàng ngày hoàn tất: có $taskCount nhiệm vụ đến hạn',
      );
    } catch (e) {
      debugPrint('Lỗi trong _dailyTaskCheckCallback: $e');
      // Lưu thông tin lỗi
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(LAST_CHECK_ERROR_KEY, e.toString());
    }
  }

  // Phương thức kiểm tra task đến hạn - đây là phiên bản non-static
  Future<DailyTaskCheckEvent> checkDueTasks() async {
    final now = DateTime.now();

    try {
      // Lấy thông tin người dùng
      final userData = await _storageService.getUserData();
      final userId = userData?['id'];

      if (userId == null) {
        debugPrint('Không thể kiểm tra task: Chưa đăng nhập');
        return DailyTaskCheckEvent(
          checkTime: now,
          hasDueTasks: false,
          taskCount: 0,
          userId: 'unknown',
          isSuccess: false,
          errorMessage: 'User not logged in',
        );
      }

      // Lấy danh sách task đến hạn hôm nay
      final progress = await _progressRepository.getDueProgress(
        userId.toString(),
        studyDate: now,
      );

      final hasTasks = progress.isNotEmpty;
      final taskCount = progress.length;

      debugPrint(
        'Kiểm tra task: ${hasTasks ? "Có $taskCount task" : "Không có task"}',
      );

      // Lưu kết quả kiểm tra
      await _storageService.setString(
        LAST_CHECK_TIME_KEY,
        now.toIso8601String(),
      );
      await _storageService.setBool(LAST_CHECK_RESULT_KEY, true);
      await _storageService.setInt(LAST_CHECK_TASK_COUNT_KEY, taskCount);

      // Nếu có task, cập nhật thông báo
      if (hasTasks) {
        await _reminderService.scheduleAllReminders();
      }

      // Gửi sự kiện để cập nhật UI
      final event = DailyTaskCheckEvent(
        checkTime: now,
        hasDueTasks: hasTasks,
        taskCount: taskCount,
        userId: userId.toString(),
        isSuccess: true,
      );

      _eventBus.fire(event);

      return event;
    } catch (e) {
      debugPrint('Lỗi khi kiểm tra task đến hạn: $e');

      // Lưu thông tin lỗi
      await _storageService.setString(LAST_CHECK_ERROR_KEY, e.toString());

      // Gửi sự kiện thất bại
      final event = DailyTaskCheckEvent(
        checkTime: now,
        hasDueTasks: false,
        taskCount: 0,
        userId: 'unknown',
        isSuccess: false,
        errorMessage: e.toString(),
      );

      _eventBus.fire(event);

      return event;
    }
  }

  // Phương thức để kiểm tra thủ công (có thể gọi từ UI)
  Future<DailyTaskCheckEvent> manualCheck() async {
    final event = await checkDueTasks();

    // Hiển thị thông báo về kết quả
    await _showResultNotificationInstance(event.hasDueTasks, event.taskCount);

    return event;
  }

  // Hiển thị thông báo kết quả (phiên bản static)
  static Future<void> _showResultNotification(
    bool hasDueTasks,
    int taskCount,
  ) async {
    try {
      final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      // Khởi tạo notification
      const androidSettings = AndroidInitializationSettings('ic_launcher');
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await flutterLocalNotificationsPlugin.initialize(initSettings);

      // Tạo notification
      const androidDetails = AndroidNotificationDetails(
        'daily_task_check_channel',
        'Daily Task Check',
        channelDescription: 'Notifications about daily task checks',
        importance: Importance.high,
        priority: Priority.high,
      );

      const iosDetails = DarwinNotificationDetails();

      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      // Hiển thị notification
      if (hasDueTasks) {
        await flutterLocalNotificationsPlugin.show(
          9000,
          'Có nhiệm vụ học tập hôm nay',
          'Bạn có $taskCount nhiệm vụ cần hoàn thành hôm nay.',
          notificationDetails,
        );
      } else {
        await flutterLocalNotificationsPlugin.show(
          9000,
          'Không có nhiệm vụ học tập hôm nay',
          'Bạn không có nhiệm vụ nào cần hoàn thành hôm nay.',
          notificationDetails,
        );
      }
    } catch (e) {
      debugPrint('Lỗi khi hiển thị thông báo kết quả: $e');
    }
  }

  // Hiển thị thông báo kết quả (phiên bản instance)
  Future<void> _showResultNotificationInstance(
    bool hasDueTasks,
    int taskCount,
  ) async {
    try {
      // Tạo notification
      const androidDetails = AndroidNotificationDetails(
        'daily_task_check_channel',
        'Daily Task Check',
        channelDescription: 'Notifications about daily task checks',
        importance: Importance.high,
        priority: Priority.high,
      );

      const iosDetails = DarwinNotificationDetails();

      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      // Hiển thị notification
      if (hasDueTasks) {
        await _notificationsPlugin.show(
          9000,
          'Có nhiệm vụ học tập hôm nay',
          'Bạn có $taskCount nhiệm vụ cần hoàn thành hôm nay.',
          notificationDetails,
        );
      } else {
        await _notificationsPlugin.show(
          9000,
          'Không có nhiệm vụ học tập hôm nay',
          'Bạn không có nhiệm vụ nào cần hoàn thành hôm nay.',
          notificationDetails,
        );
      }
    } catch (e) {
      debugPrint('Lỗi khi hiển thị thông báo kết quả: $e');
    }
  }

  // Lấy báo cáo kiểm tra gần nhất
  Future<Map<String, dynamic>> getLastCheckReport() async {
    try {
      final lastCheckTime = await _storageService.getString(
        LAST_CHECK_TIME_KEY,
      );
      final lastCheckResult =
          await _storageService.getBool(LAST_CHECK_RESULT_KEY) ?? false;
      final lastCheckTaskCount =
          await _storageService.getInt(LAST_CHECK_TASK_COUNT_KEY) ?? 0;
      final lastCheckError = await _storageService.getString(
        LAST_CHECK_ERROR_KEY,
      );

      return {
        'lastCheckTime': lastCheckTime != null
            ? DateTime.parse(lastCheckTime)
            : null,
        'lastCheckResult': lastCheckResult,
        'lastCheckTaskCount': lastCheckTaskCount,
        'lastCheckError': lastCheckError,
      };
    } catch (e) {
      debugPrint('Lỗi khi lấy báo cáo kiểm tra gần nhất: $e');
      return {
        'lastCheckTime': null,
        'lastCheckResult': false,
        'lastCheckTaskCount': 0,
        'lastCheckError': e.toString(),
      };
    }
  }

  // Tính toán thời gian lên lịch tiếp theo (00:05 AM)
  DateTime _getNextScheduleTime() {
    final now = DateTime.now();
    DateTime scheduledTime = DateTime(
      now.year,
      now.month,
      now.day,
      0, // 00 hour
      5, // 05 minute
    );

    // Nếu thời gian đã qua, lên lịch cho ngày mai
    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    return scheduledTime;
  }

  // Hủy lịch kiểm tra hàng ngày
  Future<bool> cancelDailyCheck() async {
    try {
      final result = await AndroidAlarmManager.cancel(DAILY_CHECK_ALARM_ID);
      debugPrint('Hủy lịch kiểm tra task hàng ngày: $result');
      return result;
    } catch (e) {
      debugPrint('Lỗi khi hủy lịch kiểm tra task hàng ngày: $e');
      return false;
    }
  }
}
