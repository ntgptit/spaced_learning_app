import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Removed direct AppColors import as colors should come from the theme
// import 'package:spaced_learning_app/core/theme/app_colors.dart';
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
    // Get theme data once here
    final theme = Theme.of(context);

    return Scaffold(
      // Scaffold background color comes from the theme
      appBar: AppBar(
        // AppBar theme is applied automatically
        title: Text(title),
      ),
      // Pass theme data down if needed, or widgets can get it from context
      body: _buildBody(context, theme),
    );
  }

  Widget _buildBody(BuildContext context, ThemeData theme) {
    // Use watch instead of read if you need the widget to rebuild on VM changes
    // For loading/error states, read might be ok if triggered by initial load or retry
    final learningStatsVM = context.watch<LearningStatsViewModel>();

    if (learningStatsVM.isLoading) {
      return Center(
        child: AppProgressIndicator(
          // AppProgressIndicator should ideally use theme internally
          // If not, pass the theme color
          type: ProgressType.circular,
          label: 'Loading details...',
          size: AppDimens.circularProgressSize,
          color: theme.colorScheme.primary, // Use theme color
        ),
      );
    }

    if (learningStatsVM.errorMessage != null) {
      return Center(
        child: ErrorDisplay(
          // ErrorDisplay should ideally use theme internally
          message: learningStatsVM.errorMessage!,
          onRetry:
              () =>
                  learningStatsVM
                      .loadAllStats(), // Assuming loadAllStats is the correct method
        ),
      );
    }

    final stats = learningStatsVM.stats;
    if (stats == null) {
      return Center(
        child: Text(
          'No statistics available',
          // Use theme text style and onSurface color
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(
              0.7,
            ), // Example subtle color
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimens.paddingL),
      // Pass theme to the details builder
      child: _buildCategoryDetails(context, stats, theme),
    );
  }

  Widget _buildCategoryDetails(
    BuildContext context,
    LearningStatsDTO stats,
    ThemeData theme,
  ) {
    // Pass theme down to specific detail builders
    switch (category) {
      case StatCategory.modules:
        return _buildModuleDetails(context, stats, theme);
      case StatCategory.dueSessions:
        return _buildDueSessionsDetails(context, stats, theme);
      case StatCategory.streaks:
        return _buildStreakDetails(context, stats, theme);
      case StatCategory.vocabulary:
        return _buildVocabularyDetails(context, stats, theme);
    }
  }

  // --- Detail Section Builders ---

  Widget _buildModuleDetails(
    BuildContext context,
    LearningStatsDTO stats,
    ThemeData theme,
  ) {
    // Use theme passed as argument

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

    // Define semantic colors based on theme (example mapping)
    final Color successColor =
        theme.brightness == Brightness.light
            ? const Color(0xFF4CAF50)
            : const Color(
              0xFF81C784,
            ); // Example: Map to AppColors.successLight/Dark
    final Color warningColor =
        theme.brightness == Brightness.light
            ? const Color(0xFFFFC107)
            : const Color(
              0xFFFFD54F,
            ); // Example: Map to AppColors.warningLight/Dark
    final Color errorColor = theme.colorScheme.error;
    final Color infoColor =
        theme.brightness == Brightness.light
            ? const Color(0xFF2196F3)
            : const Color(
              0xFF64B5F6,
            ); // Example: Map to AppColors.infoLight/Dark
    final Color neutralColor = theme.colorScheme.onSurface.withOpacity(0.6);
    final Color primaryAccentColor =
        theme.colorScheme.primary; // Use theme's primary color

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Module Statistics', style: theme.textTheme.headlineSmall),
        const SizedBox(height: AppDimens.spaceL),
        _buildStatCard(
          context,
          theme, // Pass theme
          'Total Modules',
          stats.totalModules.toString(),
          Icons.library_books,
          primaryAccentColor, // Use theme primary or a defined accent
          'The total number of modules in your learning plan.',
        ),
        _buildStatCard(
          context,
          theme, // Pass theme
          'Not Studied',
          notStudiedCount.toString(),
          Icons.book_outlined,
          neutralColor, // Use neutral color from theme
          'The number of modules you haven\'t started learning yet.',
        ),
        _buildStatCard(
          context,
          theme, // Pass theme
          'Completed / 1st Review',
          firstTimeCount.toString(),
          Icons.check_circle_outline,
          successColor, // Use success color defined above
          'Modules completed for the first time or currently in the first review cycle.',
        ),
        _buildStatCard(
          context,
          theme, // Pass theme
          '2nd Review Cycle',
          secondReviewCount.toString(),
          Icons.history_toggle_off,
          warningColor, // Use warning color defined above
          'The number of modules currently in the second review cycle.',
        ),
        _buildStatCard(
          context,
          theme, // Pass theme
          '3rd Review Cycle',
          thirdReviewCount.toString(),
          Icons.replay_circle_filled,
          infoColor, // Use info color defined above
          'The number of modules currently in the third review cycle.',
        ),
        _buildStatCard(
          context,
          theme, // Pass theme
          'Frequent Review (>3)',
          moreThanThreeReviewsCount.toString(),
          Icons.warning_amber_rounded,
          errorColor, // Use error color defined above
          'Modules that have been reviewed more than three times, potentially requiring more attention.',
        ),
        _buildStatCard(
          context,
          theme, // Pass theme
          'Completion Rate',
          completionRate,
          Icons.trending_up,
          theme.colorScheme.primary, // Use theme primary color
          'The percentage of modules you have completed (based on first-time completion).',
        ),
      ],
    );
  }

  Widget _buildDueSessionsDetails(
    BuildContext context,
    LearningStatsDTO stats,
    ThemeData theme,
  ) {
    // Use theme passed as argument
    // Define semantic colors based on theme (example mapping)
    final Color successColor =
        theme.brightness == Brightness.light
            ? const Color(0xFF4CAF50)
            : const Color(0xFF81C784);
    final Color warningColor =
        theme.brightness == Brightness.light
            ? const Color(0xFFFFC107)
            : const Color(0xFFFFD54F);
    final Color errorColor = theme.colorScheme.error;
    final Color primaryColor = theme.colorScheme.primary;

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
                theme, // Pass theme
                'Due Today',
                stats.dueToday.toString(),
                Icons.today,
                errorColor, // Use semantic error color
                'Sessions that are due to be completed today',
                showSecondaryInfo: true,
                secondaryInfo: '${stats.wordsDueToday} words',
              ),
            ),
            const SizedBox(width: AppDimens.spaceL),
            Expanded(
              child: _buildStatCard(
                context,
                theme, // Pass theme
                'Completed Today',
                stats.completedToday.toString(),
                Icons.check_circle,
                successColor, // Use semantic success color
                'Sessions you have already completed today',
                showSecondaryInfo: true,
                secondaryInfo: '${stats.wordsCompletedToday} words',
              ),
            ),
          ],
        ),
        const Divider(height: AppDimens.spaceXXL), // Uses theme divider
        Text('Weekly Overview', style: theme.textTheme.titleLarge),
        const SizedBox(height: AppDimens.spaceL),
        _buildProgressBar(
          context,
          theme, // Pass theme
          'This Week Completion',
          stats.completedThisWeek,
          stats.dueThisWeek,
          warningColor, // Use semantic warning color for weekly progress
        ),
        const SizedBox(height: AppDimens.spaceL),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                theme, // Pass theme
                'Due This Week',
                stats.dueThisWeek.toString(),
                Icons.view_week,
                warningColor, // Use semantic warning color
                'Sessions that are scheduled for this week',
                showSecondaryInfo: true,
                secondaryInfo: '${stats.wordsDueThisWeek} words',
              ),
            ),
            const SizedBox(width: AppDimens.spaceL),
            Expanded(
              child: _buildStatCard(
                context,
                theme, // Pass theme
                'Completed This Week',
                stats.completedThisWeek.toString(),
                Icons.task_alt,
                successColor, // Use semantic success color
                'Sessions you have completed this week',
                showSecondaryInfo: true,
                secondaryInfo: '${stats.wordsCompletedThisWeek} words',
              ),
            ),
          ],
        ),
        const Divider(height: AppDimens.spaceXXL), // Uses theme divider
        Text('Monthly Overview', style: theme.textTheme.titleLarge),
        const SizedBox(height: AppDimens.spaceL),
        _buildProgressBar(
          context,
          theme, // Pass theme
          'This Month Completion',
          stats.completedThisMonth,
          stats.dueThisMonth,
          primaryColor, // Use theme primary for monthly progress
        ),
        const SizedBox(height: AppDimens.spaceL),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                theme, // Pass theme
                'Due This Month',
                stats.dueThisMonth.toString(),
                Icons.calendar_month,
                primaryColor, // Use theme primary color
                'Sessions that are scheduled for this month',
                showSecondaryInfo: true,
                secondaryInfo: '${stats.wordsDueThisMonth} words',
              ),
            ),
            const SizedBox(width: AppDimens.spaceL),
            Expanded(
              child: _buildStatCard(
                context,
                theme, // Pass theme
                'Completed This Month',
                stats.completedThisMonth.toString(),
                Icons.verified,
                successColor, // Use semantic success color
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

  Widget _buildStreakDetails(
    BuildContext context,
    LearningStatsDTO stats,
    ThemeData theme,
  ) {
    // Use theme passed as argument
    // Define semantic colors based on theme (example mapping)
    final Color warningColor =
        theme.brightness == Brightness.light
            ? const Color(0xFFFFC107)
            : const Color(0xFFFFD54F);
    final Color neutralColor = theme.colorScheme.onSurface.withOpacity(0.6);
    final Color achievementColor =
        theme.brightness == Brightness.light
            ? const Color(0xFFFFC107)
            : const Color(0xFFFFD54F); // Often warning/gold
    final Color primaryColor = theme.colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Learning Streaks', style: theme.textTheme.headlineSmall),
        const SizedBox(height: AppDimens.spaceL),
        _buildStatCard(
          context,
          theme, // Pass theme
          'Current Day Streak',
          stats.streakDays.toString(),
          Icons.local_fire_department,
          warningColor, // Fire often uses orange/warning
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
          theme, // Pass theme
          'Week Streak',
          stats.streakWeeks.toString(),
          Icons.date_range,
          neutralColor, // Use neutral for week streak unless specific emphasis desired
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
          theme, // Pass theme
          'Longest Streak',
          stats.longestStreakDays
              .toString(), // Assuming DTO has longestStreakDays
          Icons.emoji_events,
          achievementColor, // Gold/warning for achievement
          'Your longest consecutive days streak since you started',
          expanded: true,
          showSecondaryInfo: true,
          secondaryInfo:
              (stats.streakDays >= stats.longestStreakDays &&
                      stats.longestStreakDays >
                          0) // Check if longest streak > 0
                  ? 'You\'re currently at your best streak!'
                  : 'Keep going to beat your record.',
        ),
        const SizedBox(height: AppDimens.spaceXL),
        Text('Streak Benefits', style: theme.textTheme.titleLarge),
        const SizedBox(height: AppDimens.spaceL),
        Card(
          // Card theme applied automatically
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.paddingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Why Streaks Matter',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: primaryColor, // Use theme primary
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
                    // Use theme's onSurface color, perhaps slightly less prominent
                    color: theme.colorScheme.onSurface.withOpacity(0.85),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVocabularyDetails(
    BuildContext context,
    LearningStatsDTO stats,
    ThemeData theme,
  ) {
    // Use theme passed as argument
    // Define semantic colors based on theme (example mapping)
    final Color successColor =
        theme.brightness == Brightness.light
            ? const Color(0xFF4CAF50)
            : const Color(0xFF81C784);
    final Color warningColor =
        theme.brightness == Brightness.light
            ? const Color(0xFFFFC107)
            : const Color(0xFFFFD54F);
    final Color infoColor =
        theme.brightness == Brightness.light
            ? const Color(0xFF2196F3)
            : const Color(0xFF64B5F6);
    final Color primaryColor = theme.colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Vocabulary Progress', style: theme.textTheme.headlineSmall),
        const SizedBox(height: AppDimens.spaceL),
        _buildProgressBar(
          context,
          theme, // Pass theme
          'Vocabulary Mastery',
          stats.learnedWords,
          stats.totalWords,
          successColor, // Use success color for mastery progress
        ),
        const SizedBox(height: AppDimens.spaceXL),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                theme, // Pass theme
                'Total Words',
                stats.totalWords.toString(),
                Icons.library_books,
                successColor, // Or primary color? Depends on emphasis
                'Total vocabulary words across all modules',
              ),
            ),
            const SizedBox(width: AppDimens.spaceL),
            Expanded(
              child: _buildStatCard(
                context,
                theme, // Pass theme
                'Learned Words',
                stats.learnedWords.toString(),
                Icons.spellcheck,
                successColor, // Use success color
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
                theme, // Pass theme
                'Pending Words',
                stats.pendingWords.toString(),
                Icons.hourglass_bottom,
                warningColor, // Use warning color for pending
                'Words you still need to learn',
              ),
            ),
            const SizedBox(width: AppDimens.spaceL),
            Expanded(
              child: _buildStatCard(
                context,
                theme, // Pass theme
                'Weekly Rate',
                '${stats.weeklyNewWordsRate.toStringAsFixed(1)}%', // Assuming DTO has this
                Icons.trending_up,
                infoColor, // Use info color for rate
                'Percentage of new words you learn each week',
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.spaceXL),
        Card(
          // Card theme applied automatically
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.paddingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vocabulary Learning Tips',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: primaryColor, // Use theme primary
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
                    // Use theme's onSurface color, perhaps slightly less prominent
                    color: theme.colorScheme.onSurface.withOpacity(0.85),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --- Helper Widgets ---

  Widget _buildProgressBar(
    BuildContext context,
    ThemeData theme, // Receive theme
    String label,
    int completed,
    int total,
    Color color, // Color remains specific for emphasis
  ) {
    // Use theme passed as argument
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
                color:
                    color, // Keep specific color for the percentage text itself
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.spaceS),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppDimens.radiusM),
          child: LinearProgressIndicator(
            value: percentage,
            // Use theme's track color
            backgroundColor:
                theme.progressIndicatorTheme.linearTrackColor ??
                theme.colorScheme.surfaceContainerHighest,
            // Keep specific value color
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: AppDimens.lineProgressHeightL,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    ThemeData theme, // Receive theme
    String title,
    String value,
    IconData icon,
    Color color, // Color remains specific for emphasis (icon, value)
    String description, {
    bool expanded = false,
    bool showSecondaryInfo = false,
    String secondaryInfo = '',
  }) {
    // Use theme passed as argument

    return Card(
      // Card theme applied automatically
      margin: const EdgeInsets.only(bottom: AppDimens.spaceL), // Keep margin
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: color,
                  size: AppDimens.iconL,
                ), // Use specific color for icon
                const SizedBox(width: AppDimens.spaceS),
                Expanded(
                  // Use theme text style for title
                  child: Text(title, style: theme.textTheme.titleMedium),
                ),
              ],
            ),
            const SizedBox(height: AppDimens.spaceS),
            Text(
              value,
              // Use theme text style, but override color for emphasis
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color, // Use specific color for value
              ),
            ),
            if (showSecondaryInfo && secondaryInfo.isNotEmpty) ...[
              const SizedBox(height: AppDimens.spaceXS),
              Text(
                secondaryInfo,
                // Use theme text style, but adjust color based on the main emphasis color
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                  // Make secondary info slightly less prominent than main value color
                  color: color.withOpacity(0.85),
                ),
              ),
            ],
            const SizedBox(height: AppDimens.spaceS),
            Text(
              description,
              // Use theme text style and color for description
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(
                  0.7,
                ), // Example subtle color
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

// Helper extension (optional, if you prefer .withValues over .withOpacity)
// extension ColorAlpha on Color {
//   Color withValues({double? alpha}) {
//     if (alpha != null) {
//       return withOpacity(alpha ?? 1.0);
//     }
//     return this;
//   }
// }
