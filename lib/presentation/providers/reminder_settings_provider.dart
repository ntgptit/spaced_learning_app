// lib/presentation/providers/reminder_settings_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spaced_learning_app/core/events/app_events.dart';
import 'package:spaced_learning_app/core/services/reminder/reminder_service.dart';

import '../../core/di/providers.dart';

part 'reminder_settings_provider.g.dart';

@riverpod
class ReminderSettings extends _$ReminderSettings {
  @override
  Future<Map<String, bool>> build() async {
    return _fetchSettings();
  }

  Future<Map<String, bool>> _fetchSettings() async {
    final reminderService = ref.read(reminderServiceProvider);

    final Map<String, bool> settings = {
      'reminders_enabled': await reminderService.getRemindersEnabled(),
      'noon_reminder_enabled': await reminderService.getNoonReminderEnabled(),
      'evening_first_reminder_enabled': await reminderService
          .getEveningFirstReminderEnabled(),
      'evening_second_reminder_enabled': await reminderService
          .getEveningSecondReminderEnabled(),
      'end_of_day_reminder_enabled': await reminderService
          .getEndOfDayReminderEnabled(),
    };

    return settings;
  }

  Future<void> setRemindersEnabled(bool value) async {
    state = const AsyncValue.loading();

    final reminderService = ref.read(reminderServiceProvider);
    final result = await reminderService.setRemindersEnabled(value);

    if (result) {
      // Update the state
      final currentSettings = state.valueOrNull ?? {};
      state = AsyncValue.data({...currentSettings, 'reminders_enabled': value});

      // Notify other parts of the app
      _notifySettingsChanged(value);
    }

    // Refresh settings from service
    refreshSettings();
  }

  Future<void> setNoonReminderEnabled(bool value) async {
    await _updateSetting(
      'noon_reminder_enabled',
      value,
      (reminderService) => reminderService.setNoonReminderEnabled(value),
    );
  }

  Future<void> setEveningFirstReminderEnabled(bool value) async {
    await _updateSetting(
      'evening_first_reminder_enabled',
      value,
      (reminderService) =>
          reminderService.setEveningFirstReminderEnabled(value),
    );
  }

  Future<void> setEveningSecondReminderEnabled(bool value) async {
    await _updateSetting(
      'evening_second_reminder_enabled',
      value,
      (reminderService) =>
          reminderService.setEveningSecondReminderEnabled(value),
    );
  }

  Future<void> setEndOfDayReminderEnabled(bool value) async {
    await _updateSetting(
      'end_of_day_reminder_enabled',
      value,
      (reminderService) => reminderService.setEndOfDayReminderEnabled(value),
    );
  }

  Future<void> _updateSetting(
    String key,
    bool value,
    Future<bool> Function(ReminderService) updateFunction,
  ) async {
    state = const AsyncValue.loading();

    final reminderService = ref.read(reminderServiceProvider);
    final result = await updateFunction(reminderService as ReminderService);

    if (result) {
      // Update the state
      final currentSettings = state.valueOrNull ?? {};
      state = AsyncValue.data({...currentSettings, key: value});
    }

    // Refresh settings from service
    refreshSettings();
  }

  Future<void> refreshSettings() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchSettings());
  }

  Future<void> scheduleAllReminders() async {
    final reminderService = ref.read(reminderServiceProvider);
    await reminderService.scheduleAllReminders();
    refreshSettings();
  }

  void _notifySettingsChanged(bool enabled) {
    final eventBus = ref.read(eventBusProvider);
    eventBus.fire(ReminderSettingsChangedEvent(enabled: enabled));
  }
}

@riverpod
Future<Map<String, dynamic>> devicePermissions(Ref ref) async {
  final deviceSettingsService = ref.watch(deviceSettingsServiceProvider);

  final Map<String, dynamic> permissions = {
    'isAndroid': deviceSettingsService.isAndroid,
  };

  if (deviceSettingsService.isAndroid) {
    permissions['isIgnoringBatteryOptimizations'] = await deviceSettingsService
        .isIgnoringBatteryOptimizations();
    permissions['hasExactAlarmPermission'] = await deviceSettingsService
        .hasExactAlarmPermission();
  }

  return permissions;
}
