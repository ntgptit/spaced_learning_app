import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

class SlFormSectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget? trailing;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final bool divider;
  final bool upperDivider;
  final Color? backgroundColor;
  final Color? titleColor;
  final Color? subtitleColor;
  final Color? iconColor;
  final Color? dividerColor;
  final double dividerThickness;
  final double iconSize;

  const SlFormSectionTitle({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.trailing,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(
      vertical: AppDimens.paddingM,
      horizontal: AppDimens.paddingL,
    ),
    this.margin = const EdgeInsets.only(
      top: AppDimens.paddingL,
      bottom: AppDimens.paddingS,
    ),
    this.divider = true,
    this.upperDivider = false,
    this.backgroundColor,
    this.titleColor,
    this.subtitleColor,
    this.iconColor,
    this.dividerColor,
    this.dividerThickness = AppDimens.dividerThickness,
    this.iconSize = AppDimens.iconM,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveTitleColor = titleColor ?? colorScheme.onSurface;
    final effectiveSubtitleColor =
        subtitleColor ?? colorScheme.onSurfaceVariant;
    final effectiveIconColor = iconColor ?? colorScheme.primary;
    final effectiveDividerColor = dividerColor ?? colorScheme.outlineVariant;

    Widget content = Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: iconSize, color: effectiveIconColor),
            const SizedBox(width: AppDimens.spaceM),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: effectiveTitleColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: AppDimens.spaceXS),
                  Text(
                    subtitle!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: effectiveSubtitleColor,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: AppDimens.spaceM),
            trailing!,
          ],
        ],
      ),
    );

    if (onTap != null) {
      content = InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
        child: content,
      );
    }

    return Container(
      margin: margin,
      color: backgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (upperDivider && divider)
            Divider(
              height: dividerThickness,
              thickness: dividerThickness,
              color: effectiveDividerColor,
            ),
          content,
          if (!upperDivider && divider)
            Divider(
              height: dividerThickness,
              thickness: dividerThickness,
              color: effectiveDividerColor,
            ),
        ],
      ),
    );
  }
}
