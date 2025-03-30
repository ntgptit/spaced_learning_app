import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spaced_learning_app/domain/models/learning_module.dart';
import 'package:spaced_learning_app/presentation/utils/cycle_formatter.dart';

/// Bottom sheet hiển thị chi tiết về một module học tập
class ModuleDetailsBottomSheet extends StatelessWidget {
  final LearningModule module;

  const ModuleDetailsBottomSheet({super.key, required this.module});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      maxChildSize: 0.8,
      minChildSize: 0.3,
      expand: false,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Title
                Text(module.subject, style: theme.textTheme.headlineSmall),
                Text(
                  'From: ${module.book}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                const Divider(height: 32),

                // Details grid
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _buildDetailItem(
                      context,
                      'Word Count',
                      module.wordCount.toString(),
                      Icons.text_fields,
                    ),
                    _buildDetailItem(
                      context,
                      'Progress',
                      '${module.percentage}%',
                      Icons.trending_up,
                    ),
                    _buildDetailItem(
                      context,
                      'Cycle',
                      module.cyclesStudied != null
                          ? CycleFormatter.format(module.cyclesStudied!)
                          : 'Not started',
                      Icons.loop,
                    ),
                    _buildDetailItem(
                      context,
                      'Tasks',
                      module.taskCount?.toString() ?? 'None',
                      Icons.assignment,
                    ),
                  ],
                ),

                const Divider(height: 32),

                // Dates
                if (module.firstLearningDate != null)
                  _buildDateItem(
                    context,
                    'First Learning',
                    module.firstLearningDate!,
                    Icons.play_circle,
                  ),

                if (module.nextStudyDate != null) ...[
                  const SizedBox(height: 16),
                  _buildDateItem(
                    context,
                    'Next Study',
                    module.nextStudyDate!,
                    Icons.event,
                    isUpcoming: module.nextStudyDate!.isBefore(
                      DateTime.now().add(const Duration(days: 3)),
                    ),
                  ),
                ],

                const SizedBox(height: 24),

                // Close button
                Center(
                  child: TextButton.icon(
                    icon: const Icon(Icons.close),
                    label: const Text('Close'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final theme = Theme.of(context);

    return Container(
      width: MediaQuery.of(context).size.width / 2 - 32,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateItem(
    BuildContext context,
    String label,
    DateTime date,
    IconData icon, {
    bool isUpcoming = false,
  }) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('EEEE, MMMM d, yyyy');

    return Row(
      children: [
        Icon(
          icon,
          color:
              isUpcoming ? theme.colorScheme.error : theme.colorScheme.primary,
          size: 20,
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              dateFormat.format(date),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: isUpcoming ? FontWeight.bold : null,
                color: isUpcoming ? theme.colorScheme.error : null,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
