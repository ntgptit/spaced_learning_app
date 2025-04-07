import 'package:flutter/material.dart';
// Removed direct AppColors import as colors should come from the theme
// import 'package:spaced_learning_app/core/theme/app_colors.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_button.dart'; // Assuming AppButton uses theme

/// Widget to display error messages with optional retry action
class ErrorDisplay extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final IconData? icon;
  final bool compact;
  // Removed direct color parameters, styling should primarily come from theme
  // final Color? backgroundColor;
  // final Color? textColor;
  final ThemeData? theme; // Optional theme override

  const ErrorDisplay({
    super.key,
    required this.message,
    this.onRetry,
    this.icon,
    this.compact = false,
    // this.backgroundColor,
    // this.textColor,
    this.theme, // Added optional theme parameter
  });

  @override
  Widget build(BuildContext context) {
    // Use passed theme or get from context
    final currentTheme = theme ?? Theme.of(context);
    return compact
        ? _buildCompactView(currentTheme)
        : _buildFullView(currentTheme);
  }

  /// Builds a compact version of the error display using Theme data
  Widget _buildCompactView(ThemeData theme) {
    return Card(
      // Use theme's error container color for background
      color: theme.colorScheme.errorContainer,
      // Card theme margin is applied automatically, override if needed
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimens.paddingL,
        vertical: AppDimens.paddingS,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingM),
        child: Row(
          children: [
            // Use theme's error color for icon
            _buildErrorIcon(theme, size: AppDimens.iconM),
            const SizedBox(width: AppDimens.spaceM),
            Expanded(
              child: Text(
                message,
                // Use theme text style and onErrorContainer color
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onErrorContainer,
                ),
              ),
            ),
            if (onRetry != null)
              Padding(
                padding: const EdgeInsets.only(left: AppDimens.paddingM),
                // AppButton should ideally use theme internally for styling
                child: AppButton(
                  text: 'Retry',
                  type:
                      AppButtonType
                          .text, // Text buttons use theme's textButtonTheme
                  onPressed: onRetry,
                  // Text color could be theme.colorScheme.primary or theme.colorScheme.error
                  // depending on desired emphasis. Let AppButton decide or pass explicitly.
                  // textColor: theme.colorScheme.primary,
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Builds a full-screen version of the error display using Theme data
  Widget _buildFullView(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingXL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Use theme's error color for icon
            _buildErrorIcon(theme, size: AppDimens.iconXXL),
            const SizedBox(height: AppDimens.spaceL),
            Text(
              message,
              textAlign: TextAlign.center,
              // Use theme text style and onError or onSurface color
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(
                  0.85,
                ), // Example color
              ),
            ),
            if (onRetry != null)
              Padding(
                padding: const EdgeInsets.only(top: AppDimens.paddingXL),
                // AppButton should use theme internally
                child: AppButton(
                  text: 'Try Again',
                  type:
                      AppButtonType
                          .outline, // Outline buttons use theme's outlinedButtonTheme
                  prefixIcon: Icons.refresh,
                  onPressed: onRetry,
                  // Let AppButton derive colors from theme, or pass explicitly if needed
                  // textColor: theme.colorScheme.primary,
                  // borderColor: theme.colorScheme.outline,
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Builds the error icon using Theme's error color
  Widget _buildErrorIcon(ThemeData theme, {required double size}) {
    return Icon(
      icon ?? Icons.error_outline,
      // Use theme's error color
      color: theme.colorScheme.error,
      size: size,
    );
  }
}

// --- Snackbar Helpers using Theme ---

/// Base class for snackbar helpers utilizing Theme
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
    // Use contentTextStyle from theme if available, otherwise fallback
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
                  // Use theme's action color or override
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

/// Snackbar helper for showing error messages using Theme colors
class ErrorSnackbar {
  static void show(BuildContext context, String message, {Duration? duration}) {
    _SnackbarHelper._showSnackBar(
      context: context,
      message: message,
      icon: Icons.error_outline,
      // Use theme's error colors
      backgroundColorBuilder: (theme) => theme.colorScheme.errorContainer,
      contentColorBuilder: (theme) => theme.colorScheme.onErrorContainer,
      duration: duration,
      action: SnackBarAction(
        label: 'Dismiss',
        // Let helper derive color from theme or pass onErrorContainer
        // textColor: Theme.of(context).colorScheme.onErrorContainer,
        onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
      ),
      // Explicitly set action color if needed, otherwise theme default is used by helper
      // actionColor: Theme.of(context).colorScheme.onErrorContainer
    );
  }
}

/// Snackbar helper for showing success messages using Theme colors (or custom mapping)
class SuccessSnackbar {
  // Define how success colors are derived from the theme
  static Color _getSuccessBackgroundColor(ThemeData theme) {
    // Example: Use primary container or map specific colors
    // return theme.colorScheme.primaryContainer;
    return theme.brightness == Brightness.light
        ? const Color(0xFFE8F5E9)
        : const Color(0xFF2E7D32); // Example direct map
  }

  static Color _getSuccessContentColor(ThemeData theme) {
    // Example: Use onPrimaryContainer or map specific colors
    // return theme.colorScheme.onPrimaryContainer;
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
      // Action can be added similarly if needed
    );
  }
}
