// lib/presentation/screens/settings/reminder_settings_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaced_learning_app/core/di/service_locator.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/presentation/utils/snackbar_utils.dart';
import 'package:spaced_learning_app/presentation/viewmodels/reminder_settings_viewmodel.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_button.dart';
import 'package:spaced_learning_app/presentation/widgets/common/error_display.dart';
import 'package:spaced_learning_app/presentation/widgets/common/loading_indicator.dart';

class ReminderConfig {
  static const String noonTime = '12:30 PM';
  static const String eveningFirstTime = '9:00 PM';
  static const String eveningSecondTime = '10:30 PM';
  static const String endOfDayTime = '11:30 PM';
}

class ReminderSettingsScreen extends StatelessWidget {
  const ReminderSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sử dụng service locator để lấy ViewModel đã đăng ký
    return ChangeNotifierProvider<ReminderSettingsViewModel>.value(
      value: serviceLocator<ReminderSettingsViewModel>(),
      child: const _ReminderSettingsView(),
    );
  }
}

class _ReminderSettingsView extends StatelessWidget {
  const _ReminderSettingsView();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ReminderSettingsViewModel>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminder Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: viewModel.refreshSettings,
            tooltip: 'Refresh settings',
          ),
        ],
      ),
      body:
          viewModel.isLoading && !viewModel.isInitialized
              ? const Center(child: AppLoadingIndicator())
              : viewModel.errorMessage != null && !viewModel.isInitialized
              ? Center(
                child: ErrorDisplay(
                  message: viewModel.errorMessage!,
                  onRetry: viewModel.refreshSettings,
                ),
              )
              : _buildContent(context, viewModel, theme),
    );
  }

  Widget _buildContent(
    BuildContext context,
    ReminderSettingsViewModel viewModel,
    ThemeData theme,
  ) {
    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: () => viewModel.refreshSettings(),
          child: ListView(
            padding: const EdgeInsets.all(AppDimens.paddingL),
            children: [
              _buildInfoCard(theme),
              const SizedBox(height: AppDimens.spaceL),
              _buildMasterSwitch(context, viewModel, theme),
              const Divider(height: AppDimens.spaceXL),
              _buildReminderSwitches(context, viewModel, theme),
              const SizedBox(height: AppDimens.spaceXL),
              _buildExplanations(theme),
              const SizedBox(height: AppDimens.spaceL),
              _buildDevicePermissions(context, viewModel, theme),
              const SizedBox(height: AppDimens.spaceL * 2),
            ],
          ),
        ),
        if (viewModel.isLoading && viewModel.isInitialized)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(child: CircularProgressIndicator()),
            ),
          ),
      ],
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

  Widget _buildMasterSwitch(
    BuildContext context,
    ReminderSettingsViewModel viewModel,
    ThemeData theme,
  ) {
    return SwitchListTile(
      title: Text(
        'Enable Learning Reminders',
        style: theme.textTheme.titleMedium,
      ),
      subtitle: Text(
        'Turn on/off all reminders',
        style: theme.textTheme.bodySmall,
      ),
      value: viewModel.remindersEnabled,
      onChanged:
          (value) => _updateSetting(
            context,
            () => viewModel.setRemindersEnabled(value),
            'Reminders ${value ? 'enabled' : 'disabled'}',
          ),
      secondary: Icon(
        Icons.notifications_active,
        color:
            viewModel.remindersEnabled
                ? theme.colorScheme.primary
                : theme.colorScheme.outline,
      ),
    );
  }

  Widget _buildReminderSwitches(
    BuildContext context,
    ReminderSettingsViewModel viewModel,
    ThemeData theme,
  ) {
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
        _ReminderSwitch(
          title: 'Noon Reminder (${ReminderConfig.noonTime})',
          subtitle: 'Daily check of your learning schedule',
          value: viewModel.noonReminderEnabled,
          icon: Icons.wb_sunny,
          enabled: viewModel.remindersEnabled,
          theme: theme,
          onChanged:
              (value) => _updateSetting(
                context,
                () => viewModel.setNoonReminderEnabled(value),
                'Noon reminder ${value ? 'enabled' : 'disabled'}',
              ),
        ),
        _ReminderSwitch(
          title: 'Evening Reminder (${ReminderConfig.eveningFirstTime})',
          subtitle: 'First reminder for unfinished tasks',
          value: viewModel.eveningFirstReminderEnabled,
          icon: Icons.nights_stay,
          enabled: viewModel.remindersEnabled,
          theme: theme,
          onChanged:
              (value) => _updateSetting(
                context,
                () => viewModel.setEveningFirstReminderEnabled(value),
                'Evening reminder ${value ? 'enabled' : 'disabled'}',
              ),
        ),
        _ReminderSwitch(
          title: 'Late Evening Reminder (${ReminderConfig.eveningSecondTime})',
          subtitle: 'Second reminder for unfinished tasks',
          value: viewModel.eveningSecondReminderEnabled,
          icon: Icons.nightlight,
          enabled: viewModel.remindersEnabled,
          theme: theme,
          onChanged:
              (value) => _updateSetting(
                context,
                () => viewModel.setEveningSecondReminderEnabled(value),
                'Late evening reminder ${value ? 'enabled' : 'disabled'}',
              ),
        ),
        _ReminderSwitch(
          title: 'End-of-Day Reminder (${ReminderConfig.endOfDayTime})',
          subtitle: 'Final reminder with alarm-style notification',
          value: viewModel.endOfDayReminderEnabled,
          icon: Icons.bedtime,
          enabled: viewModel.remindersEnabled,
          theme: theme,
          onChanged:
              (value) => _updateSetting(
                context,
                () => viewModel.setEndOfDayReminderEnabled(value),
                'End-of-day reminder ${value ? 'enabled' : 'disabled'}',
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

  Widget _buildDevicePermissions(
    BuildContext context,
    ReminderSettingsViewModel viewModel,
    ThemeData theme,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Device Permissions', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppDimens.spaceM),

            _buildPermissionItem(
              context,
              'Battery Optimization',
              viewModel.isIgnoringBatteryOptimizations,
              Icons.battery_charging_full,
              'Allows reminders to work reliably when the app is in background',
              onRequestPermission:
                  () => _requestPermission(
                    context,
                    viewModel.requestBatteryOptimization,
                    'Battery optimization settings requested',
                  ),
            ),

            const SizedBox(height: AppDimens.spaceM),

            // Chỉ hiển thị quyền Exact Alarm trên Android 12+
            // Giả sử SDK Version 31 là Android 12
            if (viewModel.deviceInfo['sdkVersion'] != null &&
                viewModel.deviceInfo['sdkVersion'] >= 31)
              _buildPermissionItem(
                context,
                'Exact Alarm Permission',
                viewModel.hasExactAlarmPermission,
                Icons.alarm,
                'Allows scheduling reminders at precise times (required for Android 12+)',
                onRequestPermission:
                    () => _requestPermission(
                      context,
                      viewModel.requestExactAlarmPermission,
                      'Exact alarm permission requested',
                    ),
              ),

            const SizedBox(height: AppDimens.spaceL),

            AppButton(
              text: 'Disable Device Sleeping Apps',
              type: AppButtonType.outline,
              prefixIcon: Icons.settings,
              onPressed:
                  () => _requestPermission(
                    context,
                    viewModel.disableSleepingApps,
                    'Opening device-specific settings',
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionItem(
    BuildContext context,
    String title,
    bool isGranted,
    IconData icon,
    String description, {
    required VoidCallback onRequestPermission,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.spaceM),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: isGranted ? colorScheme.primary : colorScheme.error,
            size: AppDimens.iconM,
          ),
          const SizedBox(width: AppDimens.spaceM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(title, style: theme.textTheme.titleSmall),
                    const SizedBox(width: AppDimens.spaceS),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimens.paddingXS,
                        vertical: AppDimens.paddingXXS,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isGranted
                                ? colorScheme.primaryContainer
                                : colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(AppDimens.radiusXS),
                      ),
                      child: Text(
                        isGranted ? 'Granted' : 'Required',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color:
                              isGranted
                                  ? colorScheme.onPrimaryContainer
                                  : colorScheme.onErrorContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimens.spaceXS),
                Text(description, style: theme.textTheme.bodySmall),
                if (!isGranted) ...[
                  const SizedBox(height: AppDimens.spaceS),
                  AppButton(
                    text: 'Request Permission',
                    type: AppButtonType.primary,
                    size: AppButtonSize.small,
                    onPressed: onRequestPermission,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _updateSetting(
    BuildContext context,
    Future<bool> Function() updateFunc,
    String successMessage,
  ) async {
    try {
      final success = await updateFunc();
      if (success && context.mounted) {
        SnackBarUtils.show(context, successMessage);
      } else if (context.mounted) {
        SnackBarUtils.show(
          context,
          'Failed to update setting',
          backgroundColor: Theme.of(context).colorScheme.errorContainer,
        );
      }
    } catch (e) {
      if (context.mounted) {
        SnackBarUtils.show(
          context,
          'Error: $e',
          backgroundColor: Theme.of(context).colorScheme.errorContainer,
        );
      }
    }
  }

  Future<void> _requestPermission(
    BuildContext context,
    Future<bool> Function() requestFunc,
    String successMessage,
  ) async {
    try {
      final success = await requestFunc();
      if (success && context.mounted) {
        SnackBarUtils.show(context, successMessage);
      }
    } catch (e) {
      if (context.mounted) {
        SnackBarUtils.show(
          context,
          'Error: $e',
          backgroundColor: Theme.of(context).colorScheme.errorContainer,
        );
      }
    }
  }
}

class _ReminderSwitch extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final IconData icon;
  final bool enabled;
  final ThemeData theme;
  final ValueChanged<bool> onChanged;

  const _ReminderSwitch({
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
