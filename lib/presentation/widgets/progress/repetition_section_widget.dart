import 'package:flutter/material.dart';
import 'package:spaced_learning_app/domain/models/repetition.dart';
import 'package:spaced_learning_app/presentation/widgets/repetition/repetition_card.dart';

class RepetitionSectionWidget extends StatelessWidget {
  final String title;
  final Color color;
  final List<Repetition> repetitions;
  final bool isHistory;
  final Future<void> Function(String)? onMarkCompleted;
  final Future<void> Function(String)? onMarkSkipped;
  final Future<void> Function(BuildContext, String)? onReschedule;

  const RepetitionSectionWidget({
    super.key,
    required this.title,
    required this.color,
    required this.repetitions,
    this.isHistory = false,
    this.onMarkCompleted,
    this.onMarkSkipped,
    this.onReschedule,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        _buildHeader(theme),
        const SizedBox(height: 8),
        _buildRepetitionList(context),
      ],
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        title,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildRepetitionList(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: repetitions.length,
      itemBuilder: (context, index) {
        final repetition = repetitions[index];
        return RepetitionCard(
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
