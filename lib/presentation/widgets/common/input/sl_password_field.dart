import 'package:flutter/material.dart';
import 'package:spaced_learning_app/presentation/widgets/common/input/sl_text_field.dart';

class SlPasswordField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? errorText;
  final TextEditingController? controller;
  final IconData? prefixIcon;
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
  final bool enabled;
  final SlTextFieldSize size;
  final AutovalidateMode autovalidateMode;

  const SlPasswordField({
    super.key,
    this.label,
    this.hint,
    this.errorText,
    this.controller,
    this.prefixIcon,
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
    this.enabled = true,
    this.size = SlTextFieldSize.medium,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  });

  @override
  State<SlPasswordField> createState() => _SlPasswordFieldState();
}

class _SlPasswordFieldState extends State<SlPasswordField> {
  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SlTextField(
      label: widget.label,
      hint: widget.hint,
      errorText: widget.errorText,
      controller: widget.controller,
      prefixIcon: widget.prefixIcon,
      suffixIcon: _obscureText
          ? Icons.visibility_outlined
          : Icons.visibility_off_outlined,
      onSuffixIconTap: _togglePasswordVisibility,
      obscureText: _obscureText,
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
      enabled: widget.enabled,
      size: widget.size,
      autovalidateMode: widget.autovalidateMode,
    );
  }
}
