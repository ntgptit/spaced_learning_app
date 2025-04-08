import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spaced_learning_app/core/di/service_locator.dart';
import 'package:spaced_learning_app/core/services/reminder/device_specific_service.dart';
import 'package:spaced_learning_app/core/services/reminder/notification_service.dart';
import 'package:spaced_learning_app/core/services/storage_service.dart';
import 'package:spaced_learning_app/presentation/viewmodels/progress_viewmodel.dart';

/// Manager for handling all reminder-related operations
class ReminderManager {
  final NotificationService _notificationService;
  final StorageService _storageService;
  final ProgressViewModel _progressViewModel;
  final DeviceSpecificService _deviceSpecificService;

  // Preference keys
  static const String _enabledKey = 'reminders_enabled';
  static const String _noonReminderKey = 'noon_reminder_enabled';
  static const String _eveningFirstReminderKey =
      'evening_first_reminder_enabled';
  static const String _eveningSecondReminderKey =
      'evening_second_reminder_enabled';
  static const String _endOfDayReminderKey = 'end_of_day_reminder_enabled';

  // Default settings
  bool _remindersEnabled = true;
  bool _noonReminderEnabled = true;
  bool _eveningFirstReminderEnabled = true;
  bool _eveningSecondReminderEnabled = true;
  bool _endOfDayReminderEnabled = true;

  // Constructor
  ReminderManager({
    NotificationService? notificationService,
    StorageService? storageService,
    ProgressViewModel? progressViewModel,
    DeviceSpecificService? deviceSpecificService,
  }) : _notificationService =
           notificationService ?? serviceLocator<NotificationService>(),
       _storageService = storageService ?? serviceLocator<StorageService>(),
       _progressViewModel =
           progressViewModel ?? serviceLocator<ProgressViewModel>(),
       _deviceSpecificService =
           deviceSpecificService ?? serviceLocator<DeviceSpecificService>();

  /// Initialize the reminder manager
  Future<void> initialize() async {
    // Load user preferences
    await _loadPreferences();

    // Initialize notification service
    await _notificationService.initialize();

    // Schedule initial reminders if enabled
    if (_remindersEnabled) {
      await scheduleAllReminders();
    }
  }

  /// Load reminder preferences from storage
  Future<void> _loadPreferences() async {
    await SharedPreferences.getInstance();

    _remindersEnabled = await _storageService.getBool(_enabledKey) ?? true;
    _noonReminderEnabled =
        await _storageService.getBool(_noonReminderKey) ?? true;
    _eveningFirstReminderEnabled =
        await _storageService.getBool(_eveningFirstReminderKey) ?? true;
    _eveningSecondReminderEnabled =
        await _storageService.getBool(_eveningSecondReminderKey) ?? true;
    _endOfDayReminderEnabled =
        await _storageService.getBool(_endOfDayReminderKey) ?? true;
  }

  /// Save reminder preferences to storage
  Future<void> _savePreferences() async {
    await _storageService.setBool(_enabledKey, _remindersEnabled);
    await _storageService.setBool(_noonReminderKey, _noonReminderEnabled);
    await _storageService.setBool(
      _eveningFirstReminderKey,
      _eveningFirstReminderEnabled,
    );
    await _storageService.setBool(
      _eveningSecondReminderKey,
      _eveningSecondReminderEnabled,
    );
    await _storageService.setBool(
      _endOfDayReminderKey,
      _endOfDayReminderEnabled,
    );
  }

  /// Check if the user has pending tasks for today
  Future<bool> hasPendingTasksToday() async {
    try {
      // Get the current user ID
      final userData = await _storageService.getUserData();
      final userId = userData?['id'];

      if (userId == null) {
        return false; // Not logged in
      }

      // Load due progress for today
      await _progressViewModel.loadDueProgress(
        userId.toString(),
        studyDate: DateTime.now(),
      );

      // Check if there are any due tasks
      return _progressViewModel.progressRecords.isNotEmpty;
    } catch (e) {
      debugPrint('Error checking pending tasks: $e');
      return false; // Assume no tasks on error
    }
  }

  /// Schedule all reminders with device-specific optimizations
  Future<void> scheduleAllReminders() async {
    try {
      // Cancel existing reminders first
      await _notificationService.cancelAllNotifications();

      // Only proceed if reminders are globally enabled
      if (!_remindersEnabled) return;

      // Schedule noon reminder (always shows regardless of pending tasks)
      if (_noonReminderEnabled) {
        await _notificationService.scheduleNoonReminder();
      }

      // Check if the user has pending tasks
      final hasPendingTasks = await hasPendingTasksToday();

      // Only schedule evening and end-of-day reminders if there are pending tasks
      if (hasPendingTasks) {
        if (_eveningFirstReminderEnabled) {
          await _notificationService.scheduleEveningFirstReminder();
        }

        if (_eveningSecondReminderEnabled) {
          await _notificationService.scheduleEveningSecondReminder();
        }

        if (_endOfDayReminderEnabled) {
          // For end-of-day reminders, use alarm style only on compatible devices
          final useAlarmStyle =
              _deviceSpecificService.isAndroid &&
              (_deviceSpecificService.isSamsungDevice ||
                  _deviceSpecificService.sdkVersion >= 26);

          await _notificationService.scheduleEndOfDayReminder(
            useAlarmStyle: useAlarmStyle,
          );
        }
      }
    } catch (e) {
      debugPrint('Error scheduling reminders: $e');
    }
  }

  /// Update reminders after task completion
  Future<void> updateRemindersAfterTaskCompletion() async {
    // Check if there are still pending tasks
    final stillHasPendingTasks = await hasPendingTasksToday();

    // If all tasks are completed, cancel the evening and end-of-day reminders
    if (!stillHasPendingTasks) {
      await _notificationService.cancelNotification(
        NotificationService.eveningFirstReminderId,
      );
      await _notificationService.cancelNotification(
        NotificationService.eveningSecondReminderId,
      );
      await _notificationService.cancelNotification(
        NotificationService.endOfDayReminderId,
      );
    }
  }

  // Getters for current settings
  bool get remindersEnabled => _remindersEnabled;
  bool get noonReminderEnabled => _noonReminderEnabled;
  bool get eveningFirstReminderEnabled => _eveningFirstReminderEnabled;
  bool get eveningSecondReminderEnabled => _eveningSecondReminderEnabled;
  bool get endOfDayReminderEnabled => _endOfDayReminderEnabled;

  // Setters with automatic scheduling
  Future<void> setRemindersEnabled(bool value) async {
    _remindersEnabled = value;
    await _savePreferences();

    if (_remindersEnabled) {
      await scheduleAllReminders();
    } else {
      await _notificationService.cancelAllNotifications();
    }
  }

  Future<void> setNoonReminderEnabled(bool value) async {
    _noonReminderEnabled = value;
    await _savePreferences();

    if (_remindersEnabled) {
      if (_noonReminderEnabled) {
        await _notificationService.scheduleNoonReminder();
      } else {
        await _notificationService.cancelNotification(
          NotificationService.noonReminderId,
        );
      }
    }
  }

  Future<void> setEveningFirstReminderEnabled(bool value) async {
    _eveningFirstReminderEnabled = value;
    await _savePreferences();

    if (_remindersEnabled) {
      if (_eveningFirstReminderEnabled && await hasPendingTasksToday()) {
        await _notificationService.scheduleEveningFirstReminder();
      } else {
        await _notificationService.cancelNotification(
          NotificationService.eveningFirstReminderId,
        );
      }
    }
  }

  Future<void> setEveningSecondReminderEnabled(bool value) async {
    _eveningSecondReminderEnabled = value;
    await _savePreferences();

    if (_remindersEnabled) {
      if (_eveningSecondReminderEnabled && await hasPendingTasksToday()) {
        await _notificationService.scheduleEveningSecondReminder();
      } else {
        await _notificationService.cancelNotification(
          NotificationService.eveningSecondReminderId,
        );
      }
    }
  }

  Future<void> setEndOfDayReminderEnabled(bool value) async {
    _endOfDayReminderEnabled = value;
    await _savePreferences();

    if (_remindersEnabled) {
      if (_endOfDayReminderEnabled && await hasPendingTasksToday()) {
        await _notificationService.scheduleEndOfDayReminder();
      } else {
        await _notificationService.cancelNotification(
          NotificationService.endOfDayReminderId,
        );
      }
    }
  }
}
