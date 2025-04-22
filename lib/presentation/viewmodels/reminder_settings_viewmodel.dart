import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/events/app_events.dart';
import 'package:spaced_learning_app/core/services/platform/device_settings_service.dart';
import 'package:spaced_learning_app/core/services/reminder/reminder_service.dart';
import 'package:spaced_learning_app/presentation/viewmodels/base_viewmodel.dart';

class ReminderSettingsViewModel extends BaseViewModel {
  final ReminderService _reminderService;
  final DeviceSettingsService _deviceSettingsService;
  final EventBus _eventBus;

  bool _remindersEnabled = true;
  bool _noonReminderEnabled = true;
  bool _eveningFirstReminderEnabled = true;
  bool _eveningSecondReminderEnabled = true;
  bool _endOfDayReminderEnabled = true;

  bool _hasExactAlarmPermission = false;
  bool _isIgnoringBatteryOptimizations = false;
  Map<String, dynamic> _deviceInfo = {};

  bool get remindersEnabled => _remindersEnabled;

  bool get noonReminderEnabled => _noonReminderEnabled;

  bool get eveningFirstReminderEnabled => _eveningFirstReminderEnabled;

  bool get eveningSecondReminderEnabled => _eveningSecondReminderEnabled;

  bool get endOfDayReminderEnabled => _endOfDayReminderEnabled;

  bool get hasExactAlarmPermission => _hasExactAlarmPermission;

  bool get isIgnoringBatteryOptimizations => _isIgnoringBatteryOptimizations;

  Map<String, dynamic> get deviceInfo => _deviceInfo;

  ReminderSettingsViewModel({
    required ReminderService reminderService,
    required DeviceSettingsService deviceSettingsService,
    required EventBus eventBus,
  }) : _reminderService = reminderService,
       _deviceSettingsService = deviceSettingsService,
       _eventBus = eventBus {
    _loadSettings();
  }

  /// Load all reminder settings
  Future<void> _loadSettings() async {
    beginLoading();
    try {
      _remindersEnabled = await _reminderService.getRemindersEnabled();
      _noonReminderEnabled = await _reminderService.getNoonReminderEnabled();
      _eveningFirstReminderEnabled = await _reminderService
          .getEveningFirstReminderEnabled();
      _eveningSecondReminderEnabled = await _reminderService
          .getEveningSecondReminderEnabled();
      _endOfDayReminderEnabled = await _reminderService
          .getEndOfDayReminderEnabled();

      await _loadDevicePermissions();

      setInitialized(true);
    } catch (e) {
      handleError(e, prefix: 'Failed to load reminder settings');
    } finally {
      endLoading();
    }
  }

  /// Load device permissions
  Future<void> _loadDevicePermissions() async {
    try {
      _hasExactAlarmPermission = await _deviceSettingsService
          .hasExactAlarmPermission();
      _isIgnoringBatteryOptimizations = await _deviceSettingsService
          .isIgnoringBatteryOptimizations();
      _deviceInfo = await _deviceSettingsService.getDeviceInfo();
    } catch (e) {
      debugPrint('Error loading device permissions: $e');
      _hasExactAlarmPermission = false;
      _isIgnoringBatteryOptimizations = false;
      _deviceInfo = {
        'sdkVersion': 0,
        'manufacturer': 'Unknown',
        'model': 'Unknown',
      };
    }
  }

  /// Enable/disable all reminders
  Future<bool> setRemindersEnabled(bool value) async {
    if (_remindersEnabled == value) return true;

    return await safeCall<bool>(
          action: () async {
            final success = await _reminderService.setRemindersEnabled(value);
            if (success) {
              _remindersEnabled = value;
              _eventBus.fire(ReminderSettingsChangedEvent(enabled: value));
            }
            return success;
          },
          errorPrefix: 'Failed to update reminders setting',
        ) ??
        false;
  }

  /// Enable/disable noon reminder
  Future<bool> setNoonReminderEnabled(bool value) async {
    if (_noonReminderEnabled == value) return true;

    return await safeCall<bool>(
          action: () async {
            final success = await _reminderService.setNoonReminderEnabled(
              value,
            );
            if (success) {
              _noonReminderEnabled = value;
            }
            return success;
          },
          errorPrefix: 'Failed to update noon reminder setting',
        ) ??
        false;
  }

  /// Enable/disable evening first reminder
  Future<bool> setEveningFirstReminderEnabled(bool value) async {
    if (_eveningFirstReminderEnabled == value) return true;

    return await safeCall<bool>(
          action: () async {
            final success = await _reminderService
                .setEveningFirstReminderEnabled(value);
            if (success) {
              _eveningFirstReminderEnabled = value;
            }
            return success;
          },
          errorPrefix: 'Failed to update evening first reminder setting',
        ) ??
        false;
  }

  /// Enable/disable evening second reminder
  Future<bool> setEveningSecondReminderEnabled(bool value) async {
    if (_eveningSecondReminderEnabled == value) return true;

    return await safeCall<bool>(
          action: () async {
            final success = await _reminderService
                .setEveningSecondReminderEnabled(value);
            if (success) {
              _eveningSecondReminderEnabled = value;
            }
            return success;
          },
          errorPrefix: 'Failed to update evening second reminder setting',
        ) ??
        false;
  }

  /// Enable/disable end of day reminder
  Future<bool> setEndOfDayReminderEnabled(bool value) async {
    if (_endOfDayReminderEnabled == value) return true;

    return await safeCall<bool>(
          action: () async {
            final success = await _reminderService.setEndOfDayReminderEnabled(
              value,
            );
            if (success) {
              _endOfDayReminderEnabled = value;
            }
            return success;
          },
          errorPrefix: 'Failed to update end of day reminder setting',
        ) ??
        false;
  }

  /// Request exact alarm permission
  Future<bool> requestExactAlarmPermission() async {
    return await safeCall<bool>(
          action: () async {
            final result = await _deviceSettingsService
                .requestExactAlarmPermission();
            if (result) {
              _hasExactAlarmPermission = await _deviceSettingsService
                  .hasExactAlarmPermission();
            }
            return result;
          },
          errorPrefix: 'Failed to request exact alarm permission',
        ) ??
        false;
  }

  /// Request battery optimization exemption
  Future<bool> requestBatteryOptimization() async {
    return await safeCall<bool>(
          action: () async {
            final result = await _deviceSettingsService
                .requestBatteryOptimization();
            if (result) {
              _isIgnoringBatteryOptimizations = await _deviceSettingsService
                  .isIgnoringBatteryOptimizations();
            }
            return result;
          },
          errorPrefix: 'Failed to request battery optimization',
        ) ??
        false;
  }

  /// Open device settings to disable sleeping apps
  Future<bool> disableSleepingApps() async {
    return await safeCall<bool>(
          action: () => _deviceSettingsService.disableSleepingApps(),
          errorPrefix: 'Failed to disable sleeping apps',
        ) ??
        false;
  }

  /// Refresh all settings
  Future<void> refreshSettings() async {
    beginLoading();
    try {
      await _loadSettings();
    } catch (e) {
      handleError(e, prefix: 'Failed to refresh settings');
    } finally {
      endLoading();
    }
  }
}
