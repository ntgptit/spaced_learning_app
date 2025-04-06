import 'package:flutter/material.dart';
// Assuming AppDimens is in this path
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

/// Widget for displaying quick action buttons on the home screen
class QuickActionsSection extends StatelessWidget {
  final VoidCallback onBrowseBooksPressed;
  final VoidCallback onTodaysLearningPressed;
  final VoidCallback onProgressReportPressed;
  final VoidCallback onVocabularyStatsPressed;

  const QuickActionsSection({
    super.key,
    required this.onBrowseBooksPressed,
    required this.onTodaysLearningPressed,
    required this.onProgressReportPressed,
    required this.onVocabularyStatsPressed,
  });

  @override
  Widget build(BuildContext context) {
    // Ensure AppDimens constants are used for spacing
    return GridView.count(
      shrinkWrap: true, // Important when nested in a scrollable view
      physics: const NeverScrollableScrollPhysics(), // Disable grid scrolling
      crossAxisCount: 2, // Fixed two columns
      // Use AppDimens for spacing between grid items
      crossAxisSpacing: AppDimens.gridSpacingL, // e.g., 16.0
      mainAxisSpacing: AppDimens.gridSpacingL, // e.g., 16.0
      childAspectRatio: 1.1, // Adjust aspect ratio slightly if needed
      children: _buildActionItems(context),
    );
  }

  // Build the list of action cards using theme colors
  List<Widget> _buildActionItems(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Define colors based on the theme's color scheme for a modern look
    final List<Map<String, dynamic>> actions = [
      {
        'title': 'Browse Books',
        'icon': Icons.menu_book_outlined, // Use outlined icons for consistency
        'onTap': onBrowseBooksPressed,
        'contentColor': colorScheme.primary, // Use primary theme color
      },
      {
        'title': 'Today\'s Learning',
        'icon': Icons.assignment_turned_in_outlined, // Use outlined icons
        'onTap': onTodaysLearningPressed,
        'contentColor': colorScheme.secondary, // Use secondary theme color
      },
      {
        'title': 'Progress Report',
        'icon': Icons.bar_chart_outlined, // Use outlined icons
        'onTap': onProgressReportPressed,
        // Use tertiary or another distinct color. Fallback if tertiary isn't distinct.
        'contentColor': colorScheme.tertiary.withValues(
          alpha: 0.9,
        ), // Ensure tertiary is defined, maybe slightly less bright
      },
      {
        'title': 'Vocabulary Stats',
        'icon': Icons.translate_outlined, // More specific icon? Use outlined
        'onTap': onVocabularyStatsPressed,
        // Reuse primary or secondary, or use another color like error for distinction
        'contentColor': colorScheme.error, // Example using error color
      },
    ];

    // Map the action data to action card widgets
    return actions.map((action) {
      return _buildActionCard(
        context,
        title: action['title'] as String,
        icon: action['icon'] as IconData,
        onTap: action['onTap'] as VoidCallback,
        // Pass the theme-based content color
        contentColor: action['contentColor'] as Color,
      );
    }).toList();
  }

  /// Builds a single action card with theme-aware styling.
  Widget _buildActionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    required Color contentColor, // Use this for icon and text
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      // Use AppDimens for elevation
      elevation: AppDimens.elevationS, // e.g., 2.0
      // Use a subtle background color from the theme like surfaceVariant
      // This adapts better to light/dark mode than tinted colors.
      color: colorScheme.surfaceContainerHighest.withValues(
        alpha: 0.6,
      ), // Slight transparency for effect
      // Use AppDimens for border radius
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusM), // e.g., 12.0
        // Optional: Add a subtle border
        // side: BorderSide(color: contentColor.withValues(alpha:0.2), width: 1),
      ),
      clipBehavior: Clip.antiAlias, // Ensure InkWell ripple stays within bounds
      child: InkWell(
        onTap: onTap,
        // Ensure InkWell also has the border radius
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
        child: Padding(
          // Use AppDimens for padding inside the card
          padding: const EdgeInsets.all(AppDimens.paddingL), // e.g., 16.0
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment:
                MainAxisAlignment.center, // Center content vertically
            children: [
              Icon(
                icon,
                // Use AppDimens for icon size
                size: AppDimens.iconXL, // e.g., 32.0
                // Apply the theme-based content color to the icon
                color: contentColor,
              ),
              // Use AppDimens for spacing
              const SizedBox(height: AppDimens.spaceS), // e.g., 8.0
              Text(
                title,
                // Use a theme text style, but override color for consistency
                style: theme.textTheme.titleMedium?.copyWith(
                  // Apply the theme-based content color to the text
                  color: contentColor.withValues(
                    alpha: 0.9,
                  ), // Slightly less intense text color
                  fontWeight: FontWeight.w500, // Adjust weight if needed
                ),
                textAlign: TextAlign.center,
                maxLines: 2, // Allow text to wrap
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
