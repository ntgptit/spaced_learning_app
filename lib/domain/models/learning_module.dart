// lib/domain/models/learning_module.dart
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

  /// Factory method to create a LearningModule from JSON
  factory LearningModule.fromJson(Map<String, dynamic> json) {
    List<DateTime>? studyHistoryList;
    if (json['studyHistory'] != null) {
      studyHistoryList =
          (json['studyHistory'] as List)
              .map((dateStr) => DateTime.parse(dateStr.toString()))
              .toList();
    }

    return LearningModule(
      id: json['id'] as String,
      book: json['bookName'] as String,
      subject: json['title'] as String,
      wordCount: json['wordCount'] as int,
      cyclesStudied:
          json['cyclesStudied'] != null
              ? _parseCycleStudied(json['cyclesStudied'].toString())
              : null,
      firstLearningDate:
          json['firstLearningDate'] != null
              ? DateTime.parse(json['firstLearningDate'].toString())
              : null,
      percentage:
          json['percentComplete'] != null
              ? (json['percentComplete'] is int)
                  ? json['percentComplete']
                  : (json['percentComplete'] as double).round()
              : 0,
      nextStudyDate:
          json['nextStudyDate'] != null
              ? DateTime.parse(json['nextStudyDate'].toString())
              : null,
      taskCount: json['pendingRepetitions'] as int?,
      learnedWords: json['learnedWords'] as int? ?? 0,
      lastStudyDate:
          json['lastStudyDate'] != null
              ? DateTime.parse(json['lastStudyDate'].toString())
              : null,
      studyHistory: studyHistoryList,
    );
  }

  /// Helper method to parse CycleStudied from string
  static CycleStudied? _parseCycleStudied(String? value) {
    if (value == null) return null;

    switch (value.toUpperCase()) {
      case 'FIRST_TIME':
        return CycleStudied.firstTime;
      case 'FIRST_REVIEW':
        return CycleStudied.firstReview;
      case 'SECOND_REVIEW':
        return CycleStudied.secondReview;
      case 'THIRD_REVIEW':
        return CycleStudied.thirdReview;
      case 'MORE_THAN_THREE_REVIEWS':
        return CycleStudied.moreThanThreeReviews;
      default:
        return null;
    }
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookName': book,
      'title': subject,
      'wordCount': wordCount,
      'cyclesStudied': cyclesStudied?.toString().split('.').last.toUpperCase(),
      'firstLearningDate': firstLearningDate?.toIso8601String(),
      'percentComplete': percentage,
      'nextStudyDate': nextStudyDate?.toIso8601String(),
      'pendingRepetitions': taskCount,
      'learnedWords': learnedWords,
      'lastStudyDate': lastStudyDate?.toIso8601String(),
      'studyHistory':
          studyHistory?.map((date) => date.toIso8601String()).toList(),
    };
  }

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
