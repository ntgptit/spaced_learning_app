// lib/presentation/widgets/common/input/sl_text_field.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

// Define the enum for text field sizes
enum SlTextFieldSize {
  small,
  medium, // Default
}

class SLTextField extends StatefulWidget {
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
  final Color? labelColor;
  final Color? hintColor;
  final Color? errorColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? iconColor;
  final Color? prefixIconColor;
  final Color? suffixIconColor;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? contentPadding;
  final TextInputAction? textInputAction;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;
  final SlTextFieldSize size;

  const SLTextField({
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
    this.labelColor,
    this.hintColor,
    this.errorColor,
    this.borderColor,
    this.focusedBorderColor,
    this.iconColor,
    this.prefixIconColor,
    this.suffixIconColor,
    this.backgroundColor,
    this.contentPadding,
    this.textInputAction,
    this.onEditingComplete,
    this.onSubmitted,
    this.size = SlTextFieldSize.medium,
  });

  @override
  State<SLTextField> createState() => _SLTextFieldState();

  // Factory constructor for a search field
  factory SLTextField.search({
    TextEditingController? controller,
    String? hint = 'Search...',
    ValueChanged<String>? onChanged,
    VoidCallback? onClear,
    FocusNode? focusNode,
    SlTextFieldSize size = SlTextFieldSize.medium,
    Color? fillColor,
  }) {
    return SLTextField(
      controller: controller,
      hint: hint,
      prefixIcon: Icons.search,
      keyboardType: TextInputType.text,
      onChanged: onChanged,
      focusNode: focusNode,
      size: size,
      fillColor: fillColor,
      suffixIcon: Icons.clear,
      onSuffixIconTap: onClear,
    );
  }

  // Factory constructor for a number field
  factory SLTextField.number({
    TextEditingController? controller,
    String? label,
    String? hint,
    ValueChanged<String>? onChanged,
    String? Function(String?)? validator,
    int? maxLength,
    bool allowDecimal = false,
  }) {
    return SLTextField(
      controller: controller,
      label: label,
      hint: hint,
      keyboardType: allowDecimal
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.number,
      inputFormatters: [
        if (!allowDecimal) FilteringTextInputFormatter.digitsOnly,
        if (allowDecimal)
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
      ],
      onChanged: onChanged,
      validator: validator,
      maxLength: maxLength,
      prefixIcon: Icons.numbers,
    );
  }

  // Factory constructor for a multiline text field
  factory SLTextField.multiline({
    TextEditingController? controller,
    String? label,
    String? hint,
    int minLines = 3,
    int maxLines = 5,
    ValueChanged<String>? onChanged,
    String? Function(String?)? validator,
  }) {
    return SLTextField(
      controller: controller,
      label: label,
      hint: hint,
      minLines: minLines,
      maxLines: maxLines,
      keyboardType: TextInputType.multiline,
      onChanged: onChanged,
      validator: validator,
    );
  }
}

class _SLTextFieldState extends State<SLTextField> {
  bool _passwordVisible = false;

  EdgeInsetsGeometry _getEffectiveContentPadding() {
    if (widget.contentPadding != null) {
      return widget.contentPadding!;
    }

    switch (widget.size) {
      case SlTextFieldSize.small:
        return const EdgeInsets.symmetric(
          horizontal: AppDimens.paddingM,
          vertical: AppDimens.paddingS + 2,
        );
      case SlTextFieldSize.medium:
        return const EdgeInsets.symmetric(
          horizontal: AppDimens.paddingL,
          vertical: AppDimens.paddingL,
        );
    }
  }

  double _getEffectiveIconSize() {
    switch (widget.size) {
      case SlTextFieldSize.small:
        return AppDimens.iconS;
      case SlTextFieldSize.medium:
        return AppDimens.iconM;
    }
  }

  TextStyle _getEffectiveTextStyle(ThemeData theme, ColorScheme colorScheme) {
    TextStyle baseStyle = theme.textTheme.bodyLarge!;

    if (widget.size == SlTextFieldSize.small) {
      baseStyle =
          theme.textTheme.bodyMedium ??
          theme.textTheme.bodyLarge!.copyWith(fontSize: 14);
    }

    return baseStyle.copyWith(
      color: widget.enabled
          ? colorScheme.onSurface
          : colorScheme.onSurface.withOpacity(AppDimens.opacityDisabledText),
    );
  }

  TextStyle _getEffectiveLabelStyle(ThemeData theme, ColorScheme colorScheme) {
    TextStyle baseStyle = theme.textTheme.bodyLarge!;
    Color defaultLabelColor = widget.labelColor ?? colorScheme.onSurfaceVariant;

    if (widget.size == SlTextFieldSize.small) {
      baseStyle =
          theme.textTheme.bodySmall ??
          theme.textTheme.bodyLarge!.copyWith(fontSize: 12);
    }

    if (widget.errorText != null) {
      defaultLabelColor = widget.errorColor ?? colorScheme.error;
    }

    return baseStyle.copyWith(color: defaultLabelColor);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveIconSize = _getEffectiveIconSize();
    final currentContentPadding = _getEffectiveContentPadding();
    final currentTextStyle = _getEffectiveTextStyle(theme, colorScheme);
    final currentLabelStyle = _getEffectiveLabelStyle(theme, colorScheme);

    final Color defaultIconColor =
        widget.iconColor ?? colorScheme.onSurfaceVariant;
    final Color activeIconColor = widget.iconColor ?? colorScheme.primary;
    final Color errorStateIconColor = widget.errorColor ?? colorScheme.error;

    final Color currentPrefixIconColor =
        widget.prefixIconColor ??
        (widget.errorText != null ? errorStateIconColor : defaultIconColor);

    final Color currentSuffixIconColor =
        widget.suffixIconColor ??
        (widget.errorText != null ? errorStateIconColor : defaultIconColor);

    Widget? finalSuffixIconWidget;

    if (widget.suffixIcon != null) {
      finalSuffixIconWidget = InkWell(
        onTap: widget.onSuffixIconTap,
        borderRadius: BorderRadius.circular(AppDimens.radiusXXL),
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.paddingS / 2),
          child: Icon(
            widget.suffixIcon,
            color:
                widget.suffixIconColor ??
                (widget.errorText != null
                    ? errorStateIconColor
                    : activeIconColor),
            size: effectiveIconSize,
          ),
        ),
      );
    }

    if (widget.obscureText) {
      finalSuffixIconWidget = InkWell(
        onTap: () {
          setState(() {
            _passwordVisible = !_passwordVisible;
          });
        },
        borderRadius: BorderRadius.circular(AppDimens.radiusXXL),
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.paddingS / 2),
          child: Icon(
            _passwordVisible
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: widget.suffixIconColor ?? defaultIconColor,
            size: effectiveIconSize,
          ),
        ),
      );
    }

    if (widget.suffix != null) {
      finalSuffixIconWidget = widget.suffix;
    }

    return Container(
      color: widget.backgroundColor ?? Colors.transparent,
      child: TextFormField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        textCapitalization: widget.textCapitalization,
        textAlign: widget.textAlign,
        readOnly: widget.readOnly,
        enabled: widget.enabled,
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
        style: currentTextStyle,
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hint,
          errorText: widget.errorText,
          helperText: widget.helperText,
          filled: true,
          fillColor: widget.fillColor ?? colorScheme.surfaceContainerLowest,
          contentPadding: currentContentPadding,
          prefixIcon: widget.prefixIcon != null
              ? Padding(
                  padding: EdgeInsetsDirectional.only(
                    start: AppDimens.paddingM,
                    end: widget.size == SlTextFieldSize.small
                        ? AppDimens.paddingXS
                        : AppDimens.paddingS,
                  ),
                  child: Icon(
                    widget.prefixIcon,
                    color: currentPrefixIconColor,
                    size: effectiveIconSize,
                  ),
                )
              : widget.prefix,
          suffixIcon: finalSuffixIconWidget,
          counterText: widget.showCounter ? null : '',
          labelStyle: currentLabelStyle,
          // Continuing from the previous sl_text_field.dart implementation:
          hintStyle:
              (widget.size == SlTextFieldSize.small
                      ? theme.textTheme.bodyMedium
                      : theme.textTheme.bodyLarge)
                  ?.copyWith(
                    color:
                        widget.hintColor ??
                        colorScheme.onSurfaceVariant.withOpacity(
                          AppDimens.opacityHintText,
                        ),
                  ),
          errorStyle: TextStyle(
            color: widget.errorColor ?? colorScheme.error,
            fontSize: widget.size == SlTextFieldSize.small
                ? AppDimens.fontMicro
                : null,
          ),
          helperStyle:
              (widget.size == SlTextFieldSize.small
                      ? theme.textTheme.bodySmall
                      : theme.textTheme.bodyMedium)
                  ?.copyWith(color: colorScheme.onSurfaceVariant),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusM),
            borderSide: BorderSide(
              color: widget.borderColor ?? colorScheme.outline,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusM),
            borderSide: BorderSide(
              color: widget.borderColor ?? colorScheme.outline,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusM),
            borderSide: BorderSide(
              color: widget.focusedBorderColor ?? colorScheme.primary,
              width: AppDimens.borderWidthFocused,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusM),
            borderSide: BorderSide(
              color: widget.errorColor ?? colorScheme.error,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusM),
            borderSide: BorderSide(
              color: widget.errorColor ?? colorScheme.error,
              width: AppDimens.borderWidthFocused,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusM),
            borderSide: BorderSide(
              color: (widget.borderColor ?? colorScheme.outline).withOpacity(
                AppDimens.opacityDisabledOutline,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
