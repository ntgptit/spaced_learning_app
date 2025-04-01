import 'package:flutter/material.dart';
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
    final isSmallScreen = size.width < 360;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme),
            SizedBox(height: isSmallScreen ? 12 : 16),
            _buildModuleSection(theme, isSmallScreen),
            const Divider(height: 32),
            _buildDueSection(theme, isSmallScreen),
            const Divider(height: 32),
            _buildStreakSection(theme, isSmallScreen),
            const Divider(height: 32),
            _buildVocabularySection(theme, isSmallScreen),
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
        Icon(Icons.book_online, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
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
              size: 20,
              color: theme.colorScheme.secondary,
            ),
            const SizedBox(width: 8),
            Text(
              'Module Progress',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.secondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
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
      mainAxisSpacing: 8,
      crossAxisSpacing: isSmallScreen ? 4 : 8,
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
        const SizedBox(height: 12),
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
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
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
        const SizedBox(height: 12),
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
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
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
            const Icon(Icons.menu_book, size: 20, color: Colors.teal),
            const SizedBox(width: 8),
            Text(
              'Vocabulary',
              style: theme.textTheme.titleMedium?.copyWith(color: Colors.teal),
            ),
          ],
        ),
        const SizedBox(height: 12),
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
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
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
            Icon(iconData, color: color, size: 24),
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
            color: color,
          ),
        ),
        if (additionalInfo != null)
          Text(
            additionalInfo,
            style: theme.textTheme.bodySmall?.copyWith(
              color: color.withOpacity(0.7),
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
