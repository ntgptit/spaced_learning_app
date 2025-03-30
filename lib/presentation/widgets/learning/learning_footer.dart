// lib/presentation/widgets/learning/learning_footer.dart
import 'package:flutter/material.dart';

/// Footer widget displayed at the bottom of the Learning Progress screen
/// Fixed to avoid overflow issues
class LearningFooter extends StatelessWidget {
  final int totalModules;
  final int completedModules;
  final VoidCallback? onExportData;
  final VoidCallback? onHelpPressed;

  const LearningFooter({
    super.key,
    required this.totalModules,
    required this.completedModules,
    this.onExportData,
    this.onHelpPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    final completionPercentage =
        totalModules > 0
            ? (completedModules / totalModules * 100).toStringAsFixed(1)
            : '0.0';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      // Use a more compact layout, especially for small screens
      child:
          isSmallScreen
              ? _buildSmallScreenLayout(theme, completionPercentage)
              : _buildWideScreenLayout(theme, completionPercentage),
    );
  }

  /// Build layout for small screens (stacked vertically)
  Widget _buildSmallScreenLayout(ThemeData theme, String completionPercentage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Progress summary text - using shorter format
        RichText(
          text: TextSpan(
            style: theme.textTheme.bodySmall,
            children: [
              TextSpan(
                text: 'Completed: ',
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
              TextSpan(
                text: '$completedModules/$totalModules ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              TextSpan(
                text: '($completionPercentage%)',
                style: TextStyle(color: theme.colorScheme.secondary),
              ),
            ],
          ),
        ),

        // Action buttons in a row - use compact buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Export button
            if (onExportData != null)
              TextButton.icon(
                onPressed: onExportData,
                icon: const Icon(Icons.download, size: 16),
                label: const Text('Export'),
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 0,
                  ),
                ),
              ),

            // Help button
            if (onHelpPressed != null)
              IconButton(
                onPressed: onHelpPressed,
                icon: const Icon(Icons.help_outline, size: 16),
                tooltip: 'Help',
                visualDensity: VisualDensity.compact,
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(6),
              ),
          ],
        ),
      ],
    );
  }

  /// Build layout for wide screens (row layout)
  Widget _buildWideScreenLayout(ThemeData theme, String completionPercentage) {
    return Row(
      children: [
        // Progress summary
        Expanded(
          child: RichText(
            text: TextSpan(
              style: theme.textTheme.bodySmall,
              children: [
                TextSpan(
                  text: 'Completed: ',
                  style: TextStyle(color: theme.colorScheme.onSurface),
                ),
                TextSpan(
                  text: '$completedModules of $totalModules modules ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                TextSpan(
                  text: '($completionPercentage%)',
                  style: TextStyle(color: theme.colorScheme.secondary),
                ),
              ],
            ),
          ),
        ),

        // Export button
        if (onExportData != null)
          TextButton.icon(
            onPressed: onExportData,
            icon: const Icon(Icons.download),
            label: const Text('Export'),
            style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
          ),

        // Help button
        if (onHelpPressed != null)
          IconButton(
            onPressed: onHelpPressed,
            icon: const Icon(Icons.help_outline),
            tooltip: 'Help',
            visualDensity: VisualDensity.compact,
          ),
      ],
    );
  }
}
