// lib/presentation/widgets/common/button/sl_toggle_button.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

part 'sl_toggle_button.g.dart';

@riverpod
class ToggleState extends _$ToggleState {
  @override
  bool build({String id = 'default'}) => false;

  void toggle() {
    state = !state;
  }

  void setValue(bool value) {
    state = value;
  }
}

class SlToggleButton extends ConsumerWidget {
  final String toggleId;
  final bool initialValue;
  final ValueChanged<bool>? onChanged;
  final String? label;
  final IconData? icon;
  final Color? activeColor;
  final Color? inactiveColor;
  final bool isDisabled;

  const SlToggleButton({
    super.key,
    required this.toggleId,
    this.initialValue = false,
    this.onChanged,
    this.label,
    this.icon,
    this.activeColor,
    this.inactiveColor,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Initialize toggle state with initial value
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(toggleStateProvider(id: toggleId).notifier)
          .setValue(initialValue);
    });

    // Get current toggle state
    final value = ref.watch(toggleStateProvider(id: toggleId));

    final effectiveActiveColor = activeColor ?? colorScheme.primary;
    final effectiveInactiveColor =
        inactiveColor ?? colorScheme.surfaceContainerHighest;

    void handleToggle() {
      if (isDisabled) return;

      ref.read(toggleStateProvider(id: toggleId).notifier).toggle();
      if (onChanged != null) {
        onChanged!(!value);
      }
    }

    // lib/presentation/widgets/common/button/sl_toggle_button.dart (continued)

    return InkWell(
      onTap: isDisabled ? null : handleToggle,
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
                    ? colorScheme.onSurface.withOpacity(
                        AppDimens.opacityDisabled,
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
                      ? colorScheme.onSurface.withOpacity(
                          AppDimens.opacityDisabled,
                        )
                      : colorScheme.onSurface,
                ),
              ),
              const SizedBox(width: AppDimens.spaceM),
            ],
            Switch(
              value: value,
              onChanged: isDisabled ? null : (_) => handleToggle(),
              activeColor: effectiveActiveColor,
              inactiveTrackColor: effectiveInactiveColor,
            ),
          ],
        ),
      ),
    );
  }
}
