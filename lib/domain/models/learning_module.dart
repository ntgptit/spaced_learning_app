import 'package:spaced_learning_app/domain/models/progress.dart';

/// Model đại diện cho một module học tập trong giao diện learning progress
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
  });
}
