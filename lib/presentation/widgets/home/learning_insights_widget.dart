// lib/presentation/widgets/home/learning_insights_widget.dart
import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/core/theme/theme_extensions.dart';

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
      elevation: AppDimens.elevationS,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusL),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(colorScheme, textTheme),
            const SizedBox(height: AppDimens.spaceM),
            const Divider(height: AppDimens.dividerThickness),
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
          color: colorScheme.getStatColor('tertiary'),
          size: AppDimens.iconM,
        ),
        const SizedBox(width: AppDimens.spaceS),
        Text(
          'Learning Insights',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildInsightsList(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Column(
      children: [
        _buildInsightItem(
          context,
          textTheme,
          colorScheme,
          'You learn ${vocabularyRate.toStringAsFixed(1)}% new vocabulary each week',
          Icons.trending_up,
          'secondary',
        ),
        _buildInsightItem(
          context,
          textTheme,
          colorScheme,
          'Your current streak is $streakDays days - keep going!',
          Icons.local_fire_department_outlined,
          'tertiary',
        ),
        _buildInsightItem(
          context,
          textTheme,
          colorScheme,
          'You have $pendingWords words pending to learn',
          Icons.hourglass_empty_outlined,
          'primary',
        ),
        _buildInsightItem(
          context,
          textTheme,
          colorScheme,
          'Complete today\'s $dueToday sessions to maintain your streak',
          Icons.today_outlined,
          'warning',
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
    String colorType,
  ) {
    final color = colorScheme.getStatColor(colorType);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.paddingM),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: AppDimens.iconM, color: color),
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
