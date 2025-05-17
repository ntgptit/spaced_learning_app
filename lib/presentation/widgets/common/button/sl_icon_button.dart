// lib/presentation/widgets/common/button/sl_icon_button.dart
import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

enum SlIconButtonSize { small, medium, large }

enum SlIconButtonVariant { filled, tonal, outlined, standard }

class SlIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final SlIconButtonSize size;
  final SlIconButtonVariant variant;
  final Color? backgroundColor;
  final Color? iconColor;
  final String? tooltip;
  final bool isLoading;

  const SlIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = SlIconButtonSize.medium,
    this.variant = SlIconButtonVariant.standard,
    this.backgroundColor,
    this.iconColor,
    this.tooltip,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Size configuration
    final double buttonSize = _getButtonSize();
    final double iconSize = _getIconSize();
    final double borderRadius = _getBorderRadius();

    // Colors based on variant
    final Color effectiveIconColor = iconColor ?? _getIconColor(colorScheme);
    final Color effectiveBackgroundColor =
        backgroundColor ?? _getBackgroundColor(colorScheme);

    // Build different icon button variants
    switch (variant) {
      case SlIconButtonVariant.filled:
        return _buildFilledIconButton(
          context,
          buttonSize,
          iconSize,
          borderRadius,
          effectiveBackgroundColor,
          effectiveIconColor,
        );
      case SlIconButtonVariant.tonal:
        return _buildTonalIconButton(
          context,
          buttonSize,
          iconSize,
          borderRadius,
          effectiveBackgroundColor,
          effectiveIconColor,
        );
      case SlIconButtonVariant.outlined:
        return _buildOutlinedIconButton(
          context,
          buttonSize,
          iconSize,
          borderRadius,
          effectiveIconColor,
        );
      case SlIconButtonVariant.standard:
        return _buildStandardIconButton(
          context,
          buttonSize,
          iconSize,
          effectiveIconColor,
        );
    }
  }

  Widget _buildFilledIconButton(
    BuildContext context,
    double buttonSize,
    double iconSize,
    double borderRadius,
    Color backgroundColor,
    Color iconColor,
  ) {
    return SizedBox(
      width: buttonSize,
      height: buttonSize,
      child: Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        color: backgroundColor,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.paddingS),
            child: _buildContent(iconSize, iconColor),
          ),
        ),
      ),
    );
  }

  Widget _buildTonalIconButton(
    BuildContext context,
    double buttonSize,
    double iconSize,
    double borderRadius,
    Color backgroundColor,
    Color iconColor,
  ) {
    return SizedBox(
      width: buttonSize,
      height: buttonSize,
      child: Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        color: backgroundColor,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.paddingS),
            child: _buildContent(iconSize, iconColor),
          ),
        ),
      ),
    );
  }

  Widget _buildOutlinedIconButton(
    BuildContext context,
    double buttonSize,
    double iconSize,
    double borderRadius,
    Color iconColor,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      width: buttonSize,
      height: buttonSize,
      child: Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: BorderSide(
            color: colorScheme.outline,
            width: AppDimens.outlineButtonBorderWidth,
          ),
        ),
        color: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.paddingS),
            child: _buildContent(iconSize, iconColor),
          ),
        ),
      ),
    );
  }

  Widget _buildStandardIconButton(
    BuildContext context,
    double buttonSize,
    double iconSize,
    Color iconColor,
  ) {
    return SizedBox(
      width: buttonSize,
      height: buttonSize,
      child: IconButton(
        onPressed: isLoading ? null : onPressed,
        icon: _buildContent(iconSize, iconColor),
        tooltip: tooltip,
      ),
    );
  }

  Widget _buildContent(double iconSize, Color iconColor) {
    if (isLoading) {
      return SizedBox(
        width: iconSize,
        height: iconSize,
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor: AlwaysStoppedAnimation<Color>(iconColor),
        ),
      );
    }

    return Icon(icon, size: iconSize, color: iconColor);
  }

  // Helper methods for size configurations
  double _getButtonSize() {
    switch (size) {
      case SlIconButtonSize.small:
        return AppDimens.iconL; // 24.0
      case SlIconButtonSize.medium:
        return AppDimens.iconXL; // 32.0
      case SlIconButtonSize.large:
        return AppDimens.iconXXL; // 48.0
    }
  }

  double _getIconSize() {
    switch (size) {
      case SlIconButtonSize.small:
        return AppDimens.iconS; // 16.0
      case SlIconButtonSize.medium:
        return AppDimens.iconM; // 20.0
      case SlIconButtonSize.large:
        return AppDimens.iconL; // 24.0
    }
  }

  double _getBorderRadius() {
    switch (size) {
      case SlIconButtonSize.small:
        return AppDimens.radiusCircular;
      case SlIconButtonSize.medium:
        return AppDimens.radiusCircular;
      case SlIconButtonSize.large:
        return AppDimens.radiusCircular;
    }
  }

  // Helper methods for color configurations
  Color _getBackgroundColor(ColorScheme colorScheme) {
    switch (variant) {
      case SlIconButtonVariant.filled:
        return colorScheme.primary;
      case SlIconButtonVariant.tonal:
        return colorScheme.secondaryContainer;
      case SlIconButtonVariant.outlined:
      case SlIconButtonVariant.standard:
        return Colors.transparent;
    }
  }

  Color _getIconColor(ColorScheme colorScheme) {
    switch (variant) {
      case SlIconButtonVariant.filled:
        return colorScheme.onPrimary;
      case SlIconButtonVariant.tonal:
        return colorScheme.onSecondaryContainer;
      case SlIconButtonVariant.outlined:
      case SlIconButtonVariant.standard:
        return colorScheme.primary;
    }
  }
}
