import 'package:flutter/material.dart';
import 'package:spaced_learning_app/presentation/widgets/learning/enhanced_learning_stats_card.dart';

/// Dashboard section for the home screen that displays learning statistics
class DashboardSection extends StatelessWidget {
  // Core learning stats
  final int totalModules;
  final int completedModules;
  final int inProgressModules;

  // Scheduled learning stats
  final int dueToday;
  final int dueThisWeek;
  final int dueThisMonth;

  // Word count stats for due sessions
  final int wordsDueToday;
  final int wordsDueThisWeek;
  final int wordsDueThisMonth;

  // Completion stats
  final int completedToday;
  final int completedThisWeek;
  final int completedThisMonth;

  // Word count stats for completed sessions
  final int wordsCompletedToday;
  final int wordsCompletedThisWeek;
  final int wordsCompletedThisMonth;

  // Learning streak
  final int streakDays;
  final int streakWeeks;

  // Vocabulary stats
  final int totalWords;
  final int learnedWords;
  final int pendingWords;
  final double vocabularyCompletionRate;
  final double weeklyNewWordsRate;

  // View progress callback
  final VoidCallback? onViewProgress;

  const DashboardSection({
    super.key,
    required this.totalModules,
    required this.completedModules,
    required this.inProgressModules,
    required this.dueToday,
    required this.dueThisWeek,
    required this.dueThisMonth,
    required this.wordsDueToday,
    required this.wordsDueThisWeek,
    required this.wordsDueThisMonth,
    required this.completedToday,
    required this.completedThisWeek,
    required this.completedThisMonth,
    required this.wordsCompletedToday,
    required this.wordsCompletedThisWeek,
    required this.wordsCompletedThisMonth,
    required this.streakDays,
    required this.streakWeeks,
    required this.totalWords,
    required this.learnedWords,
    required this.pendingWords,
    required this.vocabularyCompletionRate,
    required this.weeklyNewWordsRate,
    this.onViewProgress,
  });

  @override
  Widget build(BuildContext context) {
    return EnhancedLearningStatsCard(
      totalModules: totalModules,
      completedModules: completedModules,
      inProgressModules: inProgressModules,
      dueToday: dueToday,
      dueThisWeek: dueThisWeek,
      dueThisMonth: dueThisMonth,
      wordsDueToday: wordsDueToday,
      wordsDueThisWeek: wordsDueThisWeek,
      wordsDueThisMonth: wordsDueThisMonth,
      completedToday: completedToday,
      completedThisWeek: completedThisWeek,
      completedThisMonth: completedThisMonth,
      wordsCompletedToday: wordsCompletedToday,
      wordsCompletedThisWeek: wordsCompletedThisWeek,
      wordsCompletedThisMonth: wordsCompletedThisMonth,
      streakDays: streakDays,
      streakWeeks: streakWeeks,
      totalWords: totalWords,
      learnedWords: learnedWords,
      pendingWords: pendingWords,
      vocabularyCompletionRate: vocabularyCompletionRate,
      weeklyNewWordsRate: weeklyNewWordsRate,
      onViewProgress: onViewProgress,
    );
  }
}
