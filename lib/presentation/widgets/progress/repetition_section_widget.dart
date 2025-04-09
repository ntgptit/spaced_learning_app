import 'package:flutter/material.dart';
import 'package:spaced_learning_app/domain/models/repetition.dart';
import 'package:spaced_learning_app/presentation/widgets/progress/reschedule_dialog.dart';
import 'package:spaced_learning_app/presentation/widgets/repetition/repetition_card.dart';

class RepetitionSectionWidget extends StatelessWidget {
  final List<Repetition> repetitions;
  final bool isHistory;
  final Future<void> Function(String)? onMarkCompleted;
  final Future<void> Function(String)? onMarkSkipped;
  final Future<void> Function(BuildContext, String, DateTime, bool)?
  onReschedule;

  const RepetitionSectionWidget({
    super.key,
    required this.repetitions,
    this.isHistory = false,
    this.onMarkCompleted,
    this.onMarkSkipped,
    this.onReschedule,
  });

  @override
  Widget build(BuildContext context) {
    final sortedRepetitions = List<Repetition>.from(repetitions)..sort(
      (a, b) => a.repetitionOrder.index.compareTo(b.repetitionOrder.index),
    );
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sortedRepetitions.length,
      itemBuilder: (context, index) {
        final repetition = sortedRepetitions[index];
        return RepetitionCard(
          key: ValueKey(repetition.id),
          repetition: repetition,
          isHistory: isHistory,
          onMarkCompleted:
              isHistory ? null : () => onMarkCompleted?.call(repetition.id),
          onSkip: isHistory ? null : () => onMarkSkipped?.call(repetition.id),
          onReschedule:
              isHistory
                  ? null
                  : (currentDate) => _showReschedulePicker(
                    context,
                    repetition.id,
                    currentDate,
                  ),
        );
      },
    );
  }

  Future<void> _showReschedulePicker(
    BuildContext context,
    String repetitionId,
    DateTime currentDate,
  ) async {
    final result = await RescheduleDialog.show(
      context,
      initialDate: currentDate,
      title: 'Reschedule Repetition',
    );
    if (result != null) {
      final selectedDate = result['date'] as DateTime;
      final rescheduleFollowing = result['rescheduleFollowing'] as bool;
      await onReschedule?.call(
        context,
        repetitionId,
        selectedDate,
        rescheduleFollowing,
      );
    }
  }
}
