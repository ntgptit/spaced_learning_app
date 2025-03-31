import 'package:intl/intl.dart';

/// Utility class for date-related operations
class AppDateUtils {
  /// Check if two dates represent the same calendar day
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// Format date to a user-friendly string (e.g., "Jan 15, 2025")
  static String formatDate(DateTime date, {String format = 'MMM dd, yyyy'}) {
    return DateFormat(format).format(date);
  }

  /// Get the start of the day (00:00:00) for a given date
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Get the start of the week (Monday) for a given date
  static DateTime startOfWeek(DateTime date) {
    // Adjust for week starting on Monday (1) instead of Sunday (7)
    final weekday = date.weekday;
    return DateTime(date.year, date.month, date.day - (weekday - 1));
  }

  /// Get the start of the month for a given date
  static DateTime startOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  /// Get the end of the month for a given date
  static DateTime endOfMonth(DateTime date) {
    // Last day of the month
    return (date.month < 12)
        ? DateTime(date.year, date.month + 1, 0)
        : DateTime(date.year + 1, 1, 0);
  }

  /// Check if a date is in the past
  static bool isPast(DateTime date) {
    final now = DateTime.now();
    return date.isBefore(startOfDay(now));
  }

  /// Check if a date is today
  static bool isToday(DateTime date) {
    return isSameDay(date, DateTime.now());
  }

  /// Check if a date is within the current week
  static bool isThisWeek(DateTime date) {
    final now = DateTime.now();
    final startWeek = startOfWeek(now);
    final endWeek = startWeek.add(const Duration(days: 6));

    return !date.isBefore(startWeek) && !date.isAfter(endWeek);
  }

  /// Check if a date is within the current month
  static bool isThisMonth(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }

  /// Get the difference in days between two dates
  static int daysBetween(DateTime from, DateTime to) {
    from = startOfDay(from);
    to = startOfDay(to);
    return to.difference(from).inDays;
  }
}
