import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart'; // Assuming AppDimens exists
import 'package:spaced_learning_app/domain/models/learning_stats.dart'; // Assuming LearningStatsDTO exists

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
            _buildCardHeader(theme), // Renamed for clarity
            SizedBox(
              height: isSmallScreen ? AppDimens.spaceM : AppDimens.spaceL,
            ),
            // Use the generalized section builder
            _buildStatsSection(
              theme: theme,
              sectionIcon: Icons.auto_stories,
              sectionTitle: 'Module Progress',
              sectionColor: theme.colorScheme.secondary,
              gridContent: _buildModuleStatsGrid(theme, isSmallScreen),
            ),
            const Divider(height: AppDimens.spaceXXL),
            _buildStatsSection(
              theme: theme,
              sectionIcon: Icons.calendar_today,
              sectionTitle: 'Due Sessions',
              sectionColor: theme.colorScheme.error,
              gridContent: _buildDueStatsGrid(theme, isSmallScreen),
            ),
            const Divider(height: AppDimens.spaceXXL),
            _buildStatsSection(
              theme: theme,
              sectionIcon: Icons.local_fire_department,
              sectionTitle: 'Streaks',
              sectionColor: Colors.deepOrange,
              gridContent: _buildStreakStatsGrid(theme, isSmallScreen),
            ),
            const Divider(height: AppDimens.spaceXXL),
            _buildStatsSection(
              theme: theme,
              sectionIcon: Icons.menu_book,
              sectionTitle: 'Vocabulary',
              sectionColor: Colors.teal,
              gridContent: _buildVocabularyStatsGrid(
                theme,
                isSmallScreen,
              ), // Renamed grid builder
            ),
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

  // Header for the entire card
  Widget _buildCardHeader(ThemeData theme) {
    return Row(
      children: [
        Icon(Icons.book_online, color: theme.colorScheme.primary),
        const SizedBox(width: AppDimens.spaceS),
        Text('Learning Statistics', style: theme.textTheme.titleLarge),
      ],
    );
  }

  /// Builds a generic statistics section with a header and grid content.
  Widget _buildStatsSection({
    required ThemeData theme,
    required IconData sectionIcon,
    required String sectionTitle,
    required Color sectionColor,
    required Widget gridContent,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(sectionIcon, size: AppDimens.iconM, color: sectionColor),
            const SizedBox(width: AppDimens.spaceS),
            Text(
              sectionTitle,
              style: theme.textTheme.titleMedium?.copyWith(color: sectionColor),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.spaceM),
        gridContent, // Pass the specific grid widget here
      ],
    );
  }

  /// Builds the grid for the Module Progress section
  Widget _buildModuleStatsGrid(ThemeData theme, bool isSmallScreen) {
    final cycleStats = stats.cycleStats;
    final notStudied = cycleStats['NOT_STUDIED'] ?? 0;
    final firstTime = cycleStats['FIRST_TIME'] ?? 0;
    final firstReview = cycleStats['FIRST_REVIEW'] ?? 0;
    final secondReview = cycleStats['SECOND_REVIEW'] ?? 0;
    final thirdReview = cycleStats['THIRD_REVIEW'] ?? 0;
    final moreThanThree = cycleStats['MORE_THAN_THREE_REVIEWS'] ?? 0;

    // List of module items
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
        '1st\nTime', // Or 'Completed'? Based on DTO definition
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
        // Only one '3rd Review' item now
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

    // Add placeholder(s) if needed for alignment on larger screens
    // Example: Ensure the grid has a multiple of `crossAxisCount` items
    const largeScreenCrossAxisCount = 4;
    if (!isSmallScreen && moduleItems.length % largeScreenCrossAxisCount != 0) {
      final placeholdersNeeded =
          largeScreenCrossAxisCount -
          (moduleItems.length % largeScreenCrossAxisCount);
      for (int i = 0; i < placeholdersNeeded; i++) {
        moduleItems.add(
          const SizedBox.shrink(),
        ); // Use SizedBox.shrink for empty space
      }
    }

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: isSmallScreen ? 3 : largeScreenCrossAxisCount,
      childAspectRatio: isSmallScreen ? 0.85 : 1.0,
      mainAxisSpacing: AppDimens.spaceS,
      crossAxisSpacing: isSmallScreen ? AppDimens.spaceXS : AppDimens.spaceS,
      children: moduleItems,
    );
  }

  /// Builds the grid for the Due Sessions section
  Widget _buildDueStatsGrid(ThemeData theme, bool isSmallScreen) {
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
      childAspectRatio: 1.0, // Consistent aspect ratio for this grid
      mainAxisSpacing: AppDimens.spaceS,
      crossAxisSpacing: AppDimens.spaceS,
      children: dueItems,
    );
  }

  /// Builds the grid for the Streaks section
  Widget _buildStreakStatsGrid(ThemeData theme, bool isSmallScreen) {
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

    // Add placeholder for alignment on larger screens
    const largeScreenCrossAxisCount = 4;
    if (!isSmallScreen) {
      streakItems.add(const SizedBox.shrink()); // Use SizedBox.shrink
    }

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: isSmallScreen ? 3 : largeScreenCrossAxisCount,
      childAspectRatio: 1.0, // Consistent aspect ratio
      mainAxisSpacing: AppDimens.spaceS,
      crossAxisSpacing: AppDimens.spaceS,
      children: streakItems,
    );
  }

  /// Builds the grid for the Vocabulary section (Renamed from _buildVocabStatsGrid)
  Widget _buildVocabularyStatsGrid(ThemeData theme, bool isSmallScreen) {
    final completionRate = stats.vocabularyCompletionRate.toStringAsFixed(1);
    final weeklyRate = stats.weeklyNewWordsRate.toStringAsFixed(1);

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
      childAspectRatio: 1.0, // Consistent aspect ratio
      mainAxisSpacing: AppDimens.spaceS,
      crossAxisSpacing: AppDimens.spaceS,
      children: vocabItems,
    );
  }

  /// Widget builder for a single item within any grid. (No changes needed here)
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
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (additionalInfo != null)
          Text(
            additionalInfo,
            style: theme.textTheme.bodySmall?.copyWith(
              color: color.withOpacity(AppDimens.opacityHigh),
              fontSize: AppDimens.fontXS,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        Text(
          label,
          style: theme.textTheme.bodySmall,
          textAlign: TextAlign.center,
          maxLines: 2, // Allow label to wrap to two lines
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
