import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

class SlDropdownItem<T> {
  final String label;
  final T value;
  final Widget? icon;

  SlDropdownItem({required this.label, required this.value, this.icon});
}

class SlDropdown<T> extends StatelessWidget {
  final String? label;
  final List<SlDropdownItem<T>> items;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final String? hint;
  final String? errorText;
  final Widget? prefix;
  final IconData? prefixIcon;
  final bool isExpanded;
  final bool isDense;
  final bool enabled;
  final Color? fillColor;
  final Color? textColor;
  final Color? borderColor;
  final String? Function(T?)? validator;
  final AutovalidateMode autovalidateMode;
  final EdgeInsetsGeometry? contentPadding;
  final double borderRadius;
  final double borderWidth;
  final Widget? customButton;

  const SlDropdown({
    super.key,
    this.label,
    required this.items,
    this.value,
    this.onChanged,
    this.hint,
    this.errorText,
    this.prefix,
    this.prefixIcon,
    this.isExpanded = true,
    this.isDense = false,
    this.enabled = true,
    this.fillColor,
    this.textColor,
    this.borderColor,
    this.validator,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.contentPadding,
    this.borderRadius = AppDimens.radiusM,
    this.borderWidth = 1.5,
    this.customButton,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveFillColor = fillColor ?? colorScheme.surfaceContainerLowest;
    final effectiveTextColor = textColor ?? colorScheme.onSurface;
    final effectiveBorderColor = borderColor ?? colorScheme.outline;

    final effectiveContentPadding =
        contentPadding ??
        const EdgeInsets.symmetric(
          horizontal: AppDimens.paddingL,
          vertical: AppDimens.paddingM,
        );

    // Build prefix widgets
    if (prefixIcon != null) {
    } else if (prefix != null) {}

    return FormField<T>(
      initialValue: value,
      validator: validator,
      autovalidateMode: autovalidateMode,
      builder: (FormFieldState<T> field) {
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
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: isError ? colorScheme.error : colorScheme.onSurface,
                  ),
                ),
              ),
            ],
            Container(
              decoration: BoxDecoration(
                color: enabled
                    ? effectiveFillColor
                    : colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(borderRadius),
                border: Border.all(
                  color: isError
                      ? colorScheme.error
                      : field.value != null
                      ? colorScheme.primary
                      : effectiveBorderColor,
                  width: borderWidth,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child:
                    customButton ??
                    ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButton<T>(
                        value: field.value,
                        isExpanded: isExpanded,
                        isDense: isDense,
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: isError
                              ? colorScheme.error
                              : colorScheme.onSurfaceVariant,
                        ),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: enabled
                              ? effectiveTextColor
                              : effectiveTextColor.withValues(
                                  alpha: AppDimens.opacityDisabled,
                                ),
                        ),
                        hint: hint != null
                            ? Text(
                                hint!,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant
                                      .withValues(
                                        alpha: AppDimens.opacityUnselected,
                                      ),
                                ),
                              )
                            : null,
                        onChanged: enabled
                            ? (T? newValue) {
                                field.didChange(newValue);
                                if (onChanged != null) {
                                  onChanged!(newValue);
                                }
                              }
                            : null,
                        items: items.map<DropdownMenuItem<T>>((
                          SlDropdownItem<T> item,
                        ) {
                          return DropdownMenuItem<T>(
                            value: item.value,
                            child: Row(
                              children: [
                                if (item.icon != null) ...[
                                  item.icon!,
                                  const SizedBox(width: AppDimens.spaceS),
                                ],
                                Flexible(
                                  child: Text(
                                    item.label,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        padding: effectiveContentPadding,
                        borderRadius: BorderRadius.circular(borderRadius),
                        dropdownColor:
                            theme.colorScheme.surfaceContainerHighest,
                      ),
                    ),
              ),
            ),
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
}
