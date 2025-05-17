// lib/presentation/widgets/common/button/sl_segmented_button.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

part 'sl_segmented_button.g.dart';

@riverpod
class SegmentState extends _$SegmentState {
  @override
  String build({String groupId = 'default'}) => '';

  void setValue(String value) {
    state = value;
  }
}

@riverpod
class MultiSegmentState extends _$MultiSegmentState {
  @override
  Set<String> build({String groupId = 'default'}) => {};

  void toggleSelection(String value) {
    final updatedSet = Set<String>.from(state);
    if (updatedSet.contains(value)) {
      updatedSet.remove(value);
    } else {
      updatedSet.add(value);
    }
    state = updatedSet;
  }

  void setSelections(Set<String> selections) {
    state = selections;
  }
}

class SlSegmentButton<T> extends ConsumerWidget {
  final String groupId;
  final List<ButtonSegment<T>> segments;
  final T? initialSelection;
  final Set<T>? initialMultiSelections;
  final ValueChanged<T>? onSelectionChanged;
  final ValueChanged<Set<T>>? onMultiSelectionChanged;
  final bool isMultiSelect;
  final bool showSelectedIcon;
  final bool isDisabled;
  final double? borderRadius;
  final Color? selectedBackgroundColor;
  final Color? backgroundColor;
  final Color? selectedForegroundColor;
  final Color? foregroundColor;

  const SlSegmentButton({
    super.key,
    required this.groupId,
    required this.segments,
    this.initialSelection,
    this.initialMultiSelections,
    this.onSelectionChanged,
    this.onMultiSelectionChanged,
    this.isMultiSelect = false,
    this.showSelectedIcon = true,
    this.isDisabled = false,
    this.borderRadius,
    this.selectedBackgroundColor,
    this.backgroundColor,
    this.selectedForegroundColor,
    this.foregroundColor,
  }) : assert(
         (isMultiSelect && initialMultiSelections != null) ||
             (!isMultiSelect && initialSelection != null) ||
             (initialSelection == null && initialMultiSelections == null),
         'Provide initialSelection for single select or initialMultiSelections for multi-select',
       );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Initialize state with initial value(s)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isMultiSelect) {
        if (initialMultiSelections != null) {
          ref
              .read(multiSegmentStateProvider(groupId: groupId).notifier)
              .setSelections(
                initialMultiSelections!.map((e) => e.toString()).toSet(),
              );
        }
      } else {
        if (initialSelection != null) {
          ref
              .read(segmentStateProvider(groupId: groupId).notifier)
              .setValue(initialSelection.toString());
        }
      }
    });

    // Set up effective colors
    final effectiveSelectedBackgroundColor =
        selectedBackgroundColor ?? colorScheme.primary;
    final effectiveBackgroundColor =
        backgroundColor ?? colorScheme.surfaceContainerLow;
    final effectiveSelectedForegroundColor =
        selectedForegroundColor ?? colorScheme.onPrimary;
    final effectiveForegroundColor = foregroundColor ?? colorScheme.onSurface;
    final effectiveBorderRadius = borderRadius ?? AppDimens.radiusM;

    if (isMultiSelect) {
      // Handle multi-selection segmented button
      final selectedValues = ref.watch(
        multiSegmentStateProvider(groupId: groupId),
      );

      return SegmentedButton<T>(
        segments: segments,
        selected: _convertToTypeSet<T>(selectedValues),
        onSelectionChanged: isDisabled
            ? null
            : (Set<T> values) {
                ref
                    .read(multiSegmentStateProvider(groupId: groupId).notifier)
                    .setSelections(values.map((e) => e.toString()).toSet());

                if (onMultiSelectionChanged != null) {
                  onMultiSelectionChanged!(values);
                }
              },
        multiSelectionEnabled: true,
        emptySelectionAllowed: true,
        showSelectedIcon: showSelectedIcon,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return effectiveSelectedBackgroundColor;
            }
            return effectiveBackgroundColor;
          }),
          foregroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return effectiveSelectedForegroundColor;
            }
            return effectiveForegroundColor;
          }),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(effectiveBorderRadius),
            ),
          ),
        ),
      );
    } else {
      // Handle single-selection segmented button
      final selectedValue = ref.watch(segmentStateProvider(groupId: groupId));

      return SegmentedButton<T>(
        segments: segments,
        selected: _convertToTypeSet<T>(<String>{selectedValue}),
        onSelectionChanged: isDisabled
            ? null
            : (Set<T> values) {
                if (values.isNotEmpty) {
                  final value = values.first;
                  ref
                      .read(segmentStateProvider(groupId: groupId).notifier)
                      .setValue(value.toString());

                  if (onSelectionChanged != null) {
                    onSelectionChanged!(value);
                  }
                }
              },
        multiSelectionEnabled: false,
        emptySelectionAllowed: false,
        showSelectedIcon: showSelectedIcon,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return effectiveSelectedBackgroundColor;
            }
            return effectiveBackgroundColor;
          }),
          foregroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return effectiveSelectedForegroundColor;
            }
            return effectiveForegroundColor;
          }),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(effectiveBorderRadius),
            ),
          ),
        ),
      );
    }
  }

  // Helper method to convert string Set to typed Set
  Set<T> _convertToTypeSet<T>(Set<String> stringSet) {
    final result = <T>{};

    for (final segment in segments) {
      if (stringSet.contains(segment.value.toString())) {
        result.add(segment.value as T);
      }
    }

    return result;
  }
}
