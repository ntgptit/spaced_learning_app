// lib/presentation/widgets/common/dialog/sl_date_picker_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

/// A date picker dialog with Material 3 design and customizable options.
class SlDatePickerDialog extends ConsumerWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final String title;
  final String confirmText;
  final String cancelText;
  final DateFormat? displayFormat;
  final TextStyle? headerStyle;
  final bool barrierDismissible;
  final Color? headerColor;
  final bool useShortWeekdays;
  final bool useSlidingAnimation;
  final bool useCompactLayout;

  const SlDatePickerDialog({
    super.key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    this.title = 'Select Date',
    this.confirmText = 'OK',
    this.cancelText = 'Cancel',
    this.displayFormat,
    this.headerStyle,
    this.barrierDismissible = true,
    this.headerColor,
    this.useShortWeekdays = false,
    this.useSlidingAnimation = true,
    this.useCompactLayout = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Create the date picker theme
    final datePickerTheme = DatePickerThemeData(
      backgroundColor: colorScheme.surface,
      headerBackgroundColor: headerColor ?? colorScheme.primary,
      headerForegroundColor: colorScheme.onPrimary,
      dayBackgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return colorScheme.primary;
        }
        return colorScheme.surfaceContainerLowest;
      }),
      dayForegroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return colorScheme.onPrimary;
        }
        if (states.contains(WidgetState.disabled)) {
          return colorScheme.onSurface.withOpacity(0.38);
        }
        return colorScheme.onSurface;
      }),
      todayBackgroundColor: WidgetStateProperty.all(
        colorScheme.primaryContainer.withOpacity(0.5),
      ),
      todayForegroundColor: WidgetStateProperty.all(
        colorScheme.onPrimaryContainer,
      ),
      yearBackgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return colorScheme.primary;
        }
        return colorScheme.surfaceContainerLowest;
      }),
      yearForegroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return colorScheme.onPrimary;
        }
        return colorScheme.onSurface;
      }),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusL),
      ),
      headerHeadlineStyle:
          headerStyle ??
          theme.textTheme.headlineMedium?.copyWith(
            color: colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
      dayStyle: theme.textTheme.bodyLarge,
      yearStyle: theme.textTheme.bodyLarge,
    );

    return Theme(
      data: theme.copyWith(datePickerTheme: datePickerTheme),
      child: DatePickerDialog(
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate,
        initialEntryMode: useCompactLayout
            ? DatePickerEntryMode.calendarOnly
            : DatePickerEntryMode.calendar,
        helpText: title,
        confirmText: confirmText,
        cancelText: cancelText,
      ),
    );
  }

  /// Show the date picker dialog
  static Future<DateTime?> show(
    BuildContext context, {
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    String title = 'Select Date',
    String confirmText = 'OK',
    String cancelText = 'Cancel',
    DateFormat? displayFormat,
    TextStyle? headerStyle,
    bool barrierDismissible = true,
    Color? headerColor,
    bool useShortWeekdays = false,
    bool useSlidingAnimation = true,
    bool useCompactLayout = false,
  }) async {
    final now = DateTime.now();
    final effectiveInitialDate = initialDate ?? now;
    final effectiveFirstDate =
        firstDate ?? DateTime(effectiveInitialDate.year - 5, 1, 1);
    final effectiveLastDate =
        lastDate ?? DateTime(effectiveInitialDate.year + 5, 12, 31);

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final DateTime? selectedDate = await showDialog<DateTime>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.black54,
      builder: (BuildContext context) {
        return Theme(
          data: theme.copyWith(
            colorScheme: colorScheme.copyWith(surface: colorScheme.surface),
          ),
          child: SlDatePickerDialog(
            initialDate: effectiveInitialDate,
            firstDate: effectiveFirstDate,
            lastDate: effectiveLastDate,
            title: title,
            confirmText: confirmText,
            cancelText: cancelText,
            displayFormat: displayFormat,
            headerStyle: headerStyle,
            headerColor: headerColor,
            useShortWeekdays: useShortWeekdays,
            useSlidingAnimation: useSlidingAnimation,
            useCompactLayout: useCompactLayout,
          ),
        );
      },
    );

    return selectedDate;
  }

  /// Convenience method to pick a date in a range
  static Future<DateTime?> pickDateInRange(
    BuildContext context, {
    DateTime? initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
    String title = 'Select Date',
  }) {
    return show(
      context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      title: title,
      displayFormat: DateFormat.yMMMMd(),
    );
  }

  /// Convenience method to pick a birth date
  static Future<DateTime?> pickBirthDate(
    BuildContext context, {
    DateTime? initialDate,
    String title = 'Date of Birth',
  }) {
    final now = DateTime.now();
    final defaultDate =
        initialDate ?? now.subtract(const Duration(days: 365 * 18));
    final firstDate = DateTime(1900);

    return show(
      context,
      initialDate: defaultDate,
      firstDate: firstDate,
      lastDate: now,
      title: title,
      headerColor: Theme.of(context).colorScheme.tertiary,
    );
  }

  /// Convenience method to pick a future date
  static Future<DateTime?> pickFutureDate(
    BuildContext context, {
    DateTime? initialDate,
    String title = 'Select Future Date',
    int maxDaysInFuture = 365,
  }) {
    final now = DateTime.now();
    final defaultDate = initialDate ?? now.add(const Duration(days: 1));

    return show(
      context,
      initialDate: defaultDate,
      firstDate: now,
      lastDate: now.add(Duration(days: maxDaysInFuture)),
      title: title,
      headerColor: Theme.of(context).colorScheme.secondary,
    );
  }
}
