// lib/presentation/widgets/common/button/sl_progress_button.dart
import 'package:flutter/material.dart';
import 'package:spaced_learning_app/presentation/widgets/common/button/sl_button.dart';

class SlProgressButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool isLoading;
  final bool isFullWidth;
  final SlButtonSize size;
  final SlButtonVariant variant;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const SlProgressButton({
    super.key,
    required this.text,
    this.onPressed,
    this.prefixIcon,
    this.suffixIcon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.size = SlButtonSize.medium,
    this.variant = SlButtonVariant.filled,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SlButton(
      text: text,
      onPressed: onPressed,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
      size: size,
      variant: variant,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
    );
  }
}
