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

  factory SlDatePickerDialog._create({
    // Private factory
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
  }) {
    return SlDatePickerDialog(
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      title: title,
      confirmText: confirmText,
      cancelText: cancelText,
      initialEntryMode: initialEntryMode,
      initialDatePickerMode: initialDatePickerMode,
      barrierDismissible: barrierDismissible,
      headerBackgroundColor: headerBackgroundColor,
      headerForegroundColor: headerForegroundColor,
      helpText: helpText,
    );
  }

  /// Factory for picking a generic date
  factory SlDatePickerDialog.pickDate({
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
    String title = 'Select Date',
  }) {
    return SlDatePickerDialog._create(
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
    return SlDatePickerDialog._create(
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
    return SlDatePickerDialog._create(
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

    // This build method is for wrapping Flutter's DatePickerDialog
    // The direct styling of buttons inside DatePickerDialog is limited.
    // We rely on the global theme passed to showDatePicker's builder.
    // For direct use of SlDatePickerDialog as a widget (less common for pickers),
    // this internal DatePickerDialog will inherit theme.
    return DatePickerDialog(
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      helpText: helpText ?? title.toUpperCase(),
      confirmText: confirmText,
      cancelText: cancelText,
      initialEntryMode: initialEntryMode,
      initialCalendarMode: initialDatePickerMode,
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
    ref.read(selectedDateProvider.notifier).setDate(initialDate);

    final result = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      helpText: helpText ?? title.toUpperCase(),
      confirmText: confirmText,
      cancelText: cancelText,
      initialEntryMode: initialEntryMode,
      barrierDismissible: barrierDismissible,
      builder: (context, child) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        return Theme(
          data: theme.copyWith(
            colorScheme: colorScheme.copyWith(
              primary: colorScheme.primary,
              onPrimary: colorScheme.onPrimary,
              surface: colorScheme.surfaceContainerHigh,
              // M3 dialog surface
              onSurface: colorScheme.onSurface,
            ),
            datePickerTheme: DatePickerThemeData(
              backgroundColor: colorScheme.surfaceContainerHigh,
              headerBackgroundColor:
                  headerBackgroundColor ?? colorScheme.primary,
              headerForegroundColor:
                  headerForegroundColor ?? colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimens.radiusL),
              ),
              elevation: AppDimens.elevationM,
              // Button styles for the native dialog
              cancelButtonStyle: TextButton.styleFrom(
                foregroundColor: colorScheme.primary,
                textStyle: theme.textTheme.labelLarge,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.paddingM,
                  vertical: AppDimens.paddingS,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimens.radiusCircular),
                ),
              ),
              confirmButtonStyle: FilledButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                textStyle: theme.textTheme.labelLarge,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.paddingL,
                  vertical: AppDimens.paddingS,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimens.radiusCircular),
                ),
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              // Fallback for dialog actions if not picked up by DatePickerTheme
              style: TextButton.styleFrom(
                foregroundColor: colorScheme.primary,
                textStyle: theme.textTheme.labelLarge,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.paddingM,
                  vertical: AppDimens.paddingS,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimens.radiusCircular),
                ),
              ),
            ),
            dialogTheme: DialogThemeData(
              // General dialog theming
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimens.radiusL),
              ),
              backgroundColor: colorScheme.surfaceContainerHigh,
              elevation: AppDimens.elevationM,
            ),
          ),
          child: child!,
        );
      },
    );

    if (result != null) {
      ref.read(selectedDateProvider.notifier).setDate(result);
    }

    return result;
  }
}
