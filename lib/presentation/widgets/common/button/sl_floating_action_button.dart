// lib/presentation/widgets/common/button/sl_floating_action_button.dart
import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

enum SlFabSize { small, regular, large, extended }

class SlFloatingActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String? label;
  final SlFabSize size;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool isLoading;

  const SlFloatingActionButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.label,
    this.size = SlFabSize.regular,
    this.backgroundColor,
    this.foregroundColor,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveBackgroundColor = backgroundColor ?? colorScheme.primary;
    final effectiveForegroundColor = foregroundColor ?? colorScheme.onPrimary;

    // For extended FAB
    if (size == SlFabSize.extended && label != null) {
      return FloatingActionButton.extended(
        onPressed: isLoading ? null : onPressed,
        label: Text(label!),
        icon: isLoading
            ? SizedBox(
                width: AppDimens.iconS,
                height: AppDimens.iconS,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    effectiveForegroundColor,
                  ),
                ),
              )
            : Icon(icon),
        backgroundColor: effectiveBackgroundColor,
        foregroundColor: effectiveForegroundColor,
      );
    }

    // For small, regular, and large FABs
    final Widget content = isLoading
        ? SizedBox(
            width: _getLoadingSize(),
            height: _getLoadingSize(),
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              valueColor: AlwaysStoppedAnimation<Color>(
                effectiveForegroundColor,
              ),
            ),
          )
        : Icon(icon, size: _getIconSize());

    switch (size) {
      case SlFabSize.small:
        return FloatingActionButton.small(
          onPressed: isLoading ? null : onPressed,
          backgroundColor: effectiveBackgroundColor,
          foregroundColor: effectiveForegroundColor,
          child: content,
        );
      case SlFabSize.regular:
        return FloatingActionButton(
          onPressed: isLoading ? null : onPressed,
          backgroundColor: effectiveBackgroundColor,
          foregroundColor: effectiveForegroundColor,
          child: content,
        );
      case SlFabSize.large:
        return FloatingActionButton.large(
          onPressed: isLoading ? null : onPressed,
          backgroundColor: effectiveBackgroundColor,
          foregroundColor: effectiveForegroundColor,
          child: content,
        );
      case SlFabSize.extended:
        // Fallback for extended FAB without a label
        return FloatingActionButton(
          onPressed: isLoading ? null : onPressed,
          backgroundColor: effectiveBackgroundColor,
          foregroundColor: effectiveForegroundColor,
          child: content,
        );
    }
  }

  double _getIconSize() {
    switch (size) {
      case SlFabSize.small:
        return AppDimens.iconM; // 20.0
      case SlFabSize.regular:
      case SlFabSize.extended:
        return AppDimens.iconL; // 24.0
      case SlFabSize.large:
        return AppDimens.iconXL; // 32.0
    }
  }

  double _getLoadingSize() {
    switch (size) {
      case SlFabSize.small:
        return AppDimens.iconXS; // 12.0
      case SlFabSize.regular:
      case SlFabSize.extended:
        return AppDimens.iconS; // 16.0
      case SlFabSize.large:
        return AppDimens.iconM; // 20.0
    }
  }
}
