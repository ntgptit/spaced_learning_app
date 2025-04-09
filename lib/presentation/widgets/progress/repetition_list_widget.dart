import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/progress.dart';
import 'package:spaced_learning_app/domain/models/repetition.dart';
import 'package:spaced_learning_app/presentation/viewmodels/repetition_viewmodel.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_button.dart';
import 'package:spaced_learning_app/presentation/widgets/common/error_display.dart';
import 'package:spaced_learning_app/presentation/widgets/common/loading_indicator.dart';
import 'package:spaced_learning_app/presentation/widgets/repetition/repetition_card.dart';

typedef M3ColorPair = ({Color container, Color onContainer});

class RepetitionListWidget extends StatefulWidget {
  final String progressId;
  final CycleStudied currentCycleStudied;
  final Future<void> Function(String) onMarkCompleted;
  final Future<void> Function(String) onMarkSkipped;
  final Future<void> Function(String, DateTime, bool)
  onReschedule; // Cập nhật: thêm tham số rescheduleFollowing
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final _ = theme.textTheme;

    return Consumer<RepetitionViewModel>(
      builder: (context, viewModel, _) {
        if (viewModel.isLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(AppDimens.paddingXL),
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

        final notStartedByCycle = _groupRepetitionsByCycle(notStarted);
        final completedByCycle = _groupRepetitionsByCycle(completed);
        final skippedByCycle = _groupRepetitionsByCycle(skipped);

        final pendingColors = (
          container: colorScheme.primaryContainer,
          onContainer: colorScheme.onPrimaryContainer,
        );
        final completedColors = (
          container: colorScheme.tertiaryContainer,
          onContainer: colorScheme.onTertiaryContainer,
        );
        final skippedColors = (
          container: colorScheme.secondaryContainer,
          onContainer: colorScheme.onSecondaryContainer,
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (notStarted.isNotEmpty)
              _buildStatusSection(
                context,
                'Pending',
                pendingColors,
                notStartedByCycle,
                false,
              ),
            if (completed.isNotEmpty)
              _buildStatusSection(
                context,
                'Completed',
                completedColors,
                completedByCycle,
                true,
              ),
            if (skipped.isNotEmpty)
              _buildStatusSection(
                context,
                'Skipped',
                skippedColors,
                skippedByCycle,
                true,
              ),
          ],
        );
      },
    );
  }

  Map<String, List<Repetition>> _groupRepetitionsByCycle(
    List<Repetition> repetitions,
  ) {
    final Map<String, List<Repetition>> groupedByCycle = {};
    repetitions.sort((a, b) {
      if (a.createdAt == null && b.createdAt == null) return 0;
      if (a.createdAt == null) return 1;
      if (b.createdAt == null) return -1;
      return a.createdAt!.compareTo(b.createdAt!);
    });

    int cycleIndex = 1;
    int currentGroupCount = 0;
    String currentKey = '';
    int repIndex = 0;

    while (repIndex < repetitions.length) {
      final rep = repetitions[repIndex];
      if (currentGroupCount < 5) {
        if (currentGroupCount == 0) {
          currentKey = 'Cycle $cycleIndex';
          groupedByCycle[currentKey] = [];
        }
        groupedByCycle[currentKey]!.add(rep);
        currentGroupCount++;
        repIndex++;
      } else {
        cycleIndex++;
        currentGroupCount = 0;
      }
    }

    for (final key in groupedByCycle.keys) {
      groupedByCycle[key]!.sort(
        (a, b) => a.repetitionOrder.index.compareTo(b.repetitionOrder.index),
      );
    }
    return groupedByCycle;
  }

  Widget _buildStatusSection(
    BuildContext context,
    String title,
    M3ColorPair colors,
    Map<String, List<Repetition>> cycleGroups,
    bool isHistory,
  ) {
    if (cycleGroups.isEmpty) return const SizedBox.shrink();

    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(
            top: AppDimens.spaceL,
            bottom: AppDimens.spaceS,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.paddingM,
            vertical: AppDimens.paddingXS,
          ),
          decoration: BoxDecoration(
            color: colors.container,
            borderRadius: BorderRadius.circular(AppDimens.radiusM),
          ),
          child: Text(
            title,
            style: textTheme.titleSmall?.copyWith(
              color: colors.onContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        for (final entry in cycleGroups.entries)
          _buildCycleGroup(context, entry.key, entry.value, isHistory),
      ],
    );
  }

  Widget _buildCycleGroup(
    BuildContext context,
    String cycleKey,
    List<Repetition> repetitions,
    bool isHistory,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final isCurrentCycle = _isCurrentCycle(repetitions);
    final cycleNumber = int.tryParse(cycleKey.replaceAll('Cycle ', '')) ?? 1;
    final cycleName =
        isCurrentCycle
            ? widget.currentCycleStudied
            : _mapNumberToCycleStudied(cycleNumber);

    final cycleColors = _getCycleColors(cycleName, colorScheme);

    final currentBadgeColors = (
      container: colorScheme.tertiaryContainer,
      onContainer: colorScheme.onTertiaryContainer,
    );

    return Container(
      margin: const EdgeInsets.only(
        left: AppDimens.paddingM,
        bottom: AppDimens.spaceL,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: AppDimens.spaceS),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.paddingS,
                    vertical: AppDimens.paddingXXS,
                  ),
                  decoration: BoxDecoration(
                    color: cycleColors.container,
                    borderRadius: BorderRadius.circular(AppDimens.radiusS),
                  ),
                  child: Text(
                    _formatCycleStudied(cycleName),
                    style: textTheme.labelSmall?.copyWith(
                      color: cycleColors.onContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (isCurrentCycle) ...[
                  const SizedBox(width: AppDimens.spaceS),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.paddingXS,
                      vertical: AppDimens.paddingXXS,
                    ),
                    decoration: BoxDecoration(
                      color: currentBadgeColors.container,
                      borderRadius: BorderRadius.circular(AppDimens.radiusXS),
                    ),
                    child: Text(
                      'Current',
                      style: textTheme.labelSmall?.copyWith(
                        color: currentBadgeColors.onContainer,
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
                      : (currentDate) => _showReschedulePicker(
                        context,
                        repetition,
                        currentDate,
                      ),
            ),
        ],
      ),
    );
  }

  bool _isCurrentCycle(List<Repetition> repetitions) {
    if (repetitions.isEmpty) {
      return false;
    }
    return repetitions.any((r) => r.status == RepetitionStatus.notStarted) &&
        widget.currentCycleStudied != CycleStudied.firstTime;
  }

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
      padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceXL),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'No review schedule found for this module',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppDimens.spaceM),
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

  // Cập nhật: Hiển thị dialog reschedule với tùy chọn rescheduleFollowing
  Future<void> _showReschedulePicker(
    BuildContext context,
    Repetition repetition,
    DateTime currentDate,
  ) async {
    // Khởi tạo các biến state
    DateTime selectedDate =
        repetition.reviewDate ?? DateTime.now().add(const Duration(days: 1));
    bool rescheduleFollowing = false;

    // Hiển thị dialog để chọn ngày và tùy chọn reschedule
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder:
              (context, setState) => AlertDialog(
                title: const Text('Reschedule Repetition'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Select new date:'),
                    const SizedBox(height: AppDimens.spaceM),
                    SizedBox(
                      height: 300,
                      width: 300,
                      child: CalendarDatePicker(
                        initialDate: selectedDate,
                        firstDate: DateTime.now().subtract(
                          const Duration(days: 7),
                        ),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                        onDateChanged: (date) {
                          setState(() {
                            selectedDate = date;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: AppDimens.spaceM),
                    SwitchListTile(
                      title: const Text('Reschedule following repetitions'),
                      subtitle: const Text(
                        'Adjust all future repetitions based on this new date',
                      ),
                      value: rescheduleFollowing,
                      onChanged: (value) {
                        setState(() {
                          rescheduleFollowing = value;
                        });
                      },
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed:
                        () => Navigator.pop(context, {
                          'date': selectedDate,
                          'rescheduleFollowing': rescheduleFollowing,
                        }),
                    child: const Text('Reschedule'),
                  ),
                ],
              ),
        );
      },
    );

    // Nếu người dùng chọn OK, tiến hành cập nhật lịch
    if (result != null && context.mounted) {
      final selectedDate = result['date'] as DateTime;
      final rescheduleFollowing = result['rescheduleFollowing'] as bool;

      await widget.onReschedule(
        repetition.id,
        selectedDate,
        rescheduleFollowing,
      );
    }
  }

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

  M3ColorPair _getCycleColors(CycleStudied cycle, ColorScheme colorScheme) {
    switch (cycle) {
      case CycleStudied.firstTime:
        return (
          container: colorScheme.primaryContainer,
          onContainer: colorScheme.onPrimaryContainer,
        );
      case CycleStudied.firstReview:
        return (
          container: colorScheme.secondaryContainer,
          onContainer: colorScheme.onSecondaryContainer,
        );
      case CycleStudied.secondReview:
        return (
          container: colorScheme.tertiaryContainer,
          onContainer: colorScheme.onTertiaryContainer,
        );
      case CycleStudied.thirdReview:
        return (
          container: colorScheme.surfaceContainerHighest,
          onContainer: colorScheme.onSurfaceVariant,
        );
      case CycleStudied.moreThanThreeReviews:
        return (
          container: colorScheme.surfaceContainerHigh,
          onContainer: colorScheme.onSurfaceVariant,
        );
    }
  }
}
