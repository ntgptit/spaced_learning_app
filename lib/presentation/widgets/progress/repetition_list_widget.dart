import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

        // 1. Đầu tiên, phân chia theo trạng thái
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

    for (final repetition in repetitions) {
      // Sử dụng thời gian tạo (createdAt) làm key để nhóm
      final createdAtKey =
          repetition.createdAt != null
              ? DateFormat(
                'yyyy-MM-dd HH:mm:ss',
              ).format(repetition.createdAt!.toLocal()).substring(0, 16)
              : 'unknown';

      if (!groupedByCycle.containsKey(createdAtKey)) {
        groupedByCycle[createdAtKey] = [];
      }

      groupedByCycle[createdAtKey]!.add(repetition);
    }

    // Sắp xếp các key theo thứ tự thời gian (mới nhất lên đầu)
    final sortedKeys =
        groupedByCycle.keys.toList()..sort((a, b) => b.compareTo(a));

    // Tạo map mới với thứ tự đã sắp xếp
    final sortedMap = <String, List<Repetition>>{};
    for (final key in sortedKeys) {
      // Sắp xếp các repetition trong mỗi cycle theo thứ tự
      final sortedRepetitions =
          groupedByCycle[key]!..sort(
            (a, b) =>
                a.repetitionOrder.index.compareTo(b.repetitionOrder.index),
          );

      sortedMap[key] = sortedRepetitions;
    }

    return sortedMap;
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
        // Header cho trạng thái
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

        // Hiển thị từng nhóm cycle
        for (final entry in cycleGroups.entries)
          _buildCycleGroup(context, entry.key, entry.value, isHistory),
      ],
    );
  }

  // Xây dựng UI cho một nhóm cycle cụ thể
  Widget _buildCycleGroup(
    BuildContext context,
    String cycleTimeKey,
    List<Repetition> repetitions,
    bool isHistory,
  ) {
    final theme = Theme.of(context);
    final isCurrentCycle = _isCurrentCycle(repetitions);

    // Xác định cycle number dựa vào thứ tự (ví dụ: Cycle 1, Cycle 2, v.v.)
    // Bạn có thể thay logic này bằng logic thực tế từ dữ liệu của bạn
    final cycleNumber = _getCycleNumber(repetitions, cycleTimeKey);

    return Container(
      margin: const EdgeInsets.only(left: 12, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header cho cycle
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
                    color: _getCycleColor(cycleNumber),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Cycle $cycleNumber',
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

          // Danh sách các repetition trong cycle
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
    // Logic thực tế: so sánh với cycle hiện tại từ Progress
    // Đơn giản tạm thời: nếu có bất kỳ repetition nào có status là notStarted
    return repetitions.any((r) => r.status == RepetitionStatus.notStarted);
  }

  // Xác định số thứ tự của cycle dựa vào dữ liệu
  int _getCycleNumber(List<Repetition> repetitions, String cycleTimeKey) {
    // Logic giả định: xác định cycle number dựa vào thời gian tạo
    // Trong thực tế, bạn cần logic phức tạp hơn dựa vào dữ liệu thực

    // Ví dụ đơn giản: So sánh với cycleStudied hiện tại
    if (_isCurrentCycle(repetitions)) {
      switch (widget.currentCycleStudied) {
        case CycleStudied.firstTime:
          return 1;
        case CycleStudied.firstReview:
          return 2;
        case CycleStudied.secondReview:
          return 3;
        case CycleStudied.thirdReview:
          return 4;
        case CycleStudied.moreThanThreeReviews:
          return 5;
      }
    }

    // Nếu không phải cycle hiện tại, lấy từ vị trí trong danh sách
    // Logic này cần được điều chỉnh cho phù hợp với dữ liệu thực tế
    return int.tryParse(cycleTimeKey.split('-').first) ?? 0;
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

  // Màu sắc cho từng cycle
  Color _getCycleColor(int cycleNumber) {
    switch (cycleNumber) {
      case 1:
        return Colors.indigo;
      case 2:
        return Colors.green;
      case 3:
        return Colors.teal;
      case 4:
        return Colors.blue;
      default:
        return Colors.deepPurple;
    }
  }
}
