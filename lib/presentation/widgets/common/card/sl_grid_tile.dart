// lib/presentation/widgets/common/card/sl_grid_tile.dart
import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/presentation/widgets/common/card/sl_card.dart';

class SlGridTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double aspectRatio;
  final double borderRadius;
  final SlCardType cardType;
  final bool isSelected;
  final Widget? trailing;
  final CrossAxisAlignment alignment;

  const SlGridTile({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.backgroundColor,
    this.onTap,
    this.padding = const EdgeInsets.all(AppDimens.paddingL),
    this.margin = const EdgeInsets.all(AppDimens.paddingXS),
    this.aspectRatio = 1.0,
    this.borderRadius = AppDimens.radiusM,
    this.cardType = SlCardType.filled,
    this.isSelected = false,
    this.trailing,
    this.alignment = CrossAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine background color based on selection state
    final effectiveBackgroundColor =
        backgroundColor ??
        (isSelected
            ? colorScheme.primaryContainer
            : colorScheme.surfaceContainerLow);

    // Determine text and icon colors based on selection state
    final effectiveTextColor = isSelected
        ? colorScheme.onPrimaryContainer
        : colorScheme.onSurface;

    final effectiveSubtitleColor = isSelected
        ? colorScheme.onPrimaryContainer.withValues(alpha: 0.8)
        : colorScheme.onSurfaceVariant;

    final effectiveIconColor =
        iconColor ?? (isSelected ? colorScheme.primary : colorScheme.secondary);

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: SlCard(
        type: cardType,
        backgroundColor: effectiveBackgroundColor,
        padding: padding,
        margin: margin,
        borderRadius: borderRadius,
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: alignment,
          children: [
            if (icon != null) ...[
              Icon(icon, color: effectiveIconColor, size: AppDimens.iconL),
              const SizedBox(height: AppDimens.spaceM),
            ],
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                color: effectiveTextColor,
                fontWeight: FontWeight.w500,
              ),
              textAlign: alignment == CrossAxisAlignment.center
                  ? TextAlign.center
                  : TextAlign.start,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: AppDimens.spaceXS),
              Text(
                subtitle!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: effectiveSubtitleColor,
                ),
                textAlign: alignment == CrossAxisAlignment.center
                    ? TextAlign.center
                    : TextAlign.start,
              ),
            ],
            if (trailing != null) ...[const Spacer(), trailing!],
          ],
        ),
      ),
    );
  }
}
