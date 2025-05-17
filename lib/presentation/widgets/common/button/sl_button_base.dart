// lib/presentation/widgets/common/button/sl_button_base.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

part 'sl_button_base.g.dart';

enum SlButtonVariant { filled, tonal, outlined, text }

enum SlButtonSize { small, medium, large }

@riverpod
class ButtonState extends _$ButtonState {
  @override
  bool build({String id = 'default'}) => false;

  void setLoading(bool isLoading) {
    state = isLoading;
  }
}

class SlButtonBase extends ConsumerWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final String? loadingId;
  final bool isFullWidth;
  final SlButtonSize size;
  final SlButtonVariant variant;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? elevation;
  final BorderSide? borderSide;

  const SlButtonBase({
    super.key,
    required this.text,
    this.onPressed,
    this.prefixIcon,
    this.suffixIcon,
    this.loadingId,
    this.isFullWidth = false,
    this.size = SlButtonSize.medium,
    this.variant = SlButtonVariant.filled,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
    this.padding,
    this.elevation,
    this.borderSide,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isLoading = loadingId != null
        ? ref.watch(buttonStateProvider(id: loadingId!))
        : false;

    // Determine button style based on variant
    final ButtonStyle buttonStyle = _getButtonStyle(theme, colorScheme);

    // Get effective size parameters
    final (effectiveHeight, effectiveIconSize) = _getSizeParameters();
    final effectivePadding = padding ?? _getDefaultPadding();

    // Build button
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: effectiveHeight,
      child: ElevatedButton(
        onPressed: isLoading || onPressed == null ? null : onPressed,
        style: buttonStyle,
        child: Padding(
          padding: effectivePadding,
          child: Row(
            mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (prefixIcon != null && !isLoading) ...[
                Icon(prefixIcon, size: effectiveIconSize),
                const SizedBox(width: AppDimens.spaceS),
              ],
              if (isLoading) ...[
                SizedBox(
                  width: effectiveIconSize,
                  height: effectiveIconSize,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getProgressColor(colorScheme),
                    ),
                  ),
                ),
                const SizedBox(width: AppDimens.spaceS),
              ],
              Flexible(
                child: Text(
                  text,
                  style: _getTextStyle(theme),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (suffixIcon != null && !isLoading) ...[
                const SizedBox(width: AppDimens.spaceS),
                Icon(suffixIcon, size: effectiveIconSize),
              ],
            ],
          ),
        ),
      ),
    );
  }

  ButtonStyle _getButtonStyle(ThemeData theme, ColorScheme colorScheme) {
    final effectiveElevation = elevation ?? _getDefaultElevation();
    final effectiveBorderRadius = borderRadius ?? _getDefaultBorderRadius();

    switch (variant) {
      case SlButtonVariant.filled:
        return ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? colorScheme.primary,
          foregroundColor: foregroundColor ?? colorScheme.onPrimary,
          elevation: effectiveElevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(effectiveBorderRadius),
          ),
          padding: EdgeInsets.zero,
        );

      case SlButtonVariant.tonal:
        return ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? colorScheme.secondaryContainer,
          foregroundColor: foregroundColor ?? colorScheme.onSecondaryContainer,
          elevation: effectiveElevation / 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(effectiveBorderRadius),
          ),
          padding: EdgeInsets.zero,
        );

      case SlButtonVariant.outlined:
        return ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: foregroundColor ?? colorScheme.primary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(effectiveBorderRadius),
            side:
                borderSide ??
                BorderSide(
                  color: colorScheme.outline,
                  width: AppDimens.outlineButtonBorderWidth,
                ),
          ),
          padding: EdgeInsets.zero,
          shadowColor: Colors.transparent,
        );

      case SlButtonVariant.text:
        return ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: foregroundColor ?? colorScheme.primary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(effectiveBorderRadius),
          ),
          padding: EdgeInsets.zero,
          shadowColor: Colors.transparent,
        );
    }
  }

  (double, double) _getSizeParameters() {
    switch (size) {
      case SlButtonSize.small:
        return (AppDimens.buttonHeightS, AppDimens.iconS);
      case SlButtonSize.medium:
        return (AppDimens.buttonHeightM, AppDimens.iconM);
      case SlButtonSize.large:
        return (AppDimens.buttonHeightL, AppDimens.iconL);
    }
  }

  EdgeInsetsGeometry _getDefaultPadding() {
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

  double _getDefaultElevation() {
    switch (variant) {
      case SlButtonVariant.filled:
        return AppDimens.elevationS;
      case SlButtonVariant.tonal:
        return AppDimens.elevationXS;
      case SlButtonVariant.outlined:
      case SlButtonVariant.text:
        return 0;
    }
  }

  double _getDefaultBorderRadius() => AppDimens.radiusM;

  TextStyle? _getTextStyle(ThemeData theme) {
    switch (size) {
      case SlButtonSize.small:
        return theme.textTheme.labelMedium;
      case SlButtonSize.medium:
        return theme.textTheme.labelLarge;
      case SlButtonSize.large:
        return theme.textTheme.titleMedium;
    }
  }

  Color _getProgressColor(ColorScheme colorScheme) {
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
}
