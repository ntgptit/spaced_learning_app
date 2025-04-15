// lib/core/services/reminder/reminder_service.dart
import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/events/app_events.dart';
import 'package:spaced_learning_app/core/services/reminder/device_specific_service.dart';
import 'package:spaced_learning_app/core/services/reminder/notification_service.dart';
import 'package:spaced_learning_app/core/services/storage_service.dart';
import 'package:spaced_learning_app/domain/repositories/progress_repository.dart';

class ReminderService {
  final NotificationService _notificationService;
  final StorageService _storageService;
  final DeviceSpecificService _deviceSpecificService;
  final ProgressRepository _progressRepository;
  final EventBus _eventBus;

  // Để quản lý subscriptions
  final List<StreamSubscription> _subscriptions = [];

  bool _isInitialized = false;
  bool _isScheduling = false;

  ReminderService({
    required NotificationService notificationService,
    required StorageService storageService,
    required DeviceSpecificService deviceSpecificService,
    required ProgressRepository progressRepository,
    required EventBus eventBus,
  }) : _notificationService = notificationService,
       _storageService = storageService,
       _deviceSpecificService = deviceSpecificService,
       _progressRepository = progressRepository,
       _eventBus = eventBus {
    // Lắng nghe các sự kiện
    _listenToEvents();
  }

  void _listenToEvents() {
    // Đăng ký để nhận sự kiện ProgressChangedEvent
    _subscriptions.add(
      _eventBus.on<ProgressChangedEvent>().listen((event) {
        _handleProgressChanged(event);
      }),
    );

    // Đăng ký để nhận sự kiện TaskCompletedEvent
    _subscriptions.add(
      _eventBus.on<TaskCompletedEvent>().listen((event) {
        _handleTaskCompleted(event);
      }),
    );

    // Đăng ký để nhận sự kiện ReminderSettingsChangedEvent
    _subscriptions.add(
      _eventBus.on<ReminderSettingsChangedEvent>().listen((event) {
        _handleSettingsChanged(event);
      }),
    );
  }

  // Phương thức để hủy đăng ký tất cả sự kiện khi không còn cần thiết
  void dispose() {
    for (var subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions.clear();
  }

  void _handleProgressChanged(ProgressChangedEvent event) {
    // Schedule reminders based on due tasks
    if (event.hasDueTasks) {
      scheduleAllReminders();
    }
  }

  void _handleTaskCompleted(TaskCompletedEvent event) {
    // Update reminders after task completion
    updateRemindersAfterTaskCompletion();
  }

  void _handleSettingsChanged(ReminderSettingsChangedEvent event) {
    // Enable/disable reminders based on settings
    if (event.enabled) {
      scheduleAllReminders();
    } else {
      _notificationService.cancelAllNotifications();
    }
  }

  Future<bool> initialize() async {
    if (_isInitialized) return true;

    try {
      await _loadPreferences();

      final bool notificationsInitialized =
          await _notificationService.initialize();
      if (!notificationsInitialized) {
        debugPrint('Warning: Failed to initialize notification service');
      }

      final bool deviceServicesInitialized =
          await _deviceSpecificService.initialize();
      if (!deviceServicesInitialized) {
        debugPrint('Warning: Failed to initialize device-specific services');
      }

      final remindersEnabled =
          await _storageService.getBool('reminders_enabled') ?? true;
      if (remindersEnabled) {
        await scheduleAllReminders();
      }

      _isInitialized = true;
      return true;
    } catch (e) {
      debugPrint('Error initializing ReminderService: $e');
      return false;
    }
  }

  Future<void> _loadPreferences() async {
    // Implementation for loading reminder preferences
    try {
      // Sử dụng StorageService để tải tất cả cài đặt nhắc nhở từ local storage
      // Không cần lưu trữ trong biến instance vì sẽ tải trực tiếp từ storage khi cần
      debugPrint('Reminder preferences loaded');
    } catch (e) {
      debugPrint('Error loading reminder preferences: $e');
    }
  }

  Future<bool> hasPendingTasksToday() async {
    final userData = await _storageService.getUserData();
    final userId = userData?['id'];

    if (userId == null) {
      debugPrint('Cannot check pending tasks: User not logged in');
      return false; // Return early if user not logged in
    }

    try {
      final today = DateTime.now();
      final progress = await _progressRepository.getDueProgress(
        userId.toString(),
        studyDate: today,
      );

      final hasTasks = progress.isNotEmpty;
      debugPrint('Pending tasks check: ${hasTasks ? 'Has tasks' : 'No tasks'}');
      return hasTasks;
    } catch (e) {
      debugPrint('Error checking pending tasks: $e');
      return false; // Return false on error
    }
  }

  Future<bool> scheduleAllReminders() async {
    if (_isScheduling) return false;
    _isScheduling = true;

    try {
      if (!_isInitialized) {
        final bool initialized = await initialize();
        if (!initialized) {
          debugPrint('Failed to initialize ReminderService');
          _isScheduling = false;
          return false;
        }
      }

      await _notificationService.cancelAllNotifications();

      final remindersEnabled =
          await _storageService.getBool('reminders_enabled') ?? true;
      if (!remindersEnabled) {
        debugPrint('Reminders are disabled, not scheduling any reminders');
        _isScheduling = false;
        return true;
      }

      final noonReminderEnabled =
          await _storageService.getBool('noon_reminder_enabled') ?? true;
      if (noonReminderEnabled) {
        final bool noonResult =
            await _notificationService.scheduleNoonReminder();
        debugPrint('Noon reminder scheduled: $noonResult');
      }

      final hasPendingTasks = await hasPendingTasksToday();
      if (!hasPendingTasks) {
        debugPrint(
          'No pending tasks today, skipping evening and end-of-day reminders',
        );
        _isScheduling = false;
        return true;
      }

      final eveningFirstReminderEnabled =
          await _storageService.getBool('evening_first_reminder_enabled') ??
          true;
      if (eveningFirstReminderEnabled) {
        final bool eveningFirstResult =
            await _notificationService.scheduleEveningFirstReminder();
        debugPrint('Evening first reminder scheduled: $eveningFirstResult');
      }

      final eveningSecondReminderEnabled =
          await _storageService.getBool('evening_second_reminder_enabled') ??
          true;
      if (eveningSecondReminderEnabled) {
        final bool eveningSecondResult =
            await _notificationService.scheduleEveningSecondReminder();
        debugPrint('Evening second reminder scheduled: $eveningSecondResult');
      }

      final endOfDayReminderEnabled =
          await _storageService.getBool('end_of_day_reminder_enabled') ?? true;
      if (endOfDayReminderEnabled) {
        final useAlarmStyle =
            _deviceSpecificService.isAndroid &&
            (_deviceSpecificService.isSamsungDevice ||
                _deviceSpecificService.sdkVersion >= 26);

        final bool endOfDayResult = await _notificationService
            .scheduleEndOfDayReminder(useAlarmStyle: useAlarmStyle);
        debugPrint(
          'End of day reminder scheduled: $endOfDayResult (alarm style: $useAlarmStyle)',
        );
      }

      _isScheduling = false;
      return true;
    } catch (e) {
      debugPrint('Error scheduling reminders: $e');
      _isScheduling = false;
      return false;
    }
  }

  Future<bool> updateRemindersAfterTaskCompletion() async {
    try {
      final stillHasPendingTasks = await hasPendingTasksToday();
      if (stillHasPendingTasks) {
        return true;
      }

      debugPrint(
        'All tasks completed, cancelling evening and end-of-day reminders',
      );
      await _notificationService.cancelNotification(
        NotificationService.eveningFirstReminderId,
      );
      await _notificationService.cancelNotification(
        NotificationService.eveningSecondReminderId,
      );
      await _notificationService.cancelNotification(
        NotificationService.endOfDayReminderId,
      );
      return true;
    } catch (e) {
      debugPrint('Error updating reminders after task completion: $e');
      return false;
    }
  }

  // Getter methods to read reminder settings
  Future<bool> getRemindersEnabled() async {
    return await _storageService.getBool('reminders_enabled') ?? true;
  }

  Future<bool> getNoonReminderEnabled() async {
    return await _storageService.getBool('noon_reminder_enabled') ?? true;
  }

  Future<bool> getEveningFirstReminderEnabled() async {
    return await _storageService.getBool('evening_first_reminder_enabled') ??
        true;
  }

  Future<bool> getEveningSecondReminderEnabled() async {
    return await _storageService.getBool('evening_second_reminder_enabled') ??
        true;
  }

  Future<bool> getEndOfDayReminderEnabled() async {
    return await _storageService.getBool('end_of_day_reminder_enabled') ?? true;
  }

  // Setter methods to persist reminder settings and update notifications
  Future<bool> setRemindersEnabled(bool value) async {
    try {
      await _storageService.setBool('reminders_enabled', value);
      if (value) {
        return await scheduleAllReminders();
      }
      return await _notificationService.cancelAllNotifications();
    } catch (e) {
      debugPrint('Error setting reminders enabled: $e');
      return false;
    }
  }

  Future<bool> setNoonReminderEnabled(bool value) async {
    try {
      await _storageService.setBool('noon_reminder_enabled', value);
      final remindersEnabled =
          await _storageService.getBool('reminders_enabled') ?? true;
      if (!remindersEnabled) {
        return true;
      }

      if (value) {
        return await _notificationService.scheduleNoonReminder();
      }
      return await _notificationService.cancelNotification(
        NotificationService.noonReminderId,
      );
    } catch (e) {
      debugPrint('Error setting noon reminder: $e');
      return false;
    }
  }

  Future<bool> setEveningFirstReminderEnabled(bool value) async {
    try {
      await _storageService.setBool('evening_first_reminder_enabled', value);
      final remindersEnabled =
          await _storageService.getBool('reminders_enabled') ?? true;
      if (!remindersEnabled) {
        return true;
      }

      if (value && await hasPendingTasksToday()) {
        return await _notificationService.scheduleEveningFirstReminder();
      }
      return await _notificationService.cancelNotification(
        NotificationService.eveningFirstReminderId,
      );
    } catch (e) {
      debugPrint('Error setting evening first reminder: $e');
      return false;
    }
  }

  Future<bool> setEveningSecondReminderEnabled(bool value) async {
    try {
      await _storageService.setBool('evening_second_reminder_enabled', value);
      final remindersEnabled =
          await _storageService.getBool('reminders_enabled') ?? true;
      if (!remindersEnabled) {
        return true;
      }

      if (value && await hasPendingTasksToday()) {
        return await _notificationService.scheduleEveningSecondReminder();
      }
      return await _notificationService.cancelNotification(
        NotificationService.eveningSecondReminderId,
      );
    } catch (e) {
      debugPrint('Error setting evening second reminder: $e');
      return false;
    }
  }

  Future<bool> setEndOfDayReminderEnabled(bool value) async {
    try {
      await _storageService.setBool('end_of_day_reminder_enabled', value);
      final remindersEnabled =
          await _storageService.getBool('reminders_enabled') ?? true;
      if (!remindersEnabled) {
        return true;
      }

      if (value && await hasPendingTasksToday()) {
        return await _notificationService.scheduleEndOfDayReminder();
      }
      return await _notificationService.cancelNotification(
        NotificationService.endOfDayReminderId,
      );
    } catch (e) {
      debugPrint('Error setting end of day reminder: $e');
      return false;
    }
  }
}
