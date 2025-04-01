import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spaced_learning_app/domain/models/learning_insight.dart';

part 'learning_stats.freezed.dart';
part 'learning_stats.g.dart';

/// DTO for user learning statistics
@freezed
abstract class LearningStatsDTO with _$LearningStatsDTO {
  const factory LearningStatsDTO({
    // Module statistics
    @Default(0) int totalModules,
    @Default(0) int completedModules,
    @Default(0) int inProgressModules,
    @Default(0.0) double moduleCompletionRate,

    // Due sessions
    @Default(0) int dueToday,
    @Default(0) int dueThisWeek,
    @Default(0) int dueThisMonth,

    // Due words
    @Default(0) int wordsDueToday,
    @Default(0) int wordsDueThisWeek,
    @Default(0) int wordsDueThisMonth,

    // Completed sessions
    @Default(0) int completedToday,
    @Default(0) int completedThisWeek,
    @Default(0) int completedThisMonth,

    // Completed words
    @Default(0) int wordsCompletedToday,
    @Default(0) int wordsCompletedThisWeek,
    @Default(0) int wordsCompletedThisMonth,

    // Streak stats
    @Default(0) int streakDays,
    @Default(0) int streakWeeks,
    @Default(0) int longestStreakDays,

    // Vocabulary stats
    @Default(0) int totalWords,
    @Default(0) int totalCompletedModules,
    @Default(0) int totalInProgressModules,
    @Default(0) int learnedWords,
    @Default(0) int pendingWords,
    @Default(0.0) double vocabularyCompletionRate,
    @Default(0.0) double weeklyNewWordsRate,

    // Insights for UI
    @Default([]) List<LearningInsightDTO> learningInsights,

    // Metadata
    DateTime? lastUpdated,
  }) = _LearningStatsDTO;

  factory LearningStatsDTO.fromJson(Map<String, dynamic> json) =>
      _$LearningStatsDTOFromJson(json);
}
