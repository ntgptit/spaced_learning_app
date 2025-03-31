import 'package:flutter/material.dart';

/// Data classes for grouped statistics
class ModuleStats {
  final int totalModules;
  final int completedModules;
  final int inProgressModules;

  const ModuleStats({
    required this.totalModules,
    required this.completedModules,
    required this.inProgressModules,
  });
}

class DueStats {
  final int dueToday;
  final int dueThisWeek;
  final int dueThisMonth;
  final int wordsDueToday;
  final int wordsDueThisWeek;
  final int wordsDueThisMonth;

  const DueStats({
    required this.dueToday,
    required this.dueThisWeek,
    required this.dueThisMonth,
    required this.wordsDueToday,
    required this.wordsDueThisWeek,
    required this.wordsDueThisMonth,
  });
}

class CompletionStats {
  final int completedToday;
  final int completedThisWeek;
  final int completedThisMonth;
  final int wordsCompletedToday;
  final int wordsCompletedThisWeek;
  final int wordsCompletedThisMonth;

  const CompletionStats({
    required this.completedToday,
    required this.completedThisWeek,
    required this.completedThisMonth,
    required this.wordsCompletedToday,
    required this.wordsCompletedThisWeek,
    required this.wordsCompletedThisMonth,
  });
}

class StreakStats {
  final int streakDays;
  final int streakWeeks;

  const StreakStats({required this.streakDays, required this.streakWeeks});
}

class VocabularyStats {
  final int totalWords;
  final int learnedWords;
  final int pendingWords;
  final double vocabularyCompletionRate;
  final double weeklyNewWordsRate;

  const VocabularyStats({
    required this.totalWords,
    required this.learnedWords,
    required this.pendingWords,
    required this.vocabularyCompletionRate,
    required this.weeklyNewWordsRate,
  });
}

/// Card widget that displays comprehensive learning statistics with enhanced metrics
/// Optimized for accessibility, scrollability, and performance
class EnhancedLearningStatsCard extends StatelessWidget {
  final ModuleStats moduleStats;
  final DueStats dueStats;
  final CompletionStats completionStats;
  final StreakStats streakStats;
  final VocabularyStats vocabularyStats;
  final VoidCallback? onViewProgress;

  const EnhancedLearningStatsCard({
    super.key,
    this.moduleStats = const ModuleStats(
      totalModules: 0,
      completedModules: 0,
      inProgressModules: 0,
    ),
    this.dueStats = const DueStats(
      dueToday: 0,
      dueThisWeek: 0,
      dueThisMonth: 0,
      wordsDueToday: 0,
      wordsDueThisWeek: 0,
      wordsDueThisMonth: 0,
    ),
    this.completionStats = const CompletionStats(
      completedToday: 0,
      completedThisWeek: 0,
      completedThisMonth: 0,
      wordsCompletedToday: 0,
      wordsCompletedThisWeek: 0,
      wordsCompletedThisMonth: 0,
    ),
    this.streakStats = const StreakStats(streakDays: 0, streakWeeks: 0),
    this.vocabularyStats = const VocabularyStats(
      totalWords: 0,
      learnedWords: 0,
      pendingWords: 0,
      vocabularyCompletionRate: 0.0,
      weeklyNewWordsRate: 0.0,
    ),
    this.onViewProgress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(theme, colorScheme),
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 16),
              _buildDueSessionsSection(context),
              const SizedBox(height: 16),
              _buildCompletedSessionsSection(context),
              const SizedBox(height: 16),
              _buildProgressOverviewSection(context),
              const SizedBox(height: 16),
              _buildVocabularyStatsSection(context),
              if (dueStats.dueToday > 0) ...[
                const SizedBox(height: 16),
                _buildTodayProgressBar(context),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // UI Components
  Widget _buildHeader(ThemeData theme, ColorScheme colorScheme) {
    return Row(
      children: [
        Semantics(
          label: 'Learning Dashboard Icon',
          child: Icon(Icons.school, color: colorScheme.primary, size: 24),
        ),
        const SizedBox(width: 8),
        Text('Learning Dashboard', style: theme.textTheme.titleMedium),
        const Spacer(),
        if (onViewProgress != null)
          Semantics(
            label: 'View all learning statistics',
            hint: 'Navigate to detailed learning progress screen',
            button: true,
            child: TextButton.icon(
              icon: const Icon(Icons.analytics_outlined),
              label: const Text('View All'),
              onPressed: onViewProgress,
            ),
          ),
      ],
    );
  }

  Widget _buildDueSessionsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          context,
          'Upcoming Learning Sessions',
          Icons.assignment_late,
          Colors.teal,
          'Upcoming learning sessions that need your attention',
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatColumnWithWordCount(
              context: context,
              label: 'Today',
              value: dueStats.dueToday,
              wordCount: dueStats.wordsDueToday,
              color: dueStats.dueToday > 0 ? Colors.red : Colors.grey,
              icon: Icons.today,
              semanticLabel:
                  '${dueStats.dueToday} learning sessions due today with ${dueStats.wordsDueToday} words',
            ),
            _buildDivider(),
            _buildStatColumnWithWordCount(
              context: context,
              label: 'This Week',
              value: dueStats.dueThisWeek,
              wordCount: dueStats.wordsDueThisWeek,
              color: dueStats.dueThisWeek > 0 ? Colors.orange : Colors.grey,
              icon: Icons.view_week,
              semanticLabel:
                  '${dueStats.dueThisWeek} learning sessions due this week with ${dueStats.wordsDueThisWeek} words',
            ),
            _buildDivider(),
            _buildStatColumnWithWordCount(
              context: context,
              label: 'This Month',
              value: dueStats.dueThisMonth,
              wordCount: dueStats.wordsDueThisMonth,
              color:
                  dueStats.dueThisMonth > 0
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey,
              icon: Icons.calendar_month,
              semanticLabel:
                  '${dueStats.dueThisMonth} a sessions due this month with ${dueStats.wordsDueThisMonth} words',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCompletedSessionsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          context,
          'Completed Learning Sessions',
          Icons.check_circle,
          Colors.orange,
          'Learning sessions you have completed',
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatColumnWithWordCount(
              context: context,
              label: 'Today',
              value: completionStats.completedToday,
              wordCount: completionStats.wordsCompletedToday,
              color: Colors.green,
              icon: Icons.check_circle,
              semanticLabel:
                  '${completionStats.completedToday} learning sessions completed today with ${completionStats.wordsCompletedToday} words',
            ),
            _buildDivider(),
            _buildStatColumnWithWordCount(
              context: context,
              label: 'This Week',
              value: completionStats.completedThisWeek,
              wordCount: completionStats.wordsCompletedThisWeek,
              color: Colors.green,
              icon: Icons.check_circle_outline,
              semanticLabel:
                  '${completionStats.completedThisWeek} learning sessions completed this week with ${completionStats.wordsCompletedThisWeek} words',
            ),
            _buildDivider(),
            _buildStatColumnWithWordCount(
              context: context,
              label: 'This Month',
              value: completionStats.completedThisMonth,
              wordCount: completionStats.wordsCompletedThisMonth,
              color: Colors.green,
              icon: Icons.verified,
              semanticLabel:
                  '${completionStats.completedThisMonth} learning sessions completed this month with ${completionStats.wordsCompletedThisMonth} words',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressOverviewSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          context,
          'Learning Progress Overview',
          Icons.trending_up,
          Colors.indigo,
          'Overall progress across all learning modules',
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatColumn(
              context: context,
              label: 'Modules\nCompleted',
              value: moduleStats.completedModules,
              secondValue: moduleStats.totalModules,
              color: colorScheme.primary,
              icon: Icons.auto_stories,
              format:
                  '${moduleStats.completedModules}/${moduleStats.totalModules}',
              semanticLabel:
                  'Completed ${moduleStats.completedModules} out of ${moduleStats.totalModules} total modules',
            ),
            _buildDivider(),
            _buildStatColumn(
              context: context,
              label: 'Day\nStreak',
              value: streakStats.streakDays,
              color: Colors.deepOrange,
              icon: Icons.local_fire_department,
              showBadge: streakStats.streakDays >= 7,
              semanticLabel:
                  '${streakStats.streakDays} day streak${streakStats.streakDays >= 7 ? ", excellent progress!" : ""}',
            ),
            _buildDivider(),
            _buildStatColumn(
              context: context,
              label: 'Week\nStreak',
              value: streakStats.streakWeeks,
              color: Colors.purple,
              icon: Icons.pending_actions,
              showBadge: streakStats.streakWeeks >= 4,
              semanticLabel:
                  '${streakStats.streakWeeks} week streak${streakStats.streakWeeks >= 4 ? ", outstanding commitment!" : ""}',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVocabularyStatsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          context,
          'Vocabulary Statistics',
          Icons.menu_book,
          Colors.blueGrey,
          'Statistics about your vocabulary learning progress',
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatColumn(
              context: context,
              label: 'Words\nLearned',
              value: vocabularyStats.learnedWords,
              secondValue: vocabularyStats.totalWords,
              color: Colors.teal,
              icon: Icons.book_sharp,
              format:
                  '${vocabularyStats.learnedWords}/${vocabularyStats.totalWords}',
              showPercentage: true,
              percentage: vocabularyStats.vocabularyCompletionRate,
              semanticLabel:
                  'Learned ${vocabularyStats.learnedWords} out of ${vocabularyStats.totalWords} words, ${vocabularyStats.vocabularyCompletionRate.toStringAsFixed(1)} percent complete',
            ),
            _buildDivider(),
            _buildStatColumn(
              context: context,
              label: 'Pending\nWords',
              value: vocabularyStats.pendingWords,
              color: Colors.amber.shade800,
              icon: Icons.hourglass_bottom,
              semanticLabel:
                  '${vocabularyStats.pendingWords} words pending to learn',
            ),
            _buildDivider(),
            _buildStatColumn(
              context: context,
              label: 'New Words\nWeekly Rate',
              value: vocabularyStats.weeklyNewWordsRate.round(),
              color: Colors.indigo,
              icon: Icons.insights,
              suffix: '%',
              semanticLabel:
                  'Learning ${vocabularyStats.weeklyNewWordsRate.round()} percent new words weekly',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    String semanticDescription,
  ) {
    final theme = Theme.of(context);
    return Semantics(
      header: true,
      label: title,
      hint: semanticDescription,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return SizedBox(
      height: 60,
      child: VerticalDivider(
        color: Colors.grey.withValues(alpha: 0.3),
        thickness: 1,
        width: 1,
      ),
    );
  }

  Widget _buildStatColumn({
    required BuildContext context,
    required String label,
    required int value,
    int? secondValue,
    required Color color,
    required IconData icon,
    bool showBadge = false,
    String? format,
    bool showPercentage = false,
    double percentage = 0.0,
    String suffix = '',
    required String semanticLabel,
  }) {
    final theme = Theme.of(context);
    final formattedValue = format ?? '$value$suffix';

    return Expanded(
      child: Semantics(
        label: semanticLabel,
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(icon, color: color, size: 24),
                if (showBadge)
                  Positioned(
                    top: -5,
                    right: -5,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.amber,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.star,
                        color: Colors.white,
                        size: 10,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              showPercentage
                  ? '$formattedValue (${percentage.toStringAsFixed(1)}%)'
                  : formattedValue,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumnWithWordCount({
    required BuildContext context,
    required String label,
    required int value,
    required int wordCount,
    required Color color,
    required IconData icon,
    required String semanticLabel,
  }) {
    final theme = Theme.of(context);

    return Expanded(
      child: Semantics(
        label: semanticLabel,
        child: ExcludeSemantics(
          child: Column(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 4),
              Text(
                value.toString(),
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                '$wordCount words',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: color,
                  fontStyle: FontStyle.italic,
                ),
              ),
              Text(
                label,
                style: theme.textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTodayProgressBar(BuildContext context) {
    final theme = Theme.of(context);
    final completionRate =
        dueStats.dueToday > 0
            ? completionStats.completedToday / dueStats.dueToday
            : 0.0;
    final progressPercent = (completionRate * 100).toInt();

    final semanticLabel =
        dueStats.dueToday > 0
            ? 'Today\'s progress: ${completionStats.completedToday} of ${dueStats.dueToday} sessions completed, $progressPercent percent. ${completionStats.wordsCompletedToday} of ${dueStats.wordsDueToday} words completed.'
            : 'No sessions scheduled for today';

    return Semantics(
      label: semanticLabel,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Today\'s Progress', style: theme.textTheme.titleSmall),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: completionRate,
              minHeight: 10,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(
                completionRate >= 1.0
                    ? Colors.green
                    : theme.colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dueStats.dueToday > 0
                    ? 'Completed ${completionStats.completedToday} of ${dueStats.dueToday} due sessions ($progressPercent%)'
                    : 'No sessions due today',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
