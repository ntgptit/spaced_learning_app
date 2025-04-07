// lib/presentation/screens/help/spaced_repetition_info_screen.dart
import 'package:flutter/material.dart';
// Keep AppColors import if CycleFormatter or specific colors like successLight still rely on it
import 'package:spaced_learning_app/core/theme/app_colors.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/progress.dart';
import 'package:spaced_learning_app/presentation/utils/cycle_formatter.dart';

class SpacedRepetitionInfoScreen extends StatelessWidget {
  const SpacedRepetitionInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the current theme data which includes AppTheme settings
    final theme = Theme.of(context);
    // Get the color scheme for easier access to theme colors
    final colorScheme = theme.colorScheme;

    return Scaffold(
      // AppBar will automatically use appBarTheme from AppTheme
      appBar: AppBar(title: const Text('Spaced Repetition')),
      // Scaffold background color comes from theme.scaffoldBackgroundColor (defined in AppTheme)
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimens.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'How Spaced Repetition Works',
              // Use headlineSmall style from AppTheme's textTheme
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: AppDimens.spaceL),

            // Introduction
            Text(
              'Spaced repetition is a learning technique that incorporates increasing intervals of time between subsequent review of previously learned material to exploit the psychological spacing effect.',
              // Use bodyLarge style from AppTheme's textTheme
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: AppDimens.spaceL),

            // The Science - Use onSurfaceVariant color from the theme
            _buildSection(
              context,
              'The Science Behind It',
              'Spaced repetition takes advantage of the psychological spacing effect, which demonstrates that learning is more effective when study sessions are spaced out over time, rather than crammed into a single session. This technique directly addresses the "forgetting curve" - our natural tendency to forget information over time.',
              Icons.psychology,
              colorScheme.onSurfaceVariant, // Use theme color
            ),

            // How it works in this app - Use primary color from the theme
            _buildSection(
              context,
              'How It Works In This App',
              'Our app schedules your learning into optimal review intervals. After initial learning, you\'ll review the material at gradually increasing intervals: 1 day, 7 days, 16 days, and 35 days. This schedule is optimized for long-term retention.',
              Icons.schedule,
              colorScheme.primary, // Use theme color
            ),

            // Learning Cycles
            Text('Learning Cycles', style: theme.textTheme.titleLarge),
            const SizedBox(height: AppDimens.spaceM),

            // Display info for each cycle
            // Card and Divider will use cardTheme and dividerTheme from AppTheme
            _buildCycleTable(context),

            const SizedBox(height: AppDimens.spaceXL),

            // Tips - Using a specific color. Consider mapping this to theme.colorScheme.tertiary
            // or creating a theme extension if 'success' color is needed frequently.
            // For now, keeping AppColors.successLight assuming it's a specific brand/status color.
            _buildSection(
              context,
              'Tips for Effective Learning',
              '• Complete all repetitions in a cycle to maximize learning\n'
                  '• Be consistent with your study schedule\n'
                  '• Actively recall information before checking answers\n'
                  '• Connect new information to things you already know\n'
                  '• Take brief notes during each study session\n'
                  '• Review right before sleep to improve memory consolidation',
              Icons.tips_and_updates,
              // NOTE: Kept AppColors.successLight. If possible, map to a theme color
              // like colorScheme.tertiary or define in AppColors based on brightness.
              AppColors.successLight,
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for building informational sections
  Widget _buildSection(
    BuildContext context,
    String title,
    String content,
    IconData icon,
    Color color, // Accept color (now often coming from theme)
  ) {
    // Get theme for text styles
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: AppDimens.spaceXL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Icon color is now passed directly
              Icon(icon, color: color),
              const SizedBox(width: AppDimens.spaceM),
              Text(
                title,
                // Title uses the passed color and theme's titleLarge style
                style: theme.textTheme.titleLarge?.copyWith(color: color),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spaceM),
          // Content uses theme's bodyMedium style
          Text(content, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }

  // Helper widget for building the cycle table
  Widget _buildCycleTable(BuildContext context) {
    final theme = Theme.of(context);

    // Card automatically uses cardTheme from AppTheme
    return Card(
      // You can override specific theme properties if needed, e.g., elevation: 2
      // If CardTheme in AppTheme defines elevation, this value takes precedence.
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingL),
        child: Column(
          children: [
            // Table header
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Cycle',
                    // Use theme text style
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    'Description',
                    // Use theme text style
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            // Divider automatically uses dividerTheme from AppTheme
            const Divider(height: AppDimens.spaceXL),

            // Cycle rows - Uses CycleFormatter which might be theme-aware or use AppColors
            ...CycleStudied.values.map(
              (cycle) => _buildCycleRow(context, cycle),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for building a single row in the cycle table
  Widget _buildCycleRow(BuildContext context, CycleStudied cycle) {
    final theme = Theme.of(context);
    // Assuming CycleFormatter provides the appropriate color for the cycle,
    // potentially checking theme brightness internally or using AppColors.
    final color = CycleFormatter.getColor(cycle);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.spaceM),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            // Styling specific to cycle representation - likely okay to keep direct color usage here
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.paddingS,
                vertical: AppDimens.paddingXXS,
              ),
              decoration: BoxDecoration(
                // Using the specific cycle color with transparency
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppDimens.radiusS),
                border: Border.all(
                  color: color,
                ), // Border uses the specific cycle color
              ),
              child: Text(
                CycleFormatter.format(cycle),
                textAlign:
                    TextAlign.center, // Center text for better chip appearance
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: color, // Text uses the specific cycle color
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppDimens.spaceM),
          Expanded(
            flex: 3,
            child: Text(
              CycleFormatter.getDescription(cycle),
              // Use standard theme text style for description
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
