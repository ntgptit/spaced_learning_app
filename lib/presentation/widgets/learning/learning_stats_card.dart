// lib/presentation/widgets/learning/learning_stats_card.dart
import 'package:flutter/material.dart';

/// Thẻ hiển thị thống kê lịch học cho người dùng
class LearningStatsCard extends StatelessWidget {
  // Thông số lịch học hôm nay
  final int dueToday;

  // Thông số lịch học tuần này
  final int dueThisWeek;

  // Thông số lịch học tháng này
  final int dueThisMonth;

  // Thống kê hoàn thành
  final int completedToday;
  final int completedThisWeek;
  final int completedThisMonth;

  // Thông số học tập khác
  final int totalActiveModules;
  final int streakDays;

  // Callback
  final VoidCallback? onViewProgress;

  const LearningStatsCard({
    super.key,
    required this.dueToday,
    required this.dueThisWeek,
    required this.dueThisMonth,
    required this.completedToday,
    required this.completedThisWeek,
    required this.completedThisMonth,
    required this.totalActiveModules,
    required this.streakDays,
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
            Row(
              children: [
                Icon(Icons.school, color: colorScheme.primary, size: 24),
                const SizedBox(width: 8),
                Text('Learning Schedule', style: theme.textTheme.titleLarge),
                const Spacer(),
                TextButton.icon(
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('View All'),
                  onPressed: onViewProgress,
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),

            // Row 1: Due counts
            _buildSectionTitle(context, 'Due Sessions'),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumn(
                  context: context,
                  label: 'Today',
                  value: dueToday,
                  color: Colors.red,
                  icon: Icons.today,
                ),
                _buildDivider(),
                _buildStatColumn(
                  context: context,
                  label: 'This Week',
                  value: dueThisWeek,
                  color: Colors.orange,
                  icon: Icons.view_week,
                ),
                _buildDivider(),
                _buildStatColumn(
                  context: context,
                  label: 'This Month',
                  value: dueThisMonth,
                  color: colorScheme.primary,
                  icon: Icons.calendar_month,
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),

            // Row 2: Completed counts
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

            // Row 3: Additional stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumn(
                  context: context,
                  label: 'Active Modules',
                  value: totalActiveModules,
                  color: colorScheme.secondary,
                  icon: Icons.auto_stories,
                ),
                _buildDivider(),
                _buildStatColumn(
                  context: context,
                  label: 'Day Streak',
                  value: streakDays,
                  color: Colors.deepOrange,
                  icon: Icons.local_fire_department,
                  showBadge:
                      streakDays >= 7, // Hiển thị huy hiệu khi streak >= 7 ngày
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Completion progress bar
            if (dueToday + dueThisWeek > 0) ...[
              const SizedBox(height: 8),
              _buildTodayProgressBar(context),
            ],
          ],
        ),
      ),
    );
  }

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

  Widget _buildStatColumn({
    required BuildContext context,
    required String label,
    required int value,
    required Color color,
    required IconData icon,
    bool showBadge = false,
  }) {
    final theme = Theme.of(context);

    return Column(
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
                  child: const Icon(Icons.star, color: Colors.white, size: 10),
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
        Text(label, style: theme.textTheme.bodySmall),
      ],
    );
  }

  Widget _buildDivider() {
    return SizedBox(
      height: 50,
      child: VerticalDivider(
        color: Colors.grey.withValues(alpha: 0.3),
        thickness: 1,
        width: 1,
      ),
    );
  }

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

  /// Hàm trợ giúp để chuyển đổi enum CycleStudied thành chuỗi thân thiện với người dùng
}
