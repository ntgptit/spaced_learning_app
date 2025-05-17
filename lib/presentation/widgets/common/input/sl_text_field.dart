import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

enum SlTextFieldSize { small, medium, large }

class SlTextField extends StatelessWidget {
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
  final Color? backgroundColor;
  final EdgeInsetsGeometry? contentPadding;
  final TextInputAction? textInputAction;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;
  final SlTextFieldSize size;

  const SlTextField({
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
    this.backgroundColor,
    this.contentPadding,
    this.textInputAction,
    this.onEditingComplete,
    this.onSubmitted,
    this.size = SlTextFieldSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine appropriate sizes based on the field size
    final EdgeInsetsGeometry effectiveContentPadding =
        contentPadding ?? _getContentPadding();

    // Determine effective colors
    final effectiveFillColor = fillColor ?? colorScheme.surfaceContainerLowest;
    final effectiveLabelColor = labelColor ?? colorScheme.onSurface;
    final effectiveHintColor = hintColor ?? colorScheme.onSurfaceVariant;
    final effectiveErrorColor = errorColor ?? colorScheme.error;
    final effectiveBorderColor = borderColor ?? colorScheme.outline;
    final effectiveFocusedBorderColor =
        focusedBorderColor ?? colorScheme.primary;

    // Build prefix and suffix widgets
    Widget? prefixWidget = prefix;
    if (prefixIcon != null && prefixWidget == null) {
      prefixWidget = Icon(
        prefixIcon,
        color: errorText != null ? effectiveErrorColor : colorScheme.primary,
        size: _getIconSize(),
      );
    }

    Widget? suffixWidget = suffix;
    if (suffixIcon != null && suffixWidget == null) {
      suffixWidget = InkWell(
        onTap: onSuffixIconTap,
        borderRadius: BorderRadius.circular(AppDimens.radiusCircular),
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.paddingS),
          child: Icon(
            suffixIcon,
            color: errorText != null
                ? effectiveErrorColor
                : colorScheme.primary,
            size: _getIconSize(),
          ),
        ),
      );
    }

    return Container(
      color: backgroundColor,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        obscureText: obscureText,
        readOnly: readOnly,
        enabled: enabled,
        maxLength: maxLength,
        maxLines: obscureText ? 1 : maxLines,
        minLines: minLines,
        textAlign: textAlign,
        textCapitalization: textCapitalization,
        autofocus: autofocus,
        onChanged: onChanged,
        onTap: onTap,
        inputFormatters: inputFormatters,
        textInputAction: textInputAction,
        onEditingComplete: onEditingComplete,
        onFieldSubmitted: onSubmitted,
        validator: validator,
        autovalidateMode: autovalidateMode,
        style: _getTextStyle(theme, colorScheme),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          errorText: errorText,
          helperText: helperText,
          filled: true,
          fillColor: effectiveFillColor,
          contentPadding: effectiveContentPadding,
          prefixIcon: prefixWidget is Icon ? prefixWidget : null,
          prefix: prefixWidget is! Icon ? prefixWidget : null,
          suffixIcon: suffixWidget,
          counterText: showCounter ? null : '',
          labelStyle: TextStyle(
            color: effectiveLabelColor,
            fontSize: _getLabelFontSize(),
          ),
          hintStyle: TextStyle(
            color: effectiveHintColor,
            fontSize: _getHintFontSize(),
          ),
          errorStyle: TextStyle(
            color: effectiveErrorColor,
            fontSize: _getErrorFontSize(),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_getBorderRadius()),
            borderSide: BorderSide(
              color: effectiveBorderColor,
              width: _getBorderWidth(),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_getBorderRadius()),
            borderSide: BorderSide(
              color: effectiveBorderColor,
              width: _getBorderWidth(),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_getBorderRadius()),
            borderSide: BorderSide(
              color: effectiveFocusedBorderColor,
              width: _getBorderWidth() * 1.5,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_getBorderRadius()),
            borderSide: BorderSide(
              color: effectiveErrorColor,
              width: _getBorderWidth(),
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_getBorderRadius()),
            borderSide: BorderSide(
              color: effectiveErrorColor,
              width: _getBorderWidth() * 1.5,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_getBorderRadius()),
            borderSide: BorderSide(
              color: colorScheme.outline.withValues(
                alpha: AppDimens.opacityDisabled,
              ),
              width: _getBorderWidth(),
            ),
          ),
        ),
      ),
    );
  }

  // Helper methods for size-dependent styling
  TextStyle _getTextStyle(ThemeData theme, ColorScheme colorScheme) {
    switch (size) {
      case SlTextFieldSize.small:
        return theme.textTheme.bodyMedium!.copyWith(
          color: enabled
              ? colorScheme.onSurface
              : colorScheme.onSurface.withValues(
                  alpha: AppDimens.opacityDisabled,
                ),
        );
      case SlTextFieldSize.large:
        return theme.textTheme.bodyLarge!.copyWith(
          color: enabled
              ? colorScheme.onSurface
              : colorScheme.onSurface.withValues(
                  alpha: AppDimens.opacityDisabled,
                ),
        );
      case SlTextFieldSize.medium:
        return theme.textTheme.bodyMedium!.copyWith(
          color: enabled
              ? colorScheme.onSurface
              : colorScheme.onSurface.withValues(
                  alpha: AppDimens.opacityDisabled,
                ),
        );
    }
  }

  EdgeInsetsGeometry _getContentPadding() {
    switch (size) {
      case SlTextFieldSize.small:
        return const EdgeInsets.symmetric(
          horizontal: AppDimens.paddingM,
          vertical: AppDimens.paddingS,
        );
      case SlTextFieldSize.large:
        return const EdgeInsets.symmetric(
          horizontal: AppDimens.paddingL,
          vertical: AppDimens.paddingL,
        );
      case SlTextFieldSize.medium:
        return const EdgeInsets.symmetric(
          horizontal: AppDimens.paddingL,
          vertical: AppDimens.paddingM,
        );
    }
  }

  double _getIconSize() {
    switch (size) {
      case SlTextFieldSize.small:
        return AppDimens.iconS;
      case SlTextFieldSize.large:
        return AppDimens.iconL;
      case SlTextFieldSize.medium:
        return AppDimens.iconM;
    }
  }

  double _getBorderRadius() {
    switch (size) {
      case SlTextFieldSize.small:
        return AppDimens.radiusS;
      case SlTextFieldSize.large:
        return AppDimens.radiusL;
      case SlTextFieldSize.medium:
        return AppDimens.radiusM;
    }
  }

  double _getBorderWidth() {
    return AppDimens.outlineButtonBorderWidth;
  }

  double _getLabelFontSize() {
    switch (size) {
      case SlTextFieldSize.small:
        return AppDimens.fontS;
      case SlTextFieldSize.large:
        return AppDimens.fontL;
      case SlTextFieldSize.medium:
        return AppDimens.fontM;
    }
  }

  double _getHintFontSize() {
    switch (size) {
      case SlTextFieldSize.small:
        return AppDimens.fontS;
      case SlTextFieldSize.large:
        return AppDimens.fontL;
      case SlTextFieldSize.medium:
        return AppDimens.fontM;
    }
  }

  double _getErrorFontSize() {
    switch (size) {
      case SlTextFieldSize.small:
        return AppDimens.fontXS;
      case SlTextFieldSize.large:
        return AppDimens.fontM;
      case SlTextFieldSize.medium:
        return AppDimens.fontS;
    }
  }
}
