import 'package:flutter/material.dart';
import 'package:spaced_learning_app/domain/models/progress.dart';
import 'package:spaced_learning_app/presentation/utils/cycle_formatter.dart';

/// Dialog hiển thị thông tin trợ giúp về màn hình Learning Progress
/// Phiên bản cải tiến tránh lỗi overflow
class LearningHelpDialog extends StatelessWidget {
  const LearningHelpDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    // Adjust content based on screen size
    final bool isSmallScreen = size.width < 600;
    final double maxDialogWidth = isSmallScreen ? size.width * 0.95 : 500.0;
    final double maxDialogHeight = size.height * 0.7;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: maxDialogWidth,
          maxHeight: maxDialogHeight,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Dialog header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(Icons.help_outline, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Learning Progress Help',
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip: 'Close',
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Dialog content - with scrolling for overflow safety
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'This screen shows your learning progress across all modules.',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),

                    _buildHelpSection(context, 'Features', [
                      '• Use the Book filter to view modules from a specific book',
                      '• Use the Date filter to see modules due on a specific date',
                      '• Click on any module to see detailed information',
                      '• The Progress column shows your completion percentage',
                      '• Due dates highlighted in red are approaching soon',
                      '• Export your data using the Export button in the footer',
                    ]),

                    const SizedBox(height: 16),

                    _buildHelpSection(context, 'Learning Cycles', [
                      for (final cycle in CycleStudied.values)
                        '• ${CycleFormatter.format(cycle)}: ${CycleFormatter.getDescription(cycle)}',
                    ]),

                    const SizedBox(height: 16),

                    _buildHelpSection(context, 'Tips', [
                      '• Review your learning material according to the spaced repetition schedule',
                      '• Focus on modules that are due soon',
                      '• Complete all repetitions in a cycle before moving to the next one',
                      '• Use the export feature to keep track of your progress over time',
                    ]),
                  ],
                ),
              ),
            ),

            // Dialog footer
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget hiển thị một phần trong dialog trợ giúp với mức độ nén tùy chỉnh
  Widget _buildHelpSection(
    BuildContext context,
    String title,
    List<String> items,
  ) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isCompact = size.width < 360; // Extra compact for very small screens

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        ...items.map(
          (item) => Padding(
            padding: EdgeInsets.only(
              bottom: isCompact ? 2 : 4,
              left: isCompact ? 0 : 4,
            ),
            child: Text(
              item,
              style:
                  isCompact
                      ? theme.textTheme.bodySmall
                      : theme.textTheme.bodyMedium,
            ),
          ),
        ),
      ],
    );
  }
}
