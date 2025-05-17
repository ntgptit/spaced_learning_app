// lib/presentation/widgets/common/dialog/sl_date_picker_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

// Assuming color extensions are available for shades if needed
// import 'package:spaced_learning_app/core/extensions/color_extensions.dart';

/// A date picker dialog with Material 3 design and customizable options.
class SlDatePickerDialog extends ConsumerWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final String title;
  final String confirmText;
  final String cancelText;
  final DatePickerEntryMode initialEntryMode;
  final DatePickerMode initialDatePickerMode;
  final bool barrierDismissible;
  final Color?
  headerBackgroundColor; // M3: use surface color or primary for header
  final Color? headerForegroundColor; // M3: use onSurface or onPrimary
  final String? helpText; // M3: helpText is usually the title

  const SlDatePickerDialog({
    super.key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    this.title = 'Select Date', // This will be used as helpText
    this.confirmText = 'OK',
    this.cancelText = 'CANCEL', // M3 usually uses uppercase for text buttons
    this.initialEntryMode = DatePickerEntryMode.calendar,
    this.initialDatePickerMode = DatePickerMode.day,
    this.barrierDismissible = true,
    this.headerBackgroundColor,
    this.headerForegroundColor,
    this.helpText, // If provided, overrides title for helpText
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
      // Default to 18 years ago
      firstDate: DateTime(1900),
      lastDate: now,
      title: title,
      initialDatePickerMode:
          DatePickerMode.year, // Often useful for birth dates
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

    // M3 DatePickerTheme
    final datePickerTheme = DatePickerThemeData(
      backgroundColor: colorScheme.surfaceContainerHigh,
      // M3 dialog background
      headerBackgroundColor: headerBackgroundColor ?? colorScheme.primary,
      headerForegroundColor: headerForegroundColor ?? colorScheme.onPrimary,
      headerHeadlineStyle: theme.textTheme.headlineSmall?.copyWith(
        // M3 header style
        color: headerForegroundColor ?? colorScheme.onPrimary,
      ),
      headerHelpStyle: theme.textTheme.titleLarge?.copyWith(
        // M3 help text style
        color: headerForegroundColor ?? colorScheme.onPrimary,
      ),
      weekdayStyle: theme.textTheme.bodySmall?.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
      dayStyle: theme.textTheme.bodyLarge?.copyWith(
        color: colorScheme.onSurface,
      ),
      dayForegroundColor: MaterialStateProperty.resolveWith<Color?>((
        Set<MaterialState> states,
      ) {
        if (states.contains(MaterialState.selected)) {
          return colorScheme.onPrimary;
        }
        if (states.contains(MaterialState.disabled)) {
          return colorScheme.onSurface.withOpacity(0.38);
        }
        return colorScheme.onSurface;
      }),
      dayBackgroundColor: MaterialStateProperty.resolveWith<Color?>((
        Set<MaterialState> states,
      ) {
        if (states.contains(MaterialState.selected)) {
          return colorScheme.primary;
        }
        // Potentially add today's date highlight if needed, M3 handles this well by default
        return Colors.transparent; // Default, let M3 handle other states
      }),
      yearStyle: theme.textTheme.bodyLarge?.copyWith(
        color: colorScheme.onSurface,
      ),
      yearForegroundColor: MaterialStateProperty.resolveWith<Color?>((
        Set<MaterialState> states,
      ) {
        if (states.contains(MaterialState.selected)) {
          return colorScheme.onPrimary;
        }
        return colorScheme.onSurface;
      }),
      yearBackgroundColor: MaterialStateProperty.resolveWith<Color?>((
        Set<MaterialState> states,
      ) {
        if (states.contains(MaterialState.selected)) {
          return colorScheme.primary;
        }
        return Colors.transparent;
      }),
      todayBorder: BorderSide(color: colorScheme.primary),
      todayForegroundColor: MaterialStateProperty.all<Color>(
        colorScheme.primary,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusL),
      ),
      // M3 dialog shape
      elevation: AppDimens.elevationM,
      // M3 dialog elevation
      cancelButtonStyle: TextButton.styleFrom(
        foregroundColor: colorScheme.primary,
      ),
      confirmButtonStyle: FilledButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
    );

    return Theme(
      data: theme.copyWith(datePickerTheme: datePickerTheme),
      child: DatePickerDialog(
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate,
        helpText: helpText ?? title.toUpperCase(),
        // M3 help text is often uppercase
        confirmText: confirmText,
        cancelText: cancelText,
        initialEntryMode: initialEntryMode,
        initialDatePickerMode: initialDatePickerMode,
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
    DatePickerMode initialDatePickerMode = DatePickerMode.day,
    bool barrierDismissible = true,
    Color? headerBackgroundColor,
    Color? headerForegroundColor,
    String? helpText,
  }) async {
    return showDialog<DateTime>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return SlDatePickerDialog(
          initialDate: initialDate,
          firstDate: firstDate,
          lastDate: lastDate,
          title: title,
          confirmText: confirmText,
          cancelText: cancelText,
          initialEntryMode: initialEntryMode,
          initialDatePickerMode: initialDatePickerMode,
          headerBackgroundColor: headerBackgroundColor,
          headerForegroundColor: headerForegroundColor,
          helpText: helpText,
        );
      },
    );
  }
}
