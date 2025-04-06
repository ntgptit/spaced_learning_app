import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_colors.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/learning_insight.dart';

/// Card widget that displays learning insights
class LearningInsightsCard extends StatelessWidget {
  final List<LearningInsightDTO> insights;
  final String? title;
  final VoidCallback? onViewMorePressed;

  const LearningInsightsCard({
    super.key,
    required this.insights,
    this.title,
    this.onViewMorePressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final sortedInsights = List<LearningInsightDTO>.from(insights)
      ..sort((a, b) => a.priority.compareTo(b.priority));
    final displayInsights =
        sortedInsights.length > 4
            ? sortedInsights.sublist(0, 4)
            : sortedInsights;

    return Card(
      elevation: AppDimens.elevationS,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusL),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme),
            const SizedBox(height: AppDimens.spaceS),
            const Divider(height: AppDimens.dividerThickness),
            const SizedBox(height: AppDimens.spaceS),
            if (displayInsights.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: AppDimens.paddingL),
                  child: Text('No insights available'),
                ),
              )
            else
              ...displayInsights.map(
                (insight) => _buildInsightItem(context, insight),
              ),
            if (onViewMorePressed != null && insights.length > 4) ...[
              const SizedBox(height: AppDimens.spaceS),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: onViewMorePressed,
                  child: const Text('View More'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      children: [
        const Icon(
          Icons.lightbulb_outline,
          color: AppColors.warningDark,
          size: AppDimens.iconM,
        ),
        const SizedBox(width: AppDimens.spaceS),
        Text(title ?? 'Learning Insights', style: theme.textTheme.titleLarge),
      ],
    );
  }

  Widget _buildInsightItem(BuildContext context, LearningInsightDTO insight) {
    final theme = Theme.of(context);
    final Color color = _getColorFromString(insight.color);
    final IconData icon = _getIconFromString(insight.icon);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.paddingS),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: AppDimens.iconM),
          const SizedBox(width: AppDimens.spaceM),
          Expanded(
            child: Text(insight.message, style: theme.textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }

  Color _getColorFromString(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'blue':
        return AppColors.primaryBlue;
      case 'red':
        return AppColors.errorDark;
      case 'green':
        return AppColors.successLight;
      case 'orange':
        return AppColors.warningDark;
      case 'purple':
        return AppColors.accentPurple;
      case 'teal':
        return AppColors.accentGreen;
      case 'amber':
        return AppColors.warningLight;
      case 'indigo':
        return AppColors.infoDark;
      default:
        return Colors.grey;
    }
  }

  IconData _getIconFromString(String iconName) {
    switch (iconName) {
      case 'trending_up':
        return Icons.trending_up;
      case 'local_fire_department':
        return Icons.local_fire_department;
      case 'menu_book':
        return Icons.menu_book;
      case 'today':
        return Icons.today;
      case 'check_circle':
        return Icons.check_circle;
      case 'star':
        return Icons.star;
      case 'emoji_events':
        return Icons.emoji_events;
      case 'lightbulb':
        return Icons.lightbulb;
      default:
        return Icons.info_outline;
    }
  }
}
