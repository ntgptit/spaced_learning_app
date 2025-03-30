import 'package:flutter/material.dart';

/// Card widget that displays comprehensive learning statistics
class LearningStatsCard extends StatelessWidget {
  // Core learning stats
  final int totalModules;
  final int completedModules;
  final int inProgressModules;
  final int dueModules;

  // Scheduled learning stats
  final int dueToday;
  final int dueThisWeek;
  final int dueThisMonth;

  // Completion stats
  final int completedToday;
  final int completedThisWeek;
  final int completedThisMonth;

  // Learning streak
  final int streakDays;

  // Average stats
  final double averageCompletionRate;

  // View progress callback
  final VoidCallback? onViewProgress;

  /// Creates a learning stats card with comprehensive learning metrics
  const LearningStatsCard({
    super.key,
    this.totalModules = 0,
    this.completedModules = 0,
    this.inProgressModules = 0,
    this.dueModules = 0,
    this.dueToday = 0,
    this.dueThisWeek = 0,
    this.dueThisMonth = 0,
    this.completedToday = 0,
    this.completedThisWeek = 0,
    this.completedThisMonth = 0,
    this.streakDays = 0,
    this.averageCompletionRate = 0.0,
    this.onViewProgress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and view all button
            Row(
              children: [
                Icon(Icons.school, color: colorScheme.primary, size: 24),
                const SizedBox(width: 8),
                Text('Learning Schedule', style: theme.textTheme.titleLarge),
                const Spacer(),
                if (onViewProgress != null)
                  TextButton.icon(
                    icon: const Icon(Icons.analytics_outlined),
                    label: const Text('View All'),
                    onPressed: onViewProgress,
                  ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),

            // Row 1: Due sessions by timeframe
            _buildSectionTitle(context, 'Due Sessions'),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumn(
                  context: context,
                  label: 'Today',
                  value: dueToday,
                  color: dueToday > 0 ? Colors.red : Colors.grey,
                  icon: Icons.today,
                ),
                _buildDivider(),
                _buildStatColumn(
                  context: context,
                  label: 'This Week',
                  value: dueThisWeek,
                  color: dueThisWeek > 0 ? Colors.orange : Colors.grey,
                  icon: Icons.view_week,
                ),
                _buildDivider(),
                _buildStatColumn(
                  context: context,
                  label: 'This Month',
                  value: dueThisMonth,
                  color: dueThisMonth > 0 ? colorScheme.primary : Colors.grey,
                  icon: Icons.calendar_month,
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),

            // Row 2: Completed sessions by timeframe
            _buildSectionTitle(context, 'Completed'),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumn(
                  context: context,
                  label: 'Today',
                  value: completedToday,
                  color: Colors.green,
                  icon: Icons.check_circle,
                ),
                _buildDivider(),
                _buildStatColumn(
                  context: context,
                  label: 'This Week',
                  value: completedThisWeek,
                  color: Colors.green,
                  icon: Icons.check_circle_outline,
                ),
                _buildDivider(),
                _buildStatColumn(
                  context: context,
                  label: 'This Month',
                  value: completedThisMonth,
                  color: Colors.green,
                  icon: Icons.verified,
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),

            // Row 3: Overall statistics
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumn(
                  context: context,
                  label: 'Total Modules',
                  value: totalModules,
                  color: colorScheme.primary,
                  icon: Icons.auto_stories,
                ),
                _buildDivider(),
                _buildStatColumn(
                  context: context,
                  label: 'Completed',
                  value: completedModules,
                  color: Colors.green,
                  icon: Icons.task_alt,
                ),
                _buildDivider(),
                _buildStatColumn(
                  context: context,
                  label: 'Learning Streak',
                  value: streakDays,
                  color: Colors.deepOrange,
                  icon: Icons.local_fire_department,
                  showBadge: streakDays >= 7,
                ),
              ],
            ),

            // Today's learning progress bar
            if (dueToday > 0) ...[
              const SizedBox(height: 16),
              _buildTodayProgressBar(context),
            ],
          ],
        ),
      ),
    );
  }

  /// Build a section title with consistent styling
  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Build a statistic column with icon, value and label
  Widget _buildStatColumn({
    required BuildContext context,
    required String label,
    required int value,
    required Color color,
    required IconData icon,
    bool showBadge = false,
  }) {
    final theme = Theme.of(context);

    return Expanded(
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(icon, color: color, size: 24),
              if (showBadge)
                Positioned(
                  top: -5,
                  right: -5,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.amber,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.star,
                      color: Colors.white,
                      size: 10,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value.toString(),
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Build a vertical divider
  Widget _buildDivider() {
    return SizedBox(
      height: 50,
      child: VerticalDivider(
        color: Colors.grey.withOpacity(0.3),
        thickness: 1,
        width: 1,
      ),
    );
  }

  /// Build a progress bar showing today's completion
  Widget _buildTodayProgressBar(BuildContext context) {
    final theme = Theme.of(context);
    final completionRate = dueToday > 0 ? completedToday / dueToday : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Today\'s Progress', style: theme.textTheme.titleSmall),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: completionRate,
            minHeight: 10,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(
              completionRate >= 1.0 ? Colors.green : theme.colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          dueToday > 0
              ? 'Completed $completedToday of $dueToday due sessions (${(completionRate * 100).toInt()}%)'
              : 'No sessions due today',
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}
