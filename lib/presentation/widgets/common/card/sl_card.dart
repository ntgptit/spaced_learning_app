import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

enum SlCardType { elevated, outlined, filled, tonal }

enum SlCardSize { small, medium, large }

class SlCard extends StatelessWidget {
  final Widget? title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final Widget? content;
  final Widget? child;
  final List<Widget>? actions;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double? elevation;
  final double borderRadius;
  final ShapeBorder? shape;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? shadowColor;
  final SlCardType type;
  final SlCardSize size;
  final bool useSurfaceTint;
  final Clip clipBehavior;

  const SlCard({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.content,
    this.child,
    this.actions,
    this.onTap,
    this.padding = const EdgeInsets.all(AppDimens.paddingL),
    this.margin = const EdgeInsets.symmetric(vertical: AppDimens.paddingS),
    this.elevation,
    this.borderRadius = AppDimens.radiusL,
    this.shape,
    this.backgroundColor,
    this.foregroundColor,
    this.shadowColor,
    this.type = SlCardType.elevated,
    this.size = SlCardSize.medium,
    this.useSurfaceTint = true,
    this.clipBehavior = Clip.antiAlias,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final double effectiveElevation = _getEffectiveElevation();
    final Color effectiveBackgroundColor = _getEffectiveBackgroundColor(
      colorScheme,
    );
    final ShapeBorder effectiveShape =
        shape ??
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        );

    switch (type) {
      case SlCardType.elevated:
        return Card(
          margin: margin,
          elevation: effectiveElevation,
          shape: effectiveShape,
          color: effectiveBackgroundColor,
          shadowColor: shadowColor ?? colorScheme.shadow,
          surfaceTintColor: useSurfaceTint
              ? colorScheme.surfaceTint
              : Colors.transparent,
          clipBehavior: clipBehavior,
          child: _buildCardContent(theme, colorScheme),
        );

      case SlCardType.outlined:
        return Card(
          margin: margin,
          elevation: 0,
          shape: effectiveShape,
          color: effectiveBackgroundColor,
          shadowColor: shadowColor ?? colorScheme.outline,
          clipBehavior: clipBehavior,
          child: _buildCardContent(theme, colorScheme),
        );

      case SlCardType.filled:
        return Card(
          margin: margin,
          elevation: 0,
          shape: effectiveShape,
          color: effectiveBackgroundColor,
          clipBehavior: clipBehavior,
          child: _buildCardContent(theme, colorScheme),
        );

      case SlCardType.tonal:
        return Card(
          margin: margin,
          elevation: effectiveElevation,
          shape: effectiveShape,
          color: effectiveBackgroundColor,
          shadowColor: shadowColor ?? Colors.transparent,
          surfaceTintColor: useSurfaceTint
              ? colorScheme.surfaceTint
              : Colors.transparent,
          clipBehavior: clipBehavior,
          child: _buildCardContent(theme, colorScheme),
        );
    }
  }

  double _getEffectiveElevation() {
    if (elevation != null) return elevation!;
    switch (type) {
      case SlCardType.elevated:
        return AppDimens.elevationS;
      case SlCardType.tonal:
        return AppDimens.elevationXS;
      case SlCardType.outlined:
      case SlCardType.filled:
        return 0;
    }
  }

  Color _getEffectiveBackgroundColor(ColorScheme colorScheme) {
    if (backgroundColor != null) return backgroundColor!;
    switch (type) {
      case SlCardType.elevated:
      case SlCardType.outlined:
        return colorScheme.surfaceContainerLowest;
      case SlCardType.filled:
        return colorScheme.surfaceContainerLow;
      case SlCardType.tonal:
        return colorScheme.surfaceContainerHigh;
    }
  }

  Widget _buildCardContent(ThemeData theme, ColorScheme colorScheme) {
    if (child != null) {
      return InkWell(onTap: onTap, child: child);
    }

    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null ||
              subtitle != null ||
              leading != null ||
              trailing != null)
            Padding(
              padding: padding,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (leading != null)
                    Padding(
                      padding: const EdgeInsets.only(right: AppDimens.paddingL),
                      child: leading,
                    ),
                  if (title != null || subtitle != null)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (title != null)
                            DefaultTextStyle(
                              style: theme.textTheme.titleMedium!.copyWith(
                                color: foregroundColor ?? colorScheme.onSurface,
                              ),
                              child: title!,
                            ),
                          if (title != null && subtitle != null)
                            const SizedBox(height: AppDimens.spaceXS),
                          if (subtitle != null)
                            DefaultTextStyle(
                              style: theme.textTheme.bodyMedium!.copyWith(
                                color: foregroundColor != null
                                    ? foregroundColor!.withValues(
                                        alpha: AppDimens.opacityHigh,
                                      )
                                    : colorScheme.onSurfaceVariant,
                              ),
                              child: subtitle!,
                            ),
                        ],
                      ),
                    ),
                  if (trailing != null)
                    Padding(
                      padding: const EdgeInsets.only(left: AppDimens.paddingS),
                      child: trailing,
                    ),
                ],
              ),
            ),
          if (content != null)
            Padding(
              padding:
                  title != null ||
                      subtitle != null ||
                      leading != null ||
                      trailing != null
                  ? EdgeInsets.only(
                      left: padding is EdgeInsets
                          ? (padding as EdgeInsets).left
                          : AppDimens.paddingL,
                      right: padding is EdgeInsets
                          ? (padding as EdgeInsets).right
                          : AppDimens.paddingL,
                      bottom: padding is EdgeInsets
                          ? (padding as EdgeInsets).bottom
                          : AppDimens.paddingL,
                    )
                  : padding,
              child: content,
            ),
          if (actions != null && actions!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.paddingM,
                vertical: AppDimens.paddingS,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: actions!.asMap().entries.map((entry) {
                  final int index = entry.key;
                  final Widget action = entry.value;
                  return Padding(
                    padding: EdgeInsets.only(
                      left: index > 0 ? AppDimens.paddingS : 0,
                    ),
                    child: action,
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
