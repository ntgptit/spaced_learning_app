import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spaced_learning_app/domain/models/learning_stats.dart';
import 'package:spaced_learning_app/presentation/widgets/learning/learning_stats_card.dart';

part 'dashboard_section.freezed.dart';

/// Data class for module-related statistics
@freezed
abstract class ModuleStats with _$ModuleStats {
  const factory ModuleStats({
    required int totalModules,
    required Map<String, int> cycleStats,
  }) = _ModuleStats;
}

/// Data class for due learning statistics
@freezed
abstract class DueStats with _$DueStats {
  const factory DueStats({
    required int dueToday,
    required int dueThisWeek,
    required int dueThisMonth,
    required int wordsDueToday,
    required int wordsDueThisWeek,
    required int wordsDueThisMonth,
  }) = _DueStats;
}

/// Data class for completed learning statistics
@freezed
abstract class CompletionStats with _$CompletionStats {
  const factory CompletionStats({
    required int completedToday,
    required int completedThisWeek,
    required int completedThisMonth,
    required int wordsCompletedToday,
    required int wordsCompletedThisWeek,
    required int wordsCompletedThisMonth,
  }) = _CompletionStats;
}

/// Data class for learning streak statistics
@freezed
abstract class StreakStats with _$StreakStats {
  const factory StreakStats({
    required int streakDays,
    required int streakWeeks,
  }) = _StreakStats;
}

/// Data class for vocabulary statistics
@freezed
abstract class VocabularyStats with _$VocabularyStats {
  const factory VocabularyStats({
    required int totalWords,
    required int learnedWords,
    required int pendingWords,
    required double vocabularyCompletionRate,
    required double weeklyNewWordsRate,
  }) = _VocabularyStats;
}

/// Dashboard section for the home screen that displays learning statistics
class DashboardSection extends StatelessWidget {
  final ModuleStats moduleStats;
  final DueStats dueStats;
  final CompletionStats completionStats;
  final StreakStats streakStats;
  final VocabularyStats vocabularyStats;
  final VoidCallback? onViewProgress;

  const DashboardSection({
    super.key,
    required this.moduleStats,
    required this.dueStats,
    required this.completionStats,
    required this.streakStats,
    required this.vocabularyStats,
    this.onViewProgress,
  });

  @override
  Widget build(BuildContext context) {
    final statsDTO = LearningStatsDTO(
      totalModules: moduleStats.totalModules,
      cycleStats: moduleStats.cycleStats,
      dueToday: dueStats.dueToday,
      dueThisWeek: dueStats.dueThisWeek,
      dueThisMonth: dueStats.dueThisMonth,
      wordsDueToday: dueStats.wordsDueToday,
      wordsDueThisWeek: dueStats.wordsDueThisWeek,
      wordsDueThisMonth: dueStats.wordsDueThisMonth,
      completedToday: completionStats.completedToday,
      wordsCompletedToday: completionStats.wordsCompletedToday,
      streakDays: streakStats.streakDays,
      streakWeeks: streakStats.streakWeeks,
      longestStreakDays:
          streakStats
              .streakDays, // Assuming current streak is longest for simplicity
      totalWords: vocabularyStats.totalWords,
      learnedWords: vocabularyStats.learnedWords,
      pendingWords: vocabularyStats.pendingWords,
      vocabularyCompletionRate: vocabularyStats.vocabularyCompletionRate,
      weeklyNewWordsRate: vocabularyStats.weeklyNewWordsRate,
    );

    return LearningStatsCard(
      stats: statsDTO,
      onViewDetailPressed: onViewProgress,
    );
  }
}
