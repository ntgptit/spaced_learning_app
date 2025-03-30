import 'package:spaced_learning_app/domain/models/progress.dart';

/// Model representing a learning module in the learning progress interface
class LearningModule {
  final String id;
  final String book;
  final String subject;
  final int wordCount;
  final CycleStudied? cyclesStudied;
  final DateTime? firstLearningDate;
  final int percentage;
  final DateTime? nextStudyDate;
  final int? taskCount;

  // Additional properties for enhanced statistics
  final int learnedWords;
  final DateTime? lastStudyDate;
  final List<DateTime>? studyHistory;

  LearningModule({
    required this.id,
    required this.book,
    required this.subject,
    required this.wordCount,
    required this.cyclesStudied,
    required this.firstLearningDate,
    required this.percentage,
    required this.nextStudyDate,
    required this.taskCount,
    this.learnedWords = 0,
    this.lastStudyDate,
    this.studyHistory,
  });

  /// Calculate the number of learned words based on completion percentage
  int get actualLearnedWords {
    return (wordCount * percentage / 100).round();
  }

  /// Calculate remaining words to be learned
  int get remainingWords {
    return wordCount - actualLearnedWords;
  }

  /// Check if the module is due today
  bool isDueToday() {
    if (nextStudyDate == null) return false;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final studyDate = DateTime(
      nextStudyDate!.year,
      nextStudyDate!.month,
      nextStudyDate!.day,
    );

    return today.isAtSameMomentAs(studyDate);
  }

  /// Check if the module is overdue
  bool isOverdue() {
    if (nextStudyDate == null) return false;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final studyDate = DateTime(
      nextStudyDate!.year,
      nextStudyDate!.month,
      nextStudyDate!.day,
    );

    return studyDate.isBefore(today);
  }

  /// Check if the module will be due this week
  bool isDueThisWeek() {
    if (nextStudyDate == null) return false;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekStart = today.subtract(Duration(days: today.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));
    final studyDate = DateTime(
      nextStudyDate!.year,
      nextStudyDate!.month,
      nextStudyDate!.day,
    );

    return studyDate.isAfter(weekStart.subtract(const Duration(days: 1))) &&
        studyDate.isBefore(weekEnd.add(const Duration(days: 1)));
  }

  /// Check if the module will be due this month
  bool isDueThisMonth() {
    if (nextStudyDate == null) return false;

    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final monthEnd =
        (now.month < 12)
            ? DateTime(now.year, now.month + 1, 0)
            : DateTime(now.year + 1, 1, 0);
    final studyDate = DateTime(
      nextStudyDate!.year,
      nextStudyDate!.month,
      nextStudyDate!.day,
    );

    return studyDate.isAfter(monthStart.subtract(const Duration(days: 1))) &&
        studyDate.isBefore(monthEnd.add(const Duration(days: 1)));
  }

  /// Check if the module is a new module (never studied before)
  bool isNewModule() {
    return firstLearningDate == null && percentage == 0;
  }

  /// Check if the module is completed
  bool isCompleted() {
    return percentage >= 100;
  }

  /// Get days since first learning
  int? getDaysSinceFirstLearning() {
    if (firstLearningDate == null) return null;

    final now = DateTime.now();
    final difference = now.difference(firstLearningDate!);
    return difference.inDays;
  }
}
