import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaced_learning_app/domain/models/learning_stats.dart';
import 'package:spaced_learning_app/presentation/viewmodels/learning_stats_viewmodel.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_progress_indicator.dart';
import 'package:spaced_learning_app/presentation/widgets/common/error_display.dart';

/// Screen that displays a detailed breakdown of a specific learning statistic
class DetailedLearningStatsScreen extends StatelessWidget {
  final String title;
  final StatCategory category;

  const DetailedLearningStatsScreen({
    super.key,
    required this.title,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final learningStatsVM = context.watch<LearningStatsViewModel>();

    if (learningStatsVM.isLoading) {
      return const Center(
        child: AppProgressIndicator(
          type: ProgressType.circular,
          label: 'Loading details...',
        ),
      );
    }

    if (learningStatsVM.errorMessage != null) {
      return Center(
        child: ErrorDisplay(
          message: learningStatsVM.errorMessage!,
          onRetry: () => learningStatsVM.loadDashboardStats(),
        ),
      );
    }

    final stats = learningStatsVM.stats;
    if (stats == null) {
      return const Center(child: Text('No statistics available'));
    }

    // Build the appropriate detail widget based on the category
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: _buildCategoryDetails(context, stats),
    );
  }

  Widget _buildCategoryDetails(BuildContext context, LearningStatsDTO stats) {
    final theme = Theme.of(context);

    switch (category) {
      case StatCategory.modules:
        return _buildModuleDetails(context, stats);
      case StatCategory.dueSessions:
        return _buildDueSessionsDetails(context, stats);
      case StatCategory.streaks:
        return _buildStreakDetails(context, stats);
      case StatCategory.vocabulary:
        return _buildVocabularyDetails(context, stats);
    }
  }

  Widget _buildModuleDetails(BuildContext context, LearningStatsDTO stats) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Module Statistics', style: theme.textTheme.headlineSmall),
        const SizedBox(height: 16),
        _buildProgressBar(
          context,
          'Overall Completion',
          100, // TODO
          stats.totalModules,
          Colors.blue,
        ),
        const SizedBox(height: 24),
        _buildStatCard(
          context,
          'Total Modules',
          stats.totalModules.toString(),
          Icons.auto_stories,
          Colors.indigo,
          'The total number of modules in your learning plan',
        ),
        _buildStatCard(
          context,
          'Completed Modules',
          '100', // TODO
          Icons.check_circle,
          Colors.green,
          'Modules you have fully completed with 100% progress',
        ),
        _buildStatCard(
          context,
          'In Progress Modules',
          '100', // TODO
          Icons.pending_actions,
          Colors.orange,
          'Modules you have started but not yet completed',
        ),
        _buildStatCard(
          context,
          'Completion Rate',
          '100%', //TODO
          Icons.trending_up,
          theme.colorScheme.primary,
          'Your overall progress through all modules',
        ),
      ],
    );
  }

  Widget _buildDueSessionsDetails(
    BuildContext context,
    LearningStatsDTO stats,
  ) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Due Sessions', style: theme.textTheme.headlineSmall),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                'Due Today',
                stats.dueToday.toString(),
                Icons.today,
                Colors.red,
                'Sessions that are due to be completed today',
                showSecondaryInfo: true,
                secondaryInfo: '${stats.wordsDueToday} words',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                context,
                'Completed Today',
                stats.completedToday.toString(),
                Icons.check_circle,
                Colors.green,
                'Sessions you have already completed today',
                showSecondaryInfo: true,
                secondaryInfo: '${stats.wordsCompletedToday} words',
              ),
            ),
          ],
        ),
        const Divider(height: 32),
        Text('Weekly Overview', style: theme.textTheme.titleLarge),
        const SizedBox(height: 16),
        _buildProgressBar(
          context,
          'This Week Completion',
          stats.completedThisWeek,
          stats.dueThisWeek,
          Colors.orange,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                'Due This Week',
                stats.dueThisWeek.toString(),
                Icons.view_week,
                Colors.orange,
                'Sessions that are scheduled for this week',
                showSecondaryInfo: true,
                secondaryInfo: '${stats.wordsDueThisWeek} words',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                context,
                'Completed This Week',
                stats.completedThisWeek.toString(),
                Icons.task_alt,
                Colors.green,
                'Sessions you have completed this week',
                showSecondaryInfo: true,
                secondaryInfo: '${stats.wordsCompletedThisWeek} words',
              ),
            ),
          ],
        ),
        const Divider(height: 32),
        Text('Monthly Overview', style: theme.textTheme.titleLarge),
        const SizedBox(height: 16),
        _buildProgressBar(
          context,
          'This Month Completion',
          stats.completedThisMonth,
          stats.dueThisMonth,
          theme.colorScheme.primary,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                'Due This Month',
                stats.dueThisMonth.toString(),
                Icons.calendar_month,
                theme.colorScheme.primary,
                'Sessions that are scheduled for this month',
                showSecondaryInfo: true,
                secondaryInfo: '${stats.wordsDueThisMonth} words',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                context,
                'Completed This Month',
                stats.completedThisMonth.toString(),
                Icons.verified,
                Colors.green,
                'Sessions you have completed this month',
                showSecondaryInfo: true,
                secondaryInfo: '${stats.wordsCompletedThisMonth} words',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStreakDetails(BuildContext context, LearningStatsDTO stats) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Learning Streaks', style: theme.textTheme.headlineSmall),
        const SizedBox(height: 16),
        _buildStatCard(
          context,
          'Current Day Streak',
          stats.streakDays.toString(),
          Icons.local_fire_department,
          Colors.deepOrange,
          'Number of consecutive days with completed learning sessions',
          expanded: true,
          showSecondaryInfo: true,
          secondaryInfo:
              stats.streakDays >= 7
                  ? 'Excellent! You\'re building a great habit.'
                  : 'Keep going to build your learning habit!',
        ),
        _buildStatCard(
          context,
          'Week Streak',
          stats.streakWeeks.toString(),
          Icons.date_range,
          Colors.purple,
          'Number of consecutive weeks with completed learning sessions',
          expanded: true,
          showSecondaryInfo: true,
          secondaryInfo:
              stats.streakWeeks >= 4
                  ? 'Outstanding commitment to your learning!'
                  : 'Keep going to build weekly consistency.',
        ),
        _buildStatCard(
          context,
          'Longest Streak',
          stats.longestStreakDays.toString(),
          Icons.emoji_events,
          Colors.amber.shade800,
          'Your longest consecutive days streak since you started',
          expanded: true,
          showSecondaryInfo: true,
          secondaryInfo:
              stats.streakDays >= stats.longestStreakDays
                  ? 'You\'re currently at your best streak!'
                  : 'Keep going to beat your record.',
        ),
        const SizedBox(height: 24),
        Text('Streak Benefits', style: theme.textTheme.titleLarge),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Why Streaks Matter',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '• Builds consistent learning habits\n'
                  '• Improves long-term memory retention\n'
                  '• Motivates continued progress\n'
                  '• Increases effectiveness of spaced repetition\n'
                  '• Helps achieve learning goals faster',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVocabularyDetails(BuildContext context, LearningStatsDTO stats) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Vocabulary Progress', style: theme.textTheme.headlineSmall),
        const SizedBox(height: 16),
        _buildProgressBar(
          context,
          'Vocabulary Mastery',
          stats.learnedWords,
          stats.totalWords,
          Colors.teal,
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                'Total Words',
                stats.totalWords.toString(),
                Icons.library_books,
                Colors.teal,
                'Total vocabulary words across all modules',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                context,
                'Learned Words',
                stats.learnedWords.toString(),
                Icons.spellcheck,
                Colors.green,
                'Words you have successfully learned',
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                'Pending Words',
                stats.pendingWords.toString(),
                Icons.hourglass_bottom,
                Colors.amber.shade800,
                'Words you still need to learn',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                context,
                'Weekly Rate',
                '${stats.weeklyNewWordsRate.toStringAsFixed(1)}%',
                Icons.trending_up,
                Colors.blue,
                'Percentage of new words you learn each week',
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vocabulary Learning Tips',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '• Use new vocabulary in sentences\n'
                  '• Associate words with images or situations\n'
                  '• Practice regularly with spaced repetition\n'
                  '• Group related words together\n'
                  '• Review right before sleep for better retention',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar(
    BuildContext context,
    String label,
    int completed,
    int total,
    Color color,
  ) {
    final theme = Theme.of(context);
    final percentage = total > 0 ? completed / total : 0.0;
    final percentageText = (percentage * 100).toStringAsFixed(1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: theme.textTheme.titleMedium),
            Text(
              '$completed/$total ($percentageText%)',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: percentage,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
    String description, {
    bool expanded = false,
    bool showSecondaryInfo = false,
    String secondaryInfo = '',
  }) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(title, style: theme.textTheme.titleMedium),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            if (showSecondaryInfo && secondaryInfo.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                secondaryInfo,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: color.withOpacity(0.8),
                ),
              ),
            ],
            const SizedBox(height: 8),
            Text(
              description,
              style: theme.textTheme.bodyMedium,
              maxLines: expanded ? null : 2,
              overflow: expanded ? null : TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

/// Categories of learning statistics for detail views
enum StatCategory { modules, dueSessions, streaks, vocabulary }
