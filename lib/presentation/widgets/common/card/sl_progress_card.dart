// lib/presentation/widgets/common/card/sl_progress_card.dart
import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/presentation/widgets/common/card/sl_card.dart';

enum SlProgressStyle { linear, circular, step }

class SlProgressCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final double progress; // 0.0 to 1.0
  final VoidCallback? onTap;
  final Widget? leading;
  final Widget? trailing;
  final SlProgressStyle progressStyle;
  final Color? progressColor;
  final Color? backgroundColor;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double borderRadius;
  final SlCardType cardType;
  final String? progressLabel;
  final bool showPercentage;

  const SlProgressCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.progress,
    this.onTap,
    this.leading,
    this.trailing,
    this.progressStyle = SlProgressStyle.linear,
    this.progressColor,
    this.backgroundColor,
    this.padding = const EdgeInsets.all(AppDimens.paddingL),
    this.margin = const EdgeInsets.symmetric(vertical: AppDimens.paddingS),
    this.borderRadius = AppDimens.radiusL,
    this.cardType = SlCardType.elevated,
    this.progressLabel,
    this.showPercentage = true,
  }) : assert(
         progress >= 0.0 && progress <= 1.0,
         'Progress must be between 0.0 and 1.0',
       );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine effective progress color based on progress value
    final effectiveProgressColor =
        progressColor ?? _getProgressColor(colorScheme, progress);

    return SlCard(
      type: cardType,
      backgroundColor: backgroundColor,
      padding: EdgeInsets.zero,
      margin: margin,
      borderRadius: borderRadius,
      onTap: onTap,
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (leading != null) ...[
                  leading!,
                  const SizedBox(width: AppDimens.spaceM),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: theme.textTheme.titleMedium),
                      if (subtitle != null) ...[
                        const SizedBox(height: AppDimens.spaceXS),
                        Text(
                          subtitle!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
            const SizedBox(height: AppDimens.spaceL),
            _buildProgressIndicator(context, effectiveProgressColor),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(BuildContext context, Color progressColor) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Calculate percentage for display
    final percentage = (progress * 100).toInt();

    switch (progressStyle) {
      case SlProgressStyle.linear:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  progressLabel ?? 'Progress',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                if (showPercentage)
                  Text(
                    '$percentage%',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppDimens.spaceS),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppDimens.radiusXS),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                minHeight: AppDimens.lineProgressHeight,
              ),
            ),
          ],
        );

      case SlProgressStyle.circular:
        return Row(
          children: [
            SizedBox(
              height: AppDimens.circularProgressSizeL,
              width: AppDimens.circularProgressSizeL,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: progress,
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                    strokeWidth: AppDimens.lineProgressHeight,
                  ),
                  if (showPercentage)
                    Text(
                      '$percentage%',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: AppDimens.spaceL),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    progressLabel ?? 'Progress',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppDimens.spaceXS),
                  Text(
                    '$percentage% Complete',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );

      case SlProgressStyle.step:
        const totalSteps = 5;
        final completedSteps = (progress * totalSteps).round();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  progressLabel ?? 'Progress',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                if (showPercentage)
                  Text(
                    '$percentage%',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppDimens.spaceS),
            Row(
              children: List.generate(
                totalSteps,
                (index) => Expanded(
                  child: Container(
                    height: AppDimens.lineProgressHeight,
                    margin: EdgeInsets.only(
                      right: index < totalSteps - 1 ? AppDimens.spaceXS : 0,
                    ),
                    decoration: BoxDecoration(
                      color: index < completedSteps
                          ? progressColor
                          : colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(AppDimens.radiusXXS),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
    }
  }

  Color _getProgressColor(ColorScheme colorScheme, double progress) {
    if (progress < 0.3) return colorScheme.error;
    if (progress < 0.7) return colorScheme.secondary;
    if (progress < 0.9) return colorScheme.primary;
    return colorScheme.tertiary;
  }
}
