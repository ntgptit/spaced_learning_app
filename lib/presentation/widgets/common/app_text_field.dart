import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Shared text field widget with consistent styling
class AppTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? errorText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final int? maxLength;
  final bool autoFocus;
  final FocusNode? focusNode;
  final VoidCallback? onEditingComplete;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? initialValue;
  final bool readOnly;
  final VoidCallback? onTap;
  final EdgeInsets? contentPadding;
  final bool enabled;
  final bool autofillHints;
  final Iterable<String>? autofillHintsData;

  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.errorText,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.inputFormatters,
    this.maxLines = 1,
    this.maxLength,
    this.autoFocus = false,
    this.focusNode,
    this.onEditingComplete,
    this.onChanged,
    this.onSubmitted,
    this.prefixIcon,
    this.suffixIcon,
    this.initialValue,
    this.readOnly = false,
    this.onTap,
    this.contentPadding,
    this.enabled = true,
    this.autofillHints = true,
    this.autofillHintsData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Determine autofill hints
    Iterable<String>? autofill;
    if (autofillHints && autofillHintsData == null) {
      if (keyboardType == TextInputType.emailAddress) {
        autofill = [AutofillHints.email];
      } else if (obscureText) {
        autofill = [AutofillHints.password];
      } else if (keyboardType == TextInputType.name) {
        autofill = [AutofillHints.name];
      } else if (keyboardType == TextInputType.phone) {
        autofill = [AutofillHints.telephoneNumber];
      }
    } else if (autofillHints) {
      autofill = autofillHintsData;
    }

    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      maxLength: maxLength,
      autofocus: autoFocus,
      focusNode: focusNode,
      onEditingComplete: onEditingComplete,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      readOnly: readOnly,
      onTap: onTap,
      enabled: enabled,
      autofillHints: autofill,
      style: theme.textTheme.bodyLarge,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        errorText: errorText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        contentPadding: contentPadding,
      ),
    );
  }
}

/// Password text field with toggle visibility button
class AppPasswordField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? errorText;
  final TextEditingController? controller;
  final TextInputAction textInputAction;
  final bool autoFocus;
  final FocusNode? focusNode;
  final VoidCallback? onEditingComplete;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final Widget? prefixIcon;
  final String? initialValue;
  final bool enabled;

  const AppPasswordField({
    super.key,
    this.label,
    this.hint,
    this.errorText,
    this.controller,
    this.textInputAction = TextInputAction.next,
    this.autoFocus = false,
    this.focusNode,
    this.onEditingComplete,
    this.onChanged,
    this.onSubmitted,
    this.prefixIcon,
    this.initialValue,
    this.enabled = true,
  });

  @override
  State<AppPasswordField> createState() => _AppPasswordFieldState();
}

class _AppPasswordFieldState extends State<AppPasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: widget.label,
      hint: widget.hint,
      errorText: widget.errorText,
      controller: widget.controller,
      obscureText: _obscureText,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: widget.textInputAction,
      autoFocus: widget.autoFocus,
      focusNode: widget.focusNode,
      onEditingComplete: widget.onEditingComplete,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      prefixIcon: widget.prefixIcon,
      initialValue: widget.initialValue,
      enabled: widget.enabled,
      suffixIcon: IconButton(
        icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      ),
    );
  }
}
