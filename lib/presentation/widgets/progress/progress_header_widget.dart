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
    BuildContext context,
  ) {
    final progressValue = total > 0 ? completed / total : 0.0;
    final cycleColor = CycleFormatter.getColor(progress.cyclesStudied, context);
    final colorScheme = theme.colorScheme;

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
          const SizedBox(width: AppDimens.spaceS),
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
}
