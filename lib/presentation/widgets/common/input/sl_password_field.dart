import 'package:flutter/material.dart';
import 'package:spaced_learning_app/presentation/widgets/common/input/sl_text_field.dart';

class SLPasswordField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? errorText;
  final TextEditingController? controller;
  final IconData?
  prefixIconData; // Use IconData for consistency with SLTextField.prefixIcon
  final Widget? prefixWidget; // Allow a full widget for prefix if needed
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  final Color? labelColor;
  final Color? hintColor;
  final Color? errorColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? backgroundColor;
  final SlTextFieldSize size; // Added size parameter

  const SLPasswordField({
    super.key,
    this.label,
    this.hint,
    this.errorText,
    this.controller,
    this.prefixIconData,
    this.prefixWidget,
    this.onChanged,
    this.onEditingComplete,
    this.textInputAction = TextInputAction.done,
    this.focusNode,
    this.validator,
    this.labelColor,
    this.hintColor,
    this.errorColor,
    this.borderColor,
    this.focusedBorderColor,
    this.backgroundColor,
    this.size = SlTextFieldSize.medium, // Default size
  });

  @override
  State<SLPasswordField> createState() => _SLPasswordFieldState();
}

class _SLPasswordFieldState extends State<SLPasswordField> {
  @override
  Widget build(BuildContext context) {
    return SLTextField(
      label: widget.label,
      hint: widget.hint,
      controller: widget.controller,
      errorText: widget.errorText,
      prefixIcon: widget.prefixIconData,
      // Pass IconData to SLTextField's prefixIcon
      prefix: widget.prefixWidget,
      // Pass Widget to SLTextField's prefix
      obscureText: true,
      keyboardType: TextInputType.visiblePassword,
      onChanged: widget.onChanged,
      onEditingComplete: widget.onEditingComplete,
      textInputAction: widget.textInputAction,
      focusNode: widget.focusNode,
      validator: widget.validator,
      labelColor: widget.labelColor,
      hintColor: widget.hintColor,
      errorColor: widget.errorColor,
      borderColor: widget.borderColor,
      focusedBorderColor: widget.focusedBorderColor,
      backgroundColor: widget.backgroundColor,
      size: widget.size, // Pass down the size
    );
  }
}
