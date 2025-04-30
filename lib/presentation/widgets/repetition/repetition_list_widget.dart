// lib/presentation/widgets/repetition/repetition_list_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/progress.dart';
import 'package:spaced_learning_app/domain/models/repetition.dart';
import 'package:spaced_learning_app/presentation/utils/cycle_formatter.dart';
import 'package:spaced_learning_app/presentation/utils/repetition_utils.dart';
import 'package:spaced_learning_app/presentation/viewmodels/repetition_viewmodel.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_button.dart';
import 'package:spaced_learning_app/presentation/widgets/common/error_display.dart';
import 'package:spaced_learning_app/presentation/widgets/repetition/repetition_card.dart';

class RepetitionListWidget extends ConsumerStatefulWidget {
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
  ConsumerState<RepetitionListWidget> createState() =>
      _RepetitionListWidgetState();
}

class _RepetitionListWidgetState extends ConsumerState<RepetitionListWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: AppDimens.durationM),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _animationController.forward();

    // Load repetitions when widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(repetitionStateProvider.notifier)
          .loadRepetitionsByProgressId(widget.progressId);
    });
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
    final repetitionsState = ref.watch(repetitionStateProvider);

    return repetitionsState.when(
      data: (repetitions) {
        if (repetitions.isEmpty) {
          return _buildEmptyState(context, ref, colorScheme);
        }

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
              ..sort(_compareReviewDates);

        final notStartedByCycle = RepetitionUtils.groupByCycle(notStarted);
        final completedByCycle = RepetitionUtils.groupByCycle(completed);

        if (repetitions.isNotEmpty) {
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
                  colorScheme,
                ),

              if (completed.isNotEmpty)
                _buildStatusSection(
                  context,
                  'Completed Tasks',
                  Icons.check_circle_outline,
                  colorScheme.primaryContainer,
                  colorScheme.onPrimaryContainer,
                  completedByCycle,
                  true,
                  colorScheme,
                ),
            ],
          ),
        );
      },
      loading: () => _buildLoadingState(theme, colorScheme),
      error: (error, stackTrace) => SLErrorView(
        message: error.toString(),
        onRetry: () => ref
            .read(repetitionStateProvider.notifier)
            .loadRepetitionsByProgressId(widget.progressId),
        compact: true,
      ),
    );
  }

  Widget _buildLoadingState(ThemeData theme, ColorScheme colorScheme) {
    return SizedBox(
      height: AppDimens.thumbnailSizeL,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: colorScheme.primary),
            const SizedBox(height: AppDimens.spaceM),
            Text(
              'Loading repetitions...',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    WidgetRef ref,
    ColorScheme colorScheme,
  ) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(opacity: _fadeAnimation, child: child);
      },
      child: Container(
        padding: const EdgeInsets.all(AppDimens.paddingXL),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(AppDimens.radiusL),
          border: Border.all(color: colorScheme.outlineVariant, width: 1.5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.event_note,
              size: AppDimens.iconXXL,
              color: colorScheme.primary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppDimens.spaceL),
            Text(
              'No review schedule found for this module',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimens.spaceM),
            Text(
              'Create a review schedule to start the spaced repetition learning process',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimens.spaceXL),
            SLButton(
              text: 'Create Review Schedule',
              type: SLButtonType.primary,
              prefixIcon: Icons.add_circle_outline,
              onPressed: () async {
                await ref
                    .read(repetitionStateProvider.notifier)
                    .createDefaultSchedule(widget.progressId);
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
    ColorScheme colorScheme,
  ) {
    if (cycleGroups.isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);

    final sortedKeys = cycleGroups.keys.toList();
    if (isHistory) {
      sortedKeys.sort((a, b) {
        final cycleNumA = int.tryParse(a.replaceAll('Cycle ', '')) ?? 0;
        final cycleNumB = int.tryParse(b.replaceAll('Cycle ', '')) ?? 0;
        return cycleNumB.compareTo(cycleNumA); // Descending order
      });
    }

    // Sử dụng màu từ color scheme theo Material 3
    final titleIconColor = isHistory
        ? colorScheme.primary.withValues(alpha: AppDimens.opacityVeryHigh)
        : textColor;

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
                  padding: const EdgeInsets.all(AppDimens.paddingS),
                  decoration: BoxDecoration(
                    color: containerColor,
                    borderRadius: BorderRadius.circular(AppDimens.radiusM),
                    border: Border.all(
                      color: textColor.withValues(alpha: AppDimens.opacitySemi),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: titleIconColor,
                    size: AppDimens.iconM,
                  ),
                ),
                const SizedBox(width: AppDimens.spaceM),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isHistory
                        ? colorScheme.primary.withValues(
                            alpha: AppDimens.opacityVeryHigh,
                          )
                        : textColor,
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
    final cycleName = isCurrentCycle
        ? widget.currentCycleStudied
        : _mapNumberToCycleStudied(cycleNumber);

    // Sử dụng màu từ CycleFormatter để đảm bảo nhất quán
    final baseCycleColor = CycleFormatter.getColor(cycleName, context);

    // Tùy chỉnh màu dựa trên trạng thái, theo Material 3
    final cycleColor = isHistory
        ? baseCycleColor.withValues(alpha: AppDimens.opacityVeryHigh)
        : isCurrentCycle
        ? baseCycleColor
        : baseCycleColor.withValues(alpha: AppDimens.opacityVeryHigh);

    if (!isHistory) {
      repetitions.sort(
        (a, b) => a.repetitionOrder.index.compareTo(b.repetitionOrder.index),
      );
    }

    // Sử dụng màu theo Material 3
    final borderColor = isHistory
        ? cycleColor.withValues(alpha: AppDimens.opacitySemi)
        : isCurrentCycle
        ? cycleColor
        : cycleColor.withValues(alpha: AppDimens.opacitySemi);

    final backgroundColor = isHistory
        ? colorScheme.surfaceContainerLowest.withValues(
            alpha: AppDimens.opacityVeryHigh,
          )
        : isCurrentCycle
        ? cycleColor.withValues(alpha: AppDimens.opacityLight)
        : colorScheme.surfaceContainerLowest;

    // Shadow theo Material 3
    final boxShadow = isCurrentCycle || isHistory
        ? [
            BoxShadow(
              color: cycleColor.withValues(
                alpha: isHistory
                    ? AppDimens.opacityLight
                    : AppDimens.opacitySemi,
              ),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ]
        : null;

    return Card(
      margin: const EdgeInsets.only(bottom: AppDimens.spaceM),
      elevation: isCurrentCycle ? AppDimens.elevationS : AppDimens.elevationXS,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
        side: BorderSide(color: borderColor, width: isCurrentCycle ? 1.5 : 1.0),
      ),
      color: backgroundColor,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimens.radiusM),
          boxShadow: boxShadow,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.paddingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCycleHeader(
                theme,
                isHistory,
                isCurrentCycle,
                cycleColor,
                cycleName,
                colorScheme,
              ),
              const Divider(height: AppDimens.spaceL),
              ...repetitions.map(
                (repetition) => RepetitionCard(
                  repetition: repetition,
                  isHistory: isHistory,
                  onMarkCompleted: isHistory
                      ? null
                      : () => widget.onMarkCompleted(repetition.id),
                  onReschedule: isHistory
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
      ),
    );
  }

  // Header nhất quán theo Material 3
  Widget _buildCycleHeader(
    ThemeData theme,
    bool isHistory,
    bool isCurrentCycle,
    Color cycleColor,
    CycleStudied cycleName,
    ColorScheme colorScheme,
  ) {
    return Row(
      children: [
        Icon(
          _getCycleIcon(cycleName),
          size: AppDimens.iconS,
          color: cycleColor,
        ),
        const SizedBox(width: AppDimens.spaceXS),
        Text(
          CycleFormatter.format(cycleName),
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: isCurrentCycle ? FontWeight.bold : FontWeight.w500,
            color: cycleColor,
          ),
        ),
        const SizedBox(width: AppDimens.spaceS),
        if (isCurrentCycle) _buildCurrentCycleBadge(theme, colorScheme),
        if (isHistory) _buildCompletedBadge(theme, colorScheme),
      ],
    );
  }

  Widget _buildCurrentCycleBadge(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.paddingS,
        vertical: AppDimens.paddingXXS,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colorScheme.tertiaryContainer, colorScheme.primaryContainer],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimens.radiusXS),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: AppDimens.opacityLight),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Text(
        'Current',
        style: theme.textTheme.labelSmall?.copyWith(
          color: colorScheme.onTertiaryContainer,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _buildCompletedBadge(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.paddingS,
        vertical: AppDimens.paddingXXS,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primaryContainer,
            colorScheme.primary.withValues(alpha: AppDimens.opacitySemi),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimens.radiusXS),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: AppDimens.opacityLight),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Text(
        'Completed',
        style: theme.textTheme.labelSmall?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.3,
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

  // Chọn icon thích hợp theo Material 3 cho từng cycle
  IconData _getCycleIcon(CycleStudied cycle) {
    switch (cycle) {
      case CycleStudied.firstTime:
        return Icons.looks_one;
      case CycleStudied.firstReview:
        return Icons.replay_5;
      case CycleStudied.secondReview:
        return Icons.replay_10;
      case CycleStudied.thirdReview:
        return Icons.replay_30;
      case CycleStudied.moreThanThreeReviews:
        return Icons.replay_circle_filled;
    }
  }
}
