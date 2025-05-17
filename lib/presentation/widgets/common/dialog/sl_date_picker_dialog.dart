// lib/presentation/widgets/common/dialog/sl_date_picker_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

part 'sl_date_picker_dialog.g.dart';

@riverpod
class SelectedDate extends _$SelectedDate {
  @override
  DateTime build() => DateTime.now();

  void setDate(DateTime date) {
    state = date;
  }
}

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
  final Color? headerBackgroundColor;
  final Color? headerForegroundColor;
  final String? helpText;

  const SlDatePickerDialog({
    super.key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    this.title = 'Select Date',
    this.confirmText = 'OK',
    this.cancelText = 'CANCEL',
    this.initialEntryMode = DatePickerEntryMode.calendar,
    this.initialDatePickerMode = DatePickerMode.day,
    this.barrierDismissible = true,
    this.headerBackgroundColor,
    this.headerForegroundColor,
    this.helpText,
  });

  /// Factory for picking a generic date
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

  /// Factory for picking a birth date (past dates)
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

  /// Factory for picking a future date
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
        return Colors.transparent;
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
      elevation: AppDimens.elevationM,
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
        confirmText: confirmText,
        cancelText: cancelText,
        initialEntryMode: initialEntryMode,
        initialCalendarMode: initialDatePickerMode,
      ),
    );
  }

  /// Show the date picker dialog
  static Future<DateTime?> show(
    BuildContext context,
    WidgetRef ref, {
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
    // Set initial date in provider
    ref.read(selectedDateProvider.notifier).setDate(initialDate);

    final result = await showDialog<DateTime>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext dialogContext) {
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
          barrierDismissible: barrierDismissible,
        );
      },
    );

    // Update provider with result
    if (result != null) {
      ref.read(selectedDateProvider.notifier).setDate(result);
    }

    return result;
  }
}
