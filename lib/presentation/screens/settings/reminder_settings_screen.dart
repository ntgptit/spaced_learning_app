import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/di/service_locator.dart';
import 'package:spaced_learning_app/core/services/reminder/reminder_manager.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

// Centralized reminder schedule configuration
class ReminderConfig {
  static const String noonTime = '12:30 PM';
  static const String eveningFirstTime = '9:00 PM';
  static const String eveningSecondTime = '10:30 PM';
  static const String endOfDayTime = '11:30 PM';
}

class ReminderSettingsScreen extends StatefulWidget {
  const ReminderSettingsScreen({super.key});

  @override
  State<ReminderSettingsScreen> createState() => _ReminderSettingsScreenState();
}

class _ReminderSettingsScreenState extends State<ReminderSettingsScreen> {
  final ReminderManager _reminderManager = serviceLocator<ReminderManager>();
  bool _isLoading = false;

  // Local state for the switches
  bool _remindersEnabled = true;
  bool _noonReminderEnabled = true;
  bool _eveningFirstReminderEnabled = true;
  bool _eveningSecondReminderEnabled = true;
  bool _endOfDayReminderEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  /// Loads initial reminder settings from ReminderManager and updates the UI.
  Future<void> _loadSettings() async {
    setState(() => _isLoading = true);
    try {
      _remindersEnabled = _reminderManager.remindersEnabled;
      _noonReminderEnabled = _reminderManager.noonReminderEnabled;
      _eveningFirstReminderEnabled =
          _reminderManager.eveningFirstReminderEnabled;
      _eveningSecondReminderEnabled =
          _reminderManager.eveningSecondReminderEnabled;
      _endOfDayReminderEnabled = _reminderManager.endOfDayReminderEnabled;
      print('Loaded settings: remindersEnabled = $_remindersEnabled'); // Debug
    } catch (e, stackTrace) {
      print('ERROR updating reminder setting: $e'); // In lỗi ra console
      print('Stack trace: $stackTrace');
      _showError('Failed to load settings: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Updates the reminder state and ensures UI reflects the change.
  Future<void> _updateReminderSetting(
    Future<void> Function() updateFunc,
    Function(bool) onSuccess,
    bool newValue,
  ) async {
    setState(() => _isLoading = true);
    try {
      await updateFunc();
      setState(() {
        onSuccess(newValue);
        _isLoading = false;
      });
      print('Updated setting: remindersEnabled = $_remindersEnabled'); // Debug
    } catch (e, stackTrace) {
      print('ERROR updating reminder setting: $e'); // In lỗi ra console
      print('Stack trace: $stackTrace');
      _showError('Failed to update reminder: $e');
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Reminder Settings')),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                padding: const EdgeInsets.all(AppDimens.paddingL),
                children: [
                  _buildInfoCard(theme),
                  const SizedBox(height: AppDimens.spaceL),
                  _buildMasterSwitch(theme),
                  const Divider(height: AppDimens.spaceXL),
                  _buildReminderSwitches(theme),
                  const SizedBox(height: AppDimens.spaceXL),
                  _buildExplanations(theme),
                ],
              ),
    );
  }

  Widget _buildInfoCard(ThemeData theme) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.alarm, color: theme.colorScheme.primary),
                const SizedBox(width: AppDimens.spaceM),
                Text(
                  'Smart Learning Reminders',
                  style: theme.textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: AppDimens.spaceM),
            Text(
              'Reminders help you stay on track with your learning schedule. '
              'The app will remind you at specific times to check your learning tasks.',
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMasterSwitch(ThemeData theme) {
    return SwitchListTile(
      title: Text(
        'Enable Learning Reminders',
        style: theme.textTheme.titleMedium,
      ),
      subtitle: Text(
        'Turn on/off all reminders',
        style: theme.textTheme.bodySmall,
      ),
      value: _remindersEnabled,
      onChanged:
          (newValue) => _updateReminderSetting(
            () => _reminderManager.setRemindersEnabled(newValue),
            (value) => _remindersEnabled = value,
            newValue,
          ),
      secondary: Icon(
        Icons.notifications_active,
        color:
            _remindersEnabled
                ? theme.colorScheme.primary
                : theme.colorScheme.outline,
      ),
    );
  }

  Widget _buildReminderSwitches(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: AppDimens.paddingL,
            bottom: AppDimens.paddingS,
          ),
          child: Text('Reminder Schedule', style: theme.textTheme.titleMedium),
        ),
        _CustomReminderSwitch(
          title: 'Noon Reminder (${ReminderConfig.noonTime})',
          subtitle: 'Daily check of your learning schedule',
          value: _noonReminderEnabled,
          icon: Icons.wb_sunny,
          enabled: _remindersEnabled,
          theme: theme,
          onChanged:
              (newValue) => _updateReminderSetting(
                () => _reminderManager.setNoonReminderEnabled(newValue),
                (value) => _noonReminderEnabled = value,
                newValue,
              ),
        ),
        _CustomReminderSwitch(
          title: 'Evening Reminder (${ReminderConfig.eveningFirstTime})',
          subtitle: 'First reminder for unfinished tasks',
          value: _eveningFirstReminderEnabled,
          icon: Icons.nights_stay,
          enabled: _remindersEnabled,
          theme: theme,
          onChanged:
              (newValue) => _updateReminderSetting(
                () => _reminderManager.setEveningFirstReminderEnabled(newValue),
                (value) => _eveningFirstReminderEnabled = value,
                newValue,
              ),
        ),
        _CustomReminderSwitch(
          title: 'Late Evening Reminder (${ReminderConfig.eveningSecondTime})',
          subtitle: 'Second reminder for unfinished tasks',
          value: _eveningSecondReminderEnabled,
          icon: Icons.nightlight,
          enabled: _remindersEnabled,
          theme: theme,
          onChanged:
              (newValue) => _updateReminderSetting(
                () =>
                    _reminderManager.setEveningSecondReminderEnabled(newValue),
                (value) => _eveningSecondReminderEnabled = value,
                newValue,
              ),
        ),
        _CustomReminderSwitch(
          title: 'End-of-Day Reminder (${ReminderConfig.endOfDayTime})',
          subtitle: 'Final reminder with alarm-style notification',
          value: _endOfDayReminderEnabled,
          icon: Icons.bedtime,
          enabled: _remindersEnabled,
          theme: theme,
          onChanged:
              (newValue) => _updateReminderSetting(
                () => _reminderManager.setEndOfDayReminderEnabled(newValue),
                (value) => _endOfDayReminderEnabled = value,
                newValue,
              ),
        ),
      ],
    );
  }

  Widget _buildExplanations(ThemeData theme) {
    return Card(
      margin: EdgeInsets.zero,
      color: theme.colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('How It Works', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppDimens.spaceM),
            Text(
              '• The noon reminder will always show to help you plan your day.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: AppDimens.spaceS),
            Text(
              '• Evening reminders will only show if you have unfinished tasks.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: AppDimens.spaceS),
            Text(
              '• This app is optimized for Samsung devices, especially the S23 Ultra.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: AppDimens.spaceL),
            Container(
              padding: const EdgeInsets.all(AppDimens.paddingM),
              decoration: BoxDecoration(
                color: theme.colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(AppDimens.radiusM),
              ),
              child: Row(
                children: [
                  Icon(Icons.battery_alert, color: theme.colorScheme.error),
                  const SizedBox(width: AppDimens.spaceM),
                  Expanded(
                    child: Text(
                      'Some devices may limit notifications. Please make sure to '
                      'disable battery optimization for this app in your device settings.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onErrorContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A reusable widget for reminder switches.
class _CustomReminderSwitch extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final IconData icon;
  final bool enabled;
  final ThemeData theme;
  final ValueChanged<bool> onChanged;

  const _CustomReminderSwitch({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.icon,
    required this.enabled,
    required this.theme,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value && enabled,
      onChanged: enabled ? onChanged : null,
      secondary: Icon(
        icon,
        color:
            (value && enabled)
                ? theme.colorScheme.primary
                : theme.colorScheme.outline,
      ),
    );
  }
}
