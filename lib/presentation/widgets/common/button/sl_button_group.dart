// lib/presentation/widgets/common/button/sl_button_group.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

enum SlButtonGroupAlignment { horizontal, vertical }

class SlButtonGroup extends ConsumerWidget {
  final List<Widget> buttons;
  final SlButtonGroupAlignment alignment;
  final double spacing;
  final MainAxisAlignment horizontalAlignment;
  final CrossAxisAlignment verticalAlignment;
  final bool equalWidth;
  final EdgeInsetsGeometry? padding;

  const SlButtonGroup({
    super.key,
    required this.buttons,
    this.alignment = SlButtonGroupAlignment.horizontal,
    this.spacing = AppDimens.spaceM,
    this.horizontalAlignment = MainAxisAlignment.start,
    this.verticalAlignment = CrossAxisAlignment.stretch,
    this.equalWidth = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (buttons.isEmpty) {
      return const SizedBox.shrink();
    }

    final effectivePadding = padding ?? EdgeInsets.zero;

    if (alignment == SlButtonGroupAlignment.horizontal) {
      return Padding(
        padding: effectivePadding,
        child: Row(
          mainAxisAlignment: horizontalAlignment,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: _buildButtons(),
        ),
      );
    } else {
      return Padding(
        padding: effectivePadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: verticalAlignment,
          mainAxisSize: MainAxisSize.min,
          children: _buildButtons(),
        ),
      );
    }
  }

  List<Widget> _buildButtons() {
    final List<Widget> buttonWidgets = [];
    final bool isHorizontal = alignment == SlButtonGroupAlignment.horizontal;

    for (int i = 0; i < buttons.length; i++) {
      if (i > 0) {
        // Add spacing between buttons
        if (isHorizontal) {
          buttonWidgets.add(SizedBox(width: spacing));
        } else {
          buttonWidgets.add(SizedBox(height: spacing));
        }
      }

      Widget button = buttons[i];

      // Handle equal width if requested and horizontal
      if (equalWidth && isHorizontal) {
        button = Expanded(child: button);
      }

      buttonWidgets.add(button);
    }

    return buttonWidgets;
  }
}
