import 'package:flutter/material.dart';
import 'package:spaced_learning_app/domain/models/progress.dart';
import 'package:spaced_learning_app/presentation/utils/cycle_formatter.dart';

/// Dialog hiển thị thông tin trợ giúp về màn hình Learning Progress
class LearningHelpDialog extends StatelessWidget {
  const LearningHelpDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.help_outline, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          const Text('Learning Progress Help'),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'This screen shows your learning progress across all modules.',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            const _HelpSection(
              title: 'Features',
              items: [
                '• Use the Book filter to view modules from a specific book',
                '• Use the Date filter to see modules due on a specific date',
                '• Click on any module to see detailed information',
                '• The Progress column shows your completion percentage',
                '• Due dates highlighted in red are approaching soon',
                '• Export your data using the Export button in the footer',
              ],
            ),

            const SizedBox(height: 16),

            _HelpSection(
              title: 'Learning Cycles',
              items: [
                for (final cycle in CycleStudied.values)
                  '• ${CycleFormatter.format(cycle)}: ${CycleFormatter.getDescription(cycle)}',
              ],
            ),

            const SizedBox(height: 16),

            const _HelpSection(
              title: 'Tips',
              items: [
                '• Review your learning material according to the spaced repetition schedule',
                '• Focus on modules that are due soon',
                '• Complete all repetitions in a cycle before moving to the next one',
                '• Use the export feature to keep track of your progress over time',
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}

/// Widget hiển thị một phần trong dialog trợ giúp
class _HelpSection extends StatelessWidget {
  final String title;
  final List<String> items;

  const _HelpSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(item),
          ),
        ),
      ],
    );
  }
}
