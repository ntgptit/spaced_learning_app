import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spaced_learning_app/core/theme/app_colors.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/learning_module.dart';
import 'package:spaced_learning_app/presentation/utils/cycle_formatter.dart';

class ModuleDetailsBottomSheet extends StatelessWidget {
  final LearningModule module;
  final String? heroTagPrefix;

  const ModuleDetailsBottomSheet({
    super.key,
    required this.module,
    this.heroTagPrefix,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    return Container(
      key: const Key('module_details_bottom_sheet'),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppDimens.radiusL),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(AppDimens.opacityMedium),
            blurRadius: AppDimens.shadowRadiusL,
            spreadRadius: AppDimens.shadowOffsetS,
          ),
        ],
      ),
      constraints: BoxConstraints(maxHeight: mediaQuery.size.height * 0.8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDragHandle(theme),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimens.paddingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildModuleTitle(theme),
                  _buildBookInfo(theme),
                  const Divider(height: AppDimens.paddingXXL),
                  _buildModuleDetailsSection(context, theme),
                  const Divider(height: AppDimens.paddingXXL),
                  _buildDatesSection(theme),
                  if (module.studyHistory?.isNotEmpty ?? false) ...[
                    const SizedBox(height: AppDimens.spaceXL),
                    _buildStudyHistorySection(theme),
                  ],
                  const SizedBox(height: AppDimens.spaceXL),
                  _buildActionButtons(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDragHandle(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(
        top: AppDimens.paddingM,
        bottom: AppDimens.paddingS,
      ),
      child: Container(
        key: const Key('drag_handle'),
        width: AppDimens.moduleIndicatorSize,
        height: AppDimens.dividerThickness * 2,
        decoration: BoxDecoration(
          color: theme.colorScheme.onSurfaceVariant.withOpacity(
            AppDimens.opacitySemi,
          ),
          borderRadius: BorderRadius.circular(AppDimens.radiusS),
        ),
      ),
    );
  }

  Widget _buildModuleTitle(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child:
              heroTagPrefix != null
                  ? Hero(
                    tag: '${heroTagPrefix}_${module.id}',
                    child: Material(
                      color: Colors.transparent,
                      child: Text(
                        module.subject.isEmpty
                            ? 'Unnamed Module'
                            : module.subject,
                        style: theme.textTheme.headlineSmall,
                        key: const Key('module_title'),
                      ),
                    ),
                  )
                  : Text(
                    module.subject.isEmpty ? 'Unnamed Module' : module.subject,
                    style: theme.textTheme.headlineSmall,
                    key: const Key('module_title'),
                  ),
        ),
      ],
    );
  }

  Widget _buildBookInfo(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(top: AppDimens.paddingS),
      child: Row(
        children: [
          Icon(
            Icons.book,
            color: theme.colorScheme.primary,
            size: AppDimens.iconS,
            key: const Key('book_icon'),
          ),
          const SizedBox(width: AppDimens.spaceS),
          Expanded(
            child: Text(
              'From: ${module.book.isEmpty ? 'No Book' : module.book}',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
              key: const Key('book_info'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModuleDetailsSection(BuildContext context, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          theme,
          'Module Details',
          key: const Key('details_section_title'),
        ),
        Wrap(
          spacing: AppDimens.spaceL,
          runSpacing: AppDimens.spaceL,
          children: [
            _buildDetailItem(
              context,
              theme,
              'Word Count',
              module.wordCount.toString(),
              Icons.text_fields,
              key: const Key('word_count_item'),
            ),
            _buildDetailItem(
              context,
              theme,
              'Progress',
              '${module.percentage}%',
              Icons.trending_up,
              progressValue: module.percentage / 100,
              key: const Key('progress_item'),
            ),
            _buildDetailItem(
              context,
              theme,
              'Cycle',
              module.cyclesStudied != null
                  ? CycleFormatter.format(module.cyclesStudied!)
                  : 'Not started',
              Icons.loop,
              color:
                  module.cyclesStudied != null
                      ? CycleFormatter.getColor(module.cyclesStudied!)
                      : null,
              key: const Key('cycle_item'),
            ),
            _buildDetailItem(
              context,
              theme,
              'Tasks',
              module.taskCount?.toString() ?? 'None',
              Icons.assignment,
              key: const Key('tasks_item'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDatesSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          theme,
          'Important Dates',
          key: const Key('dates_section_title'),
        ),
        const SizedBox(height: AppDimens.spaceS),
        if (module.firstLearningDate != null)
          _buildDateItem(
            theme,
            'First Learning',
            module.firstLearningDate!,
            Icons.play_circle,
            key: const Key('first_learning_date'),
          ),
        if (module.nextStudyDate != null) ...[
          const SizedBox(height: AppDimens.spaceL),
          _buildDateItem(
            theme,
            'Next Study',
            module.nextStudyDate!,
            Icons.event,
            isUpcoming: module.nextStudyDate!.isBefore(
              DateTime.now().add(const Duration(days: 3)),
            ),
            key: const Key('next_study_date'),
          ),
        ],
        if (module.lastStudyDate != null) ...[
          const SizedBox(height: AppDimens.spaceL),
          _buildDateItem(
            theme,
            'Last Study',
            module.lastStudyDate!,
            Icons.history,
            key: const Key('last_study_date'),
          ),
        ],
      ],
    );
  }

  Widget _buildStudyHistorySection(ThemeData theme) {
    final studyHistory = List<DateTime>.from(module.studyHistory!)
      ..sort((a, b) => b.compareTo(a));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          theme,
          'Study History',
          key: const Key('history_section_title'),
        ),
        const SizedBox(height: AppDimens.spaceS),
        _buildHistoryItems(theme, studyHistory),
        if (studyHistory.length > 7) ...[
          const SizedBox(height: AppDimens.spaceXXS),
          Text(
            '+ ${studyHistory.length - 7} more sessions',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
            key: const Key('more_sessions_text'),
          ),
        ],
      ],
    );
  }

  Widget _buildSectionTitle(ThemeData theme, String title, {Key? key}) {
    return Row(
      children: [
        Icon(
          Icons.info_outline,
          size: AppDimens.iconM,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: AppDimens.spaceS),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
          key: key,
        ),
      ],
    );
  }

  Widget _buildDetailItem(
    BuildContext context,
    ThemeData theme,
    String label,
    String value,
    IconData icon, {
    double? progressValue,
    Color? color,
    Key? key,
  }) {
    final effectiveColor = color ?? theme.colorScheme.primary;
    final width = MediaQuery.of(context).size.width;
    final containerWidth =
        width < AppDimens.breakpointXS
            ? (width - AppDimens.spaceXXL * 2) / 2
            : (width - AppDimens.spaceXXL * 3) / 3;

    return Container(
      key: key,
      width: containerWidth,
      constraints: const BoxConstraints(minHeight: AppDimens.thumbnailSizeM),
      padding: const EdgeInsets.all(AppDimens.paddingL),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
        border: Border.all(
          color: effectiveColor.withOpacity(AppDimens.opacitySemi),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(icon, size: AppDimens.iconS, color: effectiveColor),
              const SizedBox(width: AppDimens.spaceS),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spaceXXS),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: effectiveColor,
            ),
          ),
          const SizedBox(height: AppDimens.spaceXXS),
          if (progressValue != null)
            LinearProgressIndicator(
              value: progressValue,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(
                progressValue >= 0.9
                    ? AppColors.successLight
                    : progressValue >= 0.7
                    ? AppColors.warningLight
                    : AppColors.lightError,
              ),
              borderRadius: BorderRadius.circular(AppDimens.radiusXXS),
              minHeight: AppDimens.lineProgressHeight,
            )
          else
            const SizedBox(
              height: AppDimens.lineProgressHeight,
            ), // Placeholder để đồng bộ chiều cao
        ],
      ),
    );
  }

  Widget _buildDateItem(
    ThemeData theme,
    String label,
    DateTime date,
    IconData icon, {
    bool isUpcoming = false,
    Key? key,
  }) {
    final color = isUpcoming ? AppColors.lightError : theme.colorScheme.primary;

    return Row(
      key: key,
      children: [
        Icon(icon, color: color, size: AppDimens.iconM),
        const SizedBox(width: AppDimens.spaceS),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: theme.textTheme.bodyMedium),
              Text(
                DateFormat('EEEE, MMMM d, yyyy').format(date),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: isUpcoming ? AppColors.lightError : null,
                  fontWeight: isUpcoming ? FontWeight.bold : null,
                ),
              ),
            ],
          ),
        ),
        if (isUpcoming)
          const Chip(
            label: Text(
              'Due Soon',
              style: TextStyle(
                color: AppColors.lightOnError,
                fontSize: AppDimens.fontS,
              ),
            ),
            backgroundColor: AppColors.lightError,
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
          ),
      ],
    );
  }

  Widget _buildHistoryItems(ThemeData theme, List<DateTime> studyHistory) {
    final today = DateTime.now();

    return Wrap(
      key: const Key('history_items'),
      spacing: AppDimens.spaceXS,
      runSpacing: AppDimens.spaceXS,
      children:
          studyHistory.take(7).map((date) {
            final isToday =
                date.year == today.year &&
                date.month == today.month &&
                date.day == today.day;
            final bgColor =
                isToday
                    ? theme.colorScheme.primary.withOpacity(
                      AppDimens.opacitySemi,
                    )
                    : theme.colorScheme.surfaceContainerHighest;
            final borderColor =
                isToday
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline.withOpacity(
                      AppDimens.opacitySemi,
                    );

            return Tooltip(
              message: DateFormat('MMMM d, yyyy').format(date),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.paddingS,
                  vertical: AppDimens.paddingXXS,
                ),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(AppDimens.radiusXS),
                  border: Border.all(color: borderColor),
                ),
                child: Text(
                  DateFormat('MMM d').format(date),
                  style: TextStyle(
                    fontSize: AppDimens.fontM,
                    fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                    color:
                        isToday
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface,
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        OutlinedButton.icon(
          key: const Key('close_button'),
          icon: const Icon(Icons.close),
          label: const Text('Close'),
          onPressed: () => Navigator.pop(context),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.paddingM),
          ),
        ),
        ElevatedButton.icon(
          key: const Key('study_button'),
          icon: const Icon(Icons.play_arrow),
          label: const Text('Start Studying'),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Starting study session...')),
            );
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.paddingM),
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
          ),
        ),
      ],
    );
  }
}
