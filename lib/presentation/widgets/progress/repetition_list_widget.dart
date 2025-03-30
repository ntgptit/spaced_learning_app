// lib/presentation/screens/progress/widgets/repetition_list_widget.dart
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
    final repetitionViewModel = context.watch<RepetitionViewModel>();

    if (repetitionViewModel.isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: AppLoadingIndicator(),
        ),
      );
    }

    if (repetitionViewModel.errorMessage != null) {
      return ErrorDisplay(
        message: repetitionViewModel.errorMessage!,
        onRetry: () {
          repetitionViewModel.loadRepetitionsByProgressId(progressId);
        },
        compact: true,
      );
    }

    if (repetitionViewModel.repetitions.isEmpty) {
      return _buildEmptyState(context);
    }

    // Tách repetitions thành các nhóm theo trạng thái
    final List<Repetition> repetitions = List.of(
      repetitionViewModel.repetitions,
    );

    final pendingRepetitions =
        repetitions
            .where((r) => r.status == RepetitionStatus.notStarted)
            .toList()
          ..sort(
            (a, b) =>
                a.repetitionOrder.index.compareTo(b.repetitionOrder.index),
          );

    final completedRepetitions =
        repetitions
            .where((r) => r.status == RepetitionStatus.completed)
            .toList()
          ..sort(
            (a, b) =>
                a.repetitionOrder.index.compareTo(b.repetitionOrder.index),
          );

    final skippedRepetitions =
        repetitions.where((r) => r.status == RepetitionStatus.skipped).toList()
          ..sort(
            (a, b) =>
                a.repetitionOrder.index.compareTo(b.repetitionOrder.index),
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Lịch ôn tập hiện tại (chưa hoàn thành)
        if (pendingRepetitions.isNotEmpty)
          RepetitionSectionWidget(
            title: 'Sắp tới',
            color: Theme.of(context).colorScheme.primary,
            repetitions: pendingRepetitions,
            onMarkCompleted: onMarkCompleted,
            onMarkSkipped: onMarkSkipped,
            onReschedule: _showReschedulePicker,
          ),

        // Lịch sử ôn tập (đã hoàn thành)
        if (completedRepetitions.isNotEmpty)
          RepetitionSectionWidget(
            title: 'Đã hoàn thành',
            color: Colors.green,
            repetitions: completedRepetitions,
            isHistory: true,
          ),

        // Lịch sử ôn tập bị bỏ qua
        if (skippedRepetitions.isNotEmpty)
          RepetitionSectionWidget(
            title: 'Đã bỏ qua',
            color: Colors.orange,
            repetitions: skippedRepetitions,
            isHistory: true,
          ),

        // Khoảng cách ở dưới cùng của danh sách
        const SizedBox(height: 32),
      ],
    );
  }

  /// Build empty state when no repetitions are available
  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Center(
        child: Column(
          children: [
            const Text('Chưa có lịch ôn tập nào cho mô-đun này'),
            const SizedBox(height: 8),
            AppButton(
              text: 'Tạo lịch ôn tập',
              type: AppButtonType.primary,
              onPressed: () async {
                final repetitionViewModel = context.read<RepetitionViewModel>();
                await repetitionViewModel.createDefaultSchedule(progressId);
                await onReload();
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Show date picker for rescheduling
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
