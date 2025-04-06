import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_colors.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/learning_stats.dart';

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
            _buildCardHeader(theme),
            SizedBox(
              height: isSmallScreen ? AppDimens.spaceM : AppDimens.spaceL,
            ),
            _buildStatsSection(
              theme: theme,
              sectionIcon: Icons.auto_stories,
              sectionTitle: 'Module Progress',
              sectionColor: AppColors.accentOrange,
              gridContent: _buildModuleStatsGrid(theme, isSmallScreen),
            ),
            const Divider(height: AppDimens.spaceXXL),
            _buildStatsSection(
              theme: theme,
              sectionIcon: Icons.calendar_today,
              sectionTitle: 'Due Sessions',
              sectionColor: AppColors.accentGreen,
              gridContent: _buildDueStatsGrid(theme, isSmallScreen),
            ),
            const Divider(height: AppDimens.spaceXXL),
            _buildStatsSection(
              theme: theme,
              sectionIcon: Icons.local_fire_department,
              sectionTitle: 'Streaks',
              sectionColor: AppColors.accentRed,
              gridContent: _buildStreakStatsGrid(theme, isSmallScreen),
            ),
            const Divider(height: AppDimens.spaceXXL),
            _buildStatsSection(
              theme: theme,
              sectionIcon: Icons.menu_book,
              sectionTitle: 'Vocabulary',
              sectionColor: AppColors.accentPurple,
              gridContent: _buildVocabularyStatsGrid(theme, isSmallScreen),
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

  Widget _buildCardHeader(ThemeData theme) {
    return Row(
      children: [
        const Icon(Icons.book_online, color: AppColors.iconPrimaryLight),
        const SizedBox(width: AppDimens.spaceS),
        Text('Learning Statistics', style: theme.textTheme.titleLarge),
      ],
    );
  }

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
        gridContent,
      ],
    );
  }

  Widget _buildModuleStatsGrid(ThemeData theme, bool isSmallScreen) {
    final cycleStats = stats.cycleStats;
    final items = [
      _buildGridItem(
        theme,
        stats.totalModules.toString(),
        'Total\nModules',
        Icons.menu_book,
        AppColors.accentOrange,
      ),
      _buildGridItem(
        theme,
        '${cycleStats['NOT_STUDIED'] ?? 0}',
        'Not\nStudied',
        Icons.visibility_off,
        AppColors.neutralMedium,
      ),
      _buildGridItem(
        theme,
        '${cycleStats['FIRST_TIME'] ?? 0}',
        '1st\nTime',
        Icons.play_circle_fill,
        AppColors.successLight,
      ),
      _buildGridItem(
        theme,
        '${cycleStats['FIRST_REVIEW'] ?? 0}',
        '1st\nReview',
        Icons.rotate_right,
        AppColors.accentPink,
      ),
      _buildGridItem(
        theme,
        '${cycleStats['SECOND_REVIEW'] ?? 0}',
        '2nd\nReview',
        Icons.rotate_90_degrees_ccw,
        AppColors.infoLight,
      ),
      _buildGridItem(
        theme,
        '${cycleStats['THIRD_REVIEW'] ?? 0}',
        '3rd\nReview',
        Icons.change_circle,
        AppColors.accentPurple,
      ),
      _buildGridItem(
        theme,
        '${cycleStats['MORE_THAN_THREE_REVIEWS'] ?? 0}',
        '4th+\nReviews',
        Icons.loop,
        AppColors.darkTertiary,
      ),
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: isSmallScreen ? 3 : 4,
      childAspectRatio: 0.95,
      mainAxisSpacing: AppDimens.spaceS,
      crossAxisSpacing: AppDimens.spaceS,
      children: items,
    );
  }

  Widget _buildDueStatsGrid(ThemeData theme, bool isSmallScreen) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: isSmallScreen ? 2 : 4,
      childAspectRatio: 1.0,
      mainAxisSpacing: AppDimens.spaceS,
      crossAxisSpacing: AppDimens.spaceS,
      children: [
        _buildGridItem(
          theme,
          '${stats.dueToday}',
          'Due\nToday',
          Icons.today,
          AppColors.warningLight,
          additionalInfo: '${stats.wordsDueToday} words',
        ),
        _buildGridItem(
          theme,
          '${stats.dueThisWeek}',
          'Due\nThis Week',
          Icons.view_week,
          AppColors.warningDark,
          additionalInfo: '${stats.wordsDueThisWeek} words',
        ),
        _buildGridItem(
          theme,
          '${stats.dueThisMonth}',
          'Due\nThis Month',
          Icons.calendar_month,
          AppColors.lightPrimary,
          additionalInfo: '${stats.wordsDueThisMonth} words',
        ),
        _buildGridItem(
          theme,
          '${stats.completedToday}',
          'Completed\nToday',
          Icons.check_circle,
          AppColors.successDark,
          additionalInfo: '${stats.wordsCompletedToday} words',
        ),
      ],
    );
  }

  Widget _buildStreakStatsGrid(ThemeData theme, bool isSmallScreen) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: isSmallScreen ? 3 : 4,
      childAspectRatio: 1.0,
      mainAxisSpacing: AppDimens.spaceS,
      crossAxisSpacing: AppDimens.spaceS,
      children: [
        _buildGridItem(
          theme,
          '${stats.streakDays}',
          'Day\nStreak',
          Icons.local_fire_department,
          AppColors.accentRed,
          showStar: stats.streakDays >= 7,
        ),
        _buildGridItem(
          theme,
          '${stats.streakWeeks}',
          'Week\nStreak',
          Icons.date_range,
          AppColors.accentPink,
          showStar: stats.streakWeeks >= 4,
        ),
        _buildGridItem(
          theme,
          '${stats.longestStreakDays}',
          'Longest\nStreak',
          Icons.emoji_events,
          AppColors.warningLight,
          additionalInfo: 'days',
        ),
        const SizedBox.shrink(),
      ],
    );
  }

  Widget _buildVocabularyStatsGrid(ThemeData theme, bool isSmallScreen) {
    final completionRate = stats.vocabularyCompletionRate.toStringAsFixed(1);
    final weeklyRate = stats.weeklyNewWordsRate.toStringAsFixed(1);

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: isSmallScreen ? 2 : 4,
      childAspectRatio: 1.0,
      mainAxisSpacing: AppDimens.spaceS,
      crossAxisSpacing: AppDimens.spaceS,
      children: [
        _buildGridItem(
          theme,
          '${stats.totalWords}',
          'Total\nWords',
          Icons.library_books,
          AppColors.accentGreen,
        ),
        _buildGridItem(
          theme,
          '${stats.learnedWords}',
          'Learned\nWords',
          Icons.spellcheck,
          AppColors.successLight,
          additionalInfo: '$completionRate%',
        ),
        _buildGridItem(
          theme,
          '${stats.pendingWords}',
          'Pending\nWords',
          Icons.hourglass_bottom,
          AppColors.warningDark,
        ),
        _buildGridItem(
          theme,
          weeklyRate,
          'Weekly\nRate',
          Icons.trending_up,
          AppColors.infoLight,
          additionalInfo: 'percent',
        ),
      ],
    );
  }

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
              color: color.withValues(alpha: AppDimens.opacityHigh),
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
