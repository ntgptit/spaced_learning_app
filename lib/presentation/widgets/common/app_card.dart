// lib/presentation/widgets/common/app_card.dart
import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

class AppCard extends StatelessWidget {
  final Widget? title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final Widget? content;
  final List<Widget>? actions;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double? elevation;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? highlightColor;

  const AppCard({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.content,
    this.actions,
    this.onTap,
    this.padding = const EdgeInsets.all(AppDimens.paddingL),
    this.margin = const EdgeInsets.symmetric(vertical: AppDimens.paddingS),
    this.elevation,
    this.borderRadius = AppDimens.radiusL,
    this.backgroundColor,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: margin,
      elevation:
          elevation ??
          (theme.brightness == Brightness.dark
              ? AppDimens.elevationXS
              : AppDimens.elevationS),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      color: backgroundColor ?? colorScheme.surface,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        highlightColor:
            highlightColor ??
            colorScheme.primary.withOpacity(AppDimens.opacityMedium),
        splashColor: colorScheme.primary.withOpacity(AppDimens.opacityMedium),
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
                        padding: const EdgeInsets.only(
                          right: AppDimens.paddingL,
                        ),
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
                                style: theme.textTheme.titleMedium!,
                                child: title!,
                              ),
                            if (title != null && subtitle != null)
                              const SizedBox(height: AppDimens.spaceXS),
                            if (subtitle != null)
                              DefaultTextStyle(
                                style: theme.textTheme.bodyMedium!.copyWith(
                                  color: colorScheme.onSurface.withOpacity(
                                    AppDimens.opacityHigh,
                                  ),
                                ),
                                child: subtitle!,
                              ),
                          ],
                        ),
                      ),
                    if (trailing != null)
                      Padding(
                        padding: const EdgeInsets.only(
                          left: AppDimens.paddingS,
                        ),
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
                          left:
                              padding is EdgeInsets
                                  ? (padding as EdgeInsets).left
                                  : AppDimens.paddingL,
                          right:
                              padding is EdgeInsets
                                  ? (padding as EdgeInsets).right
                                  : AppDimens.paddingL,
                          bottom:
                              padding is EdgeInsets
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
                  children:
                      actions!.map((action) {
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
        ),
      ),
    );
  }
}
