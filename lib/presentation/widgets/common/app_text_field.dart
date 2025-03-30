// lib/presentation/widgets/app_text_field.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? errorText;
  final String? helperText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool readOnly;
  final bool enabled;
  final IconData? prefixIcon;
  final Widget? prefix;
  final IconData? suffixIcon;
  final Widget? suffix;
  final VoidCallback? onSuffixIconTap;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final List<TextInputFormatter>? inputFormatters;
  final bool showCounter;
  final bool autofocus;
  final TextAlign textAlign;
  final TextCapitalization textCapitalization;
  final String? Function(String?)? validator;
  final AutovalidateMode autovalidateMode;
  final Color? fillColor;
  final EdgeInsetsGeometry? contentPadding;
  final TextInputAction? textInputAction;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;

  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.errorText,
    this.helperText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.focusNode,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.enabled = true,
    this.prefixIcon,
    this.prefix,
    this.suffixIcon,
    this.suffix,
    this.onSuffixIconTap,
    this.maxLength,
    this.maxLines = 1,
    this.minLines,
    this.inputFormatters,
    this.showCounter = false,
    this.autofocus = false,
    this.textAlign = TextAlign.start,
    this.textCapitalization = TextCapitalization.none,
    this.validator,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.fillColor,
    this.contentPadding,
    this.textInputAction,
    this.onEditingComplete,
    this.onSubmitted,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Widget? suffixIconWidget;
    if (widget.suffixIcon != null) {
      suffixIconWidget = InkWell(
        onTap: widget.onSuffixIconTap,
        borderRadius: BorderRadius.circular(48),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            widget.suffixIcon,
            color:
                widget.errorText != null
                    ? colorScheme.error
                    : colorScheme.primary,
            size: 20,
          ),
        ),
      );
    } else if (widget.obscureText) {
      suffixIconWidget = InkWell(
        onTap: () {
          setState(() {
            _passwordVisible = !_passwordVisible;
          });
        },
        borderRadius: BorderRadius.circular(48),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            _passwordVisible
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: colorScheme.onSurface.withValues(alpha: 0.6),
            size: 20,
          ),
        ),
      );
    }

    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      textCapitalization: widget.textCapitalization,
      textAlign: widget.textAlign,
      readOnly: widget.readOnly,
      enabled: widget.enabled,
      // lib/presentation/widgets/app_text_field.dart (continued)
      obscureText: widget.obscureText && !_passwordVisible,
      maxLength: widget.maxLength,
      maxLines: widget.obscureText ? 1 : widget.maxLines,
      minLines: widget.minLines,
      autofocus: widget.autofocus,
      onChanged: widget.onChanged,
      onTap: widget.onTap,
      inputFormatters: widget.inputFormatters,
      onEditingComplete: widget.onEditingComplete,
      onFieldSubmitted: widget.onSubmitted,
      autovalidateMode: widget.autovalidateMode,
      validator: widget.validator,
      style: theme.textTheme.bodyLarge!.copyWith(
        color:
            widget.enabled
                ? colorScheme.onSurface
                : colorScheme.onSurface.withValues(alpha: 0.6),
      ),
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        errorText: widget.errorText,
        helperText: widget.helperText,
        filled: true,
        fillColor:
            widget.fillColor ??
            (theme.brightness == Brightness.dark
                ? colorScheme.onSurface.withValues(alpha: 0.08)
                : colorScheme.onSurface.withValues(alpha: 0.04)),
        contentPadding:
            widget.contentPadding ??
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        prefixIcon:
            widget.prefixIcon != null
                ? Icon(
                  widget.prefixIcon,
                  color:
                      widget.errorText != null
                          ? colorScheme.error
                          : colorScheme.onSurface.withValues(alpha: 0.6),
                  size: 20,
                )
                : widget.prefix,
        suffixIcon: suffixIconWidget ?? widget.suffix,
        counterText: widget.showCounter ? null : '',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.onSurface.withValues(alpha: 0.2),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.onSurface.withValues(alpha: 0.2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.onSurface.withValues(alpha: 0.1),
          ),
        ),
      ),
    );
  }
}

class AppPasswordField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? errorText;
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;

  const AppPasswordField({
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
  });

  @override
  State<AppPasswordField> createState() => _AppPasswordFieldState();
}

class _AppPasswordFieldState extends State<AppPasswordField> {
  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: widget.label,
      hint: widget.hint,
      controller: widget.controller,
      errorText: widget.errorText,
      prefix: widget.prefixIcon,
      obscureText: true,
      keyboardType: TextInputType.visiblePassword,
      onChanged: widget.onChanged,
      onEditingComplete: widget.onEditingComplete,
      textInputAction: widget.textInputAction,
      focusNode: widget.focusNode,
      validator: widget.validator,
    );
  }
}
