import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spaced_learning_app/domain/models/progress.dart';

/// Card widget to display progress summary information
class ProgressCard extends StatelessWidget {
  final ProgressSummary progress;
  final VoidCallback onTap;
  final String moduleTitle;
  final bool isDue;

  const ProgressCard({
    super.key,
    required this.progress,
    required this.onTap,
    required this.moduleTitle,
    this.isDue = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Format dates
    final dateFormat = DateFormat('MMM dd, yyyy');
    final firstLearningDateStr =
        progress.firstLearningDate != null
            ? dateFormat.format(progress.firstLearningDate!)
            : 'Not started';
    final nextStudyDateStr =
        progress.nextStudyDate != null
            ? dateFormat.format(progress.nextStudyDate!)
            : 'Not scheduled';

    // Check if next study date is today or in the past
    bool isOverdue = false;
    if (progress.nextStudyDate != null) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final nextDate = DateTime(
        progress.nextStudyDate!.year,
        progress.nextStudyDate!.month,
        progress.nextStudyDate!.day,
      );
      isOverdue = nextDate.compareTo(today) <= 0;
    }

    return Card(
      elevation: isDue ? 4 : 2,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side:
            isDue
                ? BorderSide(
                  color: isOverdue ? Colors.red : Colors.orange,
                  width: 2,
                )
                : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      moduleTitle,
                      style: theme.textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // Progress percentage
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${progress.percentComplete.toInt()}%',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress.percentComplete / 100,
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  minHeight: 8,
                ),
              ),
              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Cycle information
                  Chip(
                    label: Text(
                      _formatCycleStudied(progress.cyclesStudied),
                      style: theme.textTheme.bodySmall,
                    ),
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    padding: EdgeInsets.zero,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),

                  // Repetition count
                  Row(
                    children: [
                      const Icon(Icons.repeat, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${progress.repetitionCount} repetitions',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Dates
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _buildDateInfo(
                      context,
                      'Started:',
                      firstLearningDateStr,
                      Icons.play_circle_outline,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDateInfo(
                      context,
                      'Next:',
                      nextStudyDateStr,
                      Icons.event,
                      isImportant: isOverdue,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build date information widget
  Widget _buildDateInfo(
    BuildContext context,
    String label,
    String date,
    IconData icon, {
    bool isImportant = false,
  }) {
    final theme = Theme.of(context);
    final textColor =
        isImportant ? Colors.red : theme.textTheme.bodySmall?.color;

    return Row(
      children: [
        Icon(icon, size: 16, color: textColor),
        const SizedBox(width: 4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: theme.textTheme.bodySmall),
              Text(
                date,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: textColor,
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

  /// Format cycle studied enum value to display string
  String _formatCycleStudied(CycleStudied cycle) {
    switch (cycle) {
      case CycleStudied.firstTime:
        return 'First Time';
      case CycleStudied.firstReview:
        return 'First Review';
      case CycleStudied.secondReview:
        return 'Second Review';
      case CycleStudied.thirdReview:
        return 'Third Review';
      case CycleStudied.moreThanThreeReviews:
        return 'Multiple Reviews';
    }
  }
}
