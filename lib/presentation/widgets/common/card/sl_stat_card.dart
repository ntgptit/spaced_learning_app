// lib/presentation/widgets/common/card/sl_stat_card.dart
import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/extensions/color_extensions.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/presentation/widgets/common/card/sl_card.dart';

enum SlStatTrend { up, down, neutral, none }

class SlStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;
  final Color? valueColor;
  final Color? backgroundColor;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double borderRadius;
  final SlCardType cardType;
  final SlStatTrend trend;
  final String? trendValue;
  final bool isLoading;

  const SlStatCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.valueColor,
    this.backgroundColor,
    this.padding = const EdgeInsets.all(AppDimens.paddingL),
    this.margin = const EdgeInsets.symmetric(vertical: AppDimens.paddingS),
    this.borderRadius = AppDimens.radiusM,
    this.cardType = SlCardType.filled,
    this.trend = SlStatTrend.none,
    this.trendValue,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine trend color
    final Color trendColor = _getTrendColor(colorScheme);

    return SlCard(
      type: cardType,
      backgroundColor: backgroundColor,
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
      child: isLoading
          ? _buildLoadingState(theme)
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (icon != null)
                      Container(
                        padding: const EdgeInsets.all(AppDimens.paddingXS),
                        decoration: BoxDecoration(
                          color: (iconColor ?? colorScheme.primary).withValues(
                            alpha: 0.1,
                          ),
                          borderRadius: BorderRadius.circular(
                            AppDimens.radiusS,
                          ),
                        ),
                        child: Icon(
                          icon,
                          size: AppDimens.iconS,
                          color: iconColor ?? colorScheme.primary,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppDimens.spaceM),
                Text(
                  value,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: valueColor ?? colorScheme.onSurface,
                  ),
                ),
                if (trend != SlStatTrend.none || subtitle != null) ...[
                  const SizedBox(height: AppDimens.spaceS),
                  Row(
                    children: [
                      if (trend != SlStatTrend.none) ...[
                        _buildTrendIndicator(trendColor),
                        const SizedBox(width: AppDimens.spaceXS),
                        Text(
                          trendValue ?? _getTrendDescription(),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: trendColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: AppDimens.spaceS),
                      ],
                      if (subtitle != null)
                        Expanded(
                          child: Text(
                            subtitle!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                ],
              ],
            ),
    );
  }

  Widget _buildLoadingState(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 80,
          height: 16,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(AppDimens.radiusXS),
          ),
        ),
        const SizedBox(height: AppDimens.spaceM),
        Container(
          width: 100,
          height: 32,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(AppDimens.radiusXS),
          ),
        ),
        const SizedBox(height: AppDimens.spaceS),
        Container(
          width: 120,
          height: 16,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(AppDimens.radiusXS),
          ),
        ),
      ],
    );
  }

  Widget _buildTrendIndicator(Color color) {
    IconData iconData;

    switch (trend) {
      case SlStatTrend.up:
        iconData = Icons.arrow_upward;
        break;
      case SlStatTrend.down:
        iconData = Icons.arrow_downward;
        break;
      case SlStatTrend.neutral:
        iconData = Icons.remove;
        break;
      case SlStatTrend.none:
        return const SizedBox.shrink();
    }

    return Icon(iconData, size: AppDimens.iconXS, color: color);
  }

  Color _getTrendColor(ColorScheme colorScheme) {
    switch (trend) {
      case SlStatTrend.up:
        return colorScheme.success;
      case SlStatTrend.down:
        return colorScheme.error;
      case SlStatTrend.neutral:
        return colorScheme.onSurfaceVariant;
      case SlStatTrend.none:
        return Colors.transparent;
    }
  }

  String _getTrendDescription() {
    switch (trend) {
      case SlStatTrend.up:
        return 'Improving';
      case SlStatTrend.down:
        return 'Declining';
      case SlStatTrend.neutral:
        return 'Stable';
      case SlStatTrend.none:
        return '';
    }
  }
}
