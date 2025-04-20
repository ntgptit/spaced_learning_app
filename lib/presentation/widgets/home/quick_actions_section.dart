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
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.paddingS,
            vertical: AppDimens.paddingM,
          ),
          child: Text(
            'Quick Actions',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // Grid with animated cards
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: AppDimens.gridSpacingL,
          mainAxisSpacing: AppDimens.gridSpacingL,
          childAspectRatio: 1.1,
          padding: const EdgeInsets.all(AppDimens.paddingS),
          children: [
            _buildActionCard(
              context: context,
              title: 'Browse Books',
              icon: Icons.menu_book_outlined,
              onTap: onBrowseBooksPressed,
              index: 0,
            ),
            _buildActionCard(
              context: context,
              title: 'Today\'s Learning',
              icon: Icons.assignment_turned_in_outlined,
              onTap: onTodaysLearningPressed,
              index: 1,
            ),
            _buildActionCard(
              context: context,
              title: 'Progress Report',
              icon: Icons.bar_chart_outlined,
              onTap: onProgressReportPressed,
              index: 2,
            ),
            _buildActionCard(
              context: context,
              title: 'Vocabulary Stats',
              icon: Icons.translate_outlined,
              onTap: onVocabularyStatsPressed,
              index: 3,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    required int index,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Define minimalist colors based on the current theme
    final List<Color> cardColors = [
      colorScheme.primary,
      colorScheme.secondary,
      colorScheme.tertiary,
      colorScheme.primary,
    ];

    final cardColor = cardColors[index % cardColors.length];

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 400 + (index * 100)),
      // Staggered animation
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Card(
        elevation: 0,
        color: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: cardColor.withValues(alpha: 0.3), width: 1),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.paddingL),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon in a subtle container
                Container(
                  padding: const EdgeInsets.all(AppDimens.paddingM),
                  decoration: BoxDecoration(
                    color: cardColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: cardColor, size: 28),
                ),
                const SizedBox(height: AppDimens.spaceM),

                // Action title
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
