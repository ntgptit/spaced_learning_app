// lib/presentation/widgets/app_button.dart
import 'package:flutter/material.dart';

enum AppButtonType {
  primary, // Filled button with primary color
  secondary, // Filled button with secondary color
  outline, // Outlined button with colored border
  text, // Text-only button without background
  ghost, // Semi-transparent background that appears on hover/press
  error, // Red/error-themed button for destructive actions
  success, // Green/success-themed button for confirmations
  warning, // Amber/warning-themed button for cautionary actions
}

enum AppButtonSize {
  tiny, // For very small buttons like icons with minimal text
  small, // For secondary actions, compact UI
  medium, // Default size for most actions
  large, // Primary actions, call-to-action buttons
  xlarge, // Prominent buttons, marketing or hero sections
}

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final AppButtonSize size;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Widget? prefixWidget; // Add custom prefix widget
  final Widget? suffixWidget; // Add custom suffix widget
  final bool isLoading;
  final bool isFullWidth;
  final double? width; // Add optional specific width
  final Color? backgroundColor;
  final Color? textColor;
  final Color? iconColor;
  final Color? borderColor;
  final double? elevation;
  final BorderRadius? customBorderRadius;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.size = AppButtonSize.medium,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixWidget,
    this.suffixWidget,
    this.isLoading = false,
    this.isFullWidth = false,
    this.width,
    this.backgroundColor,
    this.textColor,
    this.iconColor,
    this.borderColor,
    this.elevation,
    this.customBorderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Get size dimensions
    EdgeInsets padding;
    double height;
    double iconSize;
    double borderRadius;
    TextStyle textStyle;

    switch (size) {
      case AppButtonSize.tiny:
        padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4);
        height = 28;
        iconSize = 14;
        borderRadius = 6;
        textStyle = theme.textTheme.bodySmall!.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.25,
        );
        break;
      case AppButtonSize.small:
        padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
        height = 36;
        iconSize = 16;
        borderRadius = 8;
        textStyle = theme.textTheme.bodySmall!.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        );
        break;
      case AppButtonSize.medium:
        padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 12);
        height = 48;
        iconSize = 20;
        borderRadius = 12;
        textStyle = theme.textTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        );
        break;
      case AppButtonSize.large:
        padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 16);
        height = 56;
        iconSize = 24;
        borderRadius = 16;
        textStyle = theme.textTheme.bodyLarge!.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        );
        break;
      case AppButtonSize.xlarge:
        padding = const EdgeInsets.symmetric(horizontal: 32, vertical: 20);
        height = 64;
        iconSize = 28;
        borderRadius = 20;
        textStyle = theme.textTheme.titleMedium!.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        );
        break;
    }

    // Get colors based on type
    Color defaultBackgroundColor;
    Color defaultTextColor;
    Color defaultBorderColor;
    double defaultElevation;

    switch (type) {
      case AppButtonType.primary:
        defaultBackgroundColor = colorScheme.primary;
        defaultTextColor = colorScheme.onPrimary;
        defaultBorderColor = Colors.transparent;
        defaultElevation = 2;
        break;
      case AppButtonType.secondary:
        defaultBackgroundColor = colorScheme.secondary;
        defaultTextColor = colorScheme.onSecondary;
        defaultBorderColor = Colors.transparent;
        defaultElevation = 2;
        break;
      case AppButtonType.outline:
        defaultBackgroundColor = Colors.transparent;
        defaultTextColor = colorScheme.primary;
        defaultBorderColor = colorScheme.primary;
        defaultElevation = 0;
        break;
      case AppButtonType.text:
        defaultBackgroundColor = Colors.transparent;
        defaultTextColor = colorScheme.primary;
        defaultBorderColor = Colors.transparent;
        defaultElevation = 0;
        break;
      case AppButtonType.ghost:
        defaultBackgroundColor = colorScheme.primary.withOpacity(0.05);
        defaultTextColor = colorScheme.primary;
        defaultBorderColor = Colors.transparent;
        defaultElevation = 0;
        break;
      case AppButtonType.error:
        defaultBackgroundColor = colorScheme.error;
        defaultTextColor = colorScheme.onError;
        defaultBorderColor = Colors.transparent;
        defaultElevation = 2;
        break;
      case AppButtonType.success:
        defaultBackgroundColor = Colors.green;
        defaultTextColor = Colors.white;
        defaultBorderColor = Colors.transparent;
        defaultElevation = 2;
        break;
      case AppButtonType.warning:
        defaultBackgroundColor = Colors.amber;
        defaultTextColor = Colors.black87;
        defaultBorderColor = Colors.transparent;
        defaultElevation = 2;
        break;
    }

    // Apply custom colors if provided
    final effectiveBackgroundColor = backgroundColor ?? defaultBackgroundColor;
    final effectiveTextColor = textColor ?? defaultTextColor;
    final effectiveIconColor = iconColor ?? effectiveTextColor;
    final effectiveBorderColor = borderColor ?? defaultBorderColor;
    final effectiveElevation = elevation ?? defaultElevation;
    final effectiveBorderRadius =
        customBorderRadius ?? BorderRadius.circular(borderRadius);

    // Create button based on type
    Widget button;

    switch (type) {
      case AppButtonType.primary:
      case AppButtonType.secondary:
      case AppButtonType.error:
      case AppButtonType.success:
      case AppButtonType.warning:
      case AppButtonType.ghost:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            foregroundColor: effectiveTextColor,
            backgroundColor: effectiveBackgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: effectiveBorderRadius,
              side: BorderSide(color: effectiveBorderColor),
            ),
            padding: padding,
            minimumSize: Size(0, height),
            elevation: effectiveElevation,
            disabledBackgroundColor: theme.disabledColor.withOpacity(0.12),
            disabledForegroundColor: theme.disabledColor.withOpacity(0.38),
            shadowColor:
                type == AppButtonType.ghost ? Colors.transparent : null,
          ),
          child: _buildContent(
            effectiveTextColor,
            effectiveIconColor,
            iconSize,
            textStyle,
          ),
        );
        break;

      case AppButtonType.outline:
        button = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: effectiveTextColor,
            shape: RoundedRectangleBorder(borderRadius: effectiveBorderRadius),
            side: BorderSide(color: effectiveBorderColor, width: 1.5),
            padding: padding,
            minimumSize: Size(0, height),
            backgroundColor: effectiveBackgroundColor,
            disabledForegroundColor: theme.disabledColor.withOpacity(0.38),
          ),
          child: _buildContent(
            effectiveTextColor,
            effectiveIconColor,
            iconSize,
            textStyle,
          ),
        );
        break;

      case AppButtonType.text:
        button = TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: effectiveTextColor,
            shape: RoundedRectangleBorder(borderRadius: effectiveBorderRadius),
            padding: padding,
            minimumSize: Size(0, height),
            backgroundColor: effectiveBackgroundColor,
            disabledForegroundColor: theme.disabledColor.withOpacity(0.38),
          ),
          child: _buildContent(
            effectiveTextColor,
            effectiveIconColor,
            iconSize,
            textStyle,
          ),
        );
        break;
    }

    if (width != null) {
      return SizedBox(width: width, child: button);
    }

    return isFullWidth
        ? SizedBox(width: double.infinity, child: button)
        : button;
  }

  Widget _buildContent(
    Color textColor,
    Color iconColor,
    double iconSize,
    TextStyle baseTextStyle,
  ) {
    if (isLoading) {
      return SizedBox(
        width:
            size == AppButtonSize.tiny || size == AppButtonSize.small ? 16 : 20,
        height:
            size == AppButtonSize.tiny || size == AppButtonSize.small ? 16 : 20,
        child: CircularProgressIndicator(
          strokeWidth:
              size == AppButtonSize.tiny || size == AppButtonSize.small
                  ? 2.0
                  : 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(textColor),
        ),
      );
    }

    final List<Widget> children = [];

    // Add prefix (icon or widget)
    if (prefixWidget != null) {
      children.add(prefixWidget!);
      children.add(SizedBox(width: size == AppButtonSize.tiny ? 4 : 8));
    } else if (prefixIcon != null) {
      children.add(Icon(prefixIcon, size: iconSize, color: iconColor));
      children.add(SizedBox(width: size == AppButtonSize.tiny ? 4 : 8));
    }

    // Add text
    children.add(Text(text, style: baseTextStyle.copyWith(color: textColor)));

    // Add suffix (icon or widget)
    if (suffixWidget != null) {
      children.add(SizedBox(width: size == AppButtonSize.tiny ? 4 : 8));
      children.add(suffixWidget!);
    } else if (suffixIcon != null) {
      children.add(SizedBox(width: size == AppButtonSize.tiny ? 4 : 8));
      children.add(Icon(suffixIcon, size: iconSize, color: iconColor));
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }
}
