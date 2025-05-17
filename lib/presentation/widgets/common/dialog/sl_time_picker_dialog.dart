// lib/presentation/widgets/common/dialog/sl_time_picker_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Assuming color extensions for shades if needed
// import 'package:spaced_learning_app/core/extensions/color_extensions.dart';

/// A time picker dialog with Material 3 design and customizable options.
class SlTimePickerDialog extends ConsumerWidget {
  final TimeOfDay initialTime;
  final String title; // Will be used as helpText in M3
  final String confirmText;
  final String cancelText;
  final bool barrierDismissible;
  final Color? headerColor; // M3: use surfaceContainer or primary for header
  final Color? headerForegroundColor; // M3: use onSurface or onPrimary
  final bool use24HourFormat;

  // final TextStyle? headerStyle; // M3 uses helpTextStyle and headerHeadlineStyle from DatePickerThemeData
  final TimePickerEntryMode initialEntryMode;

  const SlTimePickerDialog({
    super.key,
    required this.initialTime,
    this.title = 'Select Time',
    this.confirmText = 'OK',
    this.cancelText = 'CANCEL', // M3 uses uppercase
    this.barrierDismissible = true,
    this.headerColor,
    this.headerForegroundColor,
    this.use24HourFormat = false,
    // this.headerStyle,
    this.initialEntryMode = TimePickerEntryMode.dial,
  });

  // Factory for a generic time picker
  factory SlTimePickerDialog.pickTime({
    required TimeOfDay initialTime,
    String title = 'Select Time',
  }) {
    return SlTimePickerDialog(initialTime: initialTime, title: title);
  }

  // Factory for picking a reminder time
  factory SlTimePickerDialog.pickReminderTime({
    TimeOfDay? initialTime,
    String title = 'Set Reminder Time',
  }) {
    return SlTimePickerDialog(
      initialTime: initialTime ?? const TimeOfDay(hour: 9, minute: 0),
      // Default 9 AM
      title: title,
      initialEntryMode:
          TimePickerEntryMode.input, // Often easier for specific times
    );
  }

  // Factory for picking a time with 24-hour format
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

    // M3 TimePickerTheme
    final timePickerTheme = TimePickerTheme.of(context).copyWith(
      backgroundColor: colorScheme.surfaceContainerHigh,
      // M3 dialog background
      hourMinuteTextColor: colorScheme.onSurface,
      hourMinuteColor: MaterialStateProperty.resolveWith<Color?>((
        Set<MaterialState> states,
      ) {
        if (states.contains(MaterialState.selected)) {
          return colorScheme.primaryContainer;
        }
        return colorScheme.surfaceContainerHighest; // Unselected state
      }),
      dayPeriodTextColor: MaterialStateProperty.resolveWith<Color?>((
        Set<MaterialState> states,
      ) {
        if (states.contains(MaterialState.selected)) {
          return colorScheme.onPrimaryContainer;
        }
        return colorScheme.onSurfaceVariant;
      }),
      dayPeriodColor: MaterialStateProperty.resolveWith<Color?>((
        Set<MaterialState> states,
      ) {
        if (states.contains(MaterialState.selected)) {
          return colorScheme.primaryContainer;
        }
        return colorScheme.surfaceContainerHighest; // Unselected state
      }),
      dialHandColor: colorScheme.primary,
      dialBackgroundColor: colorScheme.surfaceContainer,
      // M3 dial background
      dialTextColor: MaterialStateProperty.resolveWith<Color?>((
        Set<MaterialState> states,
      ) {
        if (states.contains(MaterialState.selected)) {
          return colorScheme.onPrimary; // Text on selected dial item
        }
        return colorScheme.onSurfaceVariant; // Text on unselected dial item
      }),
      entryModeIconColor: colorScheme.onSurfaceVariant,
      hourMinuteTextStyle: theme.textTheme.displayLarge?.copyWith(
        // M3 Hour/Minute style
        fontWeight: FontWeight.normal,
        color: colorScheme.onSurface,
      ),
      dayPeriodTextStyle: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w500,
      ),
      helpTextStyle: theme.textTheme.labelLarge?.copyWith(
        // M3 Help text (title)
        color: headerForegroundColor ?? colorScheme.onSurfaceVariant,
      ),
      // Shape is handled by AlertDialog typically, but can be overridden
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.radiusL)),
      cancelButtonStyle: TextButton.styleFrom(
        foregroundColor: colorScheme.primary,
      ),
      confirmButtonStyle: FilledButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
    );

    // Wrap with MediaQuery to set 24-hour format if needed
    Widget dialogWidget = TimePickerDialog(
      initialTime: initialTime,
      initialEntryMode: initialEntryMode,
      helpText: title.toUpperCase(),
      // M3 help text is often uppercase
      confirmText: confirmText,
      cancelText: cancelText,
    );

    if (use24HourFormat) {
      dialogWidget = MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: dialogWidget,
      );
    }

    return Theme(
      data: theme.copyWith(timePickerTheme: timePickerTheme),
      child: dialogWidget,
    );
  }

  /// Show the time picker dialog
  static Future<TimeOfDay?> show(
    BuildContext context, {
    required TimeOfDay initialTime,
    String title = 'Select Time',
    String confirmText = 'OK',
    String cancelText = 'CANCEL',
    bool barrierDismissible = true,
    Color? headerColor, // M3: use surface or primary
    Color? headerForegroundColor, // M3: use onSurface or onPrimary
    bool use24HourFormat = false,
    TimePickerEntryMode initialEntryMode = TimePickerEntryMode.dial,
    // TextStyle? headerStyle, // Not directly used in M3 TimePickerDialog, use theme
  }) async {
    return showDialog<TimeOfDay>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext dialogContext) {
        // It's important to use dialogContext for theming within the dialog
        return SlTimePickerDialog(
          initialTime: initialTime,
          title: title,
          confirmText: confirmText,
          cancelText: cancelText,
          headerColor: headerColor,
          headerForegroundColor: headerForegroundColor,
          use24HourFormat: use24HourFormat,
          initialEntryMode: initialEntryMode,
        );
      },
    );
  }
}
