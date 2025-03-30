import 'package:flutter/material.dart';

/// Card widget that displays comprehensive learning statistics with enhanced metrics
class EnhancedLearningStatsCard extends StatelessWidget {
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

  /// Creates an enhanced learning stats card with comprehensive learning metrics
  const EnhancedLearningStatsCard({
    super.key,
    this.totalModules = 0,
    this.completedModules = 0,
    this.inProgressModules = 0,
    this.dueToday = 0,
    this.dueThisWeek = 0,
    this.dueThisMonth = 0,
    this.wordsDueToday = 0,
    this.wordsDueThisWeek = 0,
    this.wordsDueThisMonth = 0,
    this.completedToday = 0,
    this.completedThisWeek = 0,
    this.completedThisMonth = 0,
    this.wordsCompletedToday = 0,
    this.wordsCompletedThisWeek = 0,
    this.wordsCompletedThisMonth = 0,
    this.streakDays = 0,
    this.streakWeeks = 0,
    this.totalWords = 0,
    this.learnedWords = 0,
    this.pendingWords = 0,
    this.vocabularyCompletionRate = 0.0,
    this.weeklyNewWordsRate = 0.0,
    this.onViewProgress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and view all button
            Row(
              children: [
                Icon(Icons.school, color: colorScheme.primary, size: 24),
                const SizedBox(width: 8),
                Text('Learning Dashboard', style: theme.textTheme.titleLarge),
                const Spacer(),
                if (onViewProgress != null)
                  TextButton.icon(
                    icon: const Icon(Icons.analytics_outlined),
                    label: const Text('View All'),
                    onPressed: onViewProgress,
                  ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 16),

            // Row 1: Due Sessions with clear title
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.assignment_late, color: colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    'UPCOMING LEARNING SESSIONS',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumnWithWordCount(
                  context: context,
                  label: 'Today',
                  value: dueToday,
                  wordCount: wordsDueToday,
                  color: dueToday > 0 ? Colors.red : Colors.grey,
                  icon: Icons.today,
                ),
                _buildDivider(),
                _buildStatColumnWithWordCount(
                  context: context,
                  label: 'This Week',
                  value: dueThisWeek,
                  wordCount: wordsDueThisWeek,
                  color: dueThisWeek > 0 ? Colors.orange : Colors.grey,
                  icon: Icons.view_week,
                ),
                _buildDivider(),
                _buildStatColumnWithWordCount(
                  context: context,
                  label: 'This Month',
                  value: dueThisMonth,
                  wordCount: wordsDueThisMonth,
                  color: dueThisMonth > 0 ? colorScheme.primary : Colors.grey,
                  icon: Icons.calendar_month,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Row 2: Completed Sessions with clear title
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green),
                  const SizedBox(width: 8),
                  Text(
                    'COMPLETED LEARNING SESSIONS',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumnWithWordCount(
                  context: context,
                  label: 'Today',
                  value: completedToday,
                  wordCount: wordsCompletedToday,
                  color: Colors.green,
                  icon: Icons.check_circle,
                ),
                _buildDivider(),
                _buildStatColumnWithWordCount(
                  context: context,
                  label: 'This Week',
                  value: completedThisWeek,
                  wordCount: wordsCompletedThisWeek,
                  color: Colors.green,
                  icon: Icons.check_circle_outline,
                ),
                _buildDivider(),
                _buildStatColumnWithWordCount(
                  context: context,
                  label: 'This Month',
                  value: completedThisMonth,
                  wordCount: wordsCompletedThisMonth,
                  color: Colors.green,
                  icon: Icons.verified,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Row 3: Overall Learning Progress with clear title
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.secondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.trending_up, color: colorScheme.secondary),
                  const SizedBox(width: 8),
                  Text(
                    'LEARNING PROGRESS OVERVIEW',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumn(
                  context: context,
                  label: 'Modules\nCompleted',
                  value: completedModules,
                  secondValue: totalModules,
                  color: colorScheme.primary,
                  icon: Icons.auto_stories,
                  format: '$completedModules/$totalModules',
                ),
                _buildDivider(),
                _buildStatColumn(
                  context: context,
                  label: 'Day\nStreak',
                  value: streakDays,
                  color: Colors.deepOrange,
                  icon: Icons.local_fire_department,
                  showBadge: streakDays >= 7,
                ),
                _buildDivider(),
                _buildStatColumn(
                  context: context,
                  label: 'Week\nStreak',
                  value: streakWeeks,
                  color: Colors.purple,
                  icon: Icons.pending_actions,
                  showBadge: streakWeeks >= 4,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Row 4: Vocabulary Statistics with clear title
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.menu_book, color: Colors.amber),
                  const SizedBox(width: 8),
                  Text(
                    'VOCABULARY STATISTICS',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.amber.shade900,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumn(
                  context: context,
                  label: 'Words\nLearned',
                  value: learnedWords,
                  secondValue: totalWords,
                  color: Colors.teal,
                  icon: Icons.spellcheck,
                  format: '$learnedWords/$totalWords',
                  showPercentage: true,
                  percentage: vocabularyCompletionRate,
                ),
                _buildDivider(),
                _buildStatColumn(
                  context: context,
                  label: 'Pending\nWords',
                  value: pendingWords,
                  color: Colors.amber.shade800,
                  icon: Icons.hourglass_bottom,
                ),
                _buildDivider(),
                _buildStatColumn(
                  context: context,
                  label: 'New Words\nWeekly Rate',
                  value: weeklyNewWordsRate.round(),
                  color: Colors.indigo,
                  icon: Icons.insights,
                  suffix: '%',
                ),
              ],
            ),

            // Today's learning progress bar
            if (dueToday > 0) ...[
              const SizedBox(height: 24),
              _buildTodayProgressBar(context),
            ],
          ],
        ),
      ),
    );
  }

  /// Build a vertical divider
  Widget _buildDivider() {
    return SizedBox(
      height: 60,
      child: VerticalDivider(
        color: Colors.grey.withOpacity(0.3),
        thickness: 1,
        width: 1,
      ),
    );
  }

  /// Build a statistic column with icon, value and label
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
  }) {
    final theme = Theme.of(context);
    final formattedValue = format ?? value.toString() + suffix;

    return Expanded(
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
            formattedValue,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          if (showPercentage)
            Text(
              '(${percentage.toStringAsFixed(1)}%)',
              style: theme.textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          Text(
            label,
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Build a statistic column with word count included
  Widget _buildStatColumnWithWordCount({
    required BuildContext context,
    required String label,
    required int value,
    required int wordCount,
    required Color color,
    required IconData icon,
  }) {
    final theme = Theme.of(context);

    return Expanded(
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
    );
  }

  /// Build a progress bar showing today's completion
  Widget _buildTodayProgressBar(BuildContext context) {
    final theme = Theme.of(context);
    final completionRate = dueToday > 0 ? completedToday / dueToday : 0.0;

    return Column(
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
              completionRate >= 1.0 ? Colors.green : theme.colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              dueToday > 0
                  ? 'Completed $completedToday of $dueToday due sessions (${(completionRate * 100).toInt()}%)'
                  : 'No sessions due today',
              style: theme.textTheme.bodySmall,
            ),
            Text(
              '$wordsCompletedToday/$wordsDueToday words',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
