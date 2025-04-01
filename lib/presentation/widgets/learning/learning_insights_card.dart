import 'package:flutter/material.dart';
import 'package:spaced_learning_app/domain/models/learning_insight.dart';

/// Card widget that displays learning insights
class LearningInsightsCard extends StatelessWidget {
  final List<LearningInsightDTO> insights;
  final String? title;
  final VoidCallback? onViewMorePressed;

  const LearningInsightsCard({
    super.key,
    required this.insights,
    this.title,
    this.onViewMorePressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Sort insights by priority, show only top 4 if more
    final sortedInsights = List<LearningInsightDTO>.from(insights)
      ..sort((a, b) => a.priority.compareTo(b.priority));

    final displayInsights =
        sortedInsights.length > 4
            ? sortedInsights.sublist(0, 4)
            : sortedInsights;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme),
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),
            if (displayInsights.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Text('No insights available'),
                ),
              )
            else
              ...displayInsights.map(
                (insight) => _buildInsightItem(context, insight),
              ),

            if (onViewMorePressed != null && insights.length > 4) ...[
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
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
    return Row(
      children: [
        Icon(Icons.lightbulb_outline, color: Colors.amber.shade700),
        const SizedBox(width: 8),
        Text(title ?? 'Learning Insights', style: theme.textTheme.titleLarge),
      ],
    );
  }

  Widget _buildInsightItem(BuildContext context, LearningInsightDTO insight) {
    final theme = Theme.of(context);
    final Color color = _getColorFromString(insight.color);
    final IconData icon = _getIconFromString(insight.icon);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(insight.message, style: theme.textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }

  Color _getColorFromString(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'blue':
        return Colors.blue;
      case 'red':
        return Colors.red;
      case 'green':
        return Colors.green;
      case 'orange':
        return Colors.orange;
      case 'purple':
        return Colors.purple;
      case 'teal':
        return Colors.teal;
      case 'amber':
        return Colors.amber;
      case 'indigo':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  IconData _getIconFromString(String iconName) {
    switch (iconName) {
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
      default:
        return Icons.info_outline;
    }
  }
}
