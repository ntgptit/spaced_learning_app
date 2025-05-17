// lib/presentation/widgets/common/button/sl_secondary_button.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spaced_learning_app/presentation/widgets/common/button/sl_button_base.dart';

class SlSecondaryButton extends ConsumerWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final String? loadingId;
  final bool isFullWidth;
  final SlButtonSize size;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const SlSecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.prefixIcon,
    this.suffixIcon,
    this.loadingId,
    this.isFullWidth = false,
    this.size = SlButtonSize.medium,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SlButtonBase(
      text: text,
      onPressed: onPressed,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      loadingId: loadingId,
      isFullWidth: isFullWidth,
      size: size,
      variant: SlButtonVariant.tonal,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
    );
  }
}
