import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spaced_learning_app/domain/models/learning_module.dart';
import 'package:spaced_learning_app/domain/models/progress.dart';
import 'package:spaced_learning_app/presentation/widgets/learning/module_details_bottom_sheet.dart';

class ModuleCard extends StatelessWidget {
  final LearningModule module;
  final int index;

  const ModuleCard({super.key, required this.module, required this.index});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final isOverdue =
        module.progressNextStudyDate != null &&
        module.progressNextStudyDate!.isBefore(DateTime.now()) &&
        !DateUtils.isSameDay(module.progressNextStudyDate, DateTime.now());

    final isDueToday =
        module.progressNextStudyDate != null &&
        DateUtils.isSameDay(module.progressNextStudyDate, DateTime.now());

    final isDueSoon =
        module.progressNextStudyDate != null &&
        module.progressNextStudyDate!.isAfter(DateTime.now()) &&
        module.progressNextStudyDate!.difference(DateTime.now()).inDays <= 2;

    // Color status logic
    Color statusColor = colorScheme.primary;
    if (isOverdue) {
      statusColor = colorScheme.error;
    } else if (isDueToday) {
      statusColor = colorScheme.tertiary;
    } else if (isDueSoon) {
      statusColor = Colors.orange;
    }

    // Generate cycle color if available
    Color? cycleColor;
    String? cycleText;
    if (module.progressCyclesStudied != null) {
      cycleText = _formatCycleStudied(module.progressCyclesStudied!);
      cycleColor = _getCycleColor(module.progressCyclesStudied!, colorScheme);
    }

    final dateFormatter = DateFormat('MMM dd, yyyy');

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: colorScheme.outlineVariant.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () => _showModuleDetails(context, module),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 7,
                child: _buildModuleInfo(
                  theme,
                  colorScheme,
                  cycleText,
                  cycleColor,
                ),
              ),
              Expanded(
                flex: 4,
                child: _buildNextStudyInfo(
                  theme,
                  colorScheme,
                  statusColor,
                  dateFormatter,
                  isOverdue,
                  isDueToday,
                  isDueSoon,
                ),
              ),
              Expanded(flex: 2, child: _buildTasksInfo(theme, colorScheme)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModuleInfo(
    ThemeData theme,
    ColorScheme colorScheme,
    String? cycleText,
    Color? cycleColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          module.moduleTitle.isEmpty ? 'Unnamed Module' : module.moduleTitle,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(
              Icons.menu_book,
              size: 14,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                module.bookName.isEmpty ? 'No book assigned' : module.bookName,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        if (cycleText != null) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color:
                  cycleColor?.withOpacity(0.1) ??
                  colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              cycleText,
              style: theme.textTheme.bodySmall?.copyWith(
                color: cycleColor ?? colorScheme.secondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildNextStudyInfo(
    ThemeData theme,
    ColorScheme colorScheme,
    Color statusColor,
    DateFormat dateFormatter,
    bool isOverdue,
    bool isDueToday,
    bool isDueSoon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (module.progressNextStudyDate == null)
          Text(
            'Not scheduled',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
          )
        else
          Row(
            children: [
              Icon(
                isOverdue
                    ? Icons.event_busy
                    : (isDueToday ? Icons.event_available : Icons.event),
                size: 16,
                color: statusColor,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  dateFormatter.format(module.progressNextStudyDate!),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: statusColor,
                    fontWeight:
                        isOverdue || isDueToday ? FontWeight.bold : null,
                  ),
                ),
              ),
            ],
          ),
        const SizedBox(height: 4),
        if (isOverdue || isDueToday || isDueSoon)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              isOverdue ? 'Overdue' : (isDueToday ? 'Due today' : 'Due soon'),
              style: theme.textTheme.bodySmall?.copyWith(
                color: statusColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTasksInfo(ThemeData theme, ColorScheme colorScheme) {
    return Center(
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color:
              module.progressDueTaskCount > 0
                  ? colorScheme.primaryContainer
                  : colorScheme.surfaceContainerHigh,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            module.progressDueTaskCount.toString(),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color:
                  module.progressDueTaskCount > 0
                      ? colorScheme.onPrimaryContainer
                      : colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }

  void _showModuleDetails(BuildContext context, LearningModule module) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => ModuleDetailsBottomSheet(
            module: module,
            heroTagPrefix: 'learning_list',
          ),
    );
  }

  String _formatCycleStudied(CycleStudied cycle) {
    switch (cycle) {
      case CycleStudied.firstTime:
        return 'First Time';
      case CycleStudied.firstReview:
        return 'First Review';
      case CycleStudied.secondReview:
        return 'Second Review';
      case CycleStudied.thirdReview:
        return 'Third Review';
      case CycleStudied.moreThanThreeReviews:
        return 'Advanced Review';
    }
  }

  Color _getCycleColor(CycleStudied cycle, ColorScheme colorScheme) {
    switch (cycle) {
      case CycleStudied.firstTime:
        return colorScheme.primary;
      case CycleStudied.firstReview:
        return colorScheme.secondary;
      case CycleStudied.secondReview:
        return colorScheme.tertiary;
      case CycleStudied.thirdReview:
        return Colors.orange;
      case CycleStudied.moreThanThreeReviews:
        return Colors.deepPurple;
    }
  }
}
