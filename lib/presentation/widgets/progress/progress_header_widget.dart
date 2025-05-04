// lib/presentation/widgets/progress/progress_header_widget.dart
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
    final colorScheme = theme.colorScheme;
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
      elevation: 0,
      color: colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusL),
        side: BorderSide(color: colorScheme.outlineVariant, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderSection(theme, colorScheme),
          Divider(color: colorScheme.outlineVariant),
          Padding(
            padding: const EdgeInsets.all(AppDimens.paddingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOverallProgress(theme, colorScheme),
                const SizedBox(height: AppDimens.spaceL),
                _buildCycleProgress(
                  theme,
                  colorScheme,
                  cycleInfo,
                  completedCount,
                  totalCount,
                  context,
                ),
                const SizedBox(height: AppDimens.spaceL),
                _buildMetadataSection(
                  theme,
                  colorScheme,
                  startDateText,
                  nextDateText,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection(ThemeData theme, ColorScheme colorScheme) {
    final textStyle = theme.textTheme.titleLarge?.copyWith(
      fontWeight: FontWeight.bold,
      color: colorScheme.onPrimaryContainer,
    );

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.8),
      ),
      padding: const EdgeInsets.all(AppDimens.paddingL),
      child: Row(
        children: [
          Container(
            width: AppDimens.iconXL,
            height: AppDimens.iconXL,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.menu_book_rounded,
              color: colorScheme.primary,
              size: AppDimens.iconL,
            ),
          ),
          const SizedBox(width: AppDimens.spaceM),
          Expanded(
            child: Text(
              progress.moduleTitle ?? 'Module',
              style: textStyle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverallProgress(ThemeData theme, ColorScheme colorScheme) {
    final progressValue = progress.percentComplete / 100;
    final progressColor = _getProgressColor(progressValue, colorScheme);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Overall Progress',
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
                color: progressColor,
                borderRadius: BorderRadius.circular(AppDimens.radiusS),
              ),
              child: Text(
                '${progress.percentComplete.toInt()}%',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.spaceS),
        Stack(
          children: [
            // Background track
            Container(
              height: AppDimens.lineProgressHeightL,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppDimens.radiusS),
              ),
            ),
            // Progress bar
            FractionallySizedBox(
              widthFactor: progressValue,
              child: Container(
                height: AppDimens.lineProgressHeightL,
                decoration: BoxDecoration(
                  color: progressColor,
                  borderRadius: BorderRadius.circular(AppDimens.radiusS),
                  boxShadow: [
                    BoxShadow(
                      color: progressColor.withValues(alpha: 0.4),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
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
    ColorScheme colorScheme,
    String cycleInfo,
    int completed,
    int total,
    BuildContext context,
  ) {
    final cycleColor = CycleFormatter.getColor(progress.cyclesStudied, context);
    final progressValue = total > 0 ? completed / total : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimens.paddingXS),
              decoration: BoxDecoration(
                color: cycleColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                CycleFormatter.getIcon(progress.cyclesStudied),
                color: cycleColor,
                size: AppDimens.iconM,
              ),
            ),
            const SizedBox(width: AppDimens.spaceS),
            Text(
              'Current Cycle: ${CycleFormatter.getDisplayName(progress.cyclesStudied)}',
              style: theme.textTheme.titleMedium?.copyWith(
                color: cycleColor,
                fontWeight: FontWeight.normal,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.paddingS,
                vertical: AppDimens.paddingXXS,
              ),
              decoration: BoxDecoration(
                color: cycleColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppDimens.radiusXL),
                border: Border.all(color: cycleColor, width: 1),
              ),
              child: Text(
                '$completed/$total',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: cycleColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
                      color: cycleColor.withValues(alpha: 0.4),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.spaceM),
        _buildCycleInfoCard(theme, colorScheme, cycleInfo, cycleColor),
      ],
    );
  }

  Widget _buildCycleInfoCard(
    ThemeData theme,
    ColorScheme colorScheme,
    String infoText,
    Color cycleColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.paddingM),
      decoration: BoxDecoration(
        color: cycleColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
        border: Border.all(color: cycleColor.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(
              Icons.info_outline,
              color: cycleColor,
              size: AppDimens.iconM,
            ),
          ),
          const SizedBox(width: AppDimens.spaceS),
          Expanded(
            child: Text(
              infoText,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetadataSection(
    ThemeData theme,
    ColorScheme colorScheme,
    String startDateText,
    String nextDateText,
  ) {
    final isOverdue =
        progress.nextStudyDate != null &&
        progress.nextStudyDate!.isBefore(DateTime.now());

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: colorScheme.surfaceContainerLowest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
        side: BorderSide(color: colorScheme.outlineVariant, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingM),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: _buildDateItem(
                  theme,
                  colorScheme,
                  'Start Date',
                  startDateText,
                  Icons.calendar_today_outlined,
                  colorScheme.primary,
                ),
              ),
              VerticalDivider(
                width: AppDimens.spaceL,
                thickness: 1,
                color: colorScheme.outlineVariant,
              ),
              Expanded(
                child: _buildDateItem(
                  theme,
                  colorScheme,
                  'Next Review',
                  nextDateText,
                  Icons.event_note,
                  isOverdue ? colorScheme.error : colorScheme.secondary,
                  isHighlighted: isOverdue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateItem(
    ThemeData theme,
    ColorScheme colorScheme,
    String label,
    String value,
    IconData icon,
    Color iconColor, {
    bool isHighlighted = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: AppDimens.iconS, color: iconColor),
            const SizedBox(width: AppDimens.spaceXS),
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.spaceXS),
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: isHighlighted ? colorScheme.error : colorScheme.onSurface,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Color _getProgressColor(double progress, ColorScheme colorScheme) {
    if (progress >= 0.9) return colorScheme.success;
    if (progress >= 0.7) return colorScheme.tertiary;
    if (progress >= 0.4) return colorScheme.primary;
    if (progress >= 0.2) return colorScheme.secondary;
    return colorScheme.error;
  }
}
