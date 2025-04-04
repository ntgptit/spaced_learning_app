import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

/// Widget for displaying quick action buttons on the home screen
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
      children: _buildActionItems(context),
    );
  }

  // UI Components
  List<Widget> _buildActionItems(BuildContext context) {
    return [
      _buildActionCard(
        context,
        title: 'Browse Books',
        icon: Icons.book,
        onTap: onBrowseBooksPressed,
        color: Colors.blueAccent,
      ),
      _buildActionCard(
        context,
        title: 'Today\'s Learning',
        icon: Icons.assignment,
        onTap: onTodaysLearningPressed,
        color: Colors.green,
      ),
      _buildActionCard(
        context,
        title: 'Progress Report',
        icon: Icons.bar_chart,
        onTap: onProgressReportPressed,
        color: Colors.orange,
      ),
      _buildActionCard(
        context,
        title: 'Vocabulary Stats',
        icon: Icons.menu_book,
        onTap: onVocabularyStatsPressed,
        color: Colors.purple,
      ),
    ];
  }

  Widget _buildActionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    Color? color,
  }) {
    final theme = Theme.of(context);
    return Card(
      elevation: AppDimens.elevationS,
      color: color?.withValues(alpha: AppDimens.opacityMedium),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.paddingL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: AppDimens.iconXL,
                color: color ?? theme.colorScheme.primary,
              ),
              const SizedBox(height: AppDimens.spaceS),
              Text(
                title,
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
