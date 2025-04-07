import 'package:flutter/material.dart';
// Removed direct AppColors import
// import 'package:spaced_learning_app/core/theme/app_colors.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/learning_insight.dart'; // Ensure this path is correct

/// Card widget that displays learning insights using Theme
class LearningInsightsCard extends StatelessWidget {
  final List<LearningInsightDTO> insights;
  final String? title;
  final VoidCallback? onViewMorePressed;
  final ThemeData? theme; // Optional theme override

  const LearningInsightsCard({
    super.key,
    required this.insights,
    this.title,
    this.onViewMorePressed,
    this.theme, // Added optional theme parameter
  });

  @override
  Widget build(BuildContext context) {
    // Use passed theme or get from context
    final currentTheme = theme ?? Theme.of(context);

    // Sort and limit insights
    final sortedInsights = List<LearningInsightDTO>.from(insights)
      ..sort((a, b) => a.priority.compareTo(b.priority));
    final displayInsights =
        sortedInsights.length > 4
            ? sortedInsights.sublist(0, 4)
            : sortedInsights;

    return Card(
      // Card theme is applied automatically
      // Use theme elevation if defined, otherwise fallback or keep custom
      elevation: currentTheme.cardTheme.elevation ?? AppDimens.elevationS,
      // Use theme shape if defined, otherwise fallback or keep custom
      shape:
          currentTheme.cardTheme.shape ??
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusL),
          ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pass theme to header
            _buildHeader(currentTheme),
            const SizedBox(height: AppDimens.spaceS),
            const Divider(), // Use theme divider
            const SizedBox(height: AppDimens.spaceS),
            if (displayInsights.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppDimens.paddingL,
                  ),
                  // Use theme text style and color
                  child: Text(
                    'No insights available',
                    style: currentTheme.textTheme.bodyMedium?.copyWith(
                      color: currentTheme.colorScheme.onSurface.withValues(
                        alpha: 0.7,
                      ),
                    ),
                  ),
                ),
              )
            else
              // Pass theme to item builder
              ...displayInsights.map(
                (insight) => _buildInsightItem(context, insight, currentTheme),
              ),
            if (onViewMorePressed != null && insights.length > 4) ...[
              const SizedBox(height: AppDimens.spaceS),
              Align(
                alignment: Alignment.centerRight,
                // TextButton uses theme automatically
                child: TextButton(
                  onPressed: onViewMorePressed,
                  child: const Text('View More'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    // Define semantic color based on theme
    final Color headerIconColor =
        theme.brightness == Brightness.light
            ? const Color(0xFFFFD54F)
            : const Color(0xFFFFCA28); // Example: Map warningDark

    return Row(
      children: [
        Icon(
          Icons.lightbulb_outline,
          color: headerIconColor, // Use theme-derived color
          size: AppDimens.iconM,
        ),
        const SizedBox(width: AppDimens.spaceS),
        // Use theme text style
        Text(title ?? 'Learning Insights', style: theme.textTheme.titleLarge),
      ],
    );
  }

  Widget _buildInsightItem(
    BuildContext context,
    LearningInsightDTO insight,
    ThemeData theme,
  ) {
    // Get color and icon using theme
    final Color color = _getColorFromString(insight.color, theme);
    final IconData icon = _getIconFromString(insight.icon);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.paddingS),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: color,
            size: AppDimens.iconM,
          ), // Use theme-derived color
          const SizedBox(width: AppDimens.spaceM),
          Expanded(
            // Use theme text style
            child: Text(insight.message, style: theme.textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }

  /// Maps color names to theme-based colors
  Color _getColorFromString(String colorName, ThemeData theme) {
    // Define semantic colors based on theme brightness (examples)
    final Color successColor =
        theme.brightness == Brightness.light
            ? const Color(0xFF4CAF50)
            : const Color(0xFF81C784);
    final Color warningColor =
        theme.brightness == Brightness.light
            ? const Color(0xFFFFC107)
            : const Color(0xFFFFD54F);
    final Color errorColor = theme.colorScheme.error;
    final Color infoColor =
        theme.brightness == Brightness.light
            ? const Color(0xFF2196F3)
            : const Color(0xFF64B5F6);

    switch (colorName.toLowerCase()) {
      // Map to theme scheme colors
      case 'primary':
      case 'blue': // Assuming blue often means primary
        return theme.colorScheme.primary;
      case 'secondary':
      case 'purple': // Assuming purple often means secondary
        return theme.colorScheme.secondary;
      case 'tertiary':
        return theme.colorScheme.tertiary;
      case 'error':
      case 'red': // Assuming red means error
        return errorColor;
      case 'surface':
        return theme.colorScheme.surface;
      case 'onSurface':
        return theme.colorScheme.onSurface;
      case 'neutral':
        return theme.colorScheme.onSurface.withValues(alpha: 0.6);

      // Map to semantic colors derived from theme
      case 'success':
      case 'green': // Assuming green means success
      case 'teal': // Assuming teal maps to success/green contextually
        return successColor;
      case 'warning':
      case 'orange': // Assuming orange means warning
      case 'amber': // Assuming amber means warning
        return warningColor;
      case 'info':
      case 'indigo': // Assuming indigo maps to info contextually
        return infoColor;

      // Fallback
      default:
        return theme.colorScheme.onSurface.withValues(
          alpha: 0.7,
        ); // Default subtle color
    }
  }

  /// Maps icon names to IconData (remains the same)
  IconData _getIconFromString(String iconName) {
    switch (iconName.toLowerCase()) {
      // Added toLowerCase for robustness
      case 'trending_up':
        return Icons.trending_up;
      case 'local_fire_department':
        return Icons.local_fire_department;
      case 'menu_book':
        return Icons.menu_book;
      case 'today':
        return Icons.today;
      case 'check_circle':
        return Icons.check_circle;
      case 'star':
        return Icons.star;
      case 'emoji_events':
        return Icons.emoji_events;
      case 'lightbulb':
        return Icons.lightbulb;
      case 'info': // Added potential icon name
        return Icons.info;
      case 'warning': // Added potential icon name
        return Icons.warning;
      case 'error': // Added potential icon name
        return Icons.error;
      default:
        return Icons.info_outline; // Default fallback icon
    }
  }
}

// Assume LearningInsightDTO structure:
// class LearningInsightDTO {
//   final String message;
//   final String color; // e.g., 'primary', 'red', 'warning'
//   final String icon;  // e.g., 'trending_up', 'error'
//   final int priority;
//   // ... other fields
//
//   LearningInsightDTO({
//     required this.message,
//     required this.color,
//     required this.icon,
//     required this.priority,
//   });
// }
