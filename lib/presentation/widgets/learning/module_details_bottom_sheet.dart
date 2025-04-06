import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/learning_module.dart';
import 'package:spaced_learning_app/presentation/utils/cycle_formatter.dart';

/// Bottom sheet hiển thị thông tin chi tiết về một module học tập
/// Được tối ưu cho giao diện mobile với đầy đủ chi tiết không hiển thị trong bảng đơn giản
class ModuleDetailsBottomSheet extends StatelessWidget {
  // Properties
  final LearningModule module;
  final String? heroTagPrefix;

  // Constructor
  const ModuleDetailsBottomSheet({
    super.key,
    required this.module,
    this.heroTagPrefix,
  });

  // Build method
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    return Container(
      decoration: _buildContainerDecoration(theme),
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
                  _buildActionButtons(context, theme),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Container decoration
  Decoration _buildContainerDecoration(ThemeData theme) {
    return BoxDecoration(
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
    );
  }

  // UI Components
  Widget _buildDragHandle(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(
        top: AppDimens.paddingM,
        bottom: AppDimens.paddingS,
      ),
      child: Container(
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
                        module.subject,
                        style: theme.textTheme.headlineSmall,
                      ),
                    ),
                  )
                  : Text(module.subject, style: theme.textTheme.headlineSmall),
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
          ),
          const SizedBox(width: AppDimens.spaceS),
          Expanded(
            child: Text(
              'From: ${module.book}',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
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
        _buildSectionTitle(theme, 'Module Details'),
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
            ),
            _buildDetailItem(
              context,
              theme,
              'Progress',
              '${module.percentage}%',
              Icons.trending_up,
              progressValue: module.percentage / 100,
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
                      ? Color(
                        CycleFormatter.getColorValue(module.cyclesStudied!),
                      )
                      : null,
            ),
            _buildDetailItem(
              context,
              theme,
              'Tasks',
              module.taskCount?.toString() ?? 'None',
              Icons.assignment,
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
        _buildSectionTitle(theme, 'Important Dates'),
        const SizedBox(height: AppDimens.spaceS),
        if (module.firstLearningDate != null)
          _buildDateItem(
            theme,
            'First Learning',
            module.firstLearningDate!,
            Icons.play_circle,
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
          ),
        ],
        if (module.lastStudyDate != null) ...[
          const SizedBox(height: AppDimens.spaceL),
          _buildDateItem(
            theme,
            'Last Study',
            module.lastStudyDate!,
            Icons.history,
          ),
        ],
      ],
    );
  }

  Widget _buildStudyHistorySection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(theme, 'Study History'),
        const SizedBox(height: AppDimens.spaceS),
        _buildHistoryItems(theme),
        if ((module.studyHistory?.length ?? 0) > 8) ...[
          const SizedBox(height: AppDimens.spaceXXS),
          _buildMoreSessionsIndicator(theme),
        ],
      ],
    );
  }

  // Helper Widgets
  Widget _buildSectionTitle(ThemeData theme, String title) {
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
  }) {
    final effectiveColor = color ?? theme.colorScheme.primary;
    // Sử dụng View.of(context) thay vì WidgetsBinding.instance.window
    final size =
        View.of(context).physicalSize / View.of(context).devicePixelRatio;
    final containerWidth =
        size.width < AppDimens.breakpointXS
            ? (size.width - AppDimens.spaceXXL * 2) / 2
            : (size.width - AppDimens.spaceXXL * 3) / 3;

    return Container(
      width: containerWidth,
      padding: const EdgeInsets.all(AppDimens.paddingL),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
        border: Border.all(
          color: effectiveColor.withOpacity(AppDimens.opacitySemi),
          width: AppDimens.dividerThickness,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          if (progressValue != null) ...[
            const SizedBox(height: AppDimens.spaceXXS),
            LinearProgressIndicator(
              value: progressValue,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(
                progressValue >= 0.9
                    ? Colors.green
                    : progressValue >= 0.7
                    ? Colors.orange
                    : Colors.red,
              ),
              borderRadius: BorderRadius.circular(AppDimens.radiusXXS),
              minHeight: AppDimens.lineProgressHeight,
            ),
          ],
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
  }) {
    final dateFormat = DateFormat('EEEE, MMMM d, yyyy');
    final color =
        isUpcoming ? theme.colorScheme.error : theme.colorScheme.primary;

    return Row(
      children: [
        Icon(icon, color: color, size: AppDimens.iconM),
        const SizedBox(width: AppDimens.spaceS),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                dateFormat.format(date),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: isUpcoming ? FontWeight.bold : null,
                  color: isUpcoming ? theme.colorScheme.error : null,
                ),
              ),
            ],
          ),
        ),
        if (isUpcoming)
          Chip(
            label: Text(
              'Due Soon',
              style: TextStyle(
                color: theme.colorScheme.onError,
                fontSize: AppDimens.fontS,
              ),
            ),
            backgroundColor: theme.colorScheme.error,
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
          ),
      ],
    );
  }

  Widget _buildHistoryItems(ThemeData theme) {
    final dateFormat = DateFormat('MMM d');
    final studyHistory = List<DateTime>.from(module.studyHistory!)
      ..sort((a, b) => b.compareTo(a));

    return Wrap(
      spacing: AppDimens.spaceXS,
      runSpacing: AppDimens.spaceXS,
      children:
          studyHistory.take(7).map((date) {
            final isToday =
                date.day == DateTime.now().day &&
                date.month == DateTime.now().month &&
                date.year == DateTime.now().year;
            return Tooltip(
              message: DateFormat('MMMM d, yyyy').format(date),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.paddingS,
                  vertical: AppDimens.paddingXXS,
                ),
                decoration: BoxDecoration(
                  color:
                      isToday
                          ? theme.colorScheme.primary.withOpacity(
                            AppDimens.opacitySemi,
                          )
                          : theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppDimens.radiusXS),
                  border: Border.all(
                    color:
                        isToday
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outline.withOpacity(
                              AppDimens.opacitySemi,
                            ),
                  ),
                ),
                child: Text(
                  dateFormat.format(date),
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

  Widget _buildMoreSessionsIndicator(ThemeData theme) {
    return Text(
      '+ ${module.studyHistory!.length - 8} more sessions',
      style: theme.textTheme.bodySmall?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
        fontStyle: FontStyle.italic,
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OutlinedButton.icon(
          icon: const Icon(Icons.close),
          label: const Text('Close'),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
