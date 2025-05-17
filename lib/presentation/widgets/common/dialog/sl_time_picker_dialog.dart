// lib/presentation/widgets/common/dialog/sl_time_picker_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

part 'sl_time_picker_dialog.g.dart';

@riverpod
class SelectedTime extends _$SelectedTime {
  @override
  TimeOfDay build() => TimeOfDay.now();

  void setTime(TimeOfDay time) {
    state = time;
  }
}

/// A time picker dialog with Material 3 design and customizable options.
class SlTimePickerDialog extends ConsumerWidget {
  final TimeOfDay initialTime;
  final String title;
  final String confirmText;
  final String cancelText;
  final bool barrierDismissible;
  final Color? dialogBackgroundColor;
  final Color? headerHelpTextColor;
  final bool use24HourFormat;
  final TimePickerEntryMode initialEntryMode;

  const SlTimePickerDialog({
    super.key,
    required this.initialTime,
    this.title = 'Select Time',
    this.confirmText = 'OK',
    this.cancelText = 'CANCEL',
    this.barrierDismissible = true,
    this.dialogBackgroundColor,
    this.headerHelpTextColor,
    this.use24HourFormat = false,
    this.initialEntryMode = TimePickerEntryMode.dial,
  });

  /// Factory for picking a time
  factory SlTimePickerDialog.pickTime({
    required TimeOfDay initialTime,
    String title = 'Select Time',
    bool use24HourFormat = false,
  }) {
    return SlTimePickerDialog(
      initialTime: initialTime,
      title: title,
      use24HourFormat: use24HourFormat,
    );
  }

  /// Factory for picking a reminder time
  factory SlTimePickerDialog.pickReminderTime({
    TimeOfDay? initialTime,
    String title = 'Set Reminder Time',
  }) {
    return SlTimePickerDialog(
      initialTime: initialTime ?? const TimeOfDay(hour: 9, minute: 0),
      title: title,
      initialEntryMode: TimePickerEntryMode.input,
    );
  }

  /// Factory for picking time in 24-hour format
  factory SlTimePickerDialog.pick24HourTime({
    required TimeOfDay initialTime,
    String title = 'Select Time (24h)',
  }) {
    return SlTimePickerDialog(
      initialTime: initialTime,
      title: title,
      use24HourFormat: true,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final timePickerTheme = TimePickerTheme.of(context).copyWith(
      backgroundColor:
          dialogBackgroundColor ?? colorScheme.surfaceContainerHigh,
      hourMinuteTextColor: colorScheme.onSurface,
      hourMinuteColor: colorScheme.surfaceContainerHighest,
      dayPeriodTextColor: colorScheme.onSurfaceVariant,
      dayPeriodColor: colorScheme.surfaceContainerHighest,
      dialHandColor: colorScheme.primary,
      dialBackgroundColor: colorScheme.surfaceContainer,
      dialTextColor: colorScheme.onSurfaceVariant,
      entryModeIconColor: colorScheme.onSurfaceVariant,
      hourMinuteTextStyle: theme.textTheme.displayLarge?.copyWith(
        fontWeight: FontWeight.normal,
      ),
      dayPeriodTextStyle: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w500,
      ),
      helpTextStyle: theme.textTheme.labelLarge?.copyWith(
        color: headerHelpTextColor ?? colorScheme.onSurfaceVariant,
      ),
      cancelButtonStyle: TextButton.styleFrom(
        foregroundColor: colorScheme.primary,
      ),
      confirmButtonStyle: FilledButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusS),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusS),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimens.paddingM,
        ),
      ),
    );

    Widget timePickerDialogWidget = TimePickerDialog(
      initialTime: initialTime,
      initialEntryMode: initialEntryMode,
      helpText: title.toUpperCase(),
      confirmText: confirmText,
      cancelText: cancelText,
    );

    if (use24HourFormat) {
      timePickerDialogWidget = MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: timePickerDialogWidget,
      );
    }

    return Theme(
      data: theme.copyWith(timePickerTheme: timePickerTheme),
      child: timePickerDialogWidget,
    );
  }

  /// Show the time picker dialog
  static Future<TimeOfDay?> show(
    BuildContext context,
    WidgetRef ref, {
    required TimeOfDay initialTime,
    String title = 'Select Time',
    String confirmText = 'OK',
    String cancelText = 'CANCEL',
    bool barrierDismissible = true,
    Color? dialogBackgroundColor,
    Color? headerHelpTextColor,
    bool use24HourFormat = false,
    TimePickerEntryMode initialEntryMode = TimePickerEntryMode.dial,
  }) async {
    // Set initial time to provider
    ref.read(selectedTimeProvider.notifier).setTime(initialTime);

    final result = await showDialog<TimeOfDay>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext dialogContext) {
        return SlTimePickerDialog(
          initialTime: initialTime,
          title: title,
          confirmText: confirmText,
          cancelText: cancelText,
          dialogBackgroundColor: dialogBackgroundColor,
          headerHelpTextColor: headerHelpTextColor,
          use24HourFormat: use24HourFormat,
          initialEntryMode: initialEntryMode,
          barrierDismissible: barrierDismissible,
        );
      },
    );

    // Update provider with result
    if (result != null) {
      ref.read(selectedTimeProvider.notifier).setTime(result);
    }

    return result;
  }
}
