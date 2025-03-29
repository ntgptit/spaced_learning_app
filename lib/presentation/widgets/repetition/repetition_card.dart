// lib/presentation/widgets/repetition_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spaced_learning_app/domain/models/repetition.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_button.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_card.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_progress_indicator.dart';

class RepetitionCard extends StatelessWidget {
  final Repetition repetition;
  final VoidCallback? onStart;
  final VoidCallback? onComplete;
  final VoidCallback? onSkip;
  final VoidCallback? onMarkCompleted; // Add this
  final VoidCallback? onReschedule; // Add this

  const RepetitionCard({
    super.key,
    required this.repetition,
    this.onStart,
    this.onComplete,
    this.onSkip,
    this.onMarkCompleted,
    this.onReschedule,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Format review date
    final dateFormatter = DateFormat('EEEE, MMMM d, yyyy');
    final reviewDateText =
        repetition.reviewDate != null
            ? dateFormatter.format(repetition.reviewDate!)
            : 'Not scheduled';

    // Status color
    Color statusColor;
    switch (repetition.status) {
      case RepetitionStatus.completed:
        statusColor = Colors.green;
        break;
      case RepetitionStatus.skipped:
        statusColor = Colors.orange;
        break;
      case RepetitionStatus.notStarted:
        statusColor = colorScheme.primary;
        break;
    }

    // Progress value based on repetition order
    double progressValue;
    switch (repetition.repetitionOrder) {
      case RepetitionOrder.firstRepetition:
        progressValue = 0.2;
        break;
      case RepetitionOrder.secondRepetition:
        progressValue = 0.4;
        break;
      case RepetitionOrder.thirdRepetition:
        progressValue = 0.6;
        break;
      case RepetitionOrder.fourthRepetition:
        progressValue = 0.8;
        break;
      case RepetitionOrder.fifthRepetition:
        progressValue = 1.0;
        break;
    }

    // Repetition label
    String repetitionLabel;
    switch (repetition.repetitionOrder) {
      case RepetitionOrder.firstRepetition:
        repetitionLabel = '1st Review';
        break;
      case RepetitionOrder.secondRepetition:
        repetitionLabel = '2nd Review';
        break;
      case RepetitionOrder.thirdRepetition:
        repetitionLabel = '3rd Review';
        break;
      case RepetitionOrder.fourthRepetition:
        repetitionLabel = '4th Review';
        break;
      case RepetitionOrder.fifthRepetition:
        repetitionLabel = 'Final Review';
        break;
    }

    return AppCard(
      title: Text(repetitionLabel),
      leading: SizedBox(
        width: 50,
        child: AppProgressIndicator(
          type: ProgressType.circular,
          value: progressValue,
          size: 50,
          child: Text(
            '${(progressValue * 100).toInt()}%',
            style: theme.textTheme.bodySmall!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 16, color: colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'Review date:',
                style: theme.textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(reviewDateText, style: theme.textTheme.bodyMedium),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.lens, size: 16, color: statusColor),
              const SizedBox(width: 8),
              Text(
                'Status:',
                style: theme.textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                _formatStatus(repetition.status),
                style: theme.textTheme.bodyMedium!.copyWith(
                  color: statusColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
      actions: _buildActions(context, repetition.status),
    );
  }

  String _formatStatus(RepetitionStatus status) {
    switch (status) {
      case RepetitionStatus.completed:
        return 'Completed';
      case RepetitionStatus.skipped:
        return 'Skipped';
      case RepetitionStatus.notStarted:
        return 'Not Started';
    }
  }

  List<Widget> _buildActions(BuildContext context, RepetitionStatus status) {
    final actions = <Widget>[];

    switch (status) {
      case RepetitionStatus.notStarted:
        if (onReschedule != null) {
          actions.add(
            AppButton(
              text: 'Reschedule',
              onPressed: onReschedule,
              type: AppButtonType.outline,
              size: AppButtonSize.small,
              prefixIcon: Icons.calendar_month,
            ),
          );
        }
        if (onSkip != null) {
          actions.add(
            AppButton(
              text: 'Skip',
              onPressed: onSkip,
              type: AppButtonType.text,
              size: AppButtonSize.small,
            ),
          );
        }
        if (onStart != null) {
          actions.add(
            AppButton(
              text: 'Start',
              onPressed: onStart,
              type: AppButtonType.primary,
              size: AppButtonSize.small,
              prefixIcon: Icons.play_arrow,
            ),
          );
        }
        if (onMarkCompleted != null) {
          actions.add(
            AppButton(
              text: 'Mark Done',
              onPressed: onMarkCompleted,
              type: AppButtonType.success,
              size: AppButtonSize.small,
              prefixIcon: Icons.check_circle,
            ),
          );
        }
        break;

      case RepetitionStatus.completed:
        // No actions for completed status, just show status
        actions.add(
          const AppButton(
            text: 'Completed',
            onPressed: null,
            type: AppButtonType.outline,
            size: AppButtonSize.small,
            prefixIcon: Icons.check_circle,
            textColor: Colors.green,
          ),
        );
        break;

      case RepetitionStatus.skipped:
        if (onReschedule != null) {
          actions.add(
            AppButton(
              text: 'Reschedule',
              onPressed: onReschedule,
              type: AppButtonType.outline,
              size: AppButtonSize.small,
              prefixIcon: Icons.calendar_month,
            ),
          );
        }
        if (onStart != null) {
          actions.add(
            AppButton(
              text: 'Start Now',
              onPressed: onStart,
              type: AppButtonType.primary,
              size: AppButtonSize.small,
              prefixIcon: Icons.play_arrow,
            ),
          );
        }
        if (onMarkCompleted != null) {
          actions.add(
            AppButton(
              text: 'Mark Done',
              onPressed: onMarkCompleted,
              type: AppButtonType.success,
              size: AppButtonSize.small,
              prefixIcon: Icons.check_circle,
            ),
          );
        }
        break;
    }

    return actions;
  }
}
