import 'package:flutter/material.dart';
import 'package:spaced_learning_app/domain/models/learning_stats.dart';

/// A card widget that displays comprehensive learning statistics
class LearningStatsCard extends StatelessWidget {
  final LearningStatsDTO stats;
  final VoidCallback? onViewDetailPressed;

  const LearningStatsCard({
    super.key,
    required this.stats,
    this.onViewDetailPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme),
            const SizedBox(height: 16),
            _buildModuleSection(theme),
            const Divider(height: 32),
            _buildDueSection(theme),
            const Divider(height: 32),
            _buildStreakSection(theme),
            const Divider(height: 32),
            _buildVocabularySection(theme),
            if (onViewDetailPressed != null) ...[
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  icon: const Icon(Icons.analytics_outlined),
                  label: const Text('View Details'),
                  onPressed: onViewDetailPressed,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      children: [
        Icon(Icons.school, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Text('Learning Statistics', style: theme.textTheme.titleLarge),
      ],
    );
  }

  Widget _buildModuleSection(ThemeData theme) {
    final completionRate = stats.moduleCompletionRate.toStringAsFixed(1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.book, size: 20, color: theme.colorScheme.secondary),
            const SizedBox(width: 8),
            Text(
              'Module Progress',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.secondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildStatItem(
              theme,
              'Total\nModules',
              stats.totalModules.toString(),
              Icons.auto_stories,
            ),
            _buildStatItem(
              theme,
              'Completed',
              stats.completedModules.toString(),
              Icons.check_circle_outline,
              color: Colors.green,
            ),
            _buildStatItem(
              theme,
              'In Progress',
              stats.inProgressModules.toString(),
              Icons.pending_actions,
              color: Colors.orange,
            ),
            _buildStatItem(
              theme,
              'Completion\nRate',
              '$completionRate%',
              Icons.trending_up,
              color: theme.colorScheme.primary,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDueSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.calendar_today,
              size: 20,
              color: theme.colorScheme.error,
            ),
            const SizedBox(width: 8),
            Text(
              'Due Sessions',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildStatItem(
              theme,
              'Due\nToday',
              stats.dueToday.toString(),
              Icons.today,
              color: theme.colorScheme.error,
              additionalInfo: '${stats.wordsDueToday} words',
            ),
            _buildStatItem(
              theme,
              'Due\nThis Week',
              stats.dueThisWeek.toString(),
              Icons.view_week,
              color: Colors.orange,
              additionalInfo: '${stats.wordsDueThisWeek} words',
            ),
            _buildStatItem(
              theme,
              'Due\nThis Month',
              stats.dueThisMonth.toString(),
              Icons.calendar_month,
              color: theme.colorScheme.primary,
              additionalInfo: '${stats.wordsDueThisMonth} words',
            ),
            _buildStatItem(
              theme,
              'Completed\nToday',
              stats.completedToday.toString(),
              Icons.check_circle,
              color: Colors.green,
              additionalInfo: '${stats.wordsCompletedToday} words',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStreakSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.local_fire_department,
              size: 20,
              color: Colors.deepOrange,
            ),
            const SizedBox(width: 8),
            Text(
              'Streaks',
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.deepOrange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(
              theme,
              'Day\nStreak',
              stats.streakDays.toString(),
              Icons.local_fire_department,
              color: Colors.deepOrange,
              showStar: stats.streakDays >= 7,
            ),
            _buildStatItem(
              theme,
              'Week\nStreak',
              stats.streakWeeks.toString(),
              Icons.date_range,
              color: Colors.deepPurple,
              showStar: stats.streakWeeks >= 4,
            ),
            _buildStatItem(
              theme,
              'Longest\nStreak',
              stats.longestStreakDays.toString(),
              Icons.emoji_events,
              color: Colors.amber,
              additionalInfo: 'days',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVocabularySection(ThemeData theme) {
    final completionRate = stats.vocabularyCompletionRate.toStringAsFixed(1);
    final weeklyRate = stats.weeklyNewWordsRate.toStringAsFixed(1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.menu_book, size: 20, color: Colors.teal),
            const SizedBox(width: 8),
            Text(
              'Vocabulary',
              style: theme.textTheme.titleMedium?.copyWith(color: Colors.teal),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildStatItem(
              theme,
              'Total\nWords',
              stats.totalWords.toString(),
              Icons.library_books,
              color: Colors.teal,
            ),
            _buildStatItem(
              theme,
              'Learned\nWords',
              stats.learnedWords.toString(),
              Icons.spellcheck,
              color: Colors.green,
              additionalInfo: '$completionRate%',
            ),
            _buildStatItem(
              theme,
              'Pending\nWords',
              stats.pendingWords.toString(),
              Icons.hourglass_bottom,
              color: Colors.amber.shade800,
            ),
            _buildStatItem(
              theme,
              'Weekly\nRate',
              '$weeklyRate%',
              Icons.trending_up,
              color: Colors.blue,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatItem(
    ThemeData theme,
    String label,
    String value,
    IconData iconData, {
    Color? color,
    String? additionalInfo,
    bool showStar = false,
  }) {
    final effectiveColor = color ?? theme.colorScheme.primary;

    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(iconData, color: effectiveColor, size: 24),
            if (showStar)
              Positioned(
                top: -5,
                right: -5,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.amber,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.star, color: Colors.white, size: 10),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: effectiveColor,
          ),
        ),
        if (additionalInfo != null)
          Text(
            additionalInfo,
            style: theme.textTheme.bodySmall?.copyWith(
              color: effectiveColor.withOpacity(0.7),
              fontSize: 10,
            ),
          ),
        Text(
          label,
          style: theme.textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
