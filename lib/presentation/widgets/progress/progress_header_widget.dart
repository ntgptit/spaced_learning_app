import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:spaced_learning_app/core/extensions/color_extensions.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/progress.dart';
import 'package:spaced_learning_app/domain/models/repetition.dart';
import 'package:spaced_learning_app/presentation/utils/cycle_formatter.dart';
import 'package:spaced_learning_app/presentation/viewmodels/repetition_viewmodel.dart';

class ProgressHeaderWidget extends ConsumerWidget {
  final ProgressDetail progress;
  final VoidCallback onCycleCompleteDialogRequested;

  const ProgressHeaderWidget({
    super.key,
    required this.progress,
    required this.onCycleCompleteDialogRequested,
  });

  static const double kProgressShadowAlpha = 0.8;

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
            _buildCycleProgress(
              theme,
              cycleInfo,
              completedCount,
              totalCount,
              context,
            ),
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
    final progressColor = theme.colorScheme.success.withValues(alpha: 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeaderWithTrailing(
          theme,
          'Overall Progress',
          '${progress.percentComplete.toInt()}%',
          progressColor,
        ),
        const SizedBox(height: AppDimens.spaceS),
        _buildProgressBar(theme, progress.percentComplete / 100, progressColor),
      ],
    );
  }

  Widget _buildCycleProgress(
    ThemeData theme,
    String cycleInfo,
    int completed,
    int total,
    BuildContext context,
  ) {
    final progressValue = total > 0 ? completed / total : 0.0;
    final cycleColor = CycleFormatter.getColor(
      progress.cyclesStudied,
      context,
    ).saturate(0.2).withValues(alpha: 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              CycleFormatter.getIcon(progress.cyclesStudied),
              color: cycleColor,
              size: AppDimens.iconM,
            ),
            const SizedBox(width: AppDimens.spaceS),
            Text(
              'Study Cycle: ${CycleFormatter.getDisplayName(progress.cyclesStudied)}',
              style: theme.textTheme.titleMedium?.copyWith(
                color: cycleColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.spaceS),
        _buildProgressBar(theme, progressValue, cycleColor),
        const SizedBox(height: AppDimens.spaceXS),
        Text.rich(
          TextSpan(
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
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
            style: theme.textTheme.bodySmall,
          ),
        ),
        const SizedBox(height: AppDimens.spaceS),
        _buildCycleInfoCard(theme, cycleInfo),
      ],
    );
  }

  Widget _buildProgressBar(ThemeData theme, double value, Color progressColor) {
    return Stack(
      children: [
        Container(
          height: AppDimens.lineProgressHeightL,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(AppDimens.radiusS),
          ),
        ),
        FractionallySizedBox(
          widthFactor: value,
          child: Container(
            height: AppDimens.lineProgressHeightL,
            decoration: BoxDecoration(
              color: progressColor,
              borderRadius: BorderRadius.circular(AppDimens.radiusS),
              boxShadow: [
                BoxShadow(
                  color: progressColor.withValues(alpha: kProgressShadowAlpha),
                  blurRadius: AppDimens.shadowRadiusS,
                  offset: const Offset(0, AppDimens.shadowOffsetS),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCycleInfoCard(ThemeData theme, String infoText) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.paddingM),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
        border: Border.all(color: theme.colorScheme.outlineVariant, width: 1.5),
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
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface,
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
    return Container(
      padding: const EdgeInsets.all(AppDimens.paddingM),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
        border: Border.all(color: theme.colorScheme.outlineVariant, width: 1.0),
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
            color: theme.colorScheme.outlineVariant,
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: AppDimens.iconS, color: theme.colorScheme.primary),
        const SizedBox(width: AppDimens.spaceS),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
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

  Widget _buildSectionHeaderWithTrailing(
    ThemeData theme,
    String title,
    String trailing,
    Color highlightColor,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.paddingS,
            vertical: AppDimens.paddingXXS,
          ),
          decoration: BoxDecoration(
            color: highlightColor,
            borderRadius: BorderRadius.circular(AppDimens.radiusS),
          ),
          child: Text(
            trailing,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSuccess,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
