import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';


class QuickActionsSection extends StatelessWidget {
  final VoidCallback onBrowseBooksPressed;
  final VoidCallback onTodaysLearningPressed;
  final VoidCallback onProgressReportPressed;
  final VoidCallback onVocabularyStatsPressed;

  const QuickActionsSection({
    super.key,
    required this.onBrowseBooksPressed,
    required this.onTodaysLearningPressed,
    required this.onProgressReportPressed,
    required this.onVocabularyStatsPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: AppDimens.gridSpacingL,
      mainAxisSpacing: AppDimens.gridSpacingL,
      childAspectRatio: 1.1, // Adjust if needed
      children: _buildActionItems(context),
    );
  }

  List<Widget> _buildActionItems(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final List<Map<String, dynamic>> actions = [
      {
        'title': 'Browse Books',
        'icon': Icons.menu_book_outlined,
        'onTap': onBrowseBooksPressed,
        'contentColor': colorScheme.primary,
      },
      {
        'title': 'Today\'s Learning',
        'icon': Icons.assignment_turned_in_outlined,
        'onTap': onTodaysLearningPressed,
        'contentColor': colorScheme.secondary,
      },
      {
        'title': 'Progress Report',
        'icon': Icons.bar_chart_outlined,
        'onTap': onProgressReportPressed,
        'contentColor': colorScheme.error,
      },
      {
        'title': 'Vocabulary Stats',
        'icon': Icons.translate_outlined, // Or Icons.assessment_outlined
        'onTap': onVocabularyStatsPressed,
        'contentColor': colorScheme.onSecondaryContainer,
      },
    ];

    return actions.map((action) {
      return _buildActionCard(
        context,
        title: action['title'] as String,
        icon: action['icon'] as IconData,
        onTap: action['onTap'] as VoidCallback,
        contentColor: action['contentColor'] as Color,
      );
    }).toList();
  }

  Widget _buildActionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    required Color contentColor, // Màu này sẽ áp dụng cho Icon và Text
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final borderRadius =
        (theme.cardTheme.shape is RoundedRectangleBorder
            ? (theme.cardTheme.shape as RoundedRectangleBorder).borderRadius
                as BorderRadius?
            : null) ??
        BorderRadius.circular(AppDimens.radiusM); // Use AppDimens if needed

    return Card(

      color: colorScheme.surfaceContainerHighest,
      clipBehavior: Clip.antiAlias, // Tốt cho InkWell
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius, // Đảm bảo khớp với shape của Card
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.paddingL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: AppDimens.iconXL,
                color: contentColor,
              ),
              const SizedBox(height: AppDimens.spaceM),
              Text(
                title,
                style: textTheme.titleSmall?.copyWith(
                  color: contentColor,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
