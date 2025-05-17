// lib/presentation/widgets/common/button/sl_chip_button.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

part 'sl_chip_button.g.dart';

enum SlChipVariant { filled, outlined, elevated }

@riverpod
class ChipState extends _$ChipState {
  @override
  bool build({String id = 'default'}) => false;

  void toggle() {
    state = !state;
  }

  void setValue(bool value) {
    state = value;
  }
}

@riverpod
class ChipGroupState extends _$ChipGroupState {
  @override
  List<String> build({String groupId = 'default'}) => [];

  void toggleSelection(String chipId) {
    final updatedSelection = List<String>.from(state);
    if (updatedSelection.contains(chipId)) {
      updatedSelection.remove(chipId);
    } else {
      updatedSelection.add(chipId);
    }
    state = updatedSelection;
  }

  void setSelection(List<String> selection) {
    state = selection;
  }

  bool isSelected(String chipId) {
    return state.contains(chipId);
  }
}

class SlChipButton extends ConsumerWidget {
  final String label;
  final String chipId;
  final String? groupId;
  final VoidCallback? onPressed;
  final VoidCallback? onDeleted;
  final IconData? leadingIcon;
  final bool initialSelected;
  final SlChipVariant variant;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? selectedBackgroundColor;
  final Color? selectedForegroundColor;
  final bool isDisabled;

  const SlChipButton({
    super.key,
    required this.label,
    required this.chipId,
    this.groupId,
    this.onPressed,
    this.onDeleted,
    this.leadingIcon,
    this.initialSelected = false,
    this.variant = SlChipVariant.filled,
    this.backgroundColor,
    this.foregroundColor,
    this.selectedBackgroundColor,
    this.selectedForegroundColor,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Initialize chip state with initial value
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (groupId != null) {
        // Handle group-based selection
        if (initialSelected) {
          final currentSelection = ref.read(
            chipGroupStateProvider(groupId: groupId!),
          );
          if (!currentSelection.contains(chipId)) {
            ref
                .read(chipGroupStateProvider(groupId: groupId!).notifier)
                .toggleSelection(chipId);
          }
        }
      } else {
        // Handle individual chip state
        ref
            .read(chipStateProvider(id: chipId).notifier)
            .setValue(initialSelected);
      }
    });

    // Determine selection state
    final bool isSelected = groupId != null
        ? ref.watch(chipGroupStateProvider(groupId: groupId!)).contains(chipId)
        : ref.watch(chipStateProvider(id: chipId));

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
          ? colorScheme.onSurface.withOpacity(AppDimens.opacityDisabled)
          : effectiveForegroundColor,
    );

    final avatar = leadingIcon != null
        ? Icon(
            leadingIcon,
            size: AppDimens.iconS,
            color: isSelected
                ? effectiveSelectedForegroundColor
                : isDisabled
                ? colorScheme.onSurface.withOpacity(AppDimens.opacityDisabled)
                : effectiveForegroundColor,
          )
        : null;

    // Handle chip selection
    void handleSelection() {
      if (isDisabled) return;

      if (groupId != null) {
        ref
            .read(chipGroupStateProvider(groupId: groupId!).notifier)
            .toggleSelection(chipId);
      } else {
        ref.read(chipStateProvider(id: chipId).notifier).toggle();
      }

      if (onPressed != null) {
        onPressed!();
      }
    }

    switch (variant) {
      case SlChipVariant.filled:
        return ActionChip(
          label: Text(label),
          avatar: avatar,
          onPressed: isDisabled ? null : handleSelection,
          backgroundColor: isSelected
              ? effectiveSelectedBackgroundColor
              : effectiveBackgroundColor,
          labelStyle: labelStyle,
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
          onSelected: isDisabled ? null : (_) => handleSelection(),
          backgroundColor: Colors.transparent,
          labelStyle: labelStyle,
          side: BorderSide(
            color: isDisabled
                ? colorScheme.outline.withOpacity(AppDimens.opacityDisabled)
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
          onPressed: isDisabled ? null : handleSelection,
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
