import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaced_learning_app/core/extensions/color_extensions.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/progress.dart';
import 'package:spaced_learning_app/domain/models/repetition.dart';
import 'package:spaced_learning_app/presentation/utils/cycle_formatter.dart';
import 'package:spaced_learning_app/presentation/utils/repetition_utils.dart';
import 'package:spaced_learning_app/presentation/viewmodels/repetition_viewmodel.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_button.dart';
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

class _RepetitionListWidgetState extends State<RepetitionListWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _restartAnimation() {
    _animationController.reset();
    _animationController.forward();
  }

  // Helper method to compare review dates for sorting (newest first)
  int _compareReviewDates(Repetition a, Repetition b) {
    if (a.reviewDate == null && b.reviewDate == null) {
      return a.repetitionOrder.index.compareTo(b.repetitionOrder.index);
    }
    if (a.reviewDate == null) return 1;
    if (b.reviewDate == null) return -1;
    return b.reviewDate!.compareTo(a.reviewDate!);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Consumer<RepetitionViewModel>(
      builder: (context, viewModel, _) {
        if (viewModel.isLoading) {
          return _buildLoadingState(theme);
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
          return _buildEmptyState(context, viewModel);
        }

        // Categorize and sort repetitions
        final repetitions = List<Repetition>.from(viewModel.repetitions);
        final notStarted =
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
                _compareReviewDates,
              ); // Sort completed by review date (newest first)

        final notStartedByCycle = RepetitionUtils.groupByCycle(notStarted);
        final completedByCycle = RepetitionUtils.groupByCycle(completed);

        // Animation effect when repetitions change
        if (viewModel.repetitions.isNotEmpty) {
          _restartAnimation();
        }

        return FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (notStarted.isNotEmpty)
                _buildStatusSection(
                  context,
                  'Pending Tasks',
                  Icons.pending_actions,
                  colorScheme.primaryContainer,
                  colorScheme.onPrimaryContainer,
                  notStartedByCycle,
                  false,
                ),

              if (completed.isNotEmpty)
                _buildStatusSection(
                  context,
                  'Completed Tasks',
                  Icons.check_circle_outline,
                  colorScheme.success, // Use success color
                  colorScheme.onSuccess, // Use onSuccess color
                  completedByCycle,
                  true,
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoadingState(ThemeData theme) {
    return SizedBox(
      height: 200,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: theme.colorScheme.primary),
            const SizedBox(height: AppDimens.spaceM),
            Text('Loading repetitions...', style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, RepetitionViewModel viewModel) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(opacity: _fadeAnimation, child: child);
      },
      child: Container(
        padding: const EdgeInsets.all(AppDimens.paddingXL),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(AppDimens.radiusL),
          border: Border.all(color: theme.colorScheme.outlineVariant, width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.event_note,
              size: AppDimens.iconXXL,
              color: theme.colorScheme.primary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppDimens.spaceL),
            Text(
              'No review schedule found for this module',
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimens.spaceM),
            Text(
              'Create a review schedule to start the spaced repetition learning process',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimens.spaceXL),
            AppButton(
              text: 'Create Review Schedule',
              type: AppButtonType.primary,
              prefixIcon: Icons.add_circle_outline,
              onPressed: () async {
                await viewModel.createDefaultSchedule(widget.progressId);
                await widget.onReload();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusSection(
    BuildContext context,
    String title,
    IconData icon,
    Color containerColor,
    Color textColor,
    Map<String, List<Repetition>> cycleGroups,
    bool isHistory,
  ) {
    if (cycleGroups.isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);

    // Sort cycle keys by cycle number (highest first) for history
    final sortedKeys = cycleGroups.keys.toList();
    if (isHistory) {
      sortedKeys.sort((a, b) {
        final cycleNumA = int.tryParse(a.replaceAll('Cycle ', '')) ?? 0;
        final cycleNumB = int.tryParse(b.replaceAll('Cycle ', '')) ?? 0;
        return cycleNumB.compareTo(cycleNumA); // Descending order
      });
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.spaceXL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: AppDimens.spaceM),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppDimens.paddingXS),
                  decoration: BoxDecoration(
                    color: containerColor,
                    borderRadius: BorderRadius.circular(AppDimens.radiusM),
                  ),
                  child: Icon(icon, color: textColor, size: AppDimens.iconM),
                ),
                const SizedBox(width: AppDimens.spaceM),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ...sortedKeys.map(
            (key) =>
                _buildCycleGroup(context, key, cycleGroups[key]!, isHistory),
          ),
        ],
      ),
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

    final isCurrentCycle = _isCurrentCycle(repetitions);
    final cycleNumber = int.tryParse(cycleKey.replaceAll('Cycle ', '')) ?? 1;
    final cycleName =
        isCurrentCycle
            ? widget.currentCycleStudied
            : _mapNumberToCycleStudied(cycleNumber);

    final cycleColor = CycleFormatter.getColor(cycleName, context);

    // Sort repetitions within a group (already sorted for history in build)
    if (!isHistory) {
      repetitions.sort(
        (a, b) => a.repetitionOrder.index.compareTo(b.repetitionOrder.index),
      );
    }

    return Card(
      margin: const EdgeInsets.only(bottom: AppDimens.spaceM),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cycle header with badges
            Row(
              children: [
                Icon(Icons.cable, size: AppDimens.iconS, color: cycleColor),
                const SizedBox(width: AppDimens.spaceXS),
                Text(
                  CycleFormatter.format(cycleName),
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: cycleColor,
                  ),
                ),
                const SizedBox(width: AppDimens.spaceS),
                if (isCurrentCycle)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.paddingXS,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.success, // Use success color
                      borderRadius: BorderRadius.circular(AppDimens.radiusXS),
                    ),
                    child: Text(
                      'Current',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSuccess, // Use onSuccess color
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),

            const Divider(height: AppDimens.spaceL),

            // Repetition cards
            ...repetitions.map(
              (repetition) => RepetitionCard(
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
            ),
          ],
        ),
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
}
