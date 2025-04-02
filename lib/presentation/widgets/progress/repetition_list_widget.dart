import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaced_learning_app/domain/models/repetition.dart';
import 'package:spaced_learning_app/presentation/viewmodels/repetition_viewmodel.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_button.dart';
import 'package:spaced_learning_app/presentation/widgets/common/error_display.dart';
import 'package:spaced_learning_app/presentation/widgets/common/loading_indicator.dart';
import 'package:spaced_learning_app/presentation/widgets/progress/repetition_section_widget.dart';

class RepetitionListWidget extends StatelessWidget {
  final String progressId;
  final Future<void> Function(String) onMarkCompleted;
  final Future<void> Function(String) onMarkSkipped;
  final Future<void> Function(String, DateTime) onReschedule;
  final Future<void> Function() onReload;

  const RepetitionListWidget({
    super.key,
    required this.progressId,
    required this.onMarkCompleted,
    required this.onMarkSkipped,
    required this.onReschedule,
    required this.onReload,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RepetitionViewModel>();

    if (viewModel.isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: AppLoadingIndicator(),
        ),
      );
    }

    if (viewModel.errorMessage != null) {
      return ErrorDisplay(
        message: viewModel.errorMessage!,
        onRetry: () {
          viewModel.loadRepetitionsByProgressId(progressId);
        },
        compact: true,
      );
    }

    if (viewModel.repetitions.isEmpty) {
      return _buildEmptyState(context);
    }

    final repetitions = List<Repetition>.from(viewModel.repetitions);

    final pending =
        repetitions
            .where((r) => r.status == RepetitionStatus.notStarted)
            .toList()
          ..sort(
            (a, b) =>
                a.repetitionOrder.index.compareTo(b.repetitionOrder.index),
          );

    final completed =
        repetitions
            .where((r) => r.status == RepetitionStatus.completed)
            .toList()
          ..sort(
            (a, b) =>
                a.repetitionOrder.index.compareTo(b.repetitionOrder.index),
          );

    final skipped =
        repetitions.where((r) => r.status == RepetitionStatus.skipped).toList()
          ..sort(
            (a, b) =>
                a.repetitionOrder.index.compareTo(b.repetitionOrder.index),
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (pending.isNotEmpty)
          RepetitionSectionWidget(
            title: 'Upcoming',
            color: Theme.of(context).colorScheme.primary,
            repetitions: pending,
            onMarkCompleted: onMarkCompleted,
            onMarkSkipped: onMarkSkipped,
            onReschedule: _showReschedulePicker,
          ),
        if (completed.isNotEmpty)
          RepetitionSectionWidget(
            title: 'Completed',
            color: Colors.green,
            repetitions: completed,
            isHistory: true,
          ),
        if (skipped.isNotEmpty)
          RepetitionSectionWidget(
            title: 'Skipped',
            color: Colors.orange,
            repetitions: skipped,
            isHistory: true,
          ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Center(
        child: Column(
          children: [
            const Text('No review schedule found for this module'),
            const SizedBox(height: 8),
            AppButton(
              text: 'Create Review Schedule',
              type: AppButtonType.primary,
              onPressed: () async {
                final viewModel = context.read<RepetitionViewModel>();
                await viewModel.createDefaultSchedule(progressId);
                await onReload();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showReschedulePicker(
    BuildContext context,
    String repetitionId,
  ) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );

    if (date != null && context.mounted) {
      await onReschedule(repetitionId, date);
    }
  }
}
