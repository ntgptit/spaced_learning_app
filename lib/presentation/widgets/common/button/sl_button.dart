// lib/presentation/widgets/common/button/sl_button.dart
import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

enum SlButtonSize { small, medium, large }

enum SlButtonVariant { filled, tonal, outlined, text }

class SlButton extends StatelessWidget {
  final String? text;
  final Widget? child;
  final VoidCallback? onPressed;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final SlButtonSize size;
  final SlButtonVariant variant;
  final bool isLoading;
  final bool isFullWidth;
  final double? width;
  final double? height;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? elevation;

  const SlButton({
    super.key,
    this.text,
    this.child,
    this.onPressed,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixWidget,
    this.suffixWidget,
    this.backgroundColor,
    this.foregroundColor,
    this.size = SlButtonSize.medium,
    this.variant = SlButtonVariant.filled,
    this.isLoading = false,
    this.isFullWidth = false,
    this.width,
    this.height,
    this.borderRadius,
    this.padding,
    this.elevation,
  }) : assert(
         text != null || child != null,
         'Either text or child must be provided',
       );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Size configuration
    final EdgeInsetsGeometry effectivePadding = padding ?? _getPadding();
    final double effectiveHeight = height ?? _getHeight();
    final double effectiveBorderRadius = borderRadius ?? _getBorderRadius();

    // Colors based on variant
    final Color effectiveBackgroundColor =
        backgroundColor ?? _getBackgroundColor(colorScheme);
    final Color effectiveForegroundColor =
        foregroundColor ?? _getForegroundColor(colorScheme);

    // Building button style
    final ButtonStyle buttonStyle = _buildButtonStyle(
      colorScheme,
      effectiveBackgroundColor,
      effectiveForegroundColor,
      effectivePadding,
      effectiveBorderRadius,
    );

    // Determine the type of button to render
    switch (variant) {
      case SlButtonVariant.filled:
        return _buildElevatedButton(buttonStyle, effectiveForegroundColor);
      case SlButtonVariant.tonal:
        return _buildElevatedButton(buttonStyle, effectiveForegroundColor);
      case SlButtonVariant.outlined:
        return _buildOutlinedButton(buttonStyle, effectiveForegroundColor);
      case SlButtonVariant.text:
        return _buildTextButton(buttonStyle, effectiveForegroundColor);
    }
  }

  Widget _buildElevatedButton(ButtonStyle style, Color foregroundColor) {
    final Widget button = ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: style,
      child: _buildButtonContent(foregroundColor),
    );

    return _wrapWithWidth(button);
  }

  Widget _buildOutlinedButton(ButtonStyle style, Color foregroundColor) {
    final Widget button = OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: style,
      child: _buildButtonContent(foregroundColor),
    );

    return _wrapWithWidth(button);
  }

  Widget _buildTextButton(ButtonStyle style, Color foregroundColor) {
    final Widget button = TextButton(
      onPressed: isLoading ? null : onPressed,
      style: style,
      child: _buildButtonContent(foregroundColor),
    );

    return _wrapWithWidth(button);
  }

  Widget _wrapWithWidth(Widget button) {
    if (width != null) {
      return SizedBox(width: width, child: button);
    }

    return isFullWidth
        ? SizedBox(width: double.infinity, child: button)
        : button;
  }

  Widget _buildButtonContent(Color foregroundColor) {
    if (isLoading) {
      return SizedBox(
        width: _getLoadingSize(),
        height: _getLoadingSize(),
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
        ),
      );
    }

    if (child != null) {
      return child!;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (prefixWidget != null) ...[
          prefixWidget!,
          const SizedBox(width: AppDimens.spaceS),
        ] else if (prefixIcon != null) ...[
          Icon(prefixIcon, size: _getIconSize()),
          const SizedBox(width: AppDimens.spaceS),
        ],

        if (text != null) Text(text!, style: _getTextStyle()),

        if (suffixWidget != null) ...[
          const SizedBox(width: AppDimens.spaceS),
          suffixWidget!,
        ] else if (suffixIcon != null) ...[
          const SizedBox(width: AppDimens.spaceS),
          Icon(suffixIcon, size: _getIconSize()),
        ],
      ],
    );
  }

  ButtonStyle _buildButtonStyle(
    ColorScheme colorScheme,
    Color backgroundColor,
    Color foregroundColor,
    EdgeInsetsGeometry padding,
    double borderRadius,
  ) {
    switch (variant) {
      case SlButtonVariant.filled:
        return ElevatedButton.styleFrom(
          foregroundColor: foregroundColor,
          backgroundColor: backgroundColor,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          elevation: elevation ?? AppDimens.elevationS,
          minimumSize: Size(0, height ?? _getHeight()),
          disabledBackgroundColor: colorScheme.onSurface.withOpacity(
            AppDimens.opacityMedium,
          ),
          disabledForegroundColor: colorScheme.onSurface.withOpacity(
            AppDimens.opacityDisabled,
          ),
        );
      case SlButtonVariant.tonal:
        return ElevatedButton.styleFrom(
          foregroundColor: foregroundColor,
          backgroundColor: backgroundColor,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          elevation: elevation ?? AppDimens.elevationXS,
          minimumSize: Size(0, height ?? _getHeight()),
          disabledBackgroundColor: colorScheme.onSurface.withOpacity(
            AppDimens.opacityMedium,
          ),
          disabledForegroundColor: colorScheme.onSurface.withOpacity(
            AppDimens.opacityDisabled,
          ),
        );
      case SlButtonVariant.outlined:
        return OutlinedButton.styleFrom(
          foregroundColor: foregroundColor,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          side: BorderSide(
            color: colorScheme.outline,
            width: AppDimens.outlineButtonBorderWidth,
          ),
          minimumSize: Size(0, height ?? _getHeight()),
          disabledForegroundColor: colorScheme.onSurface.withOpacity(
            AppDimens.opacityDisabled,
          ),
        );
      case SlButtonVariant.text:
        return TextButton.styleFrom(
          foregroundColor: foregroundColor,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          minimumSize: Size(0, height ?? _getHeight()),
          disabledForegroundColor: colorScheme.onSurface.withOpacity(
            AppDimens.opacityDisabled,
          ),
        );
    }
  }

  // Helper methods for size configurations
  double _getHeight() {
    switch (size) {
      case SlButtonSize.small:
        return AppDimens.buttonHeightS;
      case SlButtonSize.medium:
        return AppDimens.buttonHeightM;
      case SlButtonSize.large:
        return AppDimens.buttonHeightL;
    }
  }

  double _getBorderRadius() {
    switch (size) {
      case SlButtonSize.small:
        return AppDimens.radiusS;
      case SlButtonSize.medium:
        return AppDimens.radiusM;
      case SlButtonSize.large:
        return AppDimens.radiusL;
    }
  }

  EdgeInsetsGeometry _getPadding() {
    switch (size) {
      case SlButtonSize.small:
        return const EdgeInsets.symmetric(
          horizontal: AppDimens.paddingM,
          vertical: AppDimens.paddingXS,
        );
      case SlButtonSize.medium:
        return const EdgeInsets.symmetric(
          horizontal: AppDimens.paddingL,
          vertical: AppDimens.paddingS,
        );
      case SlButtonSize.large:
        return const EdgeInsets.symmetric(
          horizontal: AppDimens.paddingXL,
          vertical: AppDimens.paddingM,
        );
    }
  }

  double _getIconSize() {
    switch (size) {
      case SlButtonSize.small:
        return AppDimens.iconS;
      case SlButtonSize.medium:
        return AppDimens.iconM;
      case SlButtonSize.large:
        return AppDimens.iconL;
    }
  }

  double _getLoadingSize() {
    switch (size) {
      case SlButtonSize.small:
        return AppDimens.iconXS;
      case SlButtonSize.medium:
        return AppDimens.iconS;
      case SlButtonSize.large:
        return AppDimens.iconM;
    }
  }

  TextStyle? _getTextStyle() {
    switch (size) {
      case SlButtonSize.small:
        return const TextStyle(
          fontSize: AppDimens.fontL,
          fontWeight: FontWeight.w500,
        );
      case SlButtonSize.medium:
        return const TextStyle(
          fontSize: AppDimens.fontXL,
          fontWeight: FontWeight.w500,
        );
      case SlButtonSize.large:
        return const TextStyle(
          fontSize: AppDimens.fontXL,
          fontWeight: FontWeight.w600,
        );
    }
  }

  // Helper methods for color configurations
  Color _getBackgroundColor(ColorScheme colorScheme) {
    switch (variant) {
      case SlButtonVariant.filled:
        return colorScheme.primary;
      case SlButtonVariant.tonal:
        return colorScheme.secondaryContainer;
      case SlButtonVariant.outlined:
      case SlButtonVariant.text:
        return Colors.transparent;
    }
  }

  Color _getForegroundColor(ColorScheme colorScheme) {
    switch (variant) {
      case SlButtonVariant.filled:
        return colorScheme.onPrimary;
      case SlButtonVariant.tonal:
        return colorScheme.onSecondaryContainer;
      case SlButtonVariant.outlined:
      case SlButtonVariant.text:
        return colorScheme.primary;
    }
  }

  // Factory constructor for primary button
  factory SlButton.primary({
    required String text,
    VoidCallback? onPressed,
    IconData? prefixIcon,
    IconData? suffixIcon,
    bool isLoading = false,
    bool isFullWidth = false,
    SlButtonSize size = SlButtonSize.medium,
    Color? backgroundColor,
    Color? foregroundColor,
  }) {
    return SlButton(
      text: text,
      onPressed: onPressed,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
      size: size,
      variant: SlButtonVariant.filled,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
    );
  }

  // Factory constructor for secondary button
  factory SlButton.secondary({
    required String text,
    VoidCallback? onPressed,
    IconData? prefixIcon,
    IconData? suffixIcon,
    bool isLoading = false,
    bool isFullWidth = false,
    SlButtonSize size = SlButtonSize.medium,
    Color? backgroundColor,
    Color? foregroundColor,
  }) {
    return SlButton(
      text: text,
      onPressed: onPressed,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
      size: size,
      variant: SlButtonVariant.tonal,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
    );
  }

  // Factory constructor for text button
  factory SlButton.text({
    required String text,
    VoidCallback? onPressed,
    IconData? prefixIcon,
    IconData? suffixIcon,
    bool isLoading = false,
    SlButtonSize size = SlButtonSize.medium,
    Color? foregroundColor,
  }) {
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

  // Factory constructor for icon-only button
  factory SlButton.icon({
    required IconData icon,
    VoidCallback? onPressed,
    SlButtonSize size = SlButtonSize.medium,
    SlButtonVariant variant = SlButtonVariant.filled,
    Color? backgroundColor,
    Color? foregroundColor,
    bool isLoading = false,
  }) {
    return SlButton(
      prefixIcon: icon,
      onPressed: onPressed,
      size: size,
      variant: variant,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      isLoading: isLoading,
      text: '', // Empty text but icon will show
    );
  }
}
