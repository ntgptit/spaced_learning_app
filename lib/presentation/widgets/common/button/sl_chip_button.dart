// lib/presentation/widgets/common/button/sl_chip_button.dart
import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

enum SlChipVariant { filled, outlined, elevated }

class SlChipButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final VoidCallback? onDeleted;
  final IconData? leadingIcon;
  final bool isSelected;
  final SlChipVariant variant;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? selectedBackgroundColor;
  final Color? selectedForegroundColor;
  final bool isDisabled;

  const SlChipButton({
    Key? key,
    required this.label,
    this.onPressed,
    this.onDeleted,
    this.leadingIcon,
    this.isSelected = false,
    this.variant = SlChipVariant.filled,
    this.backgroundColor,
    this.foregroundColor,
    this.selectedBackgroundColor,
    this.selectedForegroundColor,
    this.isDisabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine colors based on state and variant
    final effectiveBackgroundColor =
        backgroundColor ?? _getDefaultBackgroundColor(colorScheme);
    final effectiveForegroundColor =
        foregroundColor ?? _getDefaultForegroundColor(colorScheme);
    final effectiveSelectedBackgroundColor =
        selectedBackgroundColor ?? colorScheme.primary;
    final effectiveSelectedForegroundColor =
        selectedForegroundColor ?? colorScheme.onPrimary;

    final labelStyle = theme.textTheme.bodySmall?.copyWith(
      color: isSelected
          ? effectiveSelectedForegroundColor
          : isDisabled
          ? colorScheme.onSurface.withValues(alpha: AppDimens.opacityDisabled)
          : effectiveForegroundColor,
    );

    final avatar = leadingIcon != null
        ? Icon(
            leadingIcon,
            size: AppDimens.iconS,
            color: isSelected
                ? effectiveSelectedForegroundColor
                : isDisabled
                ? colorScheme.onSurface.withValues(
                    alpha: AppDimens.opacityDisabled,
                  )
                : effectiveForegroundColor,
          )
        : null;

    switch (variant) {
      case SlChipVariant.filled:
        return ActionChip(
          label: Text(label),
          avatar: avatar,
          onPressed: isDisabled ? null : onPressed,
          backgroundColor: isSelected
              ? effectiveSelectedBackgroundColor
              : effectiveBackgroundColor,
          labelStyle: labelStyle,
          // ActionChip doesn't have onDeleted, we need to use InputChip for delete functionality
          // If onDeleted is provided, switch to InputChip
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.paddingM,
            vertical: AppDimens.paddingXS,
          ),
        );

      case SlChipVariant.outlined:
        return FilterChip(
          label: Text(label),
          avatar: avatar,
          selected: isSelected,
          onSelected: isDisabled
              ? null
              : (bool value) {
                  if (onPressed != null) {
                    onPressed!();
                  }
                },
          backgroundColor: Colors.transparent,
          labelStyle: labelStyle,
          side: BorderSide(
            color: isDisabled
                ? colorScheme.outline.withValues(
                    alpha: AppDimens.opacityDisabled,
                  )
                : colorScheme.outline,
          ),
          selectedColor: effectiveSelectedBackgroundColor,
          showCheckmark: false,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.paddingM,
            vertical: AppDimens.paddingXS,
          ),
        );

      case SlChipVariant.elevated:
        return InputChip(
          label: Text(label),
          avatar: avatar,
          selected: isSelected,
          onPressed: isDisabled ? null : onPressed,
          backgroundColor: effectiveBackgroundColor,
          labelStyle: labelStyle,
          selectedColor: effectiveSelectedBackgroundColor,
          elevation: AppDimens.elevationXS,
          deleteIcon: onDeleted != null
              ? const Icon(Icons.cancel, size: AppDimens.iconS)
              : null,
          onDeleted: isDisabled ? null : onDeleted,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.paddingM,
            vertical: AppDimens.paddingXS,
          ),
        );
    }
  }

  Color _getDefaultBackgroundColor(ColorScheme colorScheme) {
    switch (variant) {
      case SlChipVariant.filled:
        return colorScheme.surfaceContainerHighest;
      case SlChipVariant.outlined:
        return Colors.transparent;
      case SlChipVariant.elevated:
        return colorScheme.surfaceContainerLow;
    }
  }

  Color _getDefaultForegroundColor(ColorScheme colorScheme) {
    return colorScheme.onSurface;
  }
}
