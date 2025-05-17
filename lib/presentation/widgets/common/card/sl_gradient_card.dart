import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

class SlGradientCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget? leading;
  final Widget? trailing;
  final List<Color> gradientColors;
  final AlignmentGeometry gradientBegin;
  final AlignmentGeometry gradientEnd;
  final VoidCallback? onTap;
  final List<Widget>? actions;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double borderRadius;
  final double? elevation;

  const SlGradientCard({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.leading,
    this.trailing,
    required this.gradientColors,
    this.gradientBegin = Alignment.topLeft,
    this.gradientEnd = Alignment.bottomRight,
    this.onTap,
    this.actions,
    this.padding = const EdgeInsets.all(AppDimens.paddingL),
    this.margin = const EdgeInsets.symmetric(vertical: AppDimens.paddingS),
    this.borderRadius = AppDimens.radiusL,
    this.elevation,
  }) : assert(
         gradientColors.length >= 2,
         'At least 2 colors are required for a gradient',
       );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: elevation != null && elevation! > 0
            ? [
                BoxShadow(
                  color: theme.shadowColor.withValues(alpha: 0.1),
                  blurRadius: elevation! * 2,
                  spreadRadius: elevation! * 0.5,
                  offset: Offset(0, elevation! * 0.5),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: gradientBegin,
                end: gradientEnd,
                colors: gradientColors,
              ),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Padding(
              padding: padding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (icon != null) ...[
                        Icon(icon, color: Colors.white, size: AppDimens.iconL),
                        const SizedBox(width: AppDimens.spaceL),
                      ],
                      if (leading != null) ...[
                        leading!,
                        const SizedBox(width: AppDimens.spaceL),
                      ],
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (subtitle != null) ...[
                              const SizedBox(height: AppDimens.spaceXS),
                              Text(
                                subtitle!,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.9),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (trailing != null) trailing!,
                    ],
                  ),
                  if (actions != null && actions!.isNotEmpty) ...[
                    const SizedBox(height: AppDimens.spaceL),
                    Row(
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
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
