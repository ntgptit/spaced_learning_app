import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/progress.dart';
import 'package:spaced_learning_app/presentation/utils/cycle_formatter.dart';

class DueTasksSection extends StatelessWidget {
  final List<ProgressSummary> tasks;
  final VoidCallback onViewAllTasks;

  const DueTasksSection({
    Key? key,
    required this.tasks,
    required this.onViewAllTasks,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(AppDimens.paddingL),
            decoration: BoxDecoration(
              color: tasks.isEmpty
                  ? colorScheme.surfaceVariant
                  : colorScheme.secondaryContainer,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  tasks.isEmpty
                      ? Icons.check_circle_outline
                      : Icons.assignment_outlined,
                  color: tasks.isEmpty
                      ? colorScheme.onSurfaceVariant
                      : colorScheme.onSecondaryContainer,
                  size: 22,
                ),
                const SizedBox(width: AppDimens.spaceM),
                Text(
                  'Due Today',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: tasks.isEmpty
                        ? colorScheme.onSurfaceVariant
                        : colorScheme.onSecondaryContainer,
                  ),
                ),
                const Spacer(),
                if (tasks.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.paddingM,
                      vertical: AppDimens.paddingXS,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.onSecondaryContainer.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${tasks.length}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Content
          if (tasks.isEmpty)
            _buildEmptyState(context)
          else
            _buildTaskList(context),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(AppDimens.paddingXL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: colorScheme.tertiaryContainer.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle_outline,
              size: 40,
              color: colorScheme.tertiary,
            ),
          ),
          const SizedBox(height: AppDimens.spaceL),
          Text(
            'All caught up!',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimens.spaceS),
          Text(
            'You have no tasks due today.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimens.spaceXL),
          OutlinedButton.icon(
            onPressed: onViewAllTasks,
            icon: const Icon(Icons.calendar_today_outlined),
            label: const Text('View Schedule'),
            style: OutlinedButton.styleFrom(
              foregroundColor: colorScheme.primary,
              side: BorderSide(color: colorScheme.outline),
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.paddingXL,
                vertical: AppDimens.paddingM,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        // Show first 3 tasks with fade-in animation
        for (int i = 0; i < min(tasks.length, 3); i++)
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(milliseconds: 400),
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 10 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: _buildTaskItem(context, tasks[i], i),
          ),

        // View all button
        Padding(
          padding: const EdgeInsets.all(AppDimens.paddingL),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onViewAllTasks,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primaryContainer,
                foregroundColor: colorScheme.onPrimaryContainer,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  vertical: AppDimens.paddingM,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                tasks.length <= 3 ? 'Start Learning' : 'View All Tasks',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTaskItem(BuildContext context, ProgressSummary task, int index) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Get cycle info
    final cycleText = CycleFormatter.format(task.cyclesStudied);
    final cycleColor = CycleFormatter.getColor(task.cyclesStudied, context);

    // Calculate progress
    final progress = task.percentComplete / 100;

    return InkWell(
      onTap: () => GoRouter.of(context).go('/progress/${task.id}'),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.paddingL,
          vertical: AppDimens.paddingM,
        ),
        child: Row(
          children: [
            // Task badge with cycle indicator
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: cycleColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  (index + 1).toString(),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: cycleColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppDimens.spaceM),

            // Task details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Module title with compact design
                  Text(
                    task.moduleId,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppDimens.spaceXS),

                  // Cycle info
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimens.paddingS,
                          vertical: AppDimens.paddingXXS,
                        ),
                        decoration: BoxDecoration(
                          color: cycleColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          cycleText,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: cycleColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppDimens.spaceS),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progress.isNaN || progress.isInfinite
                                ? 0
                                : progress,
                            backgroundColor: colorScheme.surfaceVariant,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              cycleColor,
                            ),
                            minHeight: 4,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppDimens.spaceXS),
                      Text(
                        '${task.percentComplete.toInt()}%',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Arrow indicator
            Icon(
              Icons.chevron_right,
              color: colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
