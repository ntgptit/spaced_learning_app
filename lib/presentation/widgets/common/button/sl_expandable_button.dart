// lib/presentation/widgets/common/button/sl_expandable_button.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

part 'sl_expandable_button.g.dart';

@riverpod
class ExpandableButtonState extends _$ExpandableButtonState {
  @override
  bool build({String id = 'default'}) => false;

  void toggle() {
    state = !state;
  }

  void setValue(bool value) {
    state = value;
  }
}

class SlExpandableButton extends ConsumerWidget {
  final String expandableId;
  final String label;
  final List<Widget> children;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool initiallyExpanded;
  final bool isDisabled;
  final VoidCallback? onTap;

  const SlExpandableButton({
    super.key,
    required this.expandableId,
    required this.label,
    required this.children,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.initiallyExpanded = false,
    this.isDisabled = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Initialize expansion state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(expandableButtonStateProvider(id: expandableId).notifier)
          .setValue(initiallyExpanded);
    });

    // Get current expanded state
    final isExpanded = ref.watch(
      expandableButtonStateProvider(id: expandableId),
    );

    // Calculate rotation for animation
    final rotationAngle = isExpanded ? 0.5 : 0.0;

    final effectiveBackgroundColor =
        backgroundColor ?? colorScheme.surfaceContainerLow;
    final effectiveForegroundColor = foregroundColor ?? colorScheme.onSurface;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Button header
        Material(
          color: effectiveBackgroundColor,
          borderRadius: BorderRadius.circular(AppDimens.radiusM),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: isDisabled
                ? null
                : () {
                    ref
                        .read(
                          expandableButtonStateProvider(
                            id: expandableId,
                          ).notifier,
                        )
                        .toggle();
                    if (onTap != null) {
                      onTap!();
                    }
                  },
            child: Padding(
              padding: const EdgeInsets.all(AppDimens.paddingM),
              child: Row(
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      color: isDisabled
                          ? colorScheme.onSurface.withOpacity(
                              AppDimens.opacityDisabled,
                            )
                          : effectiveForegroundColor,
                      size: AppDimens.iconM,
                    ),
                    const SizedBox(width: AppDimens.spaceM),
                  ],
                  Expanded(
                    child: Text(
                      label,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: isDisabled
                            ? colorScheme.onSurface.withOpacity(
                                AppDimens.opacityDisabled,
                              )
                            : effectiveForegroundColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Transform.rotate(
                    angle: rotationAngle * 3.14159,
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: isDisabled
                          ? colorScheme.onSurface.withOpacity(
                              AppDimens.opacityDisabled,
                            )
                          : effectiveForegroundColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Expandable content with animation
        AnimatedCrossFade(
          firstChild: const SizedBox(height: 0),
          secondChild: Padding(
            padding: const EdgeInsets.only(
              left: AppDimens.paddingL,
              top: AppDimens.paddingS,
              right: AppDimens.paddingS,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
          crossFadeState: isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
        ),
      ],
    );
  }
}
