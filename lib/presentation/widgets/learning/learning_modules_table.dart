import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spaced_learning_app/domain/models/learning_module.dart';
import 'package:spaced_learning_app/domain/models/progress.dart';
import 'package:spaced_learning_app/presentation/widgets/learning/module_details_bottom_sheet.dart';

class SimplifiedLearningModulesTable extends StatelessWidget {
  final List<LearningModule> modules;
  final bool isLoading;
  final ScrollController? verticalScrollController;

  const SimplifiedLearningModulesTable({
    super.key,
    required this.modules,
    this.isLoading = false,
    this.verticalScrollController,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text('Loading your modules...', style: theme.textTheme.bodyLarge),
          ],
        ),
      );
    }

    if (modules.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 100), // Extra space for footer
      physics: const AlwaysScrollableScrollPhysics(),
      controller: verticalScrollController,
      itemCount: modules.length + 1, // Adding header
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildTableHeader(context);
        }

        final moduleIndex = index - 1;
        final module = modules[moduleIndex];
        return _buildModuleCard(context, module, moduleIndex);
      },
    );
  }

  Widget _buildTableHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 8, top: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 7,
            child: Text(
              'Module',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              'Next Study',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Tasks',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModuleCard(
    BuildContext context,
    LearningModule module,
    int index,
  ) {
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 7,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          module.moduleTitle.isEmpty
                              ? 'Unnamed Module'
                              : module.moduleTitle,
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
                                module.bookName.isEmpty
                                    ? 'No book assigned'
                                    : module.bookName,
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
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
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Column(
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
                                    : (isDueToday
                                        ? Icons.event_available
                                        : Icons.event),
                                size: 16,
                                color: statusColor,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  dateFormatter.format(
                                    module.progressNextStudyDate!,
                                  ),
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: statusColor,
                                    fontWeight:
                                        isOverdue || isDueToday
                                            ? FontWeight.bold
                                            : null,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 4),
                        if (isOverdue || isDueToday || isDueSoon)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              isOverdue
                                  ? 'Overdue'
                                  : (isDueToday ? 'Due today' : 'Due soon'),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: statusColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Center(
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
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search_off_rounded,
                size: 64,
                color: theme.colorScheme.primary.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No modules found',
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your filters or check back later',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () {
                if (verticalScrollController != null) {
                  verticalScrollController!.animateTo(
                    0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                }
              },
              icon: const Icon(Icons.filter_alt),
              label: const Text('Change filters'),
            ),
          ],
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

  Color _getProgressColor(int? percent, ColorScheme colorScheme) {
    if (percent == null) return colorScheme.primary;

    if (percent >= 100) {
      return colorScheme.tertiary;
    } else if (percent >= 75) {
      return colorScheme.primary;
    } else if (percent >= 50) {
      return colorScheme.secondary;
    } else if (percent >= 25) {
      return Colors.orange;
    } else {
      return colorScheme.error;
    }
  }
}
