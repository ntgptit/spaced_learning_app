import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaced_learning_app/domain/models/progress.dart';
import 'package:spaced_learning_app/domain/models/repetition.dart';
import 'package:spaced_learning_app/presentation/utils/repetition_utils.dart';
import 'package:spaced_learning_app/presentation/viewmodels/repetition_viewmodel.dart';
import 'package:spaced_learning_app/presentation/widgets/common/error_display.dart';
import 'package:spaced_learning_app/presentation/widgets/repetition/repetition_card.dart';

typedef M3ColorPair = ({Color container, Color onContainer});

class RepetitionListWidget extends StatefulWidget {
  final String progressId;
  final CycleStudied currentCycleStudied;
  final Future<void> Function(String) onMarkCompleted;
  final Future<void> Function(String, DateTime, bool) onReschedule;
  final Future<void> Function() onReload;

  const RepetitionListWidget({
    super.key,
    required this.progressId,
    required this.currentCycleStudied,
    required this.onMarkCompleted,
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
    return Consumer<RepetitionViewModel>(
      builder: (context, viewModel, _) {
        if (viewModel.isLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (viewModel.errorMessage != null) {
          return ErrorDisplay(
            message: viewModel.errorMessage!,
            onRetry:
                () => viewModel.loadRepetitionsByProgressId(widget.progressId),
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

        final notStartedByCycle = RepetitionUtils.groupByCycle(notStarted);
        final completedByCycle = RepetitionUtils.groupByCycle(completed);
        final skippedByCycle = RepetitionUtils.groupByCycle(skipped);

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
          margin: const EdgeInsets.only(top: 16.0, bottom: 8.0),
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: colors.container,
            borderRadius: BorderRadius.circular(8.0),
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
        left: 12.0,
        bottom: 16.0,
      ), // AppDimens.paddingM, spaceL
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 8.0), // AppDimens.spaceS
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 2.0,
                  ), // AppDimens.paddingS, paddingXXS
                  decoration: BoxDecoration(
                    color: cycleColors.container,
                    borderRadius: BorderRadius.circular(
                      4.0,
                    ), // AppDimens.radiusS
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
                  const SizedBox(width: 8.0), // AppDimens.spaceS
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4.0,
                      vertical: 2.0,
                    ), // AppDimens.paddingXS, paddingXXS
                    decoration: BoxDecoration(
                      color: currentBadgeColors.container,
                      borderRadius: BorderRadius.circular(
                        2.0,
                      ), // AppDimens.radiusXS
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
              onReschedule:
                  isHistory
                      ? null
                      : (currentDate) => widget.onReschedule(
                        repetition.id,
                        currentDate,
                        false,
                      ),
            ),
        ],
      ),
    );
  }

  bool _isCurrentCycle(List<Repetition> repetitions) {
    if (repetitions.isEmpty) return false;
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
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'No review schedule found for this module',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12.0),
            ElevatedButton(
              onPressed: () async {
                final viewModel = context.read<RepetitionViewModel>();
                await viewModel.createDefaultSchedule(widget.progressId);
                await widget.onReload();
              },
              child: const Text('Create Review Schedule'),
            ),
          ],
        ),
      ),
    );
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
