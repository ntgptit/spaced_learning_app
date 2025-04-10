// lib/domain/models/learning_module.dart

/// Model representing a learning module in the learning progress interface
class LearningModule {
  final String bookName;
  final int bookNo;
  final String moduleTitle;
  final int moduleNo;
  final int moduleWordCount;
  final String? progressCyclesStudied;
  final DateTime? progressNextStudyDate;
  final DateTime? progressFirstLearningDate;
  final int? progressLatestPercentComplete;
  final int progressDueTaskCount;
  final String moduleId;
  final List<String> studyHistory;

  const LearningModule({
    required this.bookName,
    required this.bookNo,
    required this.moduleTitle,
    required this.moduleNo,
    required this.moduleWordCount,
    this.progressCyclesStudied,
    this.progressNextStudyDate,
    this.progressFirstLearningDate,
    this.progressLatestPercentComplete,
    required this.progressDueTaskCount,
    required this.moduleId,
    required this.studyHistory,
  });

  /// Factory method to create a LearningModule from JSON
  factory LearningModule.fromJson(Map<String, dynamic> json) {
    return LearningModule(
      bookName: json['bookName'] ?? '',
      bookNo: json['bookNo'] ?? 0,
      moduleTitle: json['moduleTitle'] ?? '',
      moduleNo: json['moduleNo'] ?? 0,
      moduleWordCount: json['moduleWordCount'] ?? 0,
      progressCyclesStudied: json['progressCyclesStudied'],
      progressNextStudyDate:
          json['progressNextStudyDate'] != null
              ? DateTime.parse(json['progressNextStudyDate'])
              : null,
      progressFirstLearningDate:
          json['progressFirstLearningDate'] != null
              ? DateTime.parse(json['progressFirstLearningDate'])
              : null,
      progressLatestPercentComplete: json['progressLatestPercentComplete'],
      progressDueTaskCount: json['progressDueTaskCount'] ?? 0,
      moduleId: json['moduleId'] ?? '',
      studyHistory: List<String>.from(json['studyHistory'] ?? []),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'bookName': bookName,
      'bookNo': bookNo,
      'moduleTitle': moduleTitle,
      'moduleNo': moduleNo,
      'moduleWordCount': moduleWordCount,
      'progressCyclesStudied': progressCyclesStudied,
      'progressNextStudyDate': progressNextStudyDate?.toIso8601String(),
      'progressFirstLearningDate': progressFirstLearningDate?.toIso8601String(),
      'progressLatestPercentComplete': progressLatestPercentComplete,
      'progressDueTaskCount': progressDueTaskCount,
      'moduleId': moduleId,
      'studyHistory': studyHistory,
    };
  }

  /// --- Utility Methods Below ---

  bool isDueToday() {
    if (progressNextStudyDate == null) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final studyDate = DateTime(
      progressNextStudyDate!.year,
      progressNextStudyDate!.month,
      progressNextStudyDate!.day,
    );
    return today.isAtSameMomentAs(studyDate);
  }

  bool isOverdue() {
    if (progressNextStudyDate == null) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final studyDate = DateTime(
      progressNextStudyDate!.year,
      progressNextStudyDate!.month,
      progressNextStudyDate!.day,
    );
    return studyDate.isBefore(today);
  }

  bool isDueThisWeek() {
    if (progressNextStudyDate == null) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekStart = today.subtract(Duration(days: today.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));
    final studyDate = DateTime(
      progressNextStudyDate!.year,
      progressNextStudyDate!.month,
      progressNextStudyDate!.day,
    );
    return studyDate.isAfter(weekStart.subtract(const Duration(days: 1))) &&
        studyDate.isBefore(weekEnd.add(const Duration(days: 1)));
  }

  bool isDueThisMonth() {
    if (progressNextStudyDate == null) return false;
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final monthEnd =
        (now.month < 12)
            ? DateTime(now.year, now.month + 1, 0)
            : DateTime(now.year + 1, 1, 0);
    final studyDate = DateTime(
      progressNextStudyDate!.year,
      progressNextStudyDate!.month,
      progressNextStudyDate!.day,
    );
    return studyDate.isAfter(monthStart.subtract(const Duration(days: 1))) &&
        studyDate.isBefore(monthEnd.add(const Duration(days: 1)));
  }

  bool isNewModule() {
    return progressFirstLearningDate == null &&
        (progressLatestPercentComplete ?? 0) == 0;
  }

  bool isCompleted() {
    return (progressLatestPercentComplete ?? 0) >= 100;
  }

  int? getDaysSinceFirstLearning() {
    if (progressFirstLearningDate == null) return null;
    return DateTime.now().difference(progressFirstLearningDate!).inDays;
  }
}
