// lib/presentation/widgets/common/app_button.dart
import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

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
        padding = const EdgeInsets.symmetric(
          horizontal: AppDimens.paddingS,
          vertical: AppDimens.paddingXS,
        );
        height = AppDimens.buttonHeightS;
        iconSize = AppDimens.iconXS;
        borderRadius = AppDimens.radiusXS + 2;
        textStyle = theme.textTheme.bodySmall!.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.25,
        );
        break;
      case AppButtonSize.small:
        padding = const EdgeInsets.symmetric(
          horizontal: AppDimens.paddingM,
          vertical: AppDimens.paddingS,
        );
        height = AppDimens.buttonHeightM;
        iconSize = AppDimens.iconS;
        borderRadius = AppDimens.radiusS;
        textStyle = theme.textTheme.bodySmall!.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        );
        break;
      case AppButtonSize.medium:
        padding = const EdgeInsets.symmetric(
          horizontal: AppDimens.paddingL + 4,
          vertical: AppDimens.paddingM,
        );
        height = AppDimens.buttonHeightL;
        iconSize = AppDimens.iconM;
        borderRadius = AppDimens.radiusM;
        textStyle = theme.textTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        );
        break;
      case AppButtonSize.large:
        padding = const EdgeInsets.symmetric(
          horizontal: AppDimens.paddingXL,
          vertical: AppDimens.paddingL,
        );
        height = AppDimens.buttonHeightXL;
        iconSize = AppDimens.iconL;
        borderRadius = AppDimens.radiusL;
        textStyle = theme.textTheme.bodyLarge!.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        );
        break;
      case AppButtonSize.xlarge:
        padding = const EdgeInsets.symmetric(
          horizontal: AppDimens.paddingXXL,
          vertical: AppDimens.paddingL + 4,
        );
        height = AppDimens.buttonHeightXL + 8;
        iconSize = AppDimens.iconXL - 4;
        borderRadius = AppDimens.radiusL + 4;
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
        defaultElevation = AppDimens.elevationS;
        break;
      case AppButtonType.secondary:
        defaultBackgroundColor = colorScheme.secondary;
        defaultTextColor = colorScheme.onSecondary;
        defaultBorderColor = Colors.transparent;
        defaultElevation = AppDimens.elevationS;
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
        defaultBackgroundColor = colorScheme.primary.withOpacity(
          AppDimens.opacityLight,
        );
        defaultTextColor = colorScheme.primary;
        defaultBorderColor = Colors.transparent;
        defaultElevation = 0;
        break;
      case AppButtonType.error:
        defaultBackgroundColor = colorScheme.error;
        defaultTextColor = colorScheme.onError;
        defaultBorderColor = Colors.transparent;
        defaultElevation = AppDimens.elevationS;
        break;
      case AppButtonType.success:
        defaultBackgroundColor = Colors.green;
        defaultTextColor = Colors.white;
        defaultBorderColor = Colors.transparent;
        defaultElevation = AppDimens.elevationS;
        break;
      case AppButtonType.warning:
        defaultBackgroundColor = Colors.amber;
        defaultTextColor = Colors.black87;
        defaultBorderColor = Colors.transparent;
        defaultElevation = AppDimens.elevationS;
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
            disabledBackgroundColor: theme.disabledColor.withOpacity(
              AppDimens.opacityMedium,
            ),
            disabledForegroundColor: theme.disabledColor.withOpacity(
              AppDimens.opacityDisabled,
            ),
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
            disabledForegroundColor: theme.disabledColor.withOpacity(
              AppDimens.opacityDisabled,
            ),
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
            disabledForegroundColor: theme.disabledColor.withOpacity(
              AppDimens.opacityDisabled,
            ),
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
            size == AppButtonSize.tiny || size == AppButtonSize.small
                ? AppDimens.iconS
                : AppDimens.iconM,
        height:
            size == AppButtonSize.tiny || size == AppButtonSize.small
                ? AppDimens.iconS
                : AppDimens.iconM,
        child: CircularProgressIndicator(
          strokeWidth:
              size == AppButtonSize.tiny || size == AppButtonSize.small
                  ? AppDimens.lineProgressHeight / 2
                  : AppDimens.lineProgressHeight * 0.625,
          valueColor: AlwaysStoppedAnimation<Color>(textColor),
        ),
      );
    }

    final List<Widget> children = [];

    // Add prefix (icon or widget)
    if (prefixWidget != null) {
      children.add(prefixWidget!);
      children.add(
        SizedBox(
          width:
              size == AppButtonSize.tiny ? AppDimens.spaceXS : AppDimens.spaceS,
        ),
      );
    } else if (prefixIcon != null) {
      children.add(Icon(prefixIcon, size: iconSize, color: iconColor));
      children.add(
        SizedBox(
          width:
              size == AppButtonSize.tiny ? AppDimens.spaceXS : AppDimens.spaceS,
        ),
      );
    }

    // Add text
    children.add(Text(text, style: baseTextStyle.copyWith(color: textColor)));

    // Add suffix (icon or widget)
    if (suffixWidget != null) {
      children.add(
        SizedBox(
          width:
              size == AppButtonSize.tiny ? AppDimens.spaceXS : AppDimens.spaceS,
        ),
      );
      children.add(suffixWidget!);
    } else if (suffixIcon != null) {
      children.add(
        SizedBox(
          width:
              size == AppButtonSize.tiny ? AppDimens.spaceXS : AppDimens.spaceS,
        ),
      );
      children.add(Icon(suffixIcon, size: iconSize, color: iconColor));
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }
}
