import 'package:flutter/material.dart';
import 'package:spaced_learning_app/presentation/widgets/learning/enhanced_learning_stats_card.dart';

// /// Data class for module-related statistics
// class ModuleStats {
//   final int totalModules;
//   final int completedModules;
//   final int inProgressModules;

//   const ModuleStats({
//     required this.totalModules,
//     required this.completedModules,
//     required this.inProgressModules,
//   });
// }

// /// Data class for due learning statistics
// class DueStats {
//   final int dueToday;
//   final int dueThisWeek;
//   final int dueThisMonth;
//   final int wordsDueToday;
//   final int wordsDueThisWeek;
//   final int wordsDueThisMonth;

//   const DueStats({
//     required this.dueToday,
//     required this.dueThisWeek,
//     required this.dueThisMonth,
//     required this.wordsDueToday,
//     required this.wordsDueThisWeek,
//     required this.wordsDueThisMonth,
//   });
// }

// /// Data class for completed learning statistics
// class CompletionStats {
//   final int completedToday;
//   final int completedThisWeek;
//   final int completedThisMonth;
//   final int wordsCompletedToday;
//   final int wordsCompletedThisWeek;
//   final int wordsCompletedThisMonth;

//   const CompletionStats({
//     required this.completedToday,
//     required this.completedThisWeek,
//     required this.completedThisMonth,
//     required this.wordsCompletedToday,
//     required this.wordsCompletedThisWeek,
//     required this.wordsCompletedThisMonth,
//   });
// }

// /// Data class for learning streak statistics
// class StreakStats {
//   final int streakDays;
//   final int streakWeeks;

//   const StreakStats({required this.streakDays, required this.streakWeeks});
// }

// /// Data class for vocabulary statistics
// class VocabularyStats {
//   final int totalWords;
//   final int learnedWords;
//   final int pendingWords;
//   final double vocabularyCompletionRate;
//   final double weeklyNewWordsRate;

//   const VocabularyStats({
//     required this.totalWords,
//     required this.learnedWords,
//     required this.pendingWords,
//     required this.vocabularyCompletionRate,
//     required this.weeklyNewWordsRate,
//   });
// }

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
    return EnhancedLearningStatsCard(
      moduleStats: moduleStats,
      dueStats: dueStats,
      completionStats: completionStats,
      streakStats: streakStats,
      vocabularyStats: vocabularyStats,
      onViewProgress: onViewProgress,
    );
  }
}
