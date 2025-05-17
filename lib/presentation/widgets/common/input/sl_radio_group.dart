import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

part 'sl_radio_group.g.dart';

// Option model for SlRadioGroup
class SlRadioOption<T> {
  final String label;
  final T value;
  final String? subtitle;
  final Widget? leading;
  final bool enabled;

  SlRadioOption({
    required this.label,
    required this.value,
    this.subtitle,
    this.leading,
    this.enabled = true,
  });
}

// Provider for radio group state
@riverpod
class RadioGroupState extends _$RadioGroupState {
  @override
  dynamic build(String groupId) => null;

  void setValue(dynamic value) {
    state = value;
  }
}

class SlRadioGroup<T> extends ConsumerWidget {
  final String groupId;
  final List<SlRadioOption<T>> options;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final bool enabled;
  final String? label;
  final String? errorText;
  final bool isVertical;
  final EdgeInsetsGeometry? contentPadding;
  final double spacing;
  final Color? activeColor;
  final ShapeBorder? shape;
  final Color? selectedTileColor;
  final Color? tileColor;
  final String? Function(T?)? validator;
  final AutovalidateMode autovalidateMode;

  const SlRadioGroup({
    super.key,
    required this.groupId,
    required this.options,
    this.value,
    this.onChanged,
    this.enabled = true,
    this.label,
    this.errorText,
    this.isVertical = true,
    this.contentPadding,
    this.spacing = AppDimens.spaceM,
    this.activeColor,
    this.shape,
    this.selectedTileColor,
    this.tileColor,
    this.validator,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Set initial value if provided
    if (value != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(radioGroupStateProvider(groupId).notifier).setValue(value);
      });
    }

    // Get current value from provider
    final currentValue = ref.watch(radioGroupStateProvider(groupId));

    return FormField<T>(
      initialValue: value,
      validator: validator,
      autovalidateMode: autovalidateMode,
      builder: (FormFieldState<T> field) {
        // Handle field value changes
        void handleValueChange(dynamic newValue) {
          if (newValue != null) {
            field.didChange(newValue as T);
            ref
                .read(radioGroupStateProvider(groupId).notifier)
                .setValue(newValue);
            if (onChanged != null) {
              onChanged!(newValue);
            }
          }
        }

        final isError = field.hasError || errorText != null;
        final displayedError = errorText ?? field.errorText;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (label != null) ...[
              Padding(
                padding: const EdgeInsets.only(
                  left: AppDimens.paddingS,
                  bottom: AppDimens.paddingXS,
                ),
                child: Text(
                  label!,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: isError ? colorScheme.error : colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
            if (isVertical) ...[
              // Vertical layout
              ...options.map(
                (option) => _buildRadioTile(
                  context,
                  option,
                  currentValue,
                  handleValueChange,
                  colorScheme,
                  theme,
                ),
              ),
            ] else ...[
              // Horizontal layout
              Wrap(
                spacing: spacing,
                children: options
                    .map(
                      (option) => _buildRadioChip(
                        context,
                        option,
                        currentValue,
                        handleValueChange,
                        colorScheme,
                        theme,
                      ),
                    )
                    .toList(),
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
          ],
        );
      },
    );
  }

  Widget _buildRadioTile(
    BuildContext context,
    SlRadioOption<T> option,
    dynamic currentValue,
    ValueChanged<dynamic> onValueChanged,
    ColorScheme colorScheme,
    ThemeData theme,
  ) {
    final isOptionEnabled = enabled && option.enabled;
    final isSelected = option.value == currentValue;

    return RadioListTile<dynamic>(
      title: Text(
        option.label,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: isOptionEnabled
              ? colorScheme.onSurface
              : colorScheme.onSurface.withValues(
                  alpha: AppDimens.opacityDisabled,
                ),
        ),
      ),
      subtitle: option.subtitle != null
          ? Text(
              option.subtitle!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: isOptionEnabled
                    ? colorScheme.onSurfaceVariant
                    : colorScheme.onSurfaceVariant.withValues(
                        alpha: AppDimens.opacityDisabled,
                      ),
              ),
            )
          : null,
      value: option.value,
      groupValue: currentValue,
      onChanged: isOptionEnabled ? onValueChanged : null,
      secondary: option.leading,
      activeColor: activeColor ?? colorScheme.primary,
      contentPadding: contentPadding,
      shape:
          shape ??
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusM),
          ),
      tileColor: tileColor,
      selectedTileColor: isSelected
          ? selectedTileColor ??
                colorScheme.primaryContainer.withValues(alpha: 0.2)
          : null,
      dense: true,
    );
  }

  Widget _buildRadioChip(
    BuildContext context,
    SlRadioOption<T> option,
    dynamic currentValue,
    ValueChanged<dynamic> onValueChanged,
    ColorScheme colorScheme,
    ThemeData theme,
  ) {
    final isOptionEnabled = enabled && option.enabled;
    final isSelected = option.value == currentValue;

    return FilterChip(
      label: Text(option.label),
      selected: isSelected,
      onSelected: isOptionEnabled
          ? (selected) {
              if (selected) {
                onValueChanged(option.value);
              }
            }
          : null,
      avatar: option.leading,
      backgroundColor: tileColor ?? colorScheme.surfaceContainerLow,
      selectedColor: selectedTileColor ?? colorScheme.primaryContainer,
      checkmarkColor: activeColor ?? colorScheme.primary,
      labelStyle: theme.textTheme.bodyMedium?.copyWith(
        color: isOptionEnabled
            ? (isSelected
                  ? colorScheme.onPrimaryContainer
                  : colorScheme.onSurface)
            : colorScheme.onSurface.withValues(
                alpha: AppDimens.opacityDisabled,
              ),
      ),
      disabledColor: colorScheme.surfaceContainerLow.withValues(
        alpha: AppDimens.opacityDisabled,
      ),
    );
  }
}
