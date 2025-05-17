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
  final Widget? prefix; // Alternative to prefixIcon for more complex widgets
  final IconData? suffixIcon;
  final Widget? suffix; // Alternative to suffixIcon for more complex widgets
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
  final Color? iconColor; // General icon color if specific ones aren't set
  final Color? prefixIconColor;
  final Color?
  suffixIconColor; // Specific color for the suffix icon (e.g., visibility toggle)
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
    this.size = SlTextFieldSize.medium, // Default size
  });

  @override
  State<SLTextField> createState() => _SLTextFieldState();
}

class _SLTextFieldState extends State<SLTextField> {
  bool _passwordVisible = false;

  EdgeInsetsGeometry _getEffectiveContentPadding() {
    if (widget.contentPadding != null) {
      return widget.contentPadding!;
    }
    // No 'else', using switch which covers all enum cases or a default
    switch (widget.size) {
      case SlTextFieldSize.small:
        return const EdgeInsets.symmetric(
          horizontal: AppDimens.paddingM, // 12dp
          vertical:
              AppDimens.paddingS +
              2, // 10dp, makes it slightly taller than just paddingS
        );
      case SlTextFieldSize.medium:
        // Default case for SlTextFieldSize.medium or any other future sizes if not specified
        // This also acts as the default if the switch somehow doesn't match.
        return const EdgeInsets.symmetric(
          horizontal: AppDimens.paddingL, // 16dp
          vertical: AppDimens.paddingL, // 16dp
        );
    }
  }

  double _getEffectiveIconSize() {
    // No 'else', using switch
    switch (widget.size) {
      case SlTextFieldSize.small:
        return AppDimens.iconS; // e.g., 20.0
      case SlTextFieldSize.medium:
        return AppDimens.iconM; // e.g., 24.0
    }
  }

  TextStyle _getEffectiveTextStyle(ThemeData theme, ColorScheme colorScheme) {
    TextStyle baseStyle = theme.textTheme.bodyLarge!; // Default for medium size
    if (widget.size == SlTextFieldSize.small) {
      // For small size, consider using a slightly smaller text style if defined in AppTypography
      // or adjust font size directly.
      baseStyle =
          theme.textTheme.bodyMedium ??
          theme.textTheme.bodyLarge!.copyWith(fontSize: 14);
    }

    return baseStyle.copyWith(
      color: widget.enabled
          ? colorScheme.onSurface
          // Assuming AppDimens.opacityDisabledText or a similar value (e.g., 0.38)
          : colorScheme.onSurface.withValues(
              alpha: AppDimens.opacityDisabledText,
            ),
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
    final Color activeIconColor =
        widget.iconColor ??
        colorScheme.primary; // Used when field is focused or for actions
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
          // Consistent small padding for tap area
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
      // Override if obscureText is true, regardless of suffixIcon presence, to show visibility toggle
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
            // Default color for visibility
            size: effectiveIconSize,
          ),
        ),
      );
    }

    // If widget.suffix is provided, it takes precedence over suffixIcon and obscureText toggle
    if (widget.suffix != null) {
      finalSuffixIconWidget = widget.suffix;
    }

    return Container(
      color: widget.backgroundColor ?? Colors.transparent,
      // M3 uses surface colors, transparency might be needed
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
          // M3 typical fill
          contentPadding: currentContentPadding,
          prefixIcon: widget.prefixIcon != null
              ? Padding(
                  padding: EdgeInsetsDirectional.only(
                    start: AppDimens.paddingM, // Consistent padding
                    end: widget.size == SlTextFieldSize.small
                        ? AppDimens.paddingXS
                        : AppDimens.paddingS, // Slightly less space for small
                  ),
                  child: Icon(
                    widget.prefixIcon,
                    color: currentPrefixIconColor,
                    size: effectiveIconSize,
                  ),
                )
              : widget.prefix,
          // Use prefix widget if prefixIcon is null
          suffixIcon: finalSuffixIconWidget,
          counterText: widget.showCounter ? null : '',
          // Empty string hides default counter
          labelStyle: currentLabelStyle,
          hintStyle:
              (widget.size == SlTextFieldSize.small
                      ? theme.textTheme.bodyMedium
                      : theme.textTheme.bodyLarge)
                  ?.copyWith(
                    color:
                        widget.hintColor ??
                        colorScheme.onSurfaceVariant.withValues(
                          alpha: AppDimens.opacityHintText,
                        ), // Use specific opacity for hint
                  ),
          errorStyle: TextStyle(
            color: widget.errorColor ?? colorScheme.error,
            fontSize: widget.size == SlTextFieldSize.small
                ? AppDimens.fontMicro
                : null, // Smaller error text
          ),
          helperStyle:
              (widget.size == SlTextFieldSize.small
                      ? theme.textTheme.bodySmall
                      : theme.textTheme.bodyMedium)
                  ?.copyWith(color: colorScheme.onSurfaceVariant),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusM),
            // Consistent radius
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
              width: AppDimens.borderWidthFocused, // Use defined dimension
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
              width: AppDimens
                  .borderWidthFocused, // Consistent focused error width
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusM),
            borderSide: BorderSide(
              color: (widget.borderColor ?? colorScheme.outline).withValues(
                alpha: AppDimens.opacityDisabledOutline,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
