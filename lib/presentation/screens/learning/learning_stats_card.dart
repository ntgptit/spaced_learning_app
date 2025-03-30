// lib/presentation/widgets/learning/learning_stats_card.dart
import 'package:flutter/material.dart';

class LearningStatsCard extends StatelessWidget {
  final int totalModules;
  final int completedModules;
  final int inProgressModules;
  final int dueModules;
  final VoidCallback? onViewProgress;

  const LearningStatsCard({
    super.key,
    required this.totalModules,
    required this.completedModules,
    required this.inProgressModules,
    required this.dueModules,
    this.onViewProgress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.school, color: colorScheme.primary, size: 24),
                const SizedBox(width: 8),
                Text('Learning Progress', style: theme.textTheme.titleLarge),
                const Spacer(),
                TextButton.icon(
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('View All'),
                  onPressed: onViewProgress,
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumn(
                  context: context,
                  label: 'Total',
                  value: totalModules,
                  color: colorScheme.primary,
                  icon: Icons.menu_book,
                ),
                _buildDivider(),
                _buildStatColumn(
                  context: context,
                  label: 'Completed',
                  value: completedModules,
                  color: Colors.green,
                  icon: Icons.check_circle,
                ),
                _buildDivider(),
                _buildStatColumn(
                  context: context,
                  label: 'In Progress',
                  value: inProgressModules,
                  color: Colors.orange,
                  icon: Icons.pending,
                ),
                _buildDivider(),
                _buildStatColumn(
                  context: context,
                  label: 'Due Soon',
                  value: dueModules,
                  color: Colors.red,
                  icon: Icons.alarm,
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: totalModules > 0 ? completedModules / totalModules : 0,
                minHeight: 10,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              totalModules > 0
                  ? '${(completedModules / totalModules * 100).toStringAsFixed(1)}% Complete'
                  : 'No modules available',
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn({
    required BuildContext context,
    required String label,
    required int value,
    required Color color,
    required IconData icon,
  }) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value.toString(),
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: theme.textTheme.bodySmall),
      ],
    );
  }

  Widget _buildDivider() {
    return SizedBox(
      height: 50,
      child: VerticalDivider(
        color: Colors.grey.withValues(alpha: 0.3),
        thickness: 1,
        width: 1,
      ),
    );
  }
}
