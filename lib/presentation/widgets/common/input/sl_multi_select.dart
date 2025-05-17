import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

part 'sl_multi_select.g.dart';

class SlMultiSelectItem<T> {
  final String label;
  final T value;
  final Widget? icon;
  final bool enabled;

  SlMultiSelectItem({
    required this.label,
    required this.value,
    this.icon,
    this.enabled = true,
  });
}

// Provider for multi-select state
@riverpod
class MultiSelectState extends _$MultiSelectState {
  @override
  List<dynamic> build(String selectId) => [];

  void setSelectedItems(List<dynamic> items) {
    state = List<dynamic>.from(items);
  }

  void toggleItem(dynamic item) {
    final List<dynamic> updatedList = List<dynamic>.from(state);
    if (updatedList.contains(item)) {
      updatedList.remove(item);
    } else {
      updatedList.add(item);
    }
    state = updatedList;
  }

  void selectItem(dynamic item) {
    if (!state.contains(item)) {
      state = [...state, item];
    }
  }

  void unselectItem(dynamic item) {
    if (state.contains(item)) {
      state = state.where((i) => i != item).toList();
    }
  }

  void selectAll(List<dynamic> items) {
    state = List<dynamic>.from(items);
  }

  void clearAll() {
    state = [];
  }
}

class SlMultiSelect<T> extends ConsumerWidget {
  final String selectId;
  final List<SlMultiSelectItem<T>> items;
  final List<T> selectedItems;
  final ValueChanged<List<T>>? onChanged;
  final String? label;
  final String? errorText;
  final String? helperText;
  final bool enabled;
  final Color? chipColor;
  final Color? selectedChipColor;
  final Color? textColor;
  final Color? selectedTextColor;
  final Color? borderColor;
  final Color? selectedBorderColor;
  final Widget? selectAllButton;
  final Widget? clearAllButton;
  final bool showSelectAllButton;
  final bool showClearAllButton;
  final String? Function(List<T>?)? validator;
  final AutovalidateMode autovalidateMode;
  final double spacing;
  final double runSpacing;
  final OutlinedBorder? chipShape;
  final bool showSelectedCount;
  final Widget? Function(T)? selectedItemBuilder;
  final Widget? emptySelectionWidget;
  final bool wrap;
  final int? maxDisplayItems;
  final Widget? overflow;
  final Widget? emptyItemsWidget;

  const SlMultiSelect({
    super.key,
    required this.selectId,
    required this.items,
    this.selectedItems = const [],
    this.onChanged,
    this.label,
    this.errorText,
    this.helperText,
    this.enabled = true,
    this.chipColor,
    this.selectedChipColor,
    this.textColor,
    this.selectedTextColor,
    this.borderColor,
    this.selectedBorderColor,
    this.selectAllButton,
    this.clearAllButton,
    this.showSelectAllButton = false,
    this.showClearAllButton = false,
    this.validator,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.spacing = AppDimens.spaceS,
    this.runSpacing = AppDimens.spaceS,
    this.chipShape,
    this.showSelectedCount = true,
    this.selectedItemBuilder,
    this.emptySelectionWidget,
    this.wrap = true,
    this.maxDisplayItems,
    this.overflow,
    this.emptyItemsWidget,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Set initial selected items if provided
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(multiSelectStateProvider(selectId).notifier)
          .setSelectedItems(selectedItems);
    });

    // Get current selected items from provider
    final currentSelectedItems = ref.watch(multiSelectStateProvider(selectId));
    final typedSelectedItems = currentSelectedItems.whereType<T>().toList();

    final effectiveChipColor = chipColor ?? colorScheme.surfaceContainerLow;
    final effectiveSelectedChipColor =
        selectedChipColor ?? colorScheme.primaryContainer;
    final effectiveTextColor = textColor ?? colorScheme.onSurface;
    final effectiveSelectedTextColor =
        selectedTextColor ?? colorScheme.onPrimaryContainer;
    final effectiveBorderColor = borderColor ?? colorScheme.outline;
    final effectiveSelectedBorderColor =
        selectedBorderColor ?? colorScheme.primary;

    // Default chip shape
    final effectiveChipShape =
        chipShape ??
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusL),
          side: BorderSide(
            color: effectiveBorderColor,
            width: AppDimens.outlineButtonBorderWidth,
          ),
        );

    // Handle item toggle
    void handleToggle(T value) {
      if (!enabled) return;

      final item = items.firstWhere((item) => item.value == value);
      if (!item.enabled) return;

      ref.read(multiSelectStateProvider(selectId).notifier).toggleItem(value);

      if (onChanged != null) {
        // Get updated list after toggle
        final updatedItems = ref.read(multiSelectStateProvider(selectId));
        onChanged!(updatedItems.whereType<T>().toList());
      }
    }

    // Handle select all
    void handleSelectAll() {
      if (!enabled) return;

      final availableItems = items
          .where((item) => item.enabled)
          .map((item) => item.value)
          .toList();

      ref
          .read(multiSelectStateProvider(selectId).notifier)
          .selectAll(availableItems);

      if (onChanged != null) {
        onChanged!(availableItems);
      }
    }

    // Handle clear all
    void handleClearAll() {
      if (!enabled) return;

      ref.read(multiSelectStateProvider(selectId).notifier).clearAll();

      if (onChanged != null) {
        onChanged!([]);
      }
    }

    return FormField<List<T>>(
      initialValue: selectedItems,
      validator: validator,
      autovalidateMode: autovalidateMode,
      builder: (FormFieldState<List<T>> field) {
        final isError = field.hasError || errorText != null;
        final displayedError = errorText ?? field.errorText;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (label != null ||
                (showSelectedCount && typedSelectedItems.isNotEmpty)) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (label != null)
                    Expanded(
                      child: Text(
                        label!,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: isError
                              ? colorScheme.error
                              : colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  if (showSelectedCount && typedSelectedItems.isNotEmpty)
                    Text(
                      '${typedSelectedItems.length} selected',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isError
                            ? colorScheme.error
                            : colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppDimens.spaceS),
            ],

            if (items.isEmpty && emptyItemsWidget != null) emptyItemsWidget!,

            if (wrap)
              Wrap(
                spacing: spacing,
                runSpacing: runSpacing,
                children: [
                  ...items.map((item) {
                    final bool isSelected = typedSelectedItems.contains(
                      item.value,
                    );
                    return _buildChip(
                      context,
                      item,
                      isSelected,
                      enabled && item.enabled,
                      handleToggle,
                      theme,
                      isError,
                      effectiveChipColor,
                      effectiveSelectedChipColor,
                      effectiveTextColor,
                      effectiveSelectedTextColor,
                      effectiveBorderColor,
                      effectiveSelectedBorderColor,
                      effectiveChipShape,
                    );
                  }),
                ],
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...items.map((item) {
                    final bool isSelected = typedSelectedItems.contains(
                      item.value,
                    );
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppDimens.spaceXS),
                      child: _buildChip(
                        context,
                        item,
                        isSelected,
                        enabled && item.enabled,
                        handleToggle,
                        theme,
                        isError,
                        effectiveChipColor,
                        effectiveSelectedChipColor,
                        effectiveTextColor,
                        effectiveSelectedTextColor,
                        effectiveBorderColor,
                        effectiveSelectedBorderColor,
                        effectiveChipShape,
                      ),
                    );
                  }),
                ],
              ),

            // Display selected items if builder is provided
            if (typedSelectedItems.isNotEmpty &&
                selectedItemBuilder != null) ...[
              const SizedBox(height: AppDimens.spaceM),
              ...typedSelectedItems
                  .take(maxDisplayItems ?? typedSelectedItems.length)
                  .map((item) {
                    final widget = selectedItemBuilder!(item);
                    return widget ?? const SizedBox.shrink();
                  })
                  .whereType<Widget>(),

              if (maxDisplayItems != null &&
                  typedSelectedItems.length > maxDisplayItems!) ...[
                const SizedBox(height: AppDimens.spaceXS),
                overflow ??
                    Text(
                      '+${typedSelectedItems.length - maxDisplayItems!} more',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
              ],
            ],

            // Empty selection widget
            if (typedSelectedItems.isEmpty && emptySelectionWidget != null) ...[
              const SizedBox(height: AppDimens.spaceM),
              emptySelectionWidget!,
            ],

            // Helper text and error
            if (helperText != null && !isError) ...[
              Padding(
                padding: const EdgeInsets.only(
                  left: AppDimens.paddingM,
                  top: AppDimens.paddingXS,
                ),
                child: Text(
                  helperText!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],

            if (displayedError != null) ...[
              Padding(
                padding: const EdgeInsets.only(
                  left: AppDimens.paddingM,
                  top: AppDimens.paddingXS,
                ),
                child: Text(
                  displayedError,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.error,
                  ),
                ),
              ),
            ],

            // Select All / Clear All buttons
            if ((showSelectAllButton || showClearAllButton) &&
                items.isNotEmpty) ...[
              const SizedBox(height: AppDimens.spaceM),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (showSelectAllButton) ...[
                    selectAllButton ??
                        TextButton(
                          onPressed: enabled ? handleSelectAll : null,
                          child: const Text('Select All'),
                        ),
                  ],
                  if (showClearAllButton) ...[
                    const SizedBox(width: AppDimens.spaceS),
                    clearAllButton ??
                        TextButton(
                          onPressed: enabled && typedSelectedItems.isNotEmpty
                              ? handleClearAll
                              : null,
                          child: const Text('Clear All'),
                        ),
                  ],
                ],
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildChip(
    BuildContext context,
    SlMultiSelectItem<T> item,
    bool isSelected,
    bool isEnabled,
    Function(T) onToggle,
    ThemeData theme,
    bool isError,
    Color chipColor,
    Color selectedChipColor,
    Color textColor,
    Color selectedTextColor,
    Color borderColor,
    Color selectedBorderColor,
    OutlinedBorder chipShape,
  ) {
    final colorScheme = theme.colorScheme;

    return FilterChip(
      label: Text(
        item.label,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: isError
              ? colorScheme.error
              : isEnabled
              ? (isSelected ? selectedTextColor : textColor)
              : colorScheme.onSurface.withValues(
                  alpha: AppDimens.opacityDisabled,
                ),
        ),
      ),
      selected: isSelected,
      onSelected: isEnabled ? (selected) => onToggle(item.value) : null,
      avatar: item.icon,
      backgroundColor: chipColor,
      selectedColor: selectedChipColor,
      shape: chipShape,
      showCheckmark: true,
      checkmarkColor: selectedTextColor,
      disabledColor: chipColor.withValues(alpha: AppDimens.opacityDisabled),
      side: BorderSide(
        color: isError
            ? colorScheme.error
            : isSelected
            ? selectedBorderColor
            : borderColor,
        width: AppDimens.outlineButtonBorderWidth,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.paddingS,
        vertical: AppDimens.paddingXS,
      ),
    );
  }
}
