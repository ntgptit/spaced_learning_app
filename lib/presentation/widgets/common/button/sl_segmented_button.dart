// lib/presentation/widgets/common/button/sl_toggle_button.dart
import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

class SlToggleButton extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String? label;
  final IconData? icon;
  final Color? activeColor;
  final Color? inactiveColor;
  final bool isDisabled;

  const SlToggleButton({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.icon,
    this.activeColor,
    this.inactiveColor,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveActiveColor = activeColor ?? colorScheme.primary;
    final effectiveInactiveColor =
        inactiveColor ?? colorScheme.surfaceContainerHighest;

    return InkWell(
      onTap: isDisabled ? null : () => onChanged(!value),
      borderRadius: BorderRadius.circular(AppDimens.radiusM),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.paddingM,
          vertical: AppDimens.paddingS,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: isDisabled
                    ? colorScheme.onSurface.withValues(
                        alpha: AppDimens.opacityDisabled,
                      )
                    : (value
                          ? effectiveActiveColor
                          : colorScheme.onSurfaceVariant),
                size: AppDimens.iconM,
              ),
              const SizedBox(width: AppDimens.spaceM),
            ],
            if (label != null) ...[
              Text(
                label!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDisabled
                      ? colorScheme.onSurface.withValues(
                          alpha: AppDimens.opacityDisabled,
                        )
                      : colorScheme.onSurface,
                ),
              ),
              const SizedBox(width: AppDimens.spaceM),
            ],
            Switch(
              value: value,
              onChanged: isDisabled ? null : onChanged,
              activeColor: effectiveActiveColor,
              inactiveTrackColor: effectiveInactiveColor,
            ),
          ],
        ),
      ),
    );
  }
}
