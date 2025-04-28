// lib/presentation/widgets/home/learning_stats_card.dart
import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/core/theme/theme_extensions.dart';
import 'package:spaced_learning_app/domain/models/learning_stats.dart';

class LearningStatsCard extends StatelessWidget {
  final LearningStatsDTO stats;
  final VoidCallback? onViewDetailPressed;
  final ThemeData? theme; // Optional theme override

  const LearningStatsCard({
    super.key,
    required this.stats,
    this.onViewDetailPressed,
    this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final currentTheme = theme ?? Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < AppDimens.breakpointXS;
    final colorScheme = currentTheme.colorScheme;

    return Card(
      elevation: currentTheme.cardTheme.elevation ?? AppDimens.elevationS,
      shape:
          currentTheme.cardTheme.shape ??
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusL),
          ),
      child: Padding(
        padding: EdgeInsets.all(
          isSmallScreen ? AppDimens.paddingM : AppDimens.paddingL,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCardHeader(currentTheme),
            SizedBox(
              height: isSmallScreen ? AppDimens.spaceM : AppDimens.spaceL,
            ),
            _buildStatsSection(
              theme: currentTheme,
              sectionIcon: Icons.auto_stories,
              sectionTitle: 'Module Progress',
              sectionColor: colorScheme.getStatColor('warning'),
              gridContentBuilder: (theme, isSmall) =>
                  _buildModuleStatsGrid(theme, isSmall),
              isSmallScreen: isSmallScreen,
            ),
            const Divider(height: AppDimens.spaceXXL),
            _buildStatsSection(
              theme: currentTheme,
              sectionIcon: Icons.calendar_today,
              sectionTitle: 'Due Sessions',
              sectionColor: colorScheme.getStatColor('success'),
              gridContentBuilder: (theme, isSmall) =>
                  _buildDueStatsGrid(theme, isSmall),
              isSmallScreen: isSmallScreen,
            ),
            const Divider(height: AppDimens.spaceXXL),
            _buildStatsSection(
              theme: currentTheme,
              sectionIcon: Icons.menu_book,
              sectionTitle: 'Vocabulary',
              sectionColor: colorScheme.getStatColor('secondary'),
              gridContentBuilder: (theme, isSmall) =>
                  _buildVocabularyStatsGrid(theme, isSmall),
              isSmallScreen: isSmallScreen,
            ),
            const Divider(height: AppDimens.spaceXXL),
            _buildStatsSection(
              theme: currentTheme,
              sectionIcon: Icons.local_fire_department,
              sectionTitle: 'Streaks',
              sectionColor: colorScheme.getStatColor('error'),
              gridContentBuilder: (theme, isSmall) =>
                  _buildStreakStatsGrid(theme, isSmall),
              isSmallScreen: isSmallScreen,
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
        Icon(Icons.book_online, color: theme.iconTheme.color),
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
    required Widget Function(ThemeData, bool) gridContentBuilder,
    required bool isSmallScreen,
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
        gridContentBuilder(theme, isSmallScreen),
      ],
    );
  }

  Widget _buildModuleStatsGrid(ThemeData theme, bool isSmallScreen) {
    final colorScheme = theme.colorScheme;
    final cycleStats = stats.cycleStats;
    final items = [
      _buildGridItem(
        theme,
        stats.totalModules.toString(),
        'Total\nModules',
        Icons.menu_book,
        colorScheme.getStatColor('warning'),
      ),
      _buildGridItem(
        theme,
        '${cycleStats['NOT_STUDIED'] ?? 0}',
        'Not\nStudied',
        Icons.visibility_off,
        colorScheme.getStatColor('neutral'),
      ),
      _buildGridItem(
        theme,
        '${cycleStats['FIRST_TIME'] ?? 0}',
        '1st\nTime',
        Icons.play_circle_fill,
        colorScheme.getStatColor('success'),
      ),
      _buildGridItem(
        theme,
        '${cycleStats['FIRST_REVIEW'] ?? 0}',
        '1st\nReview',
        Icons.rotate_right,
        colorScheme.getStatColor('secondary'),
      ),
      _buildGridItem(
        theme,
        '${cycleStats['SECOND_REVIEW'] ?? 0}',
        '2nd\nReview',
        Icons.rotate_90_degrees_ccw,
        colorScheme.getStatColor('info'),
      ),
      _buildGridItem(
        theme,
        '${cycleStats['THIRD_REVIEW'] ?? 0}',
        '3rd\nReview',
        Icons.change_circle,
        colorScheme.getStatColor('secondary'),
      ),
      _buildGridItem(
        theme,
        '${cycleStats['MORE_THAN_THREE_REVIEWS'] ?? 0}',
        '4th+\nReviews',
        Icons.loop,
        colorScheme.getStatColor('tertiary'),
      ),
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: isSmallScreen ? 3 : 4,
      childAspectRatio: isSmallScreen ? 0.8 : 0.8,
      mainAxisSpacing: AppDimens.spaceS,
      crossAxisSpacing: AppDimens.spaceS,
      children: items.cast<Widget>().toList(),
    );
  }

  Widget _buildDueStatsGrid(ThemeData theme, bool isSmallScreen) {
    final colorScheme = theme.colorScheme;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: isSmallScreen ? 2 : 4,
      childAspectRatio: isSmallScreen ? 0.8 : 0.6,
      mainAxisSpacing: AppDimens.spaceS,
      crossAxisSpacing: AppDimens.spaceS,
      children: [
        _buildGridItem(
          theme,
          '${stats.dueToday}',
          'Due\nToday',
          Icons.today,
          colorScheme.getStatColor('warning'),
          additionalInfo: '${stats.wordsDueToday} words',
        ),
        _buildGridItem(
          theme,
          '${stats.dueThisWeek}',
          'Due\nThis Week',
          Icons.view_week,
          colorScheme.getStatColor('warningDark'),
          additionalInfo: '${stats.wordsDueThisWeek} words',
        ),
        _buildGridItem(
          theme,
          '${stats.dueThisMonth}',
          'Due\nThis Month',
          Icons.calendar_month,
          colorScheme.getStatColor('primary'),
          additionalInfo: '${stats.wordsDueThisMonth} words',
        ),
        _buildGridItem(
          theme,
          '${stats.completedToday}',
          'Completed\nToday',
          Icons.check_circle,
          colorScheme.getStatColor('successDark'),
          additionalInfo: '${stats.wordsCompletedToday} words',
        ),
      ],
    );
  }

  Widget _buildStreakStatsGrid(ThemeData theme, bool isSmallScreen) {
    final colorScheme = theme.colorScheme;
    final starColor = colorScheme.getStatColor('warning');
    final onStarColor = theme.brightness == Brightness.light
        ? Colors.white
        : theme.colorScheme.surface;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: isSmallScreen ? 2 : 4,
      childAspectRatio: isSmallScreen ? 0.8 : 0.75,
      mainAxisSpacing: AppDimens.spaceS,
      crossAxisSpacing: AppDimens.spaceS,
      children: [
        _buildGridItem(
          theme,
          '${stats.streakDays}',
          'Day\nStreak',
          Icons.local_fire_department,
          colorScheme.getStatColor('error'),
          showStar: stats.streakDays >= 7,
          starColor: starColor,
          onStarColor: onStarColor,
        ),
        _buildGridItem(
          theme,
          '${stats.streakWeeks}',
          'Week\nStreak',
          Icons.date_range,
          colorScheme.getStatColor('secondary'),
          showStar: stats.streakWeeks >= 4,
          starColor: starColor,
          onStarColor: onStarColor,
        ),
        _buildGridItem(
          theme,
          '${stats.longestStreakDays}',
          'Longest\nStreak',
          Icons.emoji_events,
          colorScheme.getStatColor('warning'),
          additionalInfo: 'days',
        ),
        if (!isSmallScreen) const SizedBox.shrink(),
      ].where((w) => w is! SizedBox || isSmallScreen || w.key != null).toList(),
    );
  }

  Widget _buildVocabularyStatsGrid(ThemeData theme, bool isSmallScreen) {
    final colorScheme = theme.colorScheme;
    final completionRate = stats.vocabularyCompletionRate.toStringAsFixed(1);
    final weeklyRate = stats.weeklyNewWordsRate.toStringAsFixed(1);

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: isSmallScreen ? 2 : 4,
      childAspectRatio: isSmallScreen ? 1.3 : 0.6,
      mainAxisSpacing: AppDimens.spaceS,
      crossAxisSpacing: AppDimens.spaceS,
      children: [
        _buildGridItem(
          theme,
          '${stats.totalWords}',
          'Total\nWords',
          Icons.library_books,
          colorScheme.getStatColor('success'),
        ),
        _buildGridItem(
          theme,
          '${stats.learnedWords}',
          'Learned\nWords',
          Icons.spellcheck,
          colorScheme.getStatColor('success'),
          additionalInfo: '$completionRate%',
        ),
        _buildGridItem(
          theme,
          '${stats.pendingWords}',
          'Pending\nWords',
          Icons.hourglass_bottom,
          colorScheme.getStatColor('warningDark'),
        ),
        _buildGridItem(
          theme,
          weeklyRate,
          'Weekly\nRate',
          Icons.trending_up,
          colorScheme.getStatColor('info'),
          additionalInfo: '%',
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
    Color? starColor,
    Color? onStarColor,
  }) {
    final effectiveStarColor =
        starColor ??
        (theme.brightness == Brightness.light
            ? Colors.amber
            : Colors.amberAccent);

    final effectiveOnStarColor =
        onStarColor ??
        (theme.brightness == Brightness.light
            ? Colors.white
            : theme.colorScheme.surface);

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
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
                          decoration: BoxDecoration(
                            color: effectiveStarColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.star,
                            color: effectiveOnStarColor,
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
                      color: color.withValues(alpha: AppDimens.opacityHigh),
                      fontSize: AppDimens.fontXS,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                Text(
                  label,
                  style: theme.textTheme.bodySmall,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
