import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaced_learning_app/core/theme/app_colors.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
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

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (notStarted.isNotEmpty)
              _buildStatusSection(
                context,
                'Pending',
                Theme.of(context).colorScheme.inversePrimary,
                notStartedByCycle,
                false,
              ),
            if (completed.isNotEmpty)
              _buildStatusSection(
                context,
                'Completed',
                AppColors.successDark,
                completedByCycle,
                true,
              ),
            if (skipped.isNotEmpty)
              _buildStatusSection(
                context,
                'Skipped',
                AppColors.warningDark,
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
    Color color,
    Map<String, List<Repetition>> cycleGroups,
    bool isHistory,
  ) {
    if (cycleGroups.isEmpty) return const SizedBox.shrink();

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
            color: color,
            borderRadius: BorderRadius.circular(AppDimens.radiusM),
          ),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: AppDimens.fontM,
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
    final isCurrentCycle = _isCurrentCycle(repetitions);
    final cycleNumber = int.tryParse(cycleKey.replaceAll('Cycle ', '')) ?? 1;
    final CycleStudied cycleName =
        isCurrentCycle
            ? widget.currentCycleStudied
            : _mapNumberToCycleStudied(cycleNumber);

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
                    color: _getCycleColor(cycleName),
                    borderRadius: BorderRadius.circular(AppDimens.radiusS),
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
                  const SizedBox(width: AppDimens.spaceS),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.paddingXS,
                      vertical: AppDimens.paddingXXS,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade700,
                      borderRadius: BorderRadius.circular(AppDimens.radiusXS),
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

  bool _isCurrentCycle(List<Repetition> repetitions) {
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
          children: [
            const Text('No review schedule found for this module'),
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
        return AppColors.onInfoDark;
      case CycleStudied.firstReview:
        return AppColors.darkTertiary;
      case CycleStudied.secondReview:
        return AppColors.darkOnError;
      case CycleStudied.thirdReview:
        return AppColors.infoLight;
      case CycleStudied.moreThanThreeReviews:
        return AppColors.darkTertiary;
    }
  }
}
