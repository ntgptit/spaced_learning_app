// lib/presentation/viewmodels/reminder_settings_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/di/service_locator.dart';
import 'package:spaced_learning_app/core/services/platform/device_settings_service.dart';
import 'package:spaced_learning_app/core/services/reminder/reminder_manager.dart';
import 'package:spaced_learning_app/presentation/viewmodels/base_viewmodel.dart';

class ReminderSettingsViewModel extends BaseViewModel {
  final ReminderManager _reminderManager;
  final DeviceSettingsService _deviceSettingsService = DeviceSettingsService();

  bool _remindersEnabled = true;
  bool _noonReminderEnabled = true;
  bool _eveningFirstReminderEnabled = true;
  bool _eveningSecondReminderEnabled = true;
  bool _endOfDayReminderEnabled = true;

  // Device permissions status
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

  ReminderSettingsViewModel({ReminderManager? reminderManager})
    : _reminderManager = reminderManager ?? serviceLocator<ReminderManager>() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    beginLoading();
    try {
      // Load reminder settings
      _remindersEnabled = _reminderManager.remindersEnabled;
      _noonReminderEnabled = _reminderManager.noonReminderEnabled;
      _eveningFirstReminderEnabled =
          _reminderManager.eveningFirstReminderEnabled;
      _eveningSecondReminderEnabled =
          _reminderManager.eveningSecondReminderEnabled;
      _endOfDayReminderEnabled = _reminderManager.endOfDayReminderEnabled;

      // Load device permissions status
      await _loadDevicePermissions();

      setInitialized(true);
    } catch (e) {
      handleError(e, prefix: 'Failed to load reminder settings');
    } finally {
      endLoading();
    }
  }

  Future<void> _loadDevicePermissions() async {
    try {
      _hasExactAlarmPermission =
          await _deviceSettingsService.hasExactAlarmPermission();
      _isIgnoringBatteryOptimizations =
          await _deviceSettingsService.isIgnoringBatteryOptimizations();
      _deviceInfo = await _deviceSettingsService.getDeviceInfo();
    } catch (e) {
      debugPrint('Error loading device permissions: $e');
      // Set default values
      _hasExactAlarmPermission = false;
      _isIgnoringBatteryOptimizations = false;
      _deviceInfo = {
        'sdkVersion': 0,
        'manufacturer': 'Unknown',
        'model': 'Unknown',
      };
    }
  }

  // Method to set main reminders enabled/disabled
  Future<bool> setRemindersEnabled(bool value) async {
    if (_remindersEnabled == value) return true;

    beginLoading();
    try {
      final success = await _reminderManager.setRemindersEnabled(value);
      if (success) {
        _remindersEnabled = value;
        notifyListeners();
      }
      return success;
    } catch (e) {
      handleError(e, prefix: 'Failed to update reminders setting');
      return false;
    } finally {
      endLoading();
    }
  }

  // Method to set noon reminder enabled/disabled
  Future<bool> setNoonReminderEnabled(bool value) async {
    if (_noonReminderEnabled == value) return true;

    beginLoading();
    try {
      final success = await _reminderManager.setNoonReminderEnabled(value);
      if (success) {
        _noonReminderEnabled = value;
        notifyListeners();
      }
      return success;
    } catch (e) {
      handleError(e, prefix: 'Failed to update noon reminder setting');
      return false;
    } finally {
      endLoading();
    }
  }

  // Method to set evening first reminder enabled/disabled
  Future<bool> setEveningFirstReminderEnabled(bool value) async {
    if (_eveningFirstReminderEnabled == value) return true;

    beginLoading();
    try {
      final success = await _reminderManager.setEveningFirstReminderEnabled(
        value,
      );
      if (success) {
        _eveningFirstReminderEnabled = value;
        notifyListeners();
      }
      return success;
    } catch (e) {
      handleError(e, prefix: 'Failed to update evening first reminder setting');
      return false;
    } finally {
      endLoading();
    }
  }

  // Method to set evening second reminder enabled/disabled
  Future<bool> setEveningSecondReminderEnabled(bool value) async {
    if (_eveningSecondReminderEnabled == value) return true;

    beginLoading();
    try {
      final success = await _reminderManager.setEveningSecondReminderEnabled(
        value,
      );
      if (success) {
        _eveningSecondReminderEnabled = value;
        notifyListeners();
      }
      return success;
    } catch (e) {
      handleError(
        e,
        prefix: 'Failed to update evening second reminder setting',
      );
      return false;
    } finally {
      endLoading();
    }
  }

  // Method to set end of day reminder enabled/disabled
  Future<bool> setEndOfDayReminderEnabled(bool value) async {
    if (_endOfDayReminderEnabled == value) return true;

    beginLoading();
    try {
      final success = await _reminderManager.setEndOfDayReminderEnabled(value);
      if (success) {
        _endOfDayReminderEnabled = value;
        notifyListeners();
      }
      return success;
    } catch (e) {
      handleError(e, prefix: 'Failed to update end of day reminder setting');
      return false;
    } finally {
      endLoading();
    }
  }

  // Method to request exact alarm permission
  Future<bool> requestExactAlarmPermission() async {
    beginLoading();
    try {
      final result = await _deviceSettingsService.requestExactAlarmPermission();
      if (result) {
        _hasExactAlarmPermission =
            await _deviceSettingsService.hasExactAlarmPermission();
        notifyListeners();
      }
      return result;
    } catch (e) {
      handleError(e, prefix: 'Failed to request exact alarm permission');
      return false;
    } finally {
      endLoading();
    }
  }

  // Method to request battery optimization
  Future<bool> requestBatteryOptimization() async {
    beginLoading();
    try {
      final result = await _deviceSettingsService.requestBatteryOptimization();
      if (result) {
        _isIgnoringBatteryOptimizations =
            await _deviceSettingsService.isIgnoringBatteryOptimizations();
        notifyListeners();
      }
      return result;
    } catch (e) {
      handleError(e, prefix: 'Failed to request battery optimization');
      return false;
    } finally {
      endLoading();
    }
  }

  // Method to disable sleeping apps
  Future<bool> disableSleepingApps() async {
    beginLoading();
    try {
      final result = await _deviceSettingsService.disableSleepingApps();
      return result;
    } catch (e) {
      handleError(e, prefix: 'Failed to disable sleeping apps');
      return false;
    } finally {
      endLoading();
    }
  }

  // Method to refresh all settings
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
