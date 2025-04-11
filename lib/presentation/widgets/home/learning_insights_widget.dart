import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

class LearningInsightsWidget extends StatelessWidget {
  final double vocabularyRate;
  final int streakDays;
  final int pendingWords;
  final int dueToday;
  final ThemeData? theme; // Optional theme override

  const LearningInsightsWidget({
    super.key,
    required this.vocabularyRate,
    required this.streakDays,
    required this.pendingWords,
    required this.dueToday,
    this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final currentTheme = theme ?? Theme.of(context);
    final colorScheme = currentTheme.colorScheme;
    final textTheme = currentTheme.textTheme;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(colorScheme, textTheme),
            const SizedBox(height: AppDimens.spaceM),
            const Divider(),
            const SizedBox(height: AppDimens.spaceS),
            _buildInsightsList(context, colorScheme, textTheme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ColorScheme colorScheme, TextTheme textTheme) {
    return Row(
      children: [
        Icon(
          Icons.insights_outlined,
          color: colorScheme.tertiary,
          size: AppDimens.iconM,
        ),
        const SizedBox(width: AppDimens.spaceS),
        Text(
          'Learning Insights',
          style: textTheme.titleLarge?.copyWith(color: colorScheme.onSurface),
        ),
      ],
    );
  }

  Widget _buildInsightsList(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final Color rateColor = colorScheme.secondary;
    final Color streakColor = colorScheme.tertiary;
    final Color pendingColor = colorScheme.primaryContainer;
    final Color dueColor = colorScheme.primary;

    return Column(
      children: [
        _buildInsightItem(
          context,
          textTheme,
          colorScheme,
          'You learn ${vocabularyRate.toStringAsFixed(1)}% new vocabulary each week',
          Icons.trending_up,
          rateColor,
        ),
        _buildInsightItem(
          context,
          textTheme,
          colorScheme,
          'Your current streak is $streakDays days - keep going!',
          Icons.local_fire_department_outlined,
          streakColor,
        ),
        _buildInsightItem(
          context,
          textTheme,
          colorScheme,
          'You have $pendingWords words pending to learn',
          Icons.hourglass_empty_outlined,
          pendingColor,
        ),
        _buildInsightItem(
          context,
          textTheme,
          colorScheme,
          'Complete today\'s $dueToday sessions to maintain your streak',
          Icons.today_outlined,
          dueColor,
        ),
      ],
    );
  }

  Widget _buildInsightItem(
    BuildContext context,
    TextTheme textTheme,
    ColorScheme colorScheme,
    String message,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.paddingM),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: AppDimens.iconM),
          const SizedBox(width: AppDimens.spaceM),
          Expanded(
            child: Text(
              message,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
