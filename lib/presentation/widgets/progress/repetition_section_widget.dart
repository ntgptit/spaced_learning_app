import 'package:flutter/material.dart';
import 'package:spaced_learning_app/domain/models/repetition.dart';
import 'package:spaced_learning_app/presentation/widgets/repetition/repetition_card.dart';

class RepetitionSectionWidget extends StatelessWidget {
  final List<Repetition> repetitions;
  final bool isHistory;
  final Future<void> Function(String)? onMarkCompleted;
  final Future<void> Function(String)? onMarkSkipped;
  final Future<void> Function(BuildContext, String)? onReschedule;

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
    // Sort repetitions by repetitionOrder
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
                  : () => onReschedule?.call(context, repetition.id),
        );
      },
    );
  }
}
