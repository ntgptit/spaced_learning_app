import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

/// Widget to display learning insights on the home screen
class LearningInsightsWidget extends StatelessWidget {
  final double vocabularyRate;
  final int streakDays;
  final int pendingWords;
  final int dueToday;

  const LearningInsightsWidget({
    super.key,
    required this.vocabularyRate,
    required this.streakDays,
    required this.pendingWords,
    required this.dueToday,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme),
            const Divider(height: AppDimens.dividerThickness),
            _buildInsightsList(context),
          ],
        ),
      ),
    );
  }

  // UI Components
  Widget _buildHeader(ThemeData theme) {
    return Row(
      children: [
        Icon(
          Icons.insights,
          color: theme.colorScheme.tertiary,
          size: AppDimens.iconM,
        ),
        const SizedBox(width: AppDimens.spaceS),
        Text('Learning Insights', style: theme.textTheme.titleLarge),
      ],
    );
  }

  Widget _buildInsightsList(BuildContext context) {
    return Column(
      children: [
        _buildInsightItem(
          context,
          'You learn ${vocabularyRate.toStringAsFixed(1)}% new vocabulary each week',
          Icons.trending_up,
          Colors.blue,
        ),
        _buildInsightItem(
          context,
          'Your current streak is $streakDays days - keep going!',
          Icons.local_fire_department,
          Colors.orange,
        ),
        _buildInsightItem(
          context,
          'You have $pendingWords words pending to learn',
          Icons.menu_book,
          Colors.teal,
        ),
        _buildInsightItem(
          context,
          'Complete today\'s $dueToday sessions to maintain your streak',
          Icons.today,
          Colors.red,
        ),
      ],
    );
  }

  Widget _buildInsightItem(
    BuildContext context,
    String message,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.paddingS),
      child: Row(
        children: [
          Icon(icon, color: color, size: AppDimens.iconM),
          const SizedBox(width: AppDimens.spaceM),
          Expanded(
            child: Text(message, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
