import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

class ReminderSettingsScreen extends ConsumerWidget {
  const ReminderSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const _ReminderSettingsView();
  }
}

class _ReminderSettingsView extends ConsumerStatefulWidget {
  const _ReminderSettingsView();

  @override
  ConsumerState<_ReminderSettingsView> createState() =>
      _ReminderSettingsViewState();
}

class _ReminderSettingsViewState extends ConsumerState<_ReminderSettingsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  Future<void> _loadInitialData() async {
    // Chỉ gọi refreshSettings() nếu dữ liệu chưa được tải
    final settingsState = ref.read(reminderSettingsStateProvider);
    if (settingsState.value == null || !settingsState.hasValue) {
      await ref.read(reminderSettingsStateProvider.notifier).refreshSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settingsAsync = ref.watch(reminderSettingsStateProvider);
    final permissionsAsync = ref.watch(devicePermissionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminder Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref
                .read(reminderSettingsStateProvider.notifier)
                .refreshSettings(),
            tooltip: 'Refresh settings',
          ),
        ],
      ),
      body: _buildBody(settingsAsync, permissionsAsync, theme),
    );
  }

  Widget _buildBody(
    AsyncValue<Map<String, bool>> settingsAsync,
    AsyncValue<Map<String, dynamic>> permissionsAsync,
    ThemeData theme,
  ) {
    return settingsAsync.when(
      data: (settingsData) {
        final isLoading = settingsAsync.isLoading;
        final isInitialized = settingsData.isNotEmpty;

        if (isLoading && !isInitialized) {
          return const Center(child: AppLoadingIndicator());
        }

        return permissionsAsync.when(
          data: (permissionsData) {
            return Stack(
              children: [
                RefreshIndicator(
                  onRefresh: () => ref
                      .read(reminderSettingsStateProvider.notifier)
                      .refreshSettings(),
                  child: ListView(
                    padding: const EdgeInsets.all(AppDimens.paddingL),
                    children: [
                      _buildInfoCard(theme),
                      const SizedBox(height: AppDimens.spaceL),
                      _buildMasterSwitch(settingsData, theme),
                      const Divider(height: AppDimens.spaceXL),
                      _buildReminderSwitches(settingsData, theme),
                      const SizedBox(height: AppDimens.spaceXL),
                      _buildExplanationsCard(theme),
                      const SizedBox(height: AppDimens.spaceL),
                      _buildDevicePermissionsCard(permissionsData, theme),
                      const SizedBox(height: AppDimens.spaceL * 2),
                    ],
                  ),
                ),
                if (isLoading && isInitialized)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.3),
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                  ),
              ],
            );
          },
          loading: () => const Center(child: AppLoadingIndicator()),
          error: (error, stackTrace) => Center(
            child: ErrorDisplay(
              message: 'Failed to load device permissions: $error',
              onRetry: () =>
                  ref.read(devicePermissionsProvider.notifier).build(),
            ),
          ),
        );
      },
      loading: () => const Center(child: AppLoadingIndicator()),
      error: (error, stackTrace) => Center(
        child: ErrorDisplay(
          message: 'Failed to load reminder settings: $error',
          onRetry: () => ref
              .read(reminderSettingsStateProvider.notifier)
              .refreshSettings(),
        ),
      ),
    );
  }

  Widget _buildInfoCard(ThemeData theme) {
    final colorScheme = theme.colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.alarm, color: colorScheme.primary),
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

  Widget _buildMasterSwitch(Map<String, bool> settingsData, ThemeData theme) {
    final remindersEnabled = settingsData['remindersEnabled'] ?? false;

    return SwitchListTile(
      title: Text(
        'Enable Learning Reminders',
        style: theme.textTheme.titleMedium,
      ),
      subtitle: Text(
        'Turn on/off all reminders',
        style: theme.textTheme.bodySmall,
      ),
      value: remindersEnabled,
      onChanged: (value) => _updateSetting(
        () => ref
            .read(reminderSettingsStateProvider.notifier)
            .setRemindersEnabled(value),
        'Reminders ${value ? 'enabled' : 'disabled'}',
      ),
      secondary: Icon(
        Icons.notifications_active,
        color: remindersEnabled
            ? theme.colorScheme.primary
            : theme.colorScheme.outline,
      ),
    );
  }

  Widget _buildReminderSwitches(
    Map<String, bool> settingsData,
    ThemeData theme,
  ) {
    final remindersEnabled = settingsData['remindersEnabled'] ?? false;
    final noonEnabled = settingsData['noonReminderEnabled'] ?? false;
    final eveningFirstEnabled =
        settingsData['eveningFirstReminderEnabled'] ?? false;
    final eveningSecondEnabled =
        settingsData['eveningSecondReminderEnabled'] ?? false;
    final endOfDayEnabled = settingsData['endOfDayReminderEnabled'] ?? false;

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
          value: noonEnabled,
          icon: Icons.wb_sunny,
          enabled: remindersEnabled,
          theme: theme,
          onChanged: (value) => _updateSetting(
            () => ref
                .read(reminderSettingsStateProvider.notifier)
                .setNoonReminderEnabled(value),
            'Noon reminder ${value ? 'enabled' : 'disabled'}',
          ),
        ),
        _ReminderSwitch(
          title: 'Evening Reminder (${ReminderConfig.eveningFirstTime})',
          subtitle: 'First reminder for unfinished tasks',
          value: eveningFirstEnabled,
          icon: Icons.nights_stay,
          enabled: remindersEnabled,
          theme: theme,
          onChanged: (value) => _updateSetting(
            () => ref
                .read(reminderSettingsStateProvider.notifier)
                .setEveningFirstReminderEnabled(value),
            'Evening reminder ${value ? 'enabled' : 'disabled'}',
          ),
        ),
        _ReminderSwitch(
          title: 'Late Evening Reminder (${ReminderConfig.eveningSecondTime})',
          subtitle: 'Second reminder for unfinished tasks',
          value: eveningSecondEnabled,
          icon: Icons.nightlight,
          enabled: remindersEnabled,
          theme: theme,
          onChanged: (value) => _updateSetting(
            () => ref
                .read(reminderSettingsStateProvider.notifier)
                .setEveningSecondReminderEnabled(value),
            'Late evening reminder ${value ? 'enabled' : 'disabled'}',
          ),
        ),
        _ReminderSwitch(
          title: 'End-of-Day Reminder (${ReminderConfig.endOfDayTime})',
          subtitle: 'Final reminder with alarm-style notification',
          value: endOfDayEnabled,
          icon: Icons.bedtime,
          enabled: remindersEnabled,
          theme: theme,
          onChanged: (value) => _updateSetting(
            () => ref
                .read(reminderSettingsStateProvider.notifier)
                .setEndOfDayReminderEnabled(value),
            'End-of-day reminder ${value ? 'enabled' : 'disabled'}',
          ),
        ),
      ],
    );
  }

  Widget _buildExplanationsCard(ThemeData theme) {
    final colorScheme = theme.colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      color: colorScheme.surfaceContainerLow,
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
                color: colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(AppDimens.radiusM),
              ),
              child: Row(
                children: [
                  Icon(Icons.battery_alert, color: colorScheme.error),
                  const SizedBox(width: AppDimens.spaceM),
                  Expanded(
                    child: Text(
                      'Some devices may limit notifications. Please make sure to '
                      'disable battery optimization for this app in your device settings.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onErrorContainer,
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

  Widget _buildDevicePermissionsCard(
    Map<String, dynamic> permissionsData,
    ThemeData theme,
  ) {
    final isIgnoringBatteryOptimizations =
        permissionsData['isIgnoringBatteryOptimizations'] ?? false;
    final hasExactAlarmPermission =
        permissionsData['hasExactAlarmPermission'] ?? false;
    final deviceInfo =
        permissionsData['deviceInfo'] as Map<String, dynamic>? ?? {};
    final sdkVersion = deviceInfo['sdkVersion'] as int? ?? 0;

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
              isIgnoringBatteryOptimizations,
              Icons.battery_charging_full,
              'Allows reminders to work reliably when the app is in background',
              onRequestPermission: () => _requestPermission(
                () => ref
                    .read(devicePermissionsProvider.notifier)
                    .requestBatteryOptimization(),
                'Battery optimization settings requested',
              ),
            ),

            const SizedBox(height: AppDimens.spaceM),

            if (sdkVersion >= 31)
              _buildPermissionItem(
                context,
                'Exact Alarm Permission',
                hasExactAlarmPermission,
                Icons.alarm,
                'Allows scheduling reminders at precise times (required for Android 12+)',
                onRequestPermission: () => _requestPermission(
                  () => ref
                      .read(devicePermissionsProvider.notifier)
                      .requestExactAlarmPermission(),
                  'Exact alarm permission requested',
                ),
              ),

            const SizedBox(height: AppDimens.spaceL),

            AppButton(
              text: 'Disable Device Sleeping Apps',
              type: AppButtonType.outline,
              prefixIcon: Icons.settings,
              onPressed: () => _requestPermission(
                () => ref
                    .read(devicePermissionsProvider.notifier)
                    .disableSleepingApps(),
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
                        color: isGranted
                            ? colorScheme.primaryContainer
                            : colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(AppDimens.radiusXS),
                      ),
                      child: Text(
                        isGranted ? 'Granted' : 'Required',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: isGranted
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
    Future<bool> Function() updateFunc,
    String successMessage,
  ) async {
    try {
      final success = await updateFunc();
      if (!mounted) return;

      if (success) {
        SnackBarUtils.show(context, successMessage);
        return;
      }

      SnackBarUtils.show(
        context,
        'Failed to update setting',
        backgroundColor: Theme.of(context).colorScheme.errorContainer,
      );
    } catch (e) {
      if (!mounted) return;

      SnackBarUtils.show(
        context,
        'Error: $e',
        backgroundColor: Theme.of(context).colorScheme.errorContainer,
      );
    }
  }

  Future<void> _requestPermission(
    Future<bool> Function() requestFunc,
    String successMessage,
  ) async {
    try {
      final success = await requestFunc();
      if (!mounted) return;

      if (success) {
        SnackBarUtils.show(context, successMessage);
      }
    } catch (e) {
      if (!mounted) return;

      SnackBarUtils.show(
        context,
        'Error: $e',
        backgroundColor: Theme.of(context).colorScheme.errorContainer,
      );
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
        color: (value && enabled)
            ? theme.colorScheme.primary
            : theme.colorScheme.outline,
      ),
    );
  }
}
