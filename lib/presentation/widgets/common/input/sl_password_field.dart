import 'package:flutter/material.dart';
import 'package:spaced_learning_app/presentation/widgets/common/input/sl_text_field.dart';

class SLPasswordField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? errorText;
  final TextEditingController? controller;
  final IconData? prefixIconData;
  final Widget? prefixIcon; // New: Widget-based prefix icon
  final Widget? prefixWidget;
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
  final SlTextFieldSize size;

  const SLPasswordField({
    super.key,
    this.label,
    this.hint,
    this.errorText,
    this.controller,
    this.prefixIconData,
    this.prefixIcon,
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
    this.size = SlTextFieldSize.medium,
  });

  @override
  State<SLPasswordField> createState() => _SLPasswordFieldState();
}

class _SLPasswordFieldState extends State<SLPasswordField> {
  @override
  Widget build(BuildContext context) {
    final dynamic resolvedPrefixIcon =
        widget.prefixIcon ?? widget.prefixIconData;

    return SLTextField(
      label: widget.label,
      hint: widget.hint,
      controller: widget.controller,
      errorText: widget.errorText,
      prefixIcon: resolvedPrefixIcon,
      prefix: widget.prefixWidget,
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
      size: widget.size,
    );
  }
}
