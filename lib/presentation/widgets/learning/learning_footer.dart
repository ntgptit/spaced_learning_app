import 'package:flutter/material.dart';

/// Footer hiển thị ở cuối màn hình Learning Progress
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
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Progress summary
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Learning Progress', style: theme.textTheme.titleSmall),
                const SizedBox(height: 4),
                RichText(
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
              ],
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
            ),
        ],
      ),
    );
  }
}
