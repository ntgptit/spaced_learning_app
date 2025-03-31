import 'package:flutter/material.dart';

/// Widget to display learning insights on the home screen
class LearningInsightsWidget extends StatelessWidget {
  final double vocabularyRate;
  final int streakDays;
  final int pendingWords;
  final int dueToday;

  const LearningInsightsWidget({
    super.key,
    required this.vocabularyRate,
    required this.streakDays,
    required this.pendingWords,
    required this.dueToday,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.insights, color: theme.colorScheme.tertiary),
                const SizedBox(width: 8),
                Text('Learning Insights', style: theme.textTheme.titleLarge),
              ],
            ),
            const Divider(),

            // Learning insights
            _buildInsightItem(
              context,
              'You learn ${vocabularyRate.toStringAsFixed(1)}% new vocabulary each week',
              Icons.trending_up,
              Colors.blue,
            ),
            _buildInsightItem(
              context,
              'Your current streak is $streakDays days - keep going!',
              Icons.local_fire_department,
              Colors.orange,
            ),
            _buildInsightItem(
              context,
              'You have $pendingWords words pending to learn',
              Icons.menu_book,
              Colors.teal,
            ),
            _buildInsightItem(
              context,
              'Complete today\'s $dueToday sessions to maintain your streak',
              Icons.today,
              Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  /// Build an insight item
  Widget _buildInsightItem(
    BuildContext context,
    String message,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(message, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
