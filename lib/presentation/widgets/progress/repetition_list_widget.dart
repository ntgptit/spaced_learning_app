import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaced_learning_app/domain/models/progress.dart';
import 'package:spaced_learning_app/domain/models/repetition.dart';
import 'package:spaced_learning_app/presentation/viewmodels/repetition_viewmodel.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_button.dart';
import 'package:spaced_learning_app/presentation/widgets/common/error_display.dart';
import 'package:spaced_learning_app/presentation/widgets/common/loading_indicator.dart';
import 'package:spaced_learning_app/presentation/widgets/repetition/repetition_card.dart';

class RepetitionListWidget extends StatefulWidget {
  final String progressId;
  final CycleStudied currentCycleStudied;
  final Future<void> Function(String) onMarkCompleted;
  final Future<void> Function(String) onMarkSkipped;
  final Future<void> Function(String, DateTime) onReschedule;
  final Future<void> Function() onReload;

  const RepetitionListWidget({
    super.key,
    required this.progressId,
    required this.currentCycleStudied,
    required this.onMarkCompleted,
    required this.onMarkSkipped,
    required this.onReschedule,
    required this.onReload,
  });

  @override
  State<RepetitionListWidget> createState() => _RepetitionListWidgetState();
}

class _RepetitionListWidgetState extends State<RepetitionListWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<RepetitionViewModel>(
      builder: (context, viewModel, _) {
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
              viewModel.loadRepetitionsByProgressId(widget.progressId);
            },
            compact: true,
          );
        }

        if (viewModel.repetitions.isEmpty) {
          return _buildEmptyState(context);
        }

        final repetitions = List<Repetition>.from(viewModel.repetitions);

        // 1. Phân chia theo trạng thái
        final notStarted =
            repetitions
                .where((r) => r.status == RepetitionStatus.notStarted)
                .toList();
        final completed =
            repetitions
                .where((r) => r.status == RepetitionStatus.completed)
                .toList();
        final skipped =
            repetitions
                .where((r) => r.status == RepetitionStatus.skipped)
                .toList();

        // 2. Sắp xếp để phân nhóm theo createdAt (phân tách các cycle)
        final Map<String, List<Repetition>> notStartedByCycle =
            _groupRepetitionsByCycle(notStarted);
        final Map<String, List<Repetition>> completedByCycle =
            _groupRepetitionsByCycle(completed);
        final Map<String, List<Repetition>> skippedByCycle =
            _groupRepetitionsByCycle(skipped);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status: Pending
            if (notStarted.isNotEmpty)
              _buildStatusSection(
                context,
                'Pending',
                Theme.of(context).colorScheme.primary,
                notStartedByCycle,
                false,
              ),

            // Status: Completed
            if (completed.isNotEmpty)
              _buildStatusSection(
                context,
                'Completed',
                Colors.green,
                completedByCycle,
                true,
              ),

            // Status: Skipped
            if (skipped.isNotEmpty)
              _buildStatusSection(
                context,
                'Skipped',
                Colors.orange,
                skippedByCycle,
                true,
              ),
          ],
        );
      },
    );
  }

  // Nhóm các repetition theo cycle (dựa vào createdAt)
  Map<String, List<Repetition>> _groupRepetitionsByCycle(
    List<Repetition> repetitions,
  ) {
    final Map<String, List<Repetition>> groupedByCycle = {};

    // Trước tiên, sắp xếp theo createdAt
    repetitions.sort((a, b) {
      if (a.createdAt == null && b.createdAt == null) return 0;
      if (a.createdAt == null) return 1;
      if (b.createdAt == null) return -1;
      return a.createdAt!.compareTo(b.createdAt!);
    });

    // Phân loại thành các nhóm 5 repetitions
    int cycleIndex = 1;
    int currentGroupCount = 0;
    String currentKey = '';

    for (int i = 0; i < repetitions.length; i++) {
      final rep = repetitions[i];

      if (currentGroupCount == 0 ||
          (currentGroupCount < 5 &&
              rep.createdAt != null &&
              i > 0 &&
              repetitions[i - 1].createdAt != null &&
              rep.createdAt!
                      .difference(repetitions[i - 1].createdAt!)
                      .inMinutes <
                  10)) {
        if (currentGroupCount == 0) {
          currentKey = 'Cycle $cycleIndex';
          groupedByCycle[currentKey] = [];
        }

        groupedByCycle[currentKey]!.add(rep);
        currentGroupCount++;

        if (currentGroupCount >= 5) {
          cycleIndex++;
          currentGroupCount = 0;
        }
      } else {
        currentKey = 'Cycle $cycleIndex';
        groupedByCycle[currentKey] = [rep];
        currentGroupCount = 1;
      }
    }

    // Sắp xếp các repetition trong mỗi nhóm theo order
    for (final key in groupedByCycle.keys) {
      groupedByCycle[key]!.sort(
        (a, b) => a.repetitionOrder.index.compareTo(b.repetitionOrder.index),
      );
    }

    return groupedByCycle;
  }

  // Xây dựng section cho một trạng thái (Pending, Completed, Skipped)
  Widget _buildStatusSection(
    BuildContext context,
    String title,
    Color color,
    Map<String, List<Repetition>> cycleGroups,
    bool isHistory,
  ) {
    if (cycleGroups.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 16, bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        for (final entry in cycleGroups.entries)
          _buildCycleGroup(context, entry.key, entry.value, isHistory),
      ],
    );
  }

  // Xây dựng UI cho một nhóm cycle cụ thể
  Widget _buildCycleGroup(
    BuildContext context,
    String cycleKey,
    List<Repetition> repetitions,
    bool isHistory,
  ) {
    final theme = Theme.of(context);
    final isCurrentCycle = _isCurrentCycle(repetitions);

    // Lấy cycle number từ key (nếu cần làm fallback)
    final cycleNumber = int.tryParse(cycleKey.replaceAll('Cycle ', '')) ?? 1;

    // Sử dụng widget.currentCycleStudied để xác định chu kỳ hiện tại
    final CycleStudied cycleName =
        isCurrentCycle
            ? widget
                .currentCycleStudied // Ưu tiên chu kỳ hiện tại từ Progress
            : _mapNumberToCycleStudied(cycleNumber);

    return Container(
      margin: const EdgeInsets.only(left: 12, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getCycleColor(cycleName),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _formatCycleStudied(cycleName),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (isCurrentCycle) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade700,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Current',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          for (final repetition in repetitions)
            RepetitionCard(
              repetition: repetition,
              isHistory: isHistory,
              onMarkCompleted:
                  isHistory
                      ? null
                      : () => widget.onMarkCompleted(repetition.id),
              onSkip:
                  isHistory ? null : () => widget.onMarkSkipped(repetition.id),
              onReschedule:
                  isHistory
                      ? null
                      : () => _showReschedulePicker(context, repetition.id),
            ),
        ],
      ),
    );
  }

  // Xác định xem đây có phải là cycle hiện tại không
  bool _isCurrentCycle(List<Repetition> repetitions) {
    // Kiểm tra xem danh sách repetitions này có khớp với chu kỳ hiện tại không
    return repetitions.any((r) => r.status == RepetitionStatus.notStarted) &&
        widget.currentCycleStudied != CycleStudied.firstTime;
  }

  // Chuyển đổi số thứ tự cycle thành CycleStudied (dùng làm fallback)
  CycleStudied _mapNumberToCycleStudied(int number) {
    switch (number) {
      case 1:
        return CycleStudied.firstTime;
      case 2:
        return CycleStudied.firstReview;
      case 3:
        return CycleStudied.secondReview;
      case 4:
        return CycleStudied.thirdReview;
      default:
        return CycleStudied.moreThanThreeReviews;
    }
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
                await viewModel.createDefaultSchedule(widget.progressId);
                await widget.onReload();
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
      await widget.onReschedule(repetitionId, date);
    }
  }

  // Helper methods
  String _formatCycleStudied(CycleStudied cycle) {
    switch (cycle) {
      case CycleStudied.firstTime:
        return 'Initial';
      case CycleStudied.firstReview:
        return 'Review 1';
      case CycleStudied.secondReview:
        return 'Review 2';
      case CycleStudied.thirdReview:
        return 'Review 3';
      case CycleStudied.moreThanThreeReviews:
        return 'Review 4+';
    }
  }

  Color _getCycleColor(CycleStudied cycle) {
    switch (cycle) {
      case CycleStudied.firstTime:
        return Colors.indigo;
      case CycleStudied.firstReview:
        return Colors.green;
      case CycleStudied.secondReview:
        return Colors.teal;
      case CycleStudied.thirdReview:
        return Colors.blue;
      case CycleStudied.moreThanThreeReviews:
        return Colors.deepPurple;
    }
  }
}
