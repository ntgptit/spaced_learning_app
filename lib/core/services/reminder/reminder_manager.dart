// lib/core/services/reminder/reminder_manager.dart
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
  bool _isInitialized = false;

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
  Future<bool> initialize() async {
    if (_isInitialized) return true;

    try {
      // Load user preferences
      await _loadPreferences();

      // Initialize notification service
      final bool notificationsInitialized =
          await _notificationService.initialize();
      if (!notificationsInitialized) {
        debugPrint('Warning: Failed to initialize notification service');
        // Continue anyway
      }

      // Initialize device-specific services
      final bool deviceServicesInitialized =
          await _deviceSpecificService.initialize();
      if (!deviceServicesInitialized) {
        debugPrint('Warning: Failed to initialize device-specific services');
        // Continue anyway
      }

      // Schedule initial reminders if enabled
      if (_remindersEnabled) {
        await scheduleAllReminders();
      }

      _isInitialized = true;
      return true;
    } catch (e) {
      debugPrint('Error initializing ReminderManager: $e');
      return false;
    }
  }

  /// Load reminder preferences from storage
  Future<void> _loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      _remindersEnabled = await _storageService.getBool(_enabledKey) ?? true;
      _noonReminderEnabled =
          await _storageService.getBool(_noonReminderKey) ?? true;
      _eveningFirstReminderEnabled =
          await _storageService.getBool(_eveningFirstReminderKey) ?? true;
      _eveningSecondReminderEnabled =
          await _storageService.getBool(_eveningSecondReminderKey) ?? true;
      _endOfDayReminderEnabled =
          await _storageService.getBool(_endOfDayReminderKey) ?? true;

      debugPrint('Loaded reminder preferences:');
      debugPrint('- Reminders enabled: $_remindersEnabled');
      debugPrint('- Noon reminder: $_noonReminderEnabled');
      debugPrint('- Evening first: $_eveningFirstReminderEnabled');
      debugPrint('- Evening second: $_eveningSecondReminderEnabled');
      debugPrint('- End of day: $_endOfDayReminderEnabled');
    } catch (e) {
      debugPrint('Error loading reminder preferences: $e');
      // Use default values
    }
  }

  /// Save reminder preferences to storage
  Future<bool> _savePreferences() async {
    try {
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
      return true;
    } catch (e) {
      debugPrint('Error saving reminder preferences: $e');
      return false;
    }
  }

  /// Check if the user has pending tasks for today
  Future<bool> hasPendingTasksToday() async {
    try {
      // Get the current user ID
      final userData = await _storageService.getUserData();
      final userId = userData?['id'];

      if (userId == null) {
        debugPrint('Cannot check pending tasks: User not logged in');
        return false; // Not logged in
      }

      // Load due progress for today
      await _progressViewModel.loadDueProgress(
        userId.toString(),
        studyDate: DateTime.now(),
      );

      // Check if there are any due tasks
      final hasTasks = _progressViewModel.progressRecords.isNotEmpty;
      debugPrint('Pending tasks check: ${hasTasks ? 'Has tasks' : 'No tasks'}');
      return hasTasks;
    } catch (e) {
      debugPrint('Error checking pending tasks: $e');
      return false; // Assume no tasks on error
    }
  }

  /// Schedule all reminders with device-specific optimizations
  Future<bool> scheduleAllReminders() async {
    try {
      if (!_isInitialized) {
        final bool initialized = await initialize();
        if (!initialized) {
          debugPrint('Failed to initialize ReminderManager');
          return false;
        }
      }

      // Cancel existing reminders first
      await _notificationService.cancelAllNotifications();

      // Only proceed if reminders are globally enabled
      if (!_remindersEnabled) {
        debugPrint('Reminders are disabled, not scheduling any reminders');
        return true;
      }

      // Schedule noon reminder (always shows regardless of pending tasks)
      if (_noonReminderEnabled) {
        final bool noonResult =
            await _notificationService.scheduleNoonReminder();
        debugPrint('Noon reminder scheduled: $noonResult');
      }

      // Check if the user has pending tasks
      final hasPendingTasks = await hasPendingTasksToday();

      // Only schedule evening and end-of-day reminders if there are pending tasks
      if (hasPendingTasks) {
        if (_eveningFirstReminderEnabled) {
          final bool eveningFirstResult =
              await _notificationService.scheduleEveningFirstReminder();
          debugPrint('Evening first reminder scheduled: $eveningFirstResult');
        }

        if (_eveningSecondReminderEnabled) {
          final bool eveningSecondResult =
              await _notificationService.scheduleEveningSecondReminder();
          debugPrint('Evening second reminder scheduled: $eveningSecondResult');
        }

        if (_endOfDayReminderEnabled) {
          // For end-of-day reminders, use alarm style only on compatible devices
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
      } else {
        debugPrint(
          'No pending tasks today, skipping evening and end-of-day reminders',
        );
      }

      return true;
    } catch (e) {
      debugPrint('Error scheduling reminders: $e');
      return false;
    }
  }

  /// Update reminders after task completion
  Future<bool> updateRemindersAfterTaskCompletion() async {
    try {
      // Check if there are still pending tasks
      final stillHasPendingTasks = await hasPendingTasksToday();

      // If all tasks are completed, cancel the evening and end-of-day reminders
      if (!stillHasPendingTasks) {
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
      }
      return true;
    } catch (e) {
      debugPrint('Error updating reminders after task completion: $e');
      return false;
    }
  }

  // Getters for current settings
  bool get remindersEnabled => _remindersEnabled;
  bool get noonReminderEnabled => _noonReminderEnabled;
  bool get eveningFirstReminderEnabled => _eveningFirstReminderEnabled;
  bool get eveningSecondReminderEnabled => _eveningSecondReminderEnabled;
  bool get endOfDayReminderEnabled => _endOfDayReminderEnabled;
  bool get isInitialized => _isInitialized;

  // Setters with automatic scheduling
  Future<bool> setRemindersEnabled(bool value) async {
    if (_remindersEnabled == value) return true;

    _remindersEnabled = value;
    final bool saved = await _savePreferences();
    if (!saved) return false;

    if (_remindersEnabled) {
      return scheduleAllReminders();
    } else {
      return _notificationService.cancelAllNotifications();
    }
  }

  Future<bool> setNoonReminderEnabled(bool value) async {
    if (_noonReminderEnabled == value) return true;

    _noonReminderEnabled = value;
    final bool saved = await _savePreferences();
    if (!saved) return false;

    if (_remindersEnabled) {
      if (_noonReminderEnabled) {
        return _notificationService.scheduleNoonReminder();
      } else {
        return _notificationService.cancelNotification(
          NotificationService.noonReminderId,
        );
      }
    }
    return true;
  }

  Future<bool> setEveningFirstReminderEnabled(bool value) async {
    if (_eveningFirstReminderEnabled == value) return true;

    _eveningFirstReminderEnabled = value;
    final bool saved = await _savePreferences();
    if (!saved) return false;

    if (_remindersEnabled) {
      if (_eveningFirstReminderEnabled && await hasPendingTasksToday()) {
        return _notificationService.scheduleEveningFirstReminder();
      } else {
        return _notificationService.cancelNotification(
          NotificationService.eveningFirstReminderId,
        );
      }
    }
    return true;
  }

  Future<bool> setEveningSecondReminderEnabled(bool value) async {
    if (_eveningSecondReminderEnabled == value) return true;

    _eveningSecondReminderEnabled = value;
    final bool saved = await _savePreferences();
    if (!saved) return false;

    if (_remindersEnabled) {
      if (_eveningSecondReminderEnabled && await hasPendingTasksToday()) {
        return _notificationService.scheduleEveningSecondReminder();
      } else {
        return _notificationService.cancelNotification(
          NotificationService.eveningSecondReminderId,
        );
      }
    }
    return true;
  }

  Future<bool> setEndOfDayReminderEnabled(bool value) async {
    if (_endOfDayReminderEnabled == value) return true;

    _endOfDayReminderEnabled = value;
    final bool saved = await _savePreferences();
    if (!saved) return false;

    if (_remindersEnabled) {
      if (_endOfDayReminderEnabled && await hasPendingTasksToday()) {
        return _notificationService.scheduleEndOfDayReminder();
      } else {
        return _notificationService.cancelNotification(
          NotificationService.endOfDayReminderId,
        );
      }
    }
    return true;
  }
}
