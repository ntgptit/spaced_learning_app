import 'package:flutter/material.dart';
// Removed direct AppColors import as colors should come from the theme
// import 'package:spaced_learning_app/core/theme/app_colors.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

/// Widget to display learning insights on the home screen using Theme
class LearningInsightsWidget extends StatelessWidget {
  final double vocabularyRate;
  final int streakDays;
  final int pendingWords;
  final int dueToday;
  final ThemeData? theme; // Optional theme override

  const LearningInsightsWidget({
    super.key,
    required this.vocabularyRate,
    required this.streakDays,
    required this.pendingWords,
    required this.dueToday,
    this.theme, // Added optional theme parameter
  });

  @override
  Widget build(BuildContext context) {
    // Use passed theme or get from context
    final currentTheme = theme ?? Theme.of(context);

    return Card(
      // Card theme applied automatically
      margin: EdgeInsets.zero, // Keep custom margin
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pass theme to header
            _buildHeader(currentTheme),
            const SizedBox(
              height: AppDimens.spaceM,
            ), // Added space after header
            const Divider(), // Use theme divider, height adjusted by theme
            const SizedBox(height: AppDimens.spaceS), // Added space before list
            // Pass theme to list builder
            _buildInsightsList(context, currentTheme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      children: [
        Icon(
          Icons.insights,
          // Use theme's tertiary color
          color: theme.colorScheme.tertiary,
          size: AppDimens.iconM,
        ),
        const SizedBox(width: AppDimens.spaceS),
        // Use theme text style
        Text('Learning Insights', style: theme.textTheme.titleLarge),
      ],
    );
  }

  Widget _buildInsightsList(BuildContext context, ThemeData theme) {
    // Define semantic colors based on the current theme
    // Example mapping (adjust based on your AppColors definitions and theme intent)
    final Color rateColor =
        theme.colorScheme.secondary; // Example: Map accentPurple
    final Color streakColor =
        theme.brightness == Brightness.light
            ? const Color(0xFFFFC107)
            : const Color(0xFFFFD54F); // Example: Map warningLight
    final Color pendingColor =
        theme.brightness == Brightness.light
            ? const Color(0xFF4CAF50)
            : const Color(0xFF81C784); // Example: Map accentGreen
    final Color dueColor =
        theme.colorScheme.primary; // Example: Map lightPrimary

    return Column(
      children: [
        _buildInsightItem(
          context,
          theme, // Pass theme
          'You learn ${vocabularyRate.toStringAsFixed(1)}% new vocabulary each week',
          Icons.trending_up,
          rateColor, // Use theme-derived color
        ),
        _buildInsightItem(
          context,
          theme, // Pass theme
          'Your current streak is $streakDays days - keep going!',
          Icons.local_fire_department,
          streakColor, // Use theme-derived color
        ),
        _buildInsightItem(
          context,
          theme, // Pass theme
          'You have $pendingWords words pending to learn',
          Icons
              .menu_book, // Consider a more specific icon like hourglass_empty?
          pendingColor, // Use theme-derived color
        ),
        _buildInsightItem(
          context,
          theme, // Pass theme
          'Complete today\'s $dueToday sessions to maintain your streak',
          Icons.today,
          dueColor, // Use theme-derived color
        ),
      ],
    );
  }

  Widget _buildInsightItem(
    BuildContext context,
    ThemeData theme, // Receive theme
    String message,
    IconData icon,
    Color color, // Color is now derived from theme in the caller
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.paddingS),
      child: Row(
        children: [
          // Use the derived color for the icon
          Icon(icon, color: color, size: AppDimens.iconM),
          const SizedBox(width: AppDimens.spaceM),
          Expanded(
            // Use theme text style for the message
            child: Text(message, style: theme.textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
