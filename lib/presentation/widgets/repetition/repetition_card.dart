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

    final orderText = _formatRepetitionOrder(repetition.repetitionOrder);
    final statusColor = _getStatusColor(repetition.status, theme);
    final dateText =
        repetition.reviewDate != null
            ? dateFormat.format(repetition.reviewDate!)
            : 'Not scheduled';
    final timeIndicator = _getTimeIndicator(repetition.reviewDate);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: isHistory ? 1 : 2,
      color: isHistory ? theme.cardColor.withAlpha(180) : theme.cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme, orderText, statusColor),
            const SizedBox(height: 12),
            _buildDateRow(context, theme, dateText, timeIndicator),
            if (!isHistory && repetition.status == RepetitionStatus.notStarted)
              _buildActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, String orderText, Color statusColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          orderText,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor.withAlpha(50),
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
              if (repetition.status == RepetitionStatus.completed) ...[
                const SizedBox(width: 4),
                Icon(Icons.quiz, size: 12, color: statusColor),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDateRow(
    BuildContext context,
    ThemeData theme,
    String dateText,
    String timeIndicator,
  ) {
    return Row(
      children: [
        Icon(Icons.quiz, color: theme.colorScheme.primary, size: 16),
        const SizedBox(width: 8),
        Text(dateText),
        const Spacer(),
        if (repetition.reviewDate != null && !isHistory)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: _getTimeIndicatorColor(repetition.reviewDate, theme),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              timeIndicator,
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.white),
            ),
          ),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (onReschedule != null)
            _buildActionButton(
              'Reschedule',
              Icons.calendar_month,
              Colors.blue,
              onReschedule!,
            ),
          const SizedBox(width: 8),
          if (onSkip != null)
            _buildActionButton('Skip', Icons.skip_next, Colors.orange, onSkip!),
          const SizedBox(width: 8),
          if (onMarkCompleted != null)
            _buildActionButton(
              'Complete',
              Icons.check_circle,
              Colors.green,
              onMarkCompleted!,
              showScoreIndicator: true,
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
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
                  color: color.withAlpha(30),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Icon(Icons.percent, size: 10, color: color),
              ),
            ],
          ],
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: color.withAlpha(120)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
        ),
      ),
    );
  }

  String _formatRepetitionOrder(RepetitionOrder order) {
    switch (order) {
      case RepetitionOrder.firstRepetition:
        return 'Repetition 1';
      case RepetitionOrder.secondRepetition:
        return 'Repetition 2';
      case RepetitionOrder.thirdRepetition:
        return 'Repetition 3';
      case RepetitionOrder.fourthRepetition:
        return 'Repetition 4';
      case RepetitionOrder.fifthRepetition:
        return 'Repetition 5';
    }
  }

  String _formatStatus(RepetitionStatus status) {
    switch (status) {
      case RepetitionStatus.notStarted:
        return 'Pending';
      case RepetitionStatus.completed:
        return 'Completed';
      case RepetitionStatus.skipped:
        return 'Skipped';
    }
  }

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

  String _getTimeIndicator(DateTime? date) {
    if (date == null) return '';
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final difference = target.difference(today).inDays;

    if (difference < 0) return 'Overdue ${-difference}d';
    if (difference == 0) return 'Today';
    if (difference == 1) return 'Tomorrow';
    return '$difference days left';
  }

  Color _getTimeIndicatorColor(DateTime? date, ThemeData theme) {
    if (date == null) return Colors.grey;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final difference = target.difference(today).inDays;

    if (difference < 0) return Colors.red;
    if (difference == 0) return Colors.green;
    if (difference <= 3) return Colors.orange;
    return Colors.blue;
  }
}
