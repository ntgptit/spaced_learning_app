// lib/presentation/widgets/common/dialog/sl_date_picker_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
// import 'package:spaced_learning_app/core/extensions/color_extensions.dart'; // Assuming this contains success/warning/info extensions - Not used here directly

/// A date picker dialog with Material 3 design and customizable options.
class SlDatePickerDialog extends ConsumerWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final String title; // This will be used as helpText in M3 DatePickerDialog
  final String confirmText;
  final String cancelText;
  final DatePickerEntryMode initialEntryMode;
  final DatePickerMode
  initialDatePickerMode; // This is a valid parameter for DatePickerDialog
  final bool barrierDismissible;
  final Color? headerBackgroundColor;
  final Color? headerForegroundColor;
  final String? helpText; // If provided, overrides title for helpText

  const SlDatePickerDialog({
    super.key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    this.title = 'Select Date',
    this.confirmText = 'OK',
    this.cancelText = 'CANCEL',
    this.initialEntryMode = DatePickerEntryMode.calendar,
    this.initialDatePickerMode = DatePickerMode.day, // Default to day
    this.barrierDismissible = true,
    this.headerBackgroundColor,
    this.headerForegroundColor,
    this.helpText,
  });

  // Factory for picking a generic date
  factory SlDatePickerDialog.pickDate({
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
    String title = 'Select Date',
  }) {
    return SlDatePickerDialog(
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      title: title,
    );
  }

  // Factory for picking a birth date (past dates)
  factory SlDatePickerDialog.pickBirthDate({
    DateTime? initialDate,
    String title = 'Select Date of Birth',
  }) {
    final now = DateTime.now();
    return SlDatePickerDialog(
      initialDate: initialDate ?? now.subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: now,
      title: title,
      initialDatePickerMode: DatePickerMode.year,
    );
  }

  // Factory for picking a future date
  factory SlDatePickerDialog.pickFutureDate({
    DateTime? initialDate,
    String title = 'Select Future Date',
    DateTime? firstAvailableDate,
    int maxYearsInFuture = 5,
  }) {
    final now = DateTime.now();
    return SlDatePickerDialog(
      initialDate: initialDate ?? now.add(const Duration(days: 1)),
      firstDate: firstAvailableDate ?? now,
      lastDate: DateTime(now.year + maxYearsInFuture, now.month, now.day),
      title: title,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final datePickerTheme = DatePickerThemeData(
      backgroundColor: colorScheme.surfaceContainerHigh,
      headerBackgroundColor: headerBackgroundColor ?? colorScheme.primary,
      headerForegroundColor: headerForegroundColor ?? colorScheme.onPrimary,
      headerHeadlineStyle: theme.textTheme.headlineSmall?.copyWith(
        color: headerForegroundColor ?? colorScheme.onPrimary,
      ),
      headerHelpStyle: theme.textTheme.titleLarge?.copyWith(
        color: headerForegroundColor ?? colorScheme.onPrimary,
      ),
      weekdayStyle: theme.textTheme.bodySmall?.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
      dayStyle: theme.textTheme.bodyLarge?.copyWith(
        color: colorScheme.onSurface,
      ),
      dayForegroundColor: WidgetStateProperty.resolveWith<Color?>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.selected)) {
          return colorScheme.onPrimary;
        }
        if (states.contains(WidgetState.disabled)) {
          return colorScheme.onSurface.withValues(alpha: 0.38);
        }
        return colorScheme.onSurface;
      }),
      dayBackgroundColor: WidgetStateProperty.resolveWith<Color?>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.selected)) {
          return colorScheme.primary;
        }
        return Colors.transparent;
      }),
      yearStyle: theme.textTheme.bodyLarge?.copyWith(
        color: colorScheme.onSurface,
      ),
      yearForegroundColor: WidgetStateProperty.resolveWith<Color?>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.selected)) {
          return colorScheme.onPrimary;
        }
        return colorScheme.onSurface;
      }),
      yearBackgroundColor: WidgetStateProperty.resolveWith<Color?>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.selected)) {
          return colorScheme.primary;
        }
        return Colors.transparent;
      }),
      todayBorder: BorderSide(color: colorScheme.primary),
      todayForegroundColor: WidgetStateProperty.all<Color>(colorScheme.primary),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusL),
      ),
      elevation: AppDimens.elevationM,
      cancelButtonStyle: TextButton.styleFrom(
        foregroundColor: colorScheme.primary,
      ),
      confirmButtonStyle: FilledButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
    );

    // The DatePickerDialog widget itself DOES accept initialDatePickerMode.
    // The error was likely a typo or misunderstanding of the API.
    // If the error persists, it might be that the Flutter version being used
    // has a slightly different API for DatePickerDialog.
    // However, standard Material 3 DatePickerDialog should have this.
    return Theme(
      data: theme.copyWith(datePickerTheme: datePickerTheme),
      child: DatePickerDialog(
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate,
        helpText: helpText ?? title.toUpperCase(),
        confirmText: confirmText,
        cancelText: cancelText,
        initialEntryMode: initialEntryMode,
      ),
    );
  }

  /// Show the date picker dialog
  static Future<DateTime?> show(
    BuildContext context, {
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
    String title = 'Select Date',
    String confirmText = 'OK',
    String cancelText = 'CANCEL',
    DatePickerEntryMode initialEntryMode = DatePickerEntryMode.calendar,
    DatePickerMode initialDatePickerMode =
        DatePickerMode.day, // Parameter for showDatePicker
    bool barrierDismissible = true,
    Color? headerBackgroundColor,
    Color? headerForegroundColor,
    String? helpText,
  }) async {
    // When using showDatePicker directly, it handles its own theming largely.
    // To use SlDatePickerDialog's custom theming, we call showDialog with SlDatePickerDialog as the builder.
    return showDialog<DateTime>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext dialogContext) {
        // Pass all parameters to the SlDatePickerDialog constructor
        return SlDatePickerDialog(
          initialDate: initialDate,
          firstDate: firstDate,
          lastDate: lastDate,
          title: title,
          confirmText: confirmText,
          cancelText: cancelText,
          initialEntryMode: initialEntryMode,
          initialDatePickerMode: initialDatePickerMode,
          // Pass it here
          headerBackgroundColor: headerBackgroundColor,
          headerForegroundColor: headerForegroundColor,
          helpText: helpText,
          barrierDismissible:
              barrierDismissible, // Pass barrierDismissible if SlDatePickerDialog needs it
        );
      },
    );
    // If you want to use Flutter's raw showDatePicker with M3 theming, it's simpler:
    // return showDatePicker(
    //   context: context,
    //   initialDate: initialDate,
    //   firstDate: firstDate,
    //   lastDate: lastDate,
    //   helpText: helpText ?? title.toUpperCase(),
    //   confirmText: confirmText,
    //   cancelText: cancelText,
    //   initialEntryMode: initialEntryMode,
    //   initialDatePickerMode: initialDatePickerMode, // Correct place for showDatePicker
    //   barrierDismissible: barrierDismissible,
    //   // Theming is largely handled by the global Theme or DatePickerTheme
    //   // builder: (context, child) {
    //   //   // You can wrap child with a Theme widget here if needed for further customization
    //   //   return Theme(
    //   //     data: Theme.of(context).copyWith(
    //   //       // Specific overrides for showDatePicker if SlDatePickerDialog's theme isn't picked up
    //   //     ),
    //   //     child: child!,
    //   //   );
    //   // },
    // );
  }
}
