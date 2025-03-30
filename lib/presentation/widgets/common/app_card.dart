// lib/presentation/widgets/app_card.dart
import 'package:flutter/material.dart';

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
    this.padding = const EdgeInsets.all(16.0),
    this.margin = const EdgeInsets.symmetric(vertical: 8.0),
    this.elevation,
    this.borderRadius = 16.0,
    this.backgroundColor,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: margin,
      elevation: elevation ?? (theme.brightness == Brightness.dark ? 1.0 : 2.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      color: backgroundColor ?? colorScheme.surface,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        highlightColor:
            highlightColor ?? colorScheme.primary.withValues(alpha: 0.1),
        splashColor: colorScheme.primary.withValues(alpha: 0.1),
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
                        padding: const EdgeInsets.only(right: 16.0),
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
                              const SizedBox(height: 4),
                            if (subtitle != null)
                              DefaultTextStyle(
                                style: theme.textTheme.bodyMedium!.copyWith(
                                  color: colorScheme.onSurface.withValues(
                                    alpha: 0.7,
                                  ),
                                ),
                                child: subtitle!,
                              ),
                          ],
                        ),
                      ),
                    if (trailing != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
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
                                  : 16.0,
                          right:
                              padding is EdgeInsets
                                  ? (padding as EdgeInsets).right
                                  : 16.0,
                          bottom:
                              padding is EdgeInsets
                                  ? (padding as EdgeInsets).bottom
                                  : 16.0,
                        )
                        : padding,
                child: content,
              ),
            if (actions != null && actions!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children:
                      actions!.map((action) {
                        final int index = actions!.indexOf(action);
                        return Padding(
                          padding: EdgeInsets.only(left: index > 0 ? 8.0 : 0),
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
