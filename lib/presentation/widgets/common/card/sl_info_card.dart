// lib/presentation/widgets/common/card/sl_info_card.dart
import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/presentation/widgets/common/card/sl_card.dart';

class SlInfoCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData? icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final SlCardType cardType;
  final double borderRadius;
  final bool isImportant;
  final List<Widget>? actions;

  const SlInfoCard({
    super.key,
    required this.title,
    required this.description,
    this.icon,
    this.iconColor,
    this.backgroundColor,
    this.onTap,
    this.padding = const EdgeInsets.all(AppDimens.paddingL),
    this.margin = const EdgeInsets.symmetric(vertical: AppDimens.paddingS),
    this.cardType = SlCardType.filled,
    this.borderRadius = AppDimens.radiusL,
    this.isImportant = false,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine card color based on importance
    final effectiveBackgroundColor =
        backgroundColor ??
        (isImportant
            ? colorScheme.primaryContainer
            : colorScheme.surfaceContainerLow);

    // Determine icon color
    final effectiveIconColor =
        iconColor ??
        (isImportant ? colorScheme.primary : colorScheme.secondary);

    return SlCard(
      type: cardType,
      backgroundColor: effectiveBackgroundColor,
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (icon != null) ...[
                Container(
                  padding: const EdgeInsets.all(AppDimens.paddingS),
                  decoration: BoxDecoration(
                    color: isImportant
                        ? colorScheme.primary.withValues(alpha: 0.1)
                        : colorScheme.secondary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppDimens.radiusM),
                  ),
                  child: Icon(
                    icon,
                    color: effectiveIconColor,
                    size: AppDimens.iconL,
                  ),
                ),
                const SizedBox(width: AppDimens.spaceL),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: isImportant
                            ? colorScheme.onPrimaryContainer
                            : colorScheme.onSurface,
                        fontWeight: isImportant
                            ? FontWeight.bold
                            : FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: AppDimens.spaceS),
                    Text(
                      description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isImportant
                            ? colorScheme.onPrimaryContainer.withValues(
                                alpha: 0.8,
                              )
                            : colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (actions != null && actions!.isNotEmpty) ...[
            const SizedBox(height: AppDimens.spaceL),
            Row(
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
          ],
        ],
      ),
    );
  }
}
