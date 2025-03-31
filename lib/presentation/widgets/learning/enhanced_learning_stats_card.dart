import 'package:flutter/material.dart';

/// Card widget that displays comprehensive learning statistics with enhanced metrics
/// Optimized for accessibility, scrollability, and performance
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
      child: SingleChildScrollView(
        // Wrap with SingleChildScrollView for constrained vertical spaces
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with title and view all button
              Row(
                children: [
                  Semantics(
                    label: 'Learning Dashboard Icon',
                    child: Icon(
                      Icons.school,
                      color: colorScheme.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Learning Dashboard',
                    style: theme.textTheme.titleMedium,
                  ),
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
              ),
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 16),

              // Row 1: Due Sessions with clear title
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
                    value: dueToday,
                    wordCount: wordsDueToday,
                    color: dueToday > 0 ? Colors.red : Colors.grey,
                    icon: Icons.today,
                    semanticLabel:
                        '$dueToday learning sessions due today with $wordsDueToday words',
                  ),
                  _buildDivider(),
                  _buildStatColumnWithWordCount(
                    context: context,
                    label: 'This Week',
                    value: dueThisWeek,
                    wordCount: wordsDueThisWeek,
                    color: dueThisWeek > 0 ? Colors.orange : Colors.grey,
                    icon: Icons.view_week,
                    semanticLabel:
                        '$dueThisWeek learning sessions due this week with $wordsDueThisWeek words',
                  ),
                  _buildDivider(),
                  _buildStatColumnWithWordCount(
                    context: context,
                    label: 'This Month',
                    value: dueThisMonth,
                    wordCount: wordsDueThisMonth,
                    color: dueThisMonth > 0 ? colorScheme.primary : Colors.grey,
                    icon: Icons.calendar_month,
                    semanticLabel:
                        '$dueThisMonth learning sessions due this month with $wordsDueThisMonth words',
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Row 2: Completed Sessions with clear title
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
                    value: completedToday,
                    wordCount: wordsCompletedToday,
                    color: Colors.green,
                    icon: Icons.check_circle,
                    semanticLabel:
                        '$completedToday learning sessions completed today with $wordsCompletedToday words',
                  ),
                  _buildDivider(),
                  _buildStatColumnWithWordCount(
                    context: context,
                    label: 'This Week',
                    value: completedThisWeek,
                    wordCount: wordsCompletedThisWeek,
                    color: Colors.green,
                    icon: Icons.check_circle_outline,
                    semanticLabel:
                        '$completedThisWeek learning sessions completed this week with $wordsCompletedThisWeek words',
                  ),
                  _buildDivider(),
                  _buildStatColumnWithWordCount(
                    context: context,
                    label: 'This Month',
                    value: completedThisMonth,
                    wordCount: wordsCompletedThisMonth,
                    color: Colors.green,
                    icon: Icons.verified,
                    semanticLabel:
                        '$completedThisMonth learning sessions completed this month with $wordsCompletedThisMonth words',
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Row 3: Overall Learning Progress with clear title
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
                    value: completedModules,
                    secondValue: totalModules,
                    color: colorScheme.primary,
                    icon: Icons.auto_stories,
                    format: '$completedModules/$totalModules',
                    semanticLabel:
                        'Completed $completedModules out of $totalModules total modules',
                  ),
                  _buildDivider(),
                  _buildStatColumn(
                    context: context,
                    label: 'Day\nStreak',
                    value: streakDays,
                    color: Colors.deepOrange,
                    icon: Icons.local_fire_department,
                    showBadge: streakDays >= 7,
                    semanticLabel:
                        '$streakDays day streak${streakDays >= 7 ? ", excellent progress!" : ""}',
                  ),
                  _buildDivider(),
                  _buildStatColumn(
                    context: context,
                    label: 'Week\nStreak',
                    value: streakWeeks,
                    color: Colors.purple,
                    icon: Icons.pending_actions,
                    showBadge: streakWeeks >= 4,
                    semanticLabel:
                        '$streakWeeks week streak${streakWeeks >= 4 ? ", outstanding commitment!" : ""}',
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Row 4: Vocabulary Statistics with clear title
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
                    value: learnedWords,
                    secondValue: totalWords,
                    color: Colors.teal,
                    icon: Icons.book_sharp,
                    format: '$learnedWords/$totalWords',
                    showPercentage: true,
                    percentage: vocabularyCompletionRate,
                    semanticLabel:
                        'Learned $learnedWords out of $totalWords words, ${vocabularyCompletionRate.toStringAsFixed(1)} percent complete',
                  ),
                  _buildDivider(),
                  _buildStatColumn(
                    context: context,
                    label: 'Pending\nWords',
                    value: pendingWords,
                    color: Colors.amber.shade800,
                    icon: Icons.hourglass_bottom,
                    semanticLabel: '$pendingWords words pending to learn',
                  ),
                  _buildDivider(),
                  _buildStatColumn(
                    context: context,
                    label: 'New Words\nWeekly Rate',
                    value: weeklyNewWordsRate.round(),
                    color: Colors.indigo,
                    icon: Icons.insights,
                    suffix: '%',
                    semanticLabel:
                        'Learning ${weeklyNewWordsRate.round()} percent new words weekly',
                  ),
                ],
              ),

              // Today's learning progress bar
              if (dueToday > 0) ...[
                const SizedBox(height: 16),
                _buildTodayProgressBar(context),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Build a section header with icon and title
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

  /// Build a vertical divider
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
    required String semanticLabel,
  }) {
    final theme = Theme.of(context);
    final formattedValue = format ?? value.toString() + suffix;

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
            // if (showPercentage)
            //   Text(
            //     '(${percentage.toStringAsFixed(1)}%)',
            //     style: theme.textTheme.bodySmall?.copyWith(
            //       color: color,
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
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

  /// Build a statistic column with word count included
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

  /// Build a progress bar showing today's completion
  Widget _buildTodayProgressBar(BuildContext context) {
    final theme = Theme.of(context);
    final completionRate = dueToday > 0 ? completedToday / dueToday : 0.0;
    final progressPercent = (completionRate * 100).toInt();

    // Create semantic label for the progress bar
    final semanticLabel =
        dueToday > 0
            ? 'Today\'s progress: $completedToday of $dueToday sessions completed, $progressPercent percent. $wordsCompletedToday of $wordsDueToday words completed.'
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
                dueToday > 0
                    ? 'Completed $completedToday of $dueToday due sessions ($progressPercent%)'
                    : 'No sessions due today',
                style: theme.textTheme.bodySmall,
              ),
              // Text(
              //   '$wordsCompletedToday/$wordsDueToday words',
              //   style: theme.textTheme.bodySmall?.copyWith(
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
