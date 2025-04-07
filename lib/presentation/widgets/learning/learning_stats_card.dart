import 'package:flutter/material.dart';
// Removed direct AppColors import
// import 'package:spaced_learning_app/core/theme/app_colors.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/learning_stats.dart'; // Ensure path is correct

/// Card displaying summarized learning statistics using Theme
class LearningStatsCard extends StatelessWidget {
  final LearningStatsDTO stats;
  final VoidCallback? onViewDetailPressed;
  final ThemeData? theme; // Optional theme override

  const LearningStatsCard({
    super.key,
    required this.stats,
    this.onViewDetailPressed,
    this.theme, // Added optional theme parameter
  });

  @override
  Widget build(BuildContext context) {
    // Use passed theme or get from context
    final currentTheme = theme ?? Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < AppDimens.breakpointXS;

    // Define semantic colors based on the current theme once
    // Adjust these mappings based on your AppColors and theme intent
    final Color successColor =
        currentTheme.brightness == Brightness.light
            ? const Color(0xFF4CAF50)
            : const Color(0xFF81C784);
    final Color successDarkerColor =
        currentTheme.brightness == Brightness.light
            ? const Color(0xFF2E7D32)
            : const Color(0xFFC8E6C9); // Example mapping for successDark
    final Color warningColor =
        currentTheme.brightness == Brightness.light
            ? const Color(0xFFFFC107)
            : const Color(0xFFFFD54F); // Example mapping for warningLight/Dark
    final Color warningDarkerColor =
        currentTheme.brightness == Brightness.light
            ? const Color(0xFFFFA000)
            : const Color(0xFFFFECB3); // Example mapping for warningDark
    final Color errorColor =
        currentTheme.colorScheme.error; // Use theme's error
    final Color infoColor =
        currentTheme.brightness == Brightness.light
            ? const Color(0xFF2196F3)
            : const Color(0xFF64B5F6); // Example mapping for infoLight/Dark
    final Color primaryColor = currentTheme.colorScheme.primary;
    final Color secondaryColor =
        currentTheme.colorScheme.secondary; // Often purple/pink in Material 3
    final Color tertiaryColor =
        currentTheme.colorScheme.tertiary; // Often teal/blue-grey
    final Color neutralColor = currentTheme.colorScheme.onSurface.withValues(
      alpha: 0.6,
    );

    // Create a map for easier access in builders
    final semanticColors = {
      'success': successColor,
      'successDark': successDarkerColor,
      'warning': warningColor,
      'warningDark': warningDarkerColor,
      'error': errorColor,
      'info': infoColor,
      'primary': primaryColor,
      'secondary': secondaryColor,
      'tertiary': tertiaryColor,
      'neutral': neutralColor,
    };

    return Card(
      // Card theme applied automatically
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
            // Pass theme to header
            _buildCardHeader(currentTheme),
            SizedBox(
              height: isSmallScreen ? AppDimens.spaceM : AppDimens.spaceL,
            ),
            _buildStatsSection(
              theme: currentTheme, // Pass theme
              semanticColors: semanticColors, // Pass colors map
              sectionIcon: Icons.auto_stories,
              sectionTitle: 'Module Progress',
              sectionColor:
                  semanticColors['warning']!, // Example: Orange for Modules
              gridContentBuilder:
                  (theme, isSmall) => _buildModuleStatsGrid(
                    theme,
                    isSmall,
                    semanticColors,
                  ), // Pass colors map
              isSmallScreen: isSmallScreen,
            ),
            const Divider(height: AppDimens.spaceXXL), // Uses theme divider
            _buildStatsSection(
              theme: currentTheme, // Pass theme
              semanticColors: semanticColors, // Pass colors map
              sectionIcon: Icons.calendar_today,
              sectionTitle: 'Due Sessions',
              sectionColor:
                  semanticColors['success']!, // Example: Green for Due
              gridContentBuilder:
                  (theme, isSmall) => _buildDueStatsGrid(
                    theme,
                    isSmall,
                    semanticColors,
                  ), // Pass colors map
              isSmallScreen: isSmallScreen,
            ),
            const Divider(height: AppDimens.spaceXXL), // Uses theme divider
            _buildStatsSection(
              theme: currentTheme, // Pass theme
              semanticColors: semanticColors, // Pass colors map
              sectionIcon: Icons.menu_book,
              sectionTitle: 'Vocabulary',
              sectionColor:
                  semanticColors['secondary']!, // Example: Purple for Vocabulary
              gridContentBuilder:
                  (theme, isSmall) => _buildVocabularyStatsGrid(
                    theme,
                    isSmall,
                    semanticColors,
                  ), // Pass colors map
              isSmallScreen: isSmallScreen,
            ),
            const Divider(height: AppDimens.spaceXXL), // Uses theme divider
            _buildStatsSection(
              theme: currentTheme, // Pass theme
              semanticColors: semanticColors, // Pass colors map
              sectionIcon: Icons.local_fire_department,
              sectionTitle: 'Streaks',
              sectionColor:
                  semanticColors['error']!, // Example: Red for Streaks
              gridContentBuilder:
                  (theme, isSmall) => _buildStreakStatsGrid(
                    theme,
                    isSmall,
                    semanticColors,
                  ), // Pass colors map
              isSmallScreen: isSmallScreen,
            ),
            if (onViewDetailPressed != null) ...[
              const SizedBox(height: AppDimens.spaceL),
              Align(
                alignment: Alignment.centerRight,
                // TextButton uses theme automatically
                child: TextButton.icon(
                  icon: const Icon(
                    Icons.analytics_outlined,
                  ), // Icon color from TextButton theme
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
        // Use theme's icon theme color
        Icon(Icons.book_online, color: theme.iconTheme.color),
        const SizedBox(width: AppDimens.spaceS),
        // Use theme text style
        Text('Learning Statistics', style: theme.textTheme.titleLarge),
      ],
    );
  }

  // Updated to accept a builder function for grid content
  Widget _buildStatsSection({
    required ThemeData theme,
    required Map<String, Color> semanticColors, // Receive color map
    required IconData sectionIcon,
    required String sectionTitle,
    required Color sectionColor, // Color for the section header itself
    required Widget Function(ThemeData, bool)
    gridContentBuilder, // Builder function
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
        // Call the builder function to build the grid content
        gridContentBuilder(theme, isSmallScreen),
      ],
    );
  }

  // Grid Builders now accept the semanticColors map

  Widget _buildModuleStatsGrid(
    ThemeData theme,
    bool isSmallScreen,
    Map<String, Color> colors,
  ) {
    final cycleStats = stats.cycleStats;
    final items = [
      _buildGridItem(
        theme,
        stats.totalModules.toString(),
        'Total\nModules',
        Icons.menu_book,
        colors['warning']!, // Example: Use warning color
      ),
      _buildGridItem(
        theme,
        '${cycleStats['NOT_STUDIED'] ?? 0}',
        'Not\nStudied',
        Icons.visibility_off,
        colors['neutral']!, // Use neutral color
      ),
      _buildGridItem(
        theme,
        '${cycleStats['FIRST_TIME'] ?? 0}',
        '1st\nTime',
        Icons.play_circle_fill,
        colors['success']!, // Use success color
      ),
      _buildGridItem(
        // Example mapping 'accentPink' to secondary
        theme,
        '${cycleStats['FIRST_REVIEW'] ?? 0}',
        '1st\nReview',
        Icons.rotate_right,
        colors['secondary']!, // Use secondary color
      ),
      _buildGridItem(
        theme,
        '${cycleStats['SECOND_REVIEW'] ?? 0}',
        '2nd\nReview',
        Icons.rotate_90_degrees_ccw,
        colors['info']!, // Use info color
      ),
      _buildGridItem(
        // Example mapping 'accentPurple' to secondary
        theme,
        '${cycleStats['THIRD_REVIEW'] ?? 0}',
        '3rd\nReview',
        Icons.change_circle,
        colors['secondary']!, // Use secondary color again or choose another
      ),
      _buildGridItem(
        // Example mapping 'darkTertiary' to tertiary
        theme,
        '${cycleStats['MORE_THAN_THREE_REVIEWS'] ?? 0}',
        '4th+\nReviews',
        Icons.loop,
        colors['tertiary']!, // Use tertiary color
      ),
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: isSmallScreen ? 3 : 4,
      childAspectRatio: 0.95,
      mainAxisSpacing: AppDimens.spaceS,
      crossAxisSpacing: AppDimens.spaceS,
      children:
          items
              // Removed unnecessary null check
              .cast<Widget>()
              .toList(), // Filter nulls if any logic changes
    );
  }

  Widget _buildDueStatsGrid(
    ThemeData theme,
    bool isSmallScreen,
    Map<String, Color> colors,
  ) {
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
          colors['warning']!, // Use warning color
          additionalInfo: '${stats.wordsDueToday} words',
        ),
        _buildGridItem(
          theme,
          '${stats.dueThisWeek}',
          'Due\nThis Week',
          Icons.view_week,
          colors['warningDark']!, // Use darker warning color
          additionalInfo: '${stats.wordsDueThisWeek} words',
        ),
        _buildGridItem(
          theme,
          '${stats.dueThisMonth}',
          'Due\nThis Month',
          Icons.calendar_month,
          colors['primary']!, // Use primary color
          additionalInfo: '${stats.wordsDueThisMonth} words',
        ),
        _buildGridItem(
          theme,
          '${stats.completedToday}',
          'Completed\nToday',
          Icons.check_circle,
          colors['successDark']!, // Use darker success color
          additionalInfo: '${stats.wordsCompletedToday} words',
        ),
      ],
    );
  }

  Widget _buildStreakStatsGrid(
    ThemeData theme,
    bool isSmallScreen,
    Map<String, Color> colors,
  ) {
    // Determine star color from theme
    final starColor =
        colors['warning'] ?? Colors.amber; // Fallback if warning not in map
    final onStarColor =
        theme.brightness == Brightness.light
            ? Colors.white
            : theme.colorScheme.surface; // Example contrast color

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: isSmallScreen ? 3 : 4, // Adjusted for potential 4 items
      childAspectRatio: 1.0,
      mainAxisSpacing: AppDimens.spaceS,
      crossAxisSpacing: AppDimens.spaceS,
      children:
          [
                _buildGridItem(
                  theme,
                  '${stats.streakDays}',
                  'Day\nStreak',
                  Icons.local_fire_department,
                  colors['error']!, // Use error color (mapping from accentRed)
                  showStar: stats.streakDays >= 7,
                  starColor: starColor,
                  onStarColor: onStarColor,
                ),
                _buildGridItem(
                  // Mapping accentPink to secondary
                  theme,
                  '${stats.streakWeeks}',
                  'Week\nStreak',
                  Icons.date_range,
                  colors['secondary']!,
                  showStar: stats.streakWeeks >= 4,
                  starColor: starColor,
                  onStarColor: onStarColor,
                ),
                _buildGridItem(
                  theme,
                  '${stats.longestStreakDays}',
                  'Longest\nStreak',
                  Icons.emoji_events,
                  colors['warning']!, // Use warning color
                  additionalInfo: 'days',
                ),
                // Keep SizedBox if layout requires exactly 4 slots even on small screens
                if (!isSmallScreen) const SizedBox.shrink(),
              ]
              .where((w) => w is! SizedBox || isSmallScreen || w.key != null)
              .toList(), // Flexible way to handle potential empty slots
    );
  }

  Widget _buildVocabularyStatsGrid(
    ThemeData theme,
    bool isSmallScreen,
    Map<String, Color> colors,
  ) {
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
          // Mapping accentGreen to success
          theme,
          '${stats.totalWords}',
          'Total\nWords',
          Icons.library_books,
          colors['success']!,
        ),
        _buildGridItem(
          theme,
          '${stats.learnedWords}',
          'Learned\nWords',
          Icons.spellcheck,
          colors['success']!, // Use success color
          additionalInfo: '$completionRate%',
        ),
        _buildGridItem(
          theme,
          '${stats.pendingWords}',
          'Pending\nWords',
          Icons.hourglass_bottom,
          colors['warningDark']!, // Use darker warning color
        ),
        _buildGridItem(
          theme,
          weeklyRate, // Already a string
          'Weekly\nRate',
          Icons.trending_up,
          colors['info']!, // Use info color
          additionalInfo: '%', // Changed additional info
        ),
      ],
    );
  }

  // Updated _buildGridItem to accept theme and use theme colors for star
  Widget _buildGridItem(
    ThemeData theme,
    String value,
    String label,
    IconData iconData,
    Color color, { // This color is for the main icon and value text
    String? additionalInfo,
    bool showStar = false,
    Color? starColor, // Optional override from caller
    Color? onStarColor, // Optional override from caller
  }) {
    // Determine star colors using theme fallbacks if not provided
    final effectiveStarColor =
        starColor ??
        (theme.brightness == Brightness.light
            ? Colors.amber
            : Colors.amberAccent); // Example: Theme-based star color
    final effectiveOnStarColor =
        onStarColor ??
        (theme.brightness == Brightness.light
            ? Colors.white
            : theme
                .colorScheme
                .surface); // Example: Theme-based text-on-star color

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
                  decoration: BoxDecoration(
                    color: effectiveStarColor, // Use theme-derived star color
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.star,
                    color:
                        effectiveOnStarColor, // Use theme-derived color for star icon itself
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
            color: color, // Use the passed color for emphasis
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (additionalInfo != null)
          Text(
            additionalInfo,
            style: theme.textTheme.bodySmall?.copyWith(
              // Use passed color but make it less prominent than the main value
              color: color.withValues(alpha: AppDimens.opacityHigh),
              fontSize: AppDimens.fontXS,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        // Ensure label uses theme's bodySmall style and color
        Text(
          label,
          style: theme.textTheme.bodySmall,
          textAlign: TextAlign.center,
          maxLines: 2, // Allow label to wrap
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

// Helper extension (optional)
// extension ColorAlpha on Color {
//   Color withValues({double? alpha}) {
//     if (alpha != null) {
//       return withOpacity(alpha);
//     }
//     return this;
//   }
// }
