import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_button.dart'; // Assuming AppButton uses theme

class ErrorDisplay extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final IconData? icon;
  final bool compact;
  final ThemeData? theme; // Optional theme override

  const ErrorDisplay({
    super.key,
    required this.message,
    this.onRetry,
    this.icon,
    this.compact = false,
    this.theme, // Added optional theme parameter
  });

  @override
  Widget build(BuildContext context) {
    final currentTheme = theme ?? Theme.of(context);
    return compact
        ? _buildCompactView(currentTheme)
        : _buildFullView(currentTheme);
  }

  Widget _buildCompactView(ThemeData theme) {
    return Card(
      color: theme.colorScheme.errorContainer,
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimens.paddingL,
        vertical: AppDimens.paddingS,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingM),
        child: Row(
          children: [
            _buildErrorIcon(theme, size: AppDimens.iconM),
            const SizedBox(width: AppDimens.spaceM),
            Expanded(
              child: Text(
                message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onErrorContainer,
                ),
              ),
            ),
            if (onRetry != null)
              Padding(
                padding: const EdgeInsets.only(left: AppDimens.paddingM),
                child: AppButton(
                  text: 'Retry',
                  type:
                      AppButtonType
                          .text, // Text buttons use theme's textButtonTheme
                  onPressed: onRetry,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFullView(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingXL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildErrorIcon(theme, size: AppDimens.iconXXL),
            const SizedBox(height: AppDimens.spaceL),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(
                  alpha: 0.85,
                ), // Example color
              ),
            ),
            if (onRetry != null)
              Padding(
                padding: const EdgeInsets.only(top: AppDimens.paddingXL),
                child: AppButton(
                  text: 'Try Again',
                  type:
                      AppButtonType
                          .outline, // Outline buttons use theme's outlinedButtonTheme
                  prefixIcon: Icons.refresh,
                  onPressed: onRetry,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorIcon(ThemeData theme, {required double size}) {
    return Icon(
      icon ?? Icons.error_outline,
      color: theme.colorScheme.error,
      size: size,
    );
  }
}


abstract class _SnackbarHelper {
  static void _showSnackBar({
    required BuildContext context,
    required String message,
    required IconData icon,
    required Color Function(ThemeData) backgroundColorBuilder,
    required Color Function(ThemeData) contentColorBuilder, // For icon and text
    Duration? duration,
    SnackBarAction? action,
    Color? actionColor, // Optional override for action color
  }) {
    final theme = Theme.of(context);
    final snackBarTheme = theme.snackBarTheme;

    final effectiveBackgroundColor = backgroundColorBuilder(theme);
    final effectiveContentColor = contentColorBuilder(theme);
    final effectiveTextStyle =
        snackBarTheme.contentTextStyle ??
        theme.textTheme.bodyMedium?.copyWith(color: effectiveContentColor);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              icon,
              color: effectiveContentColor, // Use derived content color
              size: AppDimens.iconM,
            ),
            const SizedBox(width: AppDimens.spaceM),
            Expanded(
              child: Text(
                message,
                style: effectiveTextStyle, // Use theme's or derived text style
              ),
            ),
          ],
        ),
        backgroundColor:
            effectiveBackgroundColor, // Use derived background color
        duration: duration ?? const Duration(seconds: 4), // Default duration
        behavior:
            snackBarTheme.behavior ??
            SnackBarBehavior.floating, // Use theme behavior
        shape: snackBarTheme.shape, // Use theme shape
        action:
            action != null
                ? SnackBarAction(
                  label: action.label,
                  onPressed: action.onPressed,
                  textColor:
                      actionColor ??
                      snackBarTheme.actionTextColor ??
                      theme.colorScheme.primary,
                )
                : null,
      ),
    );
  }
}

class ErrorSnackbar {
  static void show(BuildContext context, String message, {Duration? duration}) {
    _SnackbarHelper._showSnackBar(
      context: context,
      message: message,
      icon: Icons.error_outline,
      backgroundColorBuilder: (theme) => theme.colorScheme.errorContainer,
      contentColorBuilder: (theme) => theme.colorScheme.onErrorContainer,
      duration: duration,
      action: SnackBarAction(
        label: 'Dismiss',
        onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
      ),
    );
  }
}

class SuccessSnackbar {
  static Color _getSuccessBackgroundColor(ThemeData theme) {
    return theme.brightness == Brightness.light
        ? const Color(0xFFE8F5E9)
        : const Color(0xFF2E7D32); // Example direct map
  }

  static Color _getSuccessContentColor(ThemeData theme) {
    return theme.brightness == Brightness.light
        ? const Color(0xFF1B5E20)
        : const Color(0xFFC8E6C9); // Example direct map
  }

  static void show(BuildContext context, String message, {Duration? duration}) {
    _SnackbarHelper._showSnackBar(
      context: context,
      message: message,
      icon: Icons.check_circle,
      backgroundColorBuilder: _getSuccessBackgroundColor,
      contentColorBuilder: _getSuccessContentColor,
      duration: duration,
    );
  }
}
