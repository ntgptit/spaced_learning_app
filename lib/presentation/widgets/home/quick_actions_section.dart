import 'package:flutter/material.dart';

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
    return Column(
      children: [
        Row(
          children: [
            _buildActionCard(
              context,
              'Browse Books',
              Icons.book,
              onBrowseBooksPressed,
            ),
            const SizedBox(width: 16),
            _buildActionCard(
              context,
              'Today\'s Learning',
              Icons.assignment,
              onTodaysLearningPressed,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildActionCard(
              context,
              'Progress Report',
              Icons.bar_chart,
              onProgressReportPressed,
            ),
            const SizedBox(width: 16),
            _buildActionCard(
              context,
              'Vocabulary Stats',
              Icons.menu_book,
              onVocabularyStatsPressed,
            ),
          ],
        ),
      ],
    );
  }

  /// Build a single action card for the quick actions section
  Widget _buildActionCard(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);

    return Expanded(
      child: Card(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 32, color: theme.colorScheme.primary),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: theme.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
