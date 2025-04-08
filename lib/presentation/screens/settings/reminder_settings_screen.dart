import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/di/service_locator.dart';
import 'package:spaced_learning_app/core/services/reminder/reminder_manager.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

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

  Future<void> _loadSettings() async {
    setState(() {
      _isLoading = true;
    });

    // Load settings from ReminderManager
    _remindersEnabled = _reminderManager.remindersEnabled;
    _noonReminderEnabled = _reminderManager.noonReminderEnabled;
    _eveningFirstReminderEnabled = _reminderManager.eveningFirstReminderEnabled;
    _eveningSecondReminderEnabled =
        _reminderManager.eveningSecondReminderEnabled;
    _endOfDayReminderEnabled = _reminderManager.endOfDayReminderEnabled;

    setState(() {
      _isLoading = false;
    });
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
      onChanged: (newValue) async {
        setState(() {
          _remindersEnabled = newValue;
          _isLoading = true;
        });

        await _reminderManager.setRemindersEnabled(newValue);

        setState(() {
          _isLoading = false;
        });
      },
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

        // Each reminder switch
        SwitchListTile(
          title: const Text('Noon Reminder (12:30 PM)'),
          subtitle: const Text('Daily check of your learning schedule'),
          value: _noonReminderEnabled && _remindersEnabled,
          onChanged:
              _remindersEnabled
                  ? (newValue) async {
                    setState(() {
                      _noonReminderEnabled = newValue;
                      _isLoading = true;
                    });

                    await _reminderManager.setNoonReminderEnabled(newValue);

                    setState(() {
                      _isLoading = false;
                    });
                  }
                  : null,
          secondary: Icon(
            Icons.wb_sunny,
            color:
                (_noonReminderEnabled && _remindersEnabled)
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline,
          ),
        ),

        SwitchListTile(
          title: const Text('Evening Reminder (9:00 PM)'),
          subtitle: const Text('First reminder for unfinished tasks'),
          value: _eveningFirstReminderEnabled && _remindersEnabled,
          onChanged:
              _remindersEnabled
                  ? (newValue) async {
                    setState(() {
                      _eveningFirstReminderEnabled = newValue;
                      _isLoading = true;
                    });

                    await _reminderManager.setEveningFirstReminderEnabled(
                      newValue,
                    );

                    setState(() {
                      _isLoading = false;
                    });
                  }
                  : null,
          secondary: Icon(
            Icons.nights_stay,
            color:
                (_eveningFirstReminderEnabled && _remindersEnabled)
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline,
          ),
        ),

        SwitchListTile(
          title: const Text('Late Evening Reminder (10:30 PM)'),
          subtitle: const Text('Second reminder for unfinished tasks'),
          value: _eveningSecondReminderEnabled && _remindersEnabled,
          onChanged:
              _remindersEnabled
                  ? (newValue) async {
                    setState(() {
                      _eveningSecondReminderEnabled = newValue;
                      _isLoading = true;
                    });

                    await _reminderManager.setEveningSecondReminderEnabled(
                      newValue,
                    );

                    setState(() {
                      _isLoading = false;
                    });
                  }
                  : null,
          secondary: Icon(
            Icons.nightlight,
            color:
                (_eveningSecondReminderEnabled && _remindersEnabled)
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline,
          ),
        ),

        SwitchListTile(
          title: const Text('End-of-Day Reminder (11:30 PM)'),
          subtitle: const Text('Final reminder with alarm-style notification'),
          value: _endOfDayReminderEnabled && _remindersEnabled,
          onChanged:
              _remindersEnabled
                  ? (newValue) async {
                    setState(() {
                      _endOfDayReminderEnabled = newValue;
                      _isLoading = true;
                    });

                    await _reminderManager.setEndOfDayReminderEnabled(newValue);

                    setState(() {
                      _isLoading = false;
                    });
                  }
                  : null,
          secondary: Icon(
            Icons.bedtime,
            color:
                (_endOfDayReminderEnabled && _remindersEnabled)
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline,
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

            // Daily reminder explanation
            Text(
              '• The noon reminder will always show to help you plan your day.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: AppDimens.spaceS),

            // Evening reminders explanation
            Text(
              '• Evening reminders will only show if you have unfinished tasks.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: AppDimens.spaceS),

            // Device-specific note
            Text(
              '• This app is optimized for Samsung devices, especially the S23 Ultra.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: AppDimens.spaceL),

            // Battery optimization warning
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
                      'Some devices may limit notifications. Please make sure to disable battery optimization for this app in your device settings.',
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
