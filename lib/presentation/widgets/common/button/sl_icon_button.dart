// lib/presentation/widgets/common/button/sl_icon_button.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

part 'sl_icon_button.g.dart';

enum SlIconButtonSize { small, medium, large }

enum SlIconButtonVariant { filled, tonal, outlined, standard }

@riverpod
class IconButtonState extends _$IconButtonState {
  @override
  bool build({String id = 'default'}) => false;

  void setLoading(bool isLoading) {
    state = isLoading;
  }
}

class SlIconButton extends ConsumerWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final SlIconButtonSize size;
  final SlIconButtonVariant variant;
  final Color? backgroundColor;
  final Color? iconColor;
  final String? tooltip;
  final String? loadingId;

  const SlIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = SlIconButtonSize.medium,
    this.variant = SlIconButtonVariant.standard,
    this.backgroundColor,
    this.iconColor,
    this.tooltip,
    this.loadingId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isLoading = loadingId != null
        ? ref.watch(iconButtonStateProvider(id: loadingId!))
        : false;

    // Size configuration
    final double buttonSize = _getButtonSize();
    final double iconSize = _getIconSize();
    final double borderRadius = _getBorderRadius();

    // Colors based on variant
    final Color effectiveIconColor = iconColor ?? _getIconColor(colorScheme);
    final Color effectiveBackgroundColor =
        backgroundColor ?? _getBackgroundColor(colorScheme);

    // Build different icon button variants
    Widget buttonWidget;

    switch (variant) {
      case SlIconButtonVariant.filled:
        buttonWidget = _buildFilledIconButton(
          context,
          buttonSize,
          iconSize,
          borderRadius,
          effectiveBackgroundColor,
          effectiveIconColor,
          isLoading,
          ref,
        );
        break;
      case SlIconButtonVariant.tonal:
        buttonWidget = _buildTonalIconButton(
          context,
          buttonSize,
          iconSize,
          borderRadius,
          effectiveBackgroundColor,
          effectiveIconColor,
          isLoading,
          ref,
        );
        break;
      case SlIconButtonVariant.outlined:
        buttonWidget = _buildOutlinedIconButton(
          context,
          buttonSize,
          iconSize,
          borderRadius,
          effectiveIconColor,
          colorScheme,
          isLoading,
          ref,
        );
        break;
      case SlIconButtonVariant.standard:
        buttonWidget = _buildStandardIconButton(
          context,
          buttonSize,
          iconSize,
          effectiveIconColor,
          isLoading,
          ref,
        );
        break;
    }

    return tooltip != null
        ? Tooltip(message: tooltip!, child: buttonWidget)
        : buttonWidget;
  }

  Widget _buildFilledIconButton(
    BuildContext context,
    double buttonSize,
    double iconSize,
    double borderRadius,
    Color backgroundColor,
    Color iconColor,
    bool isLoading,
    WidgetRef ref,
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
          onTap: isLoading || onPressed == null ? null : onPressed,
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.paddingS),
            child: _buildContent(iconSize, iconColor, isLoading),
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
    bool isLoading,
    WidgetRef ref,
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
          onTap: isLoading || onPressed == null ? null : onPressed,
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.paddingS),
            child: _buildContent(iconSize, iconColor, isLoading),
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
    ColorScheme colorScheme,
    bool isLoading,
    WidgetRef ref,
  ) {
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
          onTap: isLoading || onPressed == null ? null : onPressed,
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.paddingS),
            child: _buildContent(iconSize, iconColor, isLoading),
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
    bool isLoading,
    WidgetRef ref,
  ) {
    return SizedBox(
      width: buttonSize,
      height: buttonSize,
      child: IconButton(
        onPressed: isLoading || onPressed == null ? null : onPressed,
        icon: _buildContent(iconSize, iconColor, isLoading),
        tooltip: tooltip,
      ),
    );
  }

  Widget _buildContent(double iconSize, Color iconColor, bool isLoading) {
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
        return AppDimens.iconL;
      case SlIconButtonSize.medium:
        return AppDimens.iconXL;
      case SlIconButtonSize.large:
        return AppDimens.iconXXL;
    }
  }

  double _getIconSize() {
    switch (size) {
      case SlIconButtonSize.small:
        return AppDimens.iconS;
      case SlIconButtonSize.medium:
        return AppDimens.iconM;
      case SlIconButtonSize.large:
        return AppDimens.iconL;
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
