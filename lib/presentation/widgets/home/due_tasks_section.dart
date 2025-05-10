import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/progress.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_card.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_empty_state.dart';

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

    // Lọc ra các task đến hạn
    final dueTasks = _filterDueTasks(tasks);

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
      return SLEmptyState(
        icon: Icons.check_circle_outline,
        title: 'No tasks due today',
        message: 'You\'re all caught up! Take a break or explore new modules.',
        buttonText: 'View All Tasks',
        onButtonPressed: onViewAllTasks,
      );
    }

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
                    color: colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.calendar_today,
                    size: AppDimens.iconS,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(width: AppDimens.spaceS),
                Expanded(
                  child: Text(
                    'You have ${dueTasks.length} task(s) due today',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
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
                        child: _buildProgressItem(progress, theme, colorScheme),
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
    ColorScheme colorScheme,
  ) {
    return Row(
      children: [
        _buildProgressIndicator(progress, colorScheme),
        const SizedBox(width: AppDimens.spaceM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                progress.moduleTitle ?? 'Module ${progress.moduleId}',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
        Icon(
          Icons.chevron_right,
          color: colorScheme.primary,
          size: AppDimens.iconM,
        ),
      ],
    );
  }

  Widget _buildProgressIndicator(
    ProgressDetail progress,
    ColorScheme colorScheme,
  ) {
    final progressPercent = progress.percentComplete / 100;
    final color = _getProgressColor(progressPercent, colorScheme);

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
              Icons.notifications_active,
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

  List<ProgressDetail> _filterDueTasks(List<ProgressDetail> allTasks) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return allTasks.where((task) {
      if (task.nextStudyDate == null) return false;

      final dueDate = DateTime(
        task.nextStudyDate!.year,
        task.nextStudyDate!.month,
        task.nextStudyDate!.day,
      );

      return !dueDate.isAfter(today);
    }).toList();
  }
}
