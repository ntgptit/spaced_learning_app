import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spaced_learning_app/domain/models/repetition.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_button.dart';

/// Card widget to display repetition information
class RepetitionCard extends StatelessWidget {
  final Repetition repetition;
  final VoidCallback? onMarkCompleted;
  final VoidCallback? onSkip;
  final VoidCallback? onReschedule;
  final bool isActive;

  const RepetitionCard({
    super.key,
    required this.repetition,
    this.onMarkCompleted,
    this.onSkip,
    this.onReschedule,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Format review date
    final dateFormat = DateFormat('MMM dd, yyyy');
    final reviewDateStr =
        repetition.reviewDate != null
            ? dateFormat.format(repetition.reviewDate!)
            : 'Not scheduled';

    // Check if review date is today or in the past
    bool isOverdue = false;
    bool isToday = false;

    if (repetition.reviewDate != null) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final reviewDate = DateTime(
        repetition.reviewDate!.year,
        repetition.reviewDate!.month,
        repetition.reviewDate!.day,
      );

      isOverdue = reviewDate.compareTo(today) < 0;
      isToday = reviewDate.compareTo(today) == 0;
    }

    // Status color and text
    Color statusColor;
    String statusText;

    switch (repetition.status) {
      case RepetitionStatus.notStarted:
        if (isOverdue) {
          statusColor = Colors.red;
          statusText = 'Overdue';
        } else if (isToday) {
          statusColor = Colors.orange;
          statusText = 'Due Today';
        } else {
          statusColor = Colors.blue;
          statusText = 'Scheduled';
        }
        break;
      case RepetitionStatus.completed:
        statusColor = Colors.green;
        statusText = 'Completed';
        break;
      case RepetitionStatus.skipped:
        statusColor = Colors.grey;
        statusText = 'Skipped';
        break;
    }

    return Card(
      elevation: isActive ? 3 : 1,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side:
            isActive
                ? BorderSide(color: colorScheme.primary, width: 2)
                : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Repetition order (1st, 2nd, etc.)
                Text(
                  _formatRepetitionOrder(repetition.repetitionOrder),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),

                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    statusText,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Review date
            Row(
              children: [
                const Icon(Icons.event, size: 16),
                const SizedBox(width: 4),
                Text(
                  'Review date: $reviewDateStr',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color:
                        isOverdue &&
                                repetition.status == RepetitionStatus.notStarted
                            ? Colors.red
                            : null,
                  ),
                ),
              ],
            ),

            // Action buttons if not completed or skipped
            if (repetition.status == RepetitionStatus.notStarted) ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (onMarkCompleted != null)
                    AppButton(
                      text: 'Mark Completed',
                      type: AppButtonType.primary,
                      icon: Icons.check,
                      onPressed: onMarkCompleted,
                    ),
                  if (onMarkCompleted != null && onSkip != null)
                    const SizedBox(width: 8),
                  if (onSkip != null)
                    AppButton(
                      text: 'Skip',
                      type: AppButtonType.outline,
                      icon: Icons.skip_next,
                      onPressed: onSkip,
                    ),
                  if ((onMarkCompleted != null || onSkip != null) &&
                      onReschedule != null)
                    const SizedBox(width: 8),
                  if (onReschedule != null)
                    AppButton(
                      text: '',
                      type: AppButtonType.text,
                      icon: Icons.calendar_today,
                      onPressed: onReschedule,
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Format repetition order enum value to display string
  String _formatRepetitionOrder(RepetitionOrder order) {
    switch (order) {
      case RepetitionOrder.firstRepetition:
        return '1st Repetition';
      case RepetitionOrder.secondRepetition:
        return '2nd Repetition';
      case RepetitionOrder.thirdRepetition:
        return '3rd Repetition';
      case RepetitionOrder.fourthRepetition:
        return '4th Repetition';
      case RepetitionOrder.fifthRepetition:
        return '5th Repetition';
    }
  }
}
