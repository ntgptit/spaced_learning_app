import 'package:flutter/material.dart';

class FilterStatsRow extends StatelessWidget {
  final int totalCount;
  final int dueCount;
  final int completeCount;
  final int activeFilterCount;
  final bool showFilter;
  final VoidCallback onToggleFilter;

  const FilterStatsRow({
    super.key,
    required this.totalCount,
    required this.dueCount,
    required this.completeCount,
    required this.activeFilterCount,
    required this.showFilter,
    required this.onToggleFilter,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatCard(
                  count: totalCount,
                  label: 'Total',
                  icon: Icons.menu_book,
                  color: colorScheme.primary,
                  theme: theme,
                ),
                _buildStatCard(
                  count: dueCount,
                  label: 'Due',
                  icon: Icons.access_time,
                  color: colorScheme.error,
                  theme: theme,
                  highlight: dueCount > 0,
                ),
                _buildStatCard(
                  count: completeCount,
                  label: 'Complete',
                  icon: Icons.check_circle_outline,
                  color: colorScheme.tertiary,
                  theme: theme,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              showFilter ? Icons.filter_list_off : Icons.filter_list,
              color:
                  activeFilterCount > 0
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
            ),
            tooltip: showFilter ? 'Hide filters' : 'Show filters',
            onPressed: onToggleFilter,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required int count,
    required String label,
    required IconData icon,
    required Color color,
    required ThemeData theme,
    bool highlight = false,
  }) {
    final textTheme = theme.textTheme;
    final brightness = highlight ? 1.0 : 0.8;

    return Card(
      elevation: 0,
      color: color.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 16, color: color.withOpacity(brightness)),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              count.toString(),
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color.withOpacity(brightness),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
