// lib/presentation/widgets/common/card/sl_list_card_item.dart
import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/presentation/widgets/common/card/sl_card.dart';

class SlListCardItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool isSelected;
  final bool isDisabled;
  final Color? backgroundColor;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double borderRadius;
  final SlCardType cardType;

  const SlListCardItem({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.isSelected = false,
    this.isDisabled = false,
    this.backgroundColor,
    this.padding = const EdgeInsets.symmetric(
      horizontal: AppDimens.paddingL,
      vertical: AppDimens.paddingM,
    ),
    this.margin = const EdgeInsets.symmetric(
      vertical: AppDimens.paddingXS,
      horizontal: AppDimens.paddingS,
    ),
    this.borderRadius = AppDimens.radiusM,
    this.cardType = SlCardType.elevated,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine effective background color based on selection and enabled state
    Color effectiveBackgroundColor =
        backgroundColor ??
        (cardType == SlCardType.filled
            ? colorScheme.surfaceContainerLow
            : colorScheme.surfaceContainerLowest);

    if (isSelected) {
      effectiveBackgroundColor = colorScheme.primaryContainer;
    }

    if (isDisabled) {
      effectiveBackgroundColor = colorScheme.surfaceContainerHighest.withValues(
        alpha: AppDimens.opacityDisabled,
      );
    }

    return SlCard(
      type: cardType,
      backgroundColor: effectiveBackgroundColor,
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
      onTap: isDisabled ? null : onTap,
      title: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          color: isDisabled
              ? colorScheme.onSurface.withValues(
                  alpha: AppDimens.opacityDisabled,
                )
              : isSelected
              ? colorScheme.onPrimaryContainer
              : colorScheme.onSurface,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDisabled
                    ? colorScheme.onSurfaceVariant.withValues(
                        alpha: AppDimens.opacityDisabled,
                      )
                    : isSelected
                    ? colorScheme.onPrimaryContainer.withValues(
                        alpha: AppDimens.opacityHigh,
                      )
                    : colorScheme.onSurfaceVariant,
              ),
            )
          : null,
      leading: leading != null
          ? IconTheme(
              data: IconThemeData(
                color: isDisabled
                    ? colorScheme.onSurface.withValues(
                        alpha: AppDimens.opacityDisabled,
                      )
                    : isSelected
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.primary,
                size: AppDimens.iconM,
              ),
              child: leading!,
            )
          : null,
      trailing: trailing,
    );
  }
}
