import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

class AppCard extends StatelessWidget {
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
  final Color? highlightColor;
  final Color? shadowColor;
  final bool useGradient;
  final LinearGradient? customGradient;
  final bool applyOuterShadow;

  const AppCard({
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
    this.highlightColor,
    this.shadowColor,
    this.useGradient = false,
    this.customGradient,
    this.applyOuterShadow = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveBackgroundColor =
        backgroundColor ?? colorScheme.surfaceContainerLowest;
    final effectiveShadowColor = shadowColor ?? colorScheme.shadow;
    final effectiveShape =
        shape ??
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        );

    final Widget cardContent = Container(
      decoration: useGradient
          ? BoxDecoration(
              gradient:
                  customGradient ??
                  LinearGradient(
                    colors: [
                      colorScheme.surfaceContainerLow,
                      colorScheme.surfaceContainerHigh,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
            )
          : null,
      child: InkWell(
        onTap: onTap,
        highlightColor: highlightColor ?? colorScheme.primaryContainer,
        splashColor: colorScheme.primary.withValues(
          alpha: AppDimens.opacitySemi,
        ),
        borderRadius: shape == null
            ? BorderRadius.circular(borderRadius)
            : null,
        customBorder: shape,
        child: child ?? _buildDefaultContent(theme, colorScheme),
      ),
    );

    if (applyOuterShadow) {
      return Container(
        margin: margin,
        decoration: BoxDecoration(
          borderRadius: shape == null
              ? BorderRadius.circular(borderRadius)
              : null,
          boxShadow: [
            BoxShadow(
              color: effectiveShadowColor.withValues(
                alpha: AppDimens.opacitySemi,
              ),
              blurRadius: AppDimens.shadowRadiusL,
              spreadRadius: AppDimens.shadowOffsetS,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Card(
          margin: EdgeInsets.zero,
          elevation: elevation ?? AppDimens.elevationS,
          shape: effectiveShape,
          color: effectiveBackgroundColor,
          clipBehavior: Clip.antiAlias,
          child: cardContent,
        ),
      );
    }

    return Card(
      margin: margin,
      elevation: elevation ?? AppDimens.elevationS,
      shape: effectiveShape,
      color: effectiveBackgroundColor,
      clipBehavior: Clip.antiAlias,
      child: cardContent,
    );
  }

  Widget _buildDefaultContent(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
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
                              color: colorScheme.onSurface,
                            ),
                            child: title!,
                          ),
                        if (title != null && subtitle != null)
                          const SizedBox(height: AppDimens.spaceXS),
                        if (subtitle != null)
                          DefaultTextStyle(
                            style: theme.textTheme.bodyMedium!.copyWith(
                              color: colorScheme.onSurfaceVariant,
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
            padding: const EdgeInsets.only(
              left: AppDimens.paddingS,
              right: AppDimens.paddingS,
              bottom: AppDimens.paddingS,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: actions!.map((action) {
                final int index = actions!.indexOf(action);
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
    );
  }
}
