import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/progress.dart';
import 'package:spaced_learning_app/domain/models/repetition.dart';
import 'package:spaced_learning_app/presentation/viewmodels/repetition_viewmodel.dart';

class ProgressHeaderWidget extends StatelessWidget {
  final ProgressDetail progress;
  final VoidCallback onCycleCompleteDialogRequested;

  const ProgressHeaderWidget({
    super.key,
    required this.progress,
    required this.onCycleCompleteDialogRequested,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('MMM dd, yyyy');

    final startDateText =
        progress.firstLearningDate != null
            ? dateFormat.format(progress.firstLearningDate!)
            : 'Not started';

    final nextDateText =
        progress.nextStudyDate != null
            ? dateFormat.format(progress.nextStudyDate!)
            : 'Not scheduled';

    final completedCount =
        progress.repetitions
            .where((r) => r.status == RepetitionStatus.completed)
            .length;
    final totalCount = progress.repetitions.length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(theme),
            const SizedBox(height: AppDimens.spaceL),
            _buildOverallProgress(theme),
            const SizedBox(height: AppDimens.spaceL),
            Selector<RepetitionViewModel, String>(
              selector:
                  (context, vm) => vm.getCycleInfo(progress.cyclesStudied),
              builder: (context, cycleInfo, child) {
                return _buildCycleProgress(
                  theme,
                  cycleInfo,
                  completedCount,
                  totalCount,
                );
              },
            ),
            const SizedBox(height: AppDimens.spaceL),
            _buildMetadata(theme, startDateText, nextDateText),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(ThemeData theme) {
    return Text(
      progress.moduleTitle ?? 'Module',
      style: theme.textTheme.titleLarge,
    );
  }

  Widget _buildOverallProgress(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          theme,
          'Overall Progress',
          '${progress.percentComplete.toInt()}%',
        ),
        const SizedBox(height: AppDimens.spaceS),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppDimens.radiusS),
          child: LinearProgressIndicator(
            value: progress.percentComplete / 100,
            minHeight: AppDimens.lineProgressHeightL,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
          ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Study Cycle: ${_formatCycleStudied(progress.cyclesStudied)}',
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: AppDimens.spaceS),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppDimens.radiusS),
          child: LinearProgressIndicator(
            value: total > 0 ? completed / total : 0,
            minHeight: AppDimens.lineProgressHeightL,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            color: theme.colorScheme.secondary,
          ),
        ),
        const SizedBox(height: AppDimens.spaceXS),
        Text(
          '$completed/$total repetitions completed in this cycle',
          style: theme.textTheme.bodySmall,
        ),
        const SizedBox(height: AppDimens.spaceS),
        _buildCycleInfoCard(theme, cycleInfo),
      ],
    );
  }

  Widget _buildCycleInfoCard(ThemeData theme, String infoText) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.paddingM),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withOpacity(
          AppDimens.opacityMedium,
        ),
        borderRadius: BorderRadius.circular(AppDimens.radiusS),
      ),
      child: Row(
        children: [
          Icon(
            Icons.lightbulb,
            color: theme.colorScheme.primary,
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
    return Row(
      children: [
        Expanded(
          child: _buildInfoItem(
            theme,
            'Start Date',
            startDateText,
            Icons.play_circle_outline,
          ),
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
    );
  }

  Widget _buildInfoItem(
    ThemeData theme,
    String label,
    String value,
    IconData icon,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: AppDimens.iconS, color: theme.colorScheme.primary),
        const SizedBox(width: AppDimens.spaceS),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: theme.textTheme.bodySmall),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: theme.textTheme.titleMedium),
        Text(
          trailing,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
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
        return 'More than 3 Review Cycles';
    }
  }
}
