// lib/presentation/widgets/common/button/sl_text_button.dart
import 'package:flutter/material.dart';
import 'package:spaced_learning_app/presentation/widgets/common/button/sl_button.dart';

class SlTextButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool isLoading;
  final SlButtonSize size;
  final Color? foregroundColor;

  const SlTextButton({
    super.key,
    required this.text,
    this.onPressed,
    this.prefixIcon,
    this.suffixIcon,
    this.isLoading = false,
    this.size = SlButtonSize.medium,
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
      size: size,
      variant: SlButtonVariant.text,
      foregroundColor: foregroundColor,
    );
  }
}
