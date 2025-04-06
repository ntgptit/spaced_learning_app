import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaced_learning_app/core/theme/app_colors.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
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
    final learningStatsVM = context.read<LearningStatsViewModel>();

    if (learningStatsVM.isLoading) {
      return const Center(
        child: AppProgressIndicator(
          type: ProgressType.circular,
          label: 'Loading details...',
          size: AppDimens.circularProgressSize,
          color: AppColors.lightPrimary,
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
      return Center(
        child: Text(
          'No statistics available',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: AppColors.textPrimaryLight),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimens.paddingL),
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

    final notStudiedCount = stats.cycleStats['NOT_STUDIED'] ?? 0;
    final firstTimeCount = stats.cycleStats['FIRST_TIME'] ?? 0;
    final secondReviewCount = stats.cycleStats['SECOND_REVIEW'] ?? 0;
    final thirdReviewCount = stats.cycleStats['THIRD_REVIEW'] ?? 0;
    final moreThanThreeReviewsCount =
        stats.cycleStats['MORE_THAN_THREE_REVIEWS'] ?? 0;

    final completionRate =
        (stats.totalModules > 0)
            ? '${((firstTimeCount / stats.totalModules) * 100).toStringAsFixed(1)}%'
            : 'N/A';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Module Statistics', style: theme.textTheme.headlineSmall),
        const SizedBox(height: AppDimens.spaceL),
        _buildStatCard(
          context,
          'Total Modules',
          stats.totalModules.toString(),
          Icons.library_books,
          AppColors.accentPurple,
          'The total number of modules in your learning plan.',
        ),
        _buildStatCard(
          context,
          'Not Studied',
          notStudiedCount.toString(),
          Icons.book_outlined,
          AppColors.neutralMedium,
          'The number of modules you haven\'t started learning yet.',
        ),
        _buildStatCard(
          context,
          'Completed / 1st Review',
          firstTimeCount.toString(),
          Icons.check_circle_outline,
          AppColors.successLight,
          'Modules completed for the first time or currently in the first review cycle.',
        ),
        _buildStatCard(
          context,
          '2nd Review Cycle',
          secondReviewCount.toString(),
          Icons.history_toggle_off,
          AppColors.accentOrange,
          'The number of modules currently in the second review cycle.',
        ),
        _buildStatCard(
          context,
          '3rd Review Cycle',
          thirdReviewCount.toString(),
          Icons.replay_circle_filled,
          AppColors.infoLight,
          'The number of modules currently in the third review cycle.',
        ),
        _buildStatCard(
          context,
          'Frequent Review (>3)',
          moreThanThreeReviewsCount.toString(),
          Icons.warning_amber_rounded,
          AppColors.accentRed,
          'Modules that have been reviewed more than three times, potentially requiring more attention.',
        ),
        _buildStatCard(
          context,
          'Completion Rate',
          completionRate,
          Icons.trending_up,
          theme.colorScheme.primary,
          'The percentage of modules you have completed (based on first-time completion).',
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
        const SizedBox(height: AppDimens.spaceL),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                'Due Today',
                stats.dueToday.toString(),
                Icons.today,
                AppColors.accentRed,
                'Sessions that are due to be completed today',
                showSecondaryInfo: true,
                secondaryInfo: '${stats.wordsDueToday} words',
              ),
            ),
            const SizedBox(width: AppDimens.spaceL),
            Expanded(
              child: _buildStatCard(
                context,
                'Completed Today',
                stats.completedToday.toString(),
                Icons.check_circle,
                AppColors.successLight,
                'Sessions you have already completed today',
                showSecondaryInfo: true,
                secondaryInfo: '${stats.wordsCompletedToday} words',
              ),
            ),
          ],
        ),
        const Divider(height: AppDimens.spaceXXL),
        Text('Weekly Overview', style: theme.textTheme.titleLarge),
        const SizedBox(height: AppDimens.spaceL),
        _buildProgressBar(
          context,
          'This Week Completion',
          stats.completedThisWeek,
          stats.dueThisWeek,
          AppColors.accentOrange,
        ),
        const SizedBox(height: AppDimens.spaceL),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                'Due This Week',
                stats.dueThisWeek.toString(),
                Icons.view_week,
                AppColors.accentOrange,
                'Sessions that are scheduled for this week',
                showSecondaryInfo: true,
                secondaryInfo: '${stats.wordsDueThisWeek} words',
              ),
            ),
            const SizedBox(width: AppDimens.spaceL),
            Expanded(
              child: _buildStatCard(
                context,
                'Completed This Week',
                stats.completedThisWeek.toString(),
                Icons.task_alt,
                AppColors.successLight,
                'Sessions you have completed this week',
                showSecondaryInfo: true,
                secondaryInfo: '${stats.wordsCompletedThisWeek} words',
              ),
            ),
          ],
        ),
        const Divider(height: AppDimens.spaceXXL),
        Text('Monthly Overview', style: theme.textTheme.titleLarge),
        const SizedBox(height: AppDimens.spaceL),
        _buildProgressBar(
          context,
          'This Month Completion',
          stats.completedThisMonth,
          stats.dueThisMonth,
          theme.colorScheme.primary,
        ),
        const SizedBox(height: AppDimens.spaceL),
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
            const SizedBox(width: AppDimens.spaceL),
            Expanded(
              child: _buildStatCard(
                context,
                'Completed This Month',
                stats.completedThisMonth.toString(),
                Icons.verified,
                AppColors.successLight,
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
        const SizedBox(height: AppDimens.spaceL),
        _buildStatCard(
          context,
          'Current Day Streak',
          stats.streakDays.toString(),
          Icons.local_fire_department,
          AppColors.accentOrange,
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
          AppColors.accentPurple,
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
          AppColors.warningLight,
          'Your longest consecutive days streak since you started',
          expanded: true,
          showSecondaryInfo: true,
          secondaryInfo:
              stats.streakDays >= stats.longestStreakDays
                  ? 'You\'re currently at your best streak!'
                  : 'Keep going to beat your record.',
        ),
        const SizedBox(height: AppDimens.spaceXL),
        Text('Streak Benefits', style: theme.textTheme.titleLarge),
        const SizedBox(height: AppDimens.spaceL),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.paddingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Why Streaks Matter',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: AppDimens.spaceS),
                Text(
                  '• Builds consistent learning habits\n'
                  '• Improves long-term memory retention\n'
                  '• Motivates continued progress\n'
                  '• Increases effectiveness of spaced repetition\n'
                  '• Helps achieve learning goals faster',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimaryLight,
                  ),
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
        const SizedBox(height: AppDimens.spaceL),
        _buildProgressBar(
          context,
          'Vocabulary Mastery',
          stats.learnedWords,
          stats.totalWords,
          AppColors.accentGreen,
        ),
        const SizedBox(height: AppDimens.spaceXL),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                'Total Words',
                stats.totalWords.toString(),
                Icons.library_books,
                AppColors.accentGreen,
                'Total vocabulary words across all modules',
              ),
            ),
            const SizedBox(width: AppDimens.spaceL),
            Expanded(
              child: _buildStatCard(
                context,
                'Learned Words',
                stats.learnedWords.toString(),
                Icons.spellcheck,
                AppColors.successLight,
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
                AppColors.warningLight,
                'Words you still need to learn',
              ),
            ),
            const SizedBox(width: AppDimens.spaceL),
            Expanded(
              child: _buildStatCard(
                context,
                'Weekly Rate',
                '${stats.weeklyNewWordsRate.toStringAsFixed(1)}%',
                Icons.trending_up,
                AppColors.infoLight,
                'Percentage of new words you learn each week',
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.spaceXL),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.paddingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vocabulary Learning Tips',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: AppDimens.spaceS),
                Text(
                  '• Use new vocabulary in sentences\n'
                  '• Associate words with images or situations\n'
                  '• Practice regularly with spaced repetition\n'
                  '• Group related words together\n'
                  '• Review right before sleep for better retention',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimaryLight,
                  ),
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
        const SizedBox(height: AppDimens.spaceS),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppDimens.radiusM),
          child: LinearProgressIndicator(
            value: percentage,
            backgroundColor: AppColors.neutralLight,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: AppDimens.lineProgressHeightL,
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
      margin: const EdgeInsets.only(bottom: AppDimens.spaceL),
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: AppDimens.iconL),
                const SizedBox(width: AppDimens.spaceS),
                Expanded(
                  child: Text(title, style: theme.textTheme.titleMedium),
                ),
              ],
            ),
            const SizedBox(height: AppDimens.spaceS),
            Text(
              value,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            if (showSecondaryInfo && secondaryInfo.isNotEmpty) ...[
              const SizedBox(height: AppDimens.spaceXS),
              Text(
                secondaryInfo,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: color.withOpacity(AppDimens.opacityVeryHigh),
                ),
              ),
            ],
            const SizedBox(height: AppDimens.spaceS),
            Text(
              description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimaryLight,
              ),
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
