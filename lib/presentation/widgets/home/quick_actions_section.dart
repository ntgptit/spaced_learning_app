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
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildActionCard(
          context,
          'Browse Books',
          Icons.book,
          onBrowseBooksPressed,
          color: Colors.blueAccent,
        ),
        _buildActionCard(
          context,
          'Today\'s Learning',
          Icons.assignment,
          onTodaysLearningPressed,
          color: Colors.green,
        ),
        _buildActionCard(
          context,
          'Progress Report',
          Icons.bar_chart,
          onProgressReportPressed,
          color: Colors.orange,
        ),
        _buildActionCard(
          context,
          'Vocabulary Stats',
          Icons.menu_book,
          onVocabularyStatsPressed,
          color: Colors.purple,
        ),
      ],
    );
  }

  /// Build a single action card for the quick actions section
  Widget _buildActionCard(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap, {
    Color? color,
  }) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      color: color?.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: color ?? theme.colorScheme.primary),
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
    );
  }
}
