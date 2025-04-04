import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/learning_stats.dart';

/// An enhanced card widget that displays comprehensive learning statistics using grid layouts
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
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < AppDimens.breakpointXS;

    return Card(
      elevation: AppDimens.elevationS,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusL),
      ),
      child: Padding(
        padding: EdgeInsets.all(
          isSmallScreen ? AppDimens.paddingM : AppDimens.paddingL,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme),
            SizedBox(
              height: isSmallScreen ? AppDimens.spaceM : AppDimens.spaceL,
            ),
            _buildModuleSection(theme, isSmallScreen),
            const Divider(height: AppDimens.spaceXXL),
            _buildDueSection(theme, isSmallScreen),
            const Divider(height: AppDimens.spaceXXL),
            _buildStreakSection(theme, isSmallScreen),
            const Divider(height: AppDimens.spaceXXL),
            _buildVocabularySection(theme, isSmallScreen),
            if (onViewDetailPressed != null) ...[
              const SizedBox(height: AppDimens.spaceL),
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
        Icon(Icons.book_online, color: theme.colorScheme.primary),
        const SizedBox(width: AppDimens.spaceS),
        Text('Learning Statistics', style: theme.textTheme.titleLarge),
      ],
    );
  }

  /// Xây dựng phần Module Progress
  Widget _buildModuleSection(ThemeData theme, bool isSmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.auto_stories,
              size: AppDimens.iconM,
              color: theme.colorScheme.secondary,
            ),
            const SizedBox(width: AppDimens.spaceS),
            Text(
              'Module Progress',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.secondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.spaceM),
        _buildModuleStatsGrid(theme, isSmallScreen),
      ],
    );
  }

  /// Xây dựng grid cho phần Module Progress
  Widget _buildModuleStatsGrid(ThemeData theme, bool isSmallScreen) {
    final cycleStats = stats.cycleStats;
    final notStudied = cycleStats['NOT_STUDIED'] ?? 0;
    final firstTime = cycleStats['FIRST_TIME'] ?? 0;
    final firstReview = cycleStats['FIRST_REVIEW'] ?? 0;
    final secondReview = cycleStats['SECOND_REVIEW'] ?? 0;
    final thirdReview = cycleStats['THIRD_REVIEW'] ?? 0;
    final moreThanThree = cycleStats['MORE_THAN_THREE_REVIEWS'] ?? 0;

    // Danh sách các mục module để tái sử dụng cho cả 2 kích thước màn hình
    final moduleItems = [
      _buildGridItem(
        theme,
        stats.totalModules.toString(),
        'Total\nModules',
        Icons.menu_book,
        Colors.blue,
      ),
      _buildGridItem(
        theme,
        notStudied.toString(),
        'Not\nStudied',
        Icons.visibility_off,
        Colors.grey,
      ),
      _buildGridItem(
        theme,
        firstTime.toString(),
        '1st\nTime',
        Icons.play_circle_fill,
        Colors.green,
      ),
      _buildGridItem(
        theme,
        firstReview.toString(),
        '1st\nReview',
        Icons.rotate_right,
        Colors.orange,
      ),
      _buildGridItem(
        theme,
        secondReview.toString(),
        '2nd\nReview',
        Icons.rotate_90_degrees_ccw,
        Colors.purple,
      ),
      _buildGridItem(
        theme,
        thirdReview.toString(),
        '3rd\nReview',
        Icons.change_circle,
        Colors.teal,
      ),
      // Tiếp tục lib/presentation/widgets/learning/learning_stats_card.dart
      _buildGridItem(
        theme,
        thirdReview.toString(),
        '3rd\nReview',
        Icons.change_circle,
        Colors.teal,
      ),
      _buildGridItem(
        theme,
        moreThanThree.toString(),
        '4th+\nReviews',
        Icons.loop,
        Colors.indigo,
      ),
    ];

    // Thêm ô trống cho màn hình lớn để cân bằng
    if (!isSmallScreen) {
      moduleItems.add(const SizedBox());
    }

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: isSmallScreen ? 3 : 4,
      childAspectRatio: isSmallScreen ? 0.85 : 1.0,
      mainAxisSpacing: AppDimens.spaceS,
      crossAxisSpacing: isSmallScreen ? AppDimens.spaceXS : AppDimens.spaceS,
      children: moduleItems,
    );
  }

  /// Xây dựng phần Due Sessions
  Widget _buildDueSection(ThemeData theme, bool isSmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.calendar_today,
              size: AppDimens.iconM,
              color: theme.colorScheme.error,
            ),
            const SizedBox(width: AppDimens.spaceS),
            Text(
              'Due Sessions',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.spaceM),
        _buildDueStatsGrid(theme, isSmallScreen),
      ],
    );
  }

  /// Xây dựng grid cho phần Due Sessions
  Widget _buildDueStatsGrid(ThemeData theme, bool isSmallScreen) {
    // Danh sách các mục due cho cả hai kích thước màn hình
    final dueItems = [
      _buildGridItem(
        theme,
        stats.dueToday.toString(),
        'Due\nToday',
        Icons.today,
        theme.colorScheme.error,
        additionalInfo: '${stats.wordsDueToday} words',
      ),
      _buildGridItem(
        theme,
        stats.dueThisWeek.toString(),
        'Due\nThis Week',
        Icons.view_week,
        Colors.orange,
        additionalInfo: '${stats.wordsDueThisWeek} words',
      ),
      _buildGridItem(
        theme,
        stats.dueThisMonth.toString(),
        'Due\nThis Month',
        Icons.calendar_month,
        theme.colorScheme.primary,
        additionalInfo: '${stats.wordsDueThisMonth} words',
      ),
      _buildGridItem(
        theme,
        stats.completedToday.toString(),
        'Completed\nToday',
        Icons.check_circle,
        Colors.green,
        additionalInfo: '${stats.wordsCompletedToday} words',
      ),
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: isSmallScreen ? 2 : 4,
      childAspectRatio: 1.0,
      mainAxisSpacing: AppDimens.spaceS,
      crossAxisSpacing: AppDimens.spaceS,
      children: dueItems,
    );
  }

  /// Xây dựng phần Streaks
  Widget _buildStreakSection(ThemeData theme, bool isSmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.local_fire_department,
              size: AppDimens.iconM,
              color: Colors.deepOrange,
            ),
            const SizedBox(width: AppDimens.spaceS),
            Text(
              'Streaks',
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.deepOrange,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.spaceM),
        _buildStreakStatsGrid(theme, isSmallScreen),
      ],
    );
  }

  /// Xây dựng grid cho phần Streaks
  Widget _buildStreakStatsGrid(ThemeData theme, bool isSmallScreen) {
    // Danh sách các mục streak
    final streakItems = [
      _buildGridItem(
        theme,
        stats.streakDays.toString(),
        'Day\nStreak',
        Icons.local_fire_department,
        Colors.deepOrange,
        showStar: stats.streakDays >= 7,
      ),
      _buildGridItem(
        theme,
        stats.streakWeeks.toString(),
        'Week\nStreak',
        Icons.date_range,
        Colors.deepPurple,
        showStar: stats.streakWeeks >= 4,
      ),
      _buildGridItem(
        theme,
        stats.longestStreakDays.toString(),
        'Longest\nStreak',
        Icons.emoji_events,
        Colors.amber,
        additionalInfo: 'days',
      ),
    ];

    // Thêm ô trống cho màn hình lớn để cân bằng
    if (!isSmallScreen) {
      streakItems.add(const SizedBox());
    }

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: isSmallScreen ? 3 : 4,
      childAspectRatio: 1.0,
      mainAxisSpacing: AppDimens.spaceS,
      crossAxisSpacing: AppDimens.spaceS,
      children: streakItems,
    );
  }

  /// Xây dựng phần Vocabulary
  Widget _buildVocabularySection(ThemeData theme, bool isSmallScreen) {
    final completionRate = stats.vocabularyCompletionRate.toStringAsFixed(1);
    final weeklyRate = stats.weeklyNewWordsRate.toStringAsFixed(1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.menu_book,
              size: AppDimens.iconM,
              color: Colors.teal,
            ),
            const SizedBox(width: AppDimens.spaceS),
            Text(
              'Vocabulary',
              style: theme.textTheme.titleMedium?.copyWith(color: Colors.teal),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.spaceM),
        _buildVocabStatsGrid(theme, isSmallScreen, completionRate, weeklyRate),
      ],
    );
  }

  /// Xây dựng grid cho phần Vocabulary
  Widget _buildVocabStatsGrid(
    ThemeData theme,
    bool isSmallScreen,
    String completionRate,
    String weeklyRate,
  ) {
    // Danh sách các mục vocabulary cho cả hai kích thước màn hình
    final vocabItems = [
      _buildGridItem(
        theme,
        stats.totalWords.toString(),
        'Total\nWords',
        Icons.library_books,
        Colors.teal,
      ),
      _buildGridItem(
        theme,
        stats.learnedWords.toString(),
        'Learned\nWords',
        Icons.spellcheck,
        Colors.green,
        additionalInfo: '$completionRate%',
      ),
      _buildGridItem(
        theme,
        stats.pendingWords.toString(),
        'Pending\nWords',
        Icons.hourglass_bottom,
        Colors.amber.shade800,
      ),
      _buildGridItem(
        theme,
        weeklyRate,
        'Weekly\nRate',
        Icons.trending_up,
        Colors.blue,
        additionalInfo: 'percent',
      ),
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: isSmallScreen ? 2 : 4,
      childAspectRatio: 1.0,
      mainAxisSpacing: AppDimens.spaceS,
      crossAxisSpacing: AppDimens.spaceS,
      children: vocabItems,
    );
  }

  /// Widget xây dựng một item trong grid
  Widget _buildGridItem(
    ThemeData theme,
    String value,
    String label,
    IconData iconData,
    Color color, {
    String? additionalInfo,
    bool showStar = false,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(iconData, color: color, size: AppDimens.iconL),
            if (showStar)
              Positioned(
                top: -AppDimens.paddingXS - 1,
                right: -AppDimens.paddingXS - 1,
                child: Container(
                  padding: const EdgeInsets.all(AppDimens.paddingXXS),
                  decoration: const BoxDecoration(
                    color: Colors.amber,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.star,
                    color: Colors.white,
                    size: AppDimens.iconXXS,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppDimens.spaceXS),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        if (additionalInfo != null)
          Text(
            additionalInfo,
            style: theme.textTheme.bodySmall?.copyWith(
              color: color.withOpacity(AppDimens.opacityHigh),
              fontSize: AppDimens.fontXS,
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
