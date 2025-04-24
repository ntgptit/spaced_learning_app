import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:spaced_learning_app/core/extensions/color_extensions.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/progress.dart';
import 'package:spaced_learning_app/domain/models/repetition.dart';
import 'package:spaced_learning_app/presentation/viewmodels/repetition_viewmodel.dart';

class ProgressHeaderWidget extends ConsumerWidget {
  final ProgressDetail progress;
  final VoidCallback onCycleCompleteDialogRequested;

  const ProgressHeaderWidget({
    super.key,
    required this.progress,
    required this.onCycleCompleteDialogRequested,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('MMM dd, yyyy');

    final startDateText = progress.firstLearningDate != null
        ? dateFormat.format(progress.firstLearningDate!)
        : 'Not started';

    final nextDateText = progress.nextStudyDate != null
        ? dateFormat.format(progress.nextStudyDate!)
        : 'Not scheduled';

    final completedCount = progress.repetitions
        .where((r) => r.status == RepetitionStatus.completed)
        .length;
    final totalCount = progress.repetitions.length;

    final cycleInfo = ref.watch(getCycleInfoProvider(progress.cyclesStudied));

    return Card(
      elevation: AppDimens.elevationS,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusL),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(theme),
            const SizedBox(height: AppDimens.spaceL),
            _buildOverallProgress(theme),
            const SizedBox(height: AppDimens.spaceL),
            _buildCycleProgress(theme, cycleInfo, completedCount, totalCount),
            const SizedBox(height: AppDimens.spaceL),
            _buildMetadata(theme, startDateText, nextDateText),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(ThemeData theme) {
    return Row(
      children: [
        Icon(
          Icons.book_outlined,
          color: theme.colorScheme.primary,
          size: AppDimens.iconL,
        ),
        const SizedBox(width: AppDimens.spaceM),
        Expanded(
          child: Text(
            progress.moduleTitle ?? 'Module',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildOverallProgress(ThemeData theme) {
    final colorScheme = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          theme,
          'Overall Progress',
          '${progress.percentComplete.toInt()}%',
        ),
        const SizedBox(height: AppDimens.spaceS),
        Stack(
          children: [
            Container(
              height: AppDimens.lineProgressHeightL,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppDimens.radiusS),
              ),
            ),
            FractionallySizedBox(
              widthFactor: progress.percentComplete / 100,
              child: Container(
                height: AppDimens.lineProgressHeightL,
                decoration: BoxDecoration(
                  color: colorScheme.success,
                  borderRadius: BorderRadius.circular(AppDimens.radiusS),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.success.withValues(
                        alpha: AppDimens.opacitySemi,
                      ),
                      blurRadius: AppDimens.shadowRadiusS,
                      offset: const Offset(0, AppDimens.shadowOffsetS),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCycleProgress(
    ThemeData theme,
    String cycleInfo,
    int completed,
    int total,
  ) {
    final progressValue = total > 0 ? completed / total : 0.0;
    final cycleColor = _getCycleColor(progress.cyclesStudied);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              _getCycleIcon(progress.cyclesStudied),
              color: cycleColor,
              size: AppDimens.iconM,
            ),
            const SizedBox(width: AppDimens.spaceS),
            Text(
              'Study Cycle: ${_formatCycleStudied(progress.cyclesStudied)}',
              style: theme.textTheme.titleMedium?.copyWith(color: cycleColor),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.spaceS),
        Stack(
          children: [
            Container(
              height: AppDimens.lineProgressHeightL,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppDimens.radiusS),
              ),
            ),
            FractionallySizedBox(
              widthFactor: progressValue,
              child: Container(
                height: AppDimens.lineProgressHeightL,
                decoration: BoxDecoration(
                  color: cycleColor,
                  borderRadius: BorderRadius.circular(AppDimens.radiusS),
                  boxShadow: [
                    BoxShadow(
                      color: cycleColor.withValues(
                        alpha: AppDimens.opacitySemi,
                      ),
                      blurRadius: AppDimens.shadowRadiusS,
                      offset: const Offset(0, AppDimens.shadowOffsetS),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.spaceXS),
        RichText(
          text: TextSpan(
            style: theme.textTheme.bodySmall,
            children: [
              TextSpan(
                text: '$completed',
                style: TextStyle(
                  color: cycleColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: '/$total repetitions completed in this cycle',
                style: TextStyle(color: colorScheme.onSurface),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimens.spaceS),
        _buildCycleInfoCard(theme, cycleInfo),
      ],
    );
  }

  Widget _buildCycleInfoCard(ThemeData theme, String infoText) {
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppDimens.paddingM),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
        border: Border.all(color: colorScheme.outlineVariant, width: 1),
      ),
      child: Row(
        children: [
          Icon(
            Icons.lightbulb,
            color: colorScheme.primary,
            size: AppDimens.iconM,
          ),
          const SizedBox(width: AppDimens.spaceS),
          Expanded(
            child: Text(
              infoText,
              style: theme.textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetadata(
    ThemeData theme,
    String startDateText,
    String nextDateText,
  ) {
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppDimens.paddingM),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildInfoItem(
              theme,
              'Start Date',
              startDateText,
              Icons.play_circle_outline,
            ),
          ),
          Container(
            height: AppDimens.iconXL,
            width: AppDimens.dividerThickness,
            color: colorScheme.outlineVariant,
          ),
          Expanded(
            child: _buildInfoItem(
              theme,
              'Next Review',
              nextDateText,
              Icons.event,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(
    ThemeData theme,
    String label,
    String value,
    IconData icon,
  ) {
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: AppDimens.iconS, color: colorScheme.primary),
        const SizedBox(width: AppDimens.spaceS),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title, String trailing) {
    final colorScheme = theme.colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: theme.textTheme.titleMedium),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.paddingS,
            vertical: AppDimens.paddingXXS,
          ),
          decoration: BoxDecoration(
            color: colorScheme.success.withValues(
              alpha: AppDimens.opacityVeryHigh,
            ),
            borderRadius: BorderRadius.circular(AppDimens.radiusS),
          ),
          child: Text(
            trailing,
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSuccess,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  IconData _getCycleIcon(CycleStudied cycle) {
    switch (cycle) {
      case CycleStudied.firstTime:
        return Icons.looks_one;
      case CycleStudied.firstReview:
        return Icons.looks_two;
      case CycleStudied.secondReview:
        return Icons.looks_3;
      case CycleStudied.thirdReview:
        return Icons.looks_4;
      case CycleStudied.moreThanThreeReviews:
        return Icons.looks_5;
    }
  }

  Color _getCycleColor(CycleStudied cycle) {
    const List<Color> cycleColors = [
      Color(0xFF4CAF50), // Green 500 (First Time)
      Color(0xFF2196F3), // Blue 500 (First Review)
      Color(0xFFF4511E), // Deep Orange 600 (Second Review)
      Color(0xFFAB47BC), // Purple 400 (Third Review)
      Color(0xFFEF5350), // Red 400 (More Than Three Reviews)
    ];
    switch (cycle) {
      case CycleStudied.firstTime:
        return cycleColors[0];
      case CycleStudied.firstReview:
        return cycleColors[1];
      case CycleStudied.secondReview:
        return cycleColors[2];
      case CycleStudied.thirdReview:
        return cycleColors[3];
      case CycleStudied.moreThanThreeReviews:
        return cycleColors[4];
    }
  }

  String _formatCycleStudied(CycleStudied cycle) {
    switch (cycle) {
      case CycleStudied.firstTime:
        return 'First Cycle';
      case CycleStudied.firstReview:
        return 'First Review Cycle';
      case CycleStudied.secondReview:
        return 'Second Review Cycle';
      case CycleStudied.thirdReview:
        return 'Third Review Cycle';
      case CycleStudied.moreThanThreeReviews:
        return 'Advanced Review Cycle';
    }
  }
}
