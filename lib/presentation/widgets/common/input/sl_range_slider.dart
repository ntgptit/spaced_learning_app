import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

part 'sl_range_slider.g.dart';

// Provider for range slider state
@riverpod
class RangeSliderState extends _$RangeSliderState {
  @override
  RangeValues build(String sliderId) => const RangeValues(0.0, 1.0);

  void setRange(RangeValues range) {
    state = range;
  }
}

class SlRangeSlider extends ConsumerWidget {
  final String sliderId;
  final RangeValues values;
  final double min;
  final double max;
  final int? divisions;
  final RangeLabels? labels;
  final String? title;
  final String? subtitle;
  final ValueChanged<RangeValues>? onChanged;
  final ValueChanged<RangeValues>? onChangeStart;
  final ValueChanged<RangeValues>? onChangeEnd;
  final bool enabled;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? thumbColor;
  final MouseCursor? mouseCursor;
  final String? Function(RangeValues?)? validator;
  final AutovalidateMode autovalidateMode;
  final bool showLabels;
  final bool showValues;
  final String? valuePrefix;
  final String? valueSuffix;
  final String? errorText;
  final int valueDecimals;
  final double thumbRadius;
  final double trackHeight;

  const SlRangeSlider({
    super.key,
    required this.sliderId,
    this.values = const RangeValues(0.0, 1.0),
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.labels,
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
    this.showLabels = true,
    this.showValues = true,
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

    // Set initial values if provided
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(rangeSliderStateProvider(sliderId).notifier).setRange(values);
    });

    // Get current values from provider
    final currentValues = ref.watch(rangeSliderStateProvider(sliderId));

    final effectiveActiveColor = activeColor ?? colorScheme.primary;
    final effectiveInactiveColor =
        inactiveColor ?? colorScheme.surfaceContainerHighest;
    final effectiveThumbColor = thumbColor ?? colorScheme.primary;

    return FormField<RangeValues>(
      initialValue: values,
      validator: validator != null ? (value) => validator!(value) : null,
      autovalidateMode: autovalidateMode,
      builder: (FormFieldState<RangeValues> field) {
        // Handle field value changes
        void handleValueChange(RangeValues newValues) {
          field.didChange(newValues);
          ref
              .read(rangeSliderStateProvider(sliderId).notifier)
              .setRange(newValues);
          if (onChanged != null) {
            onChanged!(newValues);
          }
        }

        final isError = field.hasError || errorText != null;
        final displayedError = errorText ?? field.errorText;

        // Format the values to display
        String formatValue(double value) {
          String formatted = value.toStringAsFixed(valueDecimals);
          if (valuePrefix != null) {
            formatted = '$valuePrefix$formatted';
          }
          if (valueSuffix != null) {
            formatted = '$formatted$valueSuffix';
          }
          return formatted;
        }

        final startValue = formatValue(currentValues.start);
        final endValue = formatValue(currentValues.end);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null ||
                (showValues &&
                    startValue.isNotEmpty &&
                    endValue.isNotEmpty)) ...[
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
                  if (showValues &&
                      startValue.isNotEmpty &&
                      endValue.isNotEmpty)
                    Text(
                      '$startValue - $endValue',
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
                showValueIndicator: showLabels
                    ? ShowValueIndicator.always
                    : ShowValueIndicator.never,
                valueIndicatorColor: colorScheme.primaryContainer,
                valueIndicatorTextStyle: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onPrimaryContainer,
                ),
                rangeThumbShape: RoundRangeSliderThumbShape(
                  enabledThumbRadius: thumbRadius,
                  disabledThumbRadius: thumbRadius,
                ),
                rangeTrackShape: const RoundedRectRangeSliderTrackShape(),
                rangeValueIndicatorShape:
                    const PaddleRangeSliderValueIndicatorShape(),
              ),
              child: RangeSlider(
                values: RangeValues(
                  currentValues.start.clamp(min, max),
                  currentValues.end.clamp(min, max),
                ),
                min: min,
                max: max,
                divisions: divisions,
                labels: labels ?? RangeLabels(startValue, endValue),
                onChanged: enabled ? handleValueChange : null,
                onChangeStart: enabled && onChangeStart != null
                    ? onChangeStart
                    : null,
                onChangeEnd: enabled && onChangeEnd != null
                    ? onChangeEnd
                    : null,
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
