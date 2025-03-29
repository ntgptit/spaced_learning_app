// lib/presentation/widgets/repetition/repetition_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spaced_learning_app/domain/models/repetition.dart';

class RepetitionCard extends StatelessWidget {
  final Repetition repetition;
  final VoidCallback? onMarkCompleted;
  final VoidCallback? onSkip;
  final VoidCallback? onReschedule;

  const RepetitionCard({
    super.key,
    required this.repetition,
    this.onMarkCompleted,
    this.onSkip,
    this.onReschedule,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('MMM dd, yyyy');

    // Get repetition order text
    final String repetitionOrderText = getRepetitionOrderText();

    // Determine if this repetition is due
    bool isDue = false;
    if (repetition.reviewDate != null &&
        repetition.status == RepetitionStatus.notStarted) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final reviewDay = DateTime(
        repetition.reviewDate!.year,
        repetition.reviewDate!.month,
        repetition.reviewDate!.day,
      );
      isDue = reviewDay.compareTo(today) <= 0;
    }

    // Determine status colors
    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (repetition.status) {
      case RepetitionStatus.completed:
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        statusText = 'Completed';
        break;
      case RepetitionStatus.skipped:
        statusColor = Colors.orange;
        statusIcon = Icons.skip_next;
        statusText = 'Skipped';
        break;
      case RepetitionStatus.notStarted:
        statusColor = isDue ? Colors.red : Colors.blue;
        statusIcon = isDue ? Icons.warning : Icons.access_time;
        statusText = isDue ? 'Due now' : 'Upcoming';
        break;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isDue ? theme.colorScheme.errorContainer.withOpacity(0.3) : null,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Repetition header
                Row(
                  children: [
                    Icon(statusIcon, color: statusColor),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        repetitionOrderText,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
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

                // Scheduled date
                if (repetition.reviewDate != null)
                  Row(
                    children: [
                      const Icon(Icons.event, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        'Scheduled for: ${dateFormat.format(repetition.reviewDate!)}',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),

                // Actions for not completed repetitions
                if (repetition.status == RepetitionStatus.notStarted) ...[
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (onReschedule != null)
                        TextButton.icon(
                          icon: const Icon(Icons.calendar_today),
                          label: const Text('Reschedule'),
                          onPressed: onReschedule,
                        ),
                      if (onSkip != null) ...[
                        const SizedBox(width: 8),
                        TextButton.icon(
                          icon: const Icon(Icons.skip_next),
                          label: const Text('Skip'),
                          onPressed: onSkip,
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.orange,
                          ),
                        ),
                      ],
                      if (onMarkCompleted != null) ...[
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.check),
                          label: const Text('Complete'),
                          onPressed: onMarkCompleted,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ],
            ),
          ),

          // Completion hint for fifth repetition
          buildCompletionHint(theme),
        ],
      ),
    );
  }

  /// Get user-friendly repetition order text
  String getRepetitionOrderText() {
    switch (repetition.repetitionOrder) {
      case RepetitionOrder.firstRepetition:
        return 'Lần ôn tập thứ 1 (trong chu kỳ hiện tại)';
      case RepetitionOrder.secondRepetition:
        return 'Lần ôn tập thứ 2 (trong chu kỳ hiện tại)';
      case RepetitionOrder.thirdRepetition:
        return 'Lần ôn tập thứ 3 (trong chu kỳ hiện tại)';
      case RepetitionOrder.fourthRepetition:
        return 'Lần ôn tập thứ 4 (trong chu kỳ hiện tại)';
      case RepetitionOrder.fifthRepetition:
        return 'Lần ôn tập thứ 5 (trong chu kỳ hiện tại)';
    }
  }

  /// Build completion hint for final repetition
  Widget buildCompletionHint(ThemeData theme) {
    if (repetition.repetitionOrder == RepetitionOrder.fifthRepetition &&
        repetition.status != RepetitionStatus.completed) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.lightbulb, color: theme.colorScheme.primary, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Đây là lần ôn tập cuối cùng trong chu kỳ hiện tại. Hoàn thành để chuyển sang chu kỳ tiếp theo!',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
