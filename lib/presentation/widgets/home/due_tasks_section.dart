// lib/presentation/widgets/home/due_tasks_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/progress.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_card.dart';
import 'package:spaced_learning_app/presentation/widgets/common/state/sl_empty_state_widget.dart';

class DueTasksSection extends ConsumerWidget {
  final List<ProgressDetail> tasks;
  final VoidCallback onViewAllTasks;

  const DueTasksSection({
    super.key,
    required this.tasks,
    required this.onViewAllTasks,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Debug log: number of tasks received from parent
    debugPrint('[DueTasksSection] Received ${tasks.length} tasks from parent');

    // Filter due and overdue tasks
    final dueTasks = _getDueAndOverdueTasks(tasks);

    // Debug log: number of tasks after filtering
    debugPrint(
      '[DueTasksSection] After filtering: ${dueTasks.length} due tasks',
    );

    // Debug more about the dates of tasks
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    for (final task in tasks.take(3)) {
      final dueDate = task.nextStudyDate != null
          ? DateTime(
              task.nextStudyDate!.year,
              task.nextStudyDate!.month,
              task.nextStudyDate!.day,
            )
          : null;
      final isDue = dueDate != null && !dueDate.isAfter(today);
      debugPrint(
        '[DueTasksSection] Task ${task.id.substring(0, 8)}: dueDate=${dueDate?.toString() ?? 'null'}, isDue=$isDue',
      );
    }

    // Sort tasks to prioritize overdue ones
    dueTasks.sort((a, b) {
      // If both have nextStudyDate
      if (a.nextStudyDate != null && b.nextStudyDate != null) {
        // Sort by ascending date (most overdue first)
        return a.nextStudyDate!.compareTo(b.nextStudyDate!);
      }
      // Bring task with nextStudyDate up
      if (a.nextStudyDate != null) return -1;
      if (b.nextStudyDate != null) return 1;
      return 0;
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Due Today',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (dueTasks.isNotEmpty)
              TextButton.icon(
                onPressed: onViewAllTasks,
                icon: const Icon(Icons.chevron_right),
                label: const Text('View All'),
              ),
          ],
        ),
        const SizedBox(height: AppDimens.spaceM),
        _buildContent(dueTasks, context, colorScheme, theme),
      ],
    );
  }

  Widget _buildContent(
    List<ProgressDetail> dueTasks,
    BuildContext context,
    ColorScheme colorScheme,
    ThemeData theme,
  ) {
    if (dueTasks.isEmpty) {
      return SlEmptyStateWidget(
        icon: Icons.check_circle_outline,
        title: 'No tasks due today',
        message: 'You\'re all caught up! Take a break or explore new modules.',
        buttonText: 'View All Tasks',
        onButtonPressed: onViewAllTasks,
      );
    }

    // Calculate overdue tasks
    final overdueCount = _getOverdueTasksCount(dueTasks);
    final todayCount = dueTasks.length - overdueCount;

    return SLCard(
      padding: EdgeInsets.zero,
      elevation: AppDimens.elevationXS,
      backgroundColor: colorScheme.surface,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.paddingL,
              vertical: AppDimens.paddingM,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppDimens.paddingXS),
                  decoration: BoxDecoration(
                    color: overdueCount > 0
                        ? colorScheme.errorContainer
                        : colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    overdueCount > 0
                        ? Icons.warning_amber
                        : Icons.calendar_today,
                    size: AppDimens.iconS,
                    color: overdueCount > 0
                        ? colorScheme.error
                        : colorScheme.primary,
                  ),
                ),
                const SizedBox(width: AppDimens.spaceS),
                Expanded(
                  child: Text(
                    overdueCount > 0
                        ? 'You have $overdueCount overdue and $todayCount due today'
                        : 'You have ${dueTasks.length} task(s) due today',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: overdueCount > 0 ? colorScheme.error : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ...dueTasks
              .take(3)
              .map(
                (progress) => Column(
                  children: [
                    InkWell(
                      onTap: () => _navigateToProgressDetail(context, progress),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimens.paddingL,
                          vertical: AppDimens.paddingM,
                        ),
                        child: _buildProgressItem(
                          progress,
                          theme,
                          colorScheme,
                          isOverdue: _isOverdue(progress),
                        ),
                      ),
                    ),
                    if (progress != dueTasks.take(3).last)
                      const Divider(height: 1, indent: 16, endIndent: 16),
                  ],
                ),
              ),
          if (dueTasks.length > 3) ...[
            const Divider(height: 1),
            InkWell(
              onTap: onViewAllTasks,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.paddingL,
                  vertical: AppDimens.paddingM,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'View All (${dueTasks.length} Tasks)',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: AppDimens.spaceXS),
                    Icon(
                      Icons.arrow_forward,
                      size: AppDimens.iconS,
                      color: colorScheme.primary,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProgressItem(
    ProgressDetail progress,
    ThemeData theme,
    ColorScheme colorScheme, {
    bool isOverdue = false,
  }) {
    // Use different color for overdue task
    final itemColor = isOverdue ? colorScheme.error : colorScheme.primary;

    return Row(
      children: [
        _buildProgressIndicator(progress, colorScheme, isOverdue: isOverdue),
        const SizedBox(width: AppDimens.spaceM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                progress.moduleTitle ?? 'Module ${progress.moduleId}',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isOverdue ? colorScheme.error : null,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppDimens.spaceXXS),
              if (progress.nextStudyDate != null)
                Text(
                  isOverdue
                      ? 'Overdue: ${_formatDate(progress.nextStudyDate!)}'
                      : 'Due: ${_formatDate(progress.nextStudyDate!)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isOverdue
                        ? colorScheme.error
                        : colorScheme.onSurfaceVariant,
                    fontWeight: isOverdue ? FontWeight.bold : null,
                  ),
                ),
              const SizedBox(height: AppDimens.spaceXXS),
              Text(
                '${progress.percentComplete.toInt()}% complete',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Icon(Icons.chevron_right, color: itemColor, size: AppDimens.iconM),
      ],
    );
  }

  Widget _buildProgressIndicator(
    ProgressDetail progress,
    ColorScheme colorScheme, {
    bool isOverdue = false,
  }) {
    final progressPercent = progress.percentComplete / 100;
    Color color;

    if (isOverdue) {
      color = colorScheme.error;
    } else {
      color = _getProgressColor(progressPercent, colorScheme);
    }

    return SizedBox(
      width: AppDimens.iconL,
      height: AppDimens.iconL,
      child: Stack(
        children: [
          CircularProgressIndicator(
            value: progressPercent,
            backgroundColor: colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            strokeWidth: 3.0,
          ),
          Center(
            child: Icon(
              isOverdue ? Icons.warning_amber : Icons.notifications_active,
              size: AppDimens.iconS,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _getProgressColor(double percent, ColorScheme colorScheme) {
    if (percent >= 0.9) return colorScheme.tertiary;
    if (percent >= 0.6) return colorScheme.primary;
    if (percent >= 0.3) return colorScheme.secondary;
    return colorScheme.error;
  }

  void _navigateToProgressDetail(
    BuildContext context,
    ProgressDetail progress,
  ) {
    context.push('/progress/${progress.id}');
  }

  // Function to filter due and overdue tasks
  List<ProgressDetail> _getDueAndOverdueTasks(List<ProgressDetail> allTasks) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return allTasks.where((task) {
      if (task.nextStudyDate == null) return false;

      final dueDate = DateTime(
        task.nextStudyDate!.year,
        task.nextStudyDate!.month,
        task.nextStudyDate!.day,
      );

      // Get all tasks where date <= today (including overdue)
      return !dueDate.isAfter(today);
    }).toList();
  }

  // Check if the task is overdue
  bool _isOverdue(ProgressDetail task) {
    if (task.nextStudyDate == null) return false;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueDate = DateTime(
      task.nextStudyDate!.year,
      task.nextStudyDate!.month,
      task.nextStudyDate!.day,
    );

    // Task is overdue if due date < today
    return dueDate.isBefore(today);
  }

  // Count overdue tasks
  int _getOverdueTasksCount(List<ProgressDetail> tasks) {
    return tasks.where(_isOverdue).length;
  }

  // Format date for display
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    final dueDate = DateTime(date.year, date.month, date.day);

    if (dueDate.isAtSameMomentAs(today)) {
      return 'Today';
    } else if (dueDate.isAtSameMomentAs(yesterday)) {
      return 'Yesterday';
    } else {
      // Format date as "dd/MM/yyyy"
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
