// lib/presentation/widgets/repetition/repetition_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spaced_learning_app/domain/models/repetition.dart';

class RepetitionCard extends StatelessWidget {
  final Repetition repetition;
  final bool isHistory;
  final VoidCallback? onMarkCompleted;
  final VoidCallback? onSkip;
  final VoidCallback? onReschedule;

  const RepetitionCard({
    super.key,
    required this.repetition,
    this.isHistory = false,
    this.onMarkCompleted,
    this.onSkip,
    this.onReschedule,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('dd MMM yyyy');

    // Format repetition order
    final orderText = _formatRepetitionOrder(repetition.repetitionOrder);

    // Determine status color
    final statusColor = _getStatusColor(repetition.status, theme);

    // Format date
    final dateText =
        repetition.reviewDate != null
            ? dateFormat.format(repetition.reviewDate!)
            : 'Chưa lên lịch';

    // Calculate days left or overdue
    final String timeIndicator = _getTimeIndicator(repetition.reviewDate);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: isHistory ? 1 : 2,
      color:
          isHistory ? theme.cardColor.withValues(alpha: 0.7) : theme.cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with order and status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Order
                Text(
                  orderText,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // Status
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatStatus(repetition.status),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // Hiển thị biểu tượng quiz cho các mục đã hoàn thành
                      if (repetition.status == RepetitionStatus.completed) ...[
                        const SizedBox(width: 4),
                        Icon(Icons.quiz, size: 12, color: statusColor),
                      ],
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Date information
            Row(
              children: [
                Icon(Icons.quiz, color: theme.colorScheme.primary, size: 16),
                const SizedBox(width: 8),
                Text(dateText),
                const Spacer(),

                if (repetition.reviewDate != null && !isHistory) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: _getTimeIndicatorColor(
                        repetition.reviewDate,
                        theme,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      timeIndicator,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ],
            ),

            // Action buttons for non-history items
            if (!isHistory &&
                repetition.status == RepetitionStatus.notStarted) ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Reschedule
                  if (onReschedule != null)
                    _buildActionButton(
                      context,
                      'Lịch',
                      Icons.calendar_month,
                      Colors.blue,
                      onReschedule!,
                    ),
                  const SizedBox(width: 8),

                  // Skip
                  if (onSkip != null)
                    _buildActionButton(
                      context,
                      'Bỏ qua',
                      Icons.skip_next,
                      Colors.orange,
                      onSkip!,
                    ),
                  const SizedBox(width: 8),

                  // Complete with quiz score input
                  if (onMarkCompleted != null)
                    _buildActionButton(
                      context,
                      'Hoàn thành',
                      Icons.check_circle,
                      Colors.green,
                      onMarkCompleted!,
                      showScoreIndicator: true,
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Build an action button
  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed, {
    bool showScoreIndicator = false,
  }) {
    return SizedBox(
      height: 36,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 16, color: color),
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: TextStyle(color: color, fontSize: 12)),
            if (showScoreIndicator) ...[
              const SizedBox(width: 3),
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Icon(Icons.percent, size: 10, color: color),
              ),
            ],
          ],
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: color.withValues(alpha: 0.5)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
        ),
      ),
    );
  }

  /// Format repetition order to user-friendly string
  String _formatRepetitionOrder(RepetitionOrder order) {
    switch (order) {
      case RepetitionOrder.firstRepetition:
        return 'Lần ôn tập thứ 1';
      case RepetitionOrder.secondRepetition:
        return 'Lần ôn tập thứ 2';
      case RepetitionOrder.thirdRepetition:
        return 'Lần ôn tập thứ 3';
      case RepetitionOrder.fourthRepetition:
        return 'Lần ôn tập thứ 4';
      case RepetitionOrder.fifthRepetition:
        return 'Lần ôn tập thứ 5';
    }
  }

  /// Format status to user-friendly string
  String _formatStatus(RepetitionStatus status) {
    switch (status) {
      case RepetitionStatus.notStarted:
        return 'Chưa học';
      case RepetitionStatus.completed:
        return 'Đã hoàn thành';
      case RepetitionStatus.skipped:
        return 'Đã bỏ qua';
    }
  }

  /// Get status color based on repetition status
  Color _getStatusColor(RepetitionStatus status, ThemeData theme) {
    switch (status) {
      case RepetitionStatus.notStarted:
        return theme.colorScheme.primary;
      case RepetitionStatus.completed:
        return Colors.green;
      case RepetitionStatus.skipped:
        return Colors.orange;
    }
  }

  /// Get time indicator text (days left or overdue)
  String _getTimeIndicator(DateTime? date) {
    if (date == null) return '';

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final reviewDate = DateTime(date.year, date.month, date.day);

    final difference = reviewDate.difference(today).inDays;

    if (difference < 0) {
      return 'Trễ ${-difference} ngày';
    } else if (difference == 0) {
      return 'Hôm nay';
    } else if (difference == 1) {
      return 'Ngày mai';
    } else {
      return 'Còn $difference ngày';
    }
  }

  /// Get time indicator color based on days left
  Color _getTimeIndicatorColor(DateTime? date, ThemeData theme) {
    if (date == null) return Colors.grey;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final reviewDate = DateTime(date.year, date.month, date.day);

    final difference = reviewDate.difference(today).inDays;

    if (difference < 0) {
      return Colors.red; // Overdue
    } else if (difference == 0) {
      return Colors.green; // Today
    } else if (difference <= 3) {
      return Colors.orange; // Coming soon
    } else {
      return Colors.blue; // Future
    }
  }
}
