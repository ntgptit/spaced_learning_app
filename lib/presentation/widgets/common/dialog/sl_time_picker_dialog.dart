// lib/presentation/widgets/common/dialog/sl_time_picker_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

/// A time picker dialog with Material 3 design and customizable options.
class SlTimePickerDialog extends ConsumerWidget {
  final TimeOfDay initialTime;
  final String title;
  final String confirmText;
  final String cancelText;
  final bool barrierDismissible;
  final Color? headerColor;
  final bool use24HourFormat;
  final TextStyle? headerStyle;

  const SlTimePickerDialog({
    super.key,
    required this.initialTime,
    this.title = 'Select Time',
    this.confirmText = 'OK',
    this.cancelText = 'Cancel',
    this.barrierDismissible = true,
    this.headerColor,
    this.use24HourFormat = false,
    this.headerStyle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Create the time picker theme
    final timePickerTheme = TimePickerThemeData(
      backgroundColor: colorScheme.surface,
      hourMinuteTextColor: colorScheme.onSurface,
      hourMinuteColor: colorScheme.surfaceContainerHighest,
      dayPeriodTextColor: colorScheme.onSurface,
      dayPeriodColor: colorScheme.surfaceContainerHigh,
      dialHandColor: colorScheme.primary,
      dialBackgroundColor: colorScheme.surfaceContainerLowest,
      // Correct implementation for dialTextColor
      dialTextColor: MaterialStateColor.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return colorScheme.onPrimary;
        }
        return colorScheme.onSurface;
      }),
      entryModeIconColor: colorScheme.onSurface,
      hourMinuteTextStyle: theme.textTheme.displayMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),
      dayPeriodTextStyle: theme.textTheme.titleMedium,
      helpTextStyle: theme.textTheme.titleMedium?.copyWith(
        color: headerColor ?? colorScheme.primary,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusL),
      ),
    );

    return Theme(
      data: theme.copyWith(timePickerTheme: timePickerTheme),
      child: TimePickerDialog(
        initialTime: initialTime,
        initialEntryMode: TimePickerEntryMode.dial,
        helpText: title,
        confirmText: confirmText,
        cancelText: cancelText,
      ),
    );
  }

  /// Show the time picker dialog
  static Future<TimeOfDay?> show(
    BuildContext context, {
    TimeOfDay? initialTime,
    String title = 'Select Time',
    String confirmText = 'OK',
    String cancelText = 'Cancel',
    bool barrierDismissible = true,
    Color? headerColor,
    bool use24HourFormat = false,
    TextStyle? headerStyle,
  }) async {
    initialTime ??= TimeOfDay.now();

    // Wrap with MediaQuery to set 24-hour format
    Widget dialogWidget = SlTimePickerDialog(
      initialTime: initialTime,
      title: title,
      confirmText: confirmText,
      cancelText: cancelText,
      headerColor: headerColor,
      use24HourFormat: use24HourFormat,
      headerStyle: headerStyle,
    );

    if (use24HourFormat) {
      dialogWidget = MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: dialogWidget,
      );
    }

    final TimeOfDay? selectedTime = await showDialog<TimeOfDay>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.black54,
      builder: (BuildContext context) {
        return dialogWidget;
      },
    );

    return selectedTime;
  }

  /// Convenience method to pick a time with 24-hour format
  static Future<TimeOfDay?> pick24HourTime(
    BuildContext context, {
    TimeOfDay? initialTime,
    String title = 'Select Time',
  }) {
    return show(
      context,
      initialTime: initialTime,
      title: title,
      use24HourFormat: true,
      headerColor: Theme.of(context).colorScheme.secondary,
    );
  }

  /// Convenience method to pick a time for an alarm
  static Future<TimeOfDay?> pickAlarmTime(
    BuildContext context, {
    TimeOfDay? initialTime,
    String title = 'Set Alarm Time',
  }) {
    return show(
      context,
      initialTime: initialTime ?? const TimeOfDay(hour: 7, minute: 0),
      title: title,
      headerColor: Theme.of(context).colorScheme.tertiary,
    );
  }

  /// Convenience method to select reminder time
  static Future<TimeOfDay?> pickReminderTime(
    BuildContext context, {
    TimeOfDay? initialTime,
    String title = 'Set Reminder',
  }) {
    return show(
      context,
      initialTime: initialTime ?? const TimeOfDay(hour: 18, minute: 0),
      title: title,
      headerColor: Theme.of(context).colorScheme.primary,
    );
  }
}
