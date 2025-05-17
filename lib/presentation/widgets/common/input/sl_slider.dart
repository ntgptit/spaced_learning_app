import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

part 'sl_slider.g.dart';

// Provider for slider state
@riverpod
class SliderState extends _$SliderState {
  @override
  double build(String sliderId) => 0.0;

  void setValue(double value) {
    state = value;
  }
}

class SlSlider extends ConsumerWidget {
  final String sliderId;
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final String? label;
  final String? title;
  final String? subtitle;
  final ValueChanged<double>? onChanged;
  final ValueChanged<double>? onChangeStart;
  final ValueChanged<double>? onChangeEnd;
  final bool enabled;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? thumbColor;
  final MouseCursor? mouseCursor;
  final String? Function(double?)? validator;
  final AutovalidateMode autovalidateMode;
  final bool showLabel;
  final bool showValue;
  final String? valuePrefix;
  final String? valueSuffix;
  final String? errorText;
  final int valueDecimals;
  final double thumbRadius;
  final double trackHeight;

  const SlSlider({
    super.key,
    required this.sliderId,
    this.value = 0.0,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.label,
    this.title,
    this.subtitle,
    this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.enabled = true,
    this.activeColor,
    this.inactiveColor,
    this.thumbColor,
    this.mouseCursor,
    this.validator,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.showLabel = true,
    this.showValue = true,
    this.valuePrefix,
    this.valueSuffix,
    this.errorText,
    this.valueDecimals = 0,
    this.thumbRadius = 10.0,
    this.trackHeight = 4.0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Set initial value if provided
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(sliderStateProvider(sliderId).notifier).setValue(value);
    });

    // Get current value from provider
    final currentValue = ref.watch(sliderStateProvider(sliderId));

    final effectiveActiveColor = activeColor ?? colorScheme.primary;
    final effectiveInactiveColor =
        inactiveColor ?? colorScheme.surfaceContainerHighest;
    final effectiveThumbColor = thumbColor ?? colorScheme.primary;

    return FormField<double>(
      initialValue: value,
      validator: validator,
      autovalidateMode: autovalidateMode,
      builder: (FormFieldState<double> field) {
        // Handle field value changes
        void handleValueChange(double newValue) {
          field.didChange(newValue);
          ref.read(sliderStateProvider(sliderId).notifier).setValue(newValue);
          if (onChanged != null) {
            onChanged!(newValue);
          }
        }

        final isError = field.hasError || errorText != null;
        final displayedError = errorText ?? field.errorText;

        // Format the value to display
        String formattedValue = currentValue.toStringAsFixed(valueDecimals);
        if (valuePrefix != null) {
          formattedValue = '$valuePrefix$formattedValue';
        }
        if (valueSuffix != null) {
          formattedValue = '$formattedValue$valueSuffix';
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null || (showValue && formattedValue.isNotEmpty)) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (title != null)
                    Expanded(
                      child: Text(
                        title!,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: isError
                              ? colorScheme.error
                              : colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  if (showValue && formattedValue.isNotEmpty)
                    Text(
                      formattedValue,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isError
                            ? colorScheme.error
                            : enabled
                            ? colorScheme.onSurface
                            : colorScheme.onSurface.withValues(
                                alpha: AppDimens.opacityDisabled,
                              ),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
              if (subtitle != null) ...[
                const SizedBox(height: AppDimens.spaceXS),
                Text(
                  subtitle!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isError
                        ? colorScheme.error
                        : colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
              const SizedBox(height: AppDimens.spaceS),
            ],
            SliderTheme(
              data: SliderThemeData(
                trackHeight: trackHeight,
                activeTrackColor: enabled
                    ? effectiveActiveColor
                    : effectiveActiveColor.withValues(
                        alpha: AppDimens.opacityDisabled,
                      ),
                inactiveTrackColor: enabled
                    ? effectiveInactiveColor
                    : effectiveInactiveColor.withValues(
                        alpha: AppDimens.opacityDisabled,
                      ),
                thumbColor: enabled
                    ? effectiveThumbColor
                    : effectiveThumbColor.withValues(
                        alpha: AppDimens.opacityDisabled,
                      ),
                overlayColor: colorScheme.primary.withValues(alpha: 0.12),
                thumbShape: RoundSliderThumbShape(
                  enabledThumbRadius: thumbRadius,
                  disabledThumbRadius: thumbRadius,
                ),
                overlayShape: RoundSliderOverlayShape(
                  overlayRadius: thumbRadius * 2.5,
                ),
                showValueIndicator: showLabel
                    ? ShowValueIndicator.always
                    : ShowValueIndicator.never,
                valueIndicatorColor: colorScheme.primaryContainer,
                valueIndicatorTextStyle: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
              child: Slider(
                value: currentValue.clamp(min, max),
                min: min,
                max: max,
                divisions: divisions,
                label: label,
                onChanged: enabled ? handleValueChange : null,
                onChangeStart: enabled && onChangeStart != null
                    ? onChangeStart
                    : null,
                onChangeEnd: enabled && onChangeEnd != null
                    ? onChangeEnd
                    : null,
                mouseCursor: mouseCursor,
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
