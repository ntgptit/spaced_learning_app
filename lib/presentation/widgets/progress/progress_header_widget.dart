// lib/presentation/screens/progress/widgets/progress_header_widget.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:spaced_learning_app/domain/models/progress.dart';
import 'package:spaced_learning_app/domain/models/repetition.dart';
import 'package:spaced_learning_app/presentation/viewmodels/repetition_viewmodel.dart';

class ProgressHeaderWidget extends StatelessWidget {
  final ProgressDetail progress;
  final VoidCallback onCycleCompleteDialogRequested;

  const ProgressHeaderWidget({
    super.key,
    required this.progress,
    required this.onCycleCompleteDialogRequested,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final repetitionViewModel = context.watch<RepetitionViewModel>();
    final dateFormat = DateFormat('MMM dd, yyyy');

    // Format dates
    final startDateText =
        progress.firstLearningDate != null
            ? dateFormat.format(progress.firstLearningDate!)
            : 'Not started';

    final nextDateText =
        progress.nextStudyDate != null
            ? dateFormat.format(progress.nextStudyDate!)
            : 'Not scheduled';

    // Calculate completed repetitions
    final completedCount =
        progress.repetitions
            .where((r) => r.status == RepetitionStatus.completed)
            .length;
    final totalCount = progress.repetitions.length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Module title
            Text(
              progress.moduleTitle ?? 'Module',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            // Progress bar for overall completion
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tiến độ tổng thể',
                      style: theme.textTheme.titleMedium,
                    ),
                    Text(
                      '${progress.percentComplete.toInt()}%',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress.percentComplete / 100,
                    minHeight: 10,
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Cycle progress section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chu kỳ học: ${_formatCycleStudied(progress.cyclesStudied)}',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 8),

                // Show progress in current cycle
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: totalCount > 0 ? completedCount / totalCount : 0,
                    minHeight: 10,
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                    color: theme.colorScheme.secondary,
                  ),
                ),

                const SizedBox(height: 4),
                Text(
                  '$completedCount/$totalCount lần ôn tập hoàn thành trong chu kỳ này',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 8),

                // Show cycle info
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lightbulb,
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          repetitionViewModel.getCycleInfo(
                            progress.cyclesStudied,
                          ),
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Metadata
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    theme,
                    'Bắt đầu',
                    startDateText,
                    Icons.play_circle_outline,
                  ),
                ),
                Expanded(
                  child: _buildInfoItem(
                    theme,
                    'Ôn tập tiếp theo',
                    nextDateText,
                    Icons.event,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Build an info item
  Widget _buildInfoItem(
    ThemeData theme,
    String label,
    String value,
    IconData icon,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: theme.textTheme.bodySmall),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Format cycle studied enum to user-friendly string
  String _formatCycleStudied(CycleStudied cycle) {
    switch (cycle) {
      case CycleStudied.firstTime:
        return 'Chu kỳ đầu tiên';
      case CycleStudied.firstReview:
        return 'Chu kỳ ôn tập thứ nhất';
      case CycleStudied.secondReview:
        return 'Chu kỳ ôn tập thứ hai';
      case CycleStudied.thirdReview:
        return 'Chu kỳ ôn tập thứ ba';
      case CycleStudied.moreThanThreeReviews:
        return 'Đã ôn tập nhiều hơn 3 chu kỳ';
    }
  }
}
