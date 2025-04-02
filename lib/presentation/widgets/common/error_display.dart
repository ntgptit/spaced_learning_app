import 'package:flutter/material.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_button.dart';

/// Widget to display error messages with optional retry action
class ErrorDisplay extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final IconData? icon;
  final bool compact;

  const ErrorDisplay({
    super.key,
    required this.message,
    this.onRetry,
    this.icon,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return compact ? _buildCompactView(theme) : _buildFullView(theme);
  }

  /// Builds a compact version of the error display
  Widget _buildCompactView(ThemeData theme) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            _buildErrorIcon(theme, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Text(message, style: theme.textTheme.bodyMedium)),
            if (onRetry != null)
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: AppButton(
                  text: 'Retry',
                  type: AppButtonType.text,
                  onPressed: onRetry,
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Builds a full-screen version of the error display
  Widget _buildFullView(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildErrorIcon(theme, size: 48),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium,
            ),
            if (onRetry != null)
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: AppButton(
                  text: 'Try Again',
                  type: AppButtonType.outline,
                  prefixIcon: Icons.refresh,
                  onPressed: onRetry,
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Builds the error icon with consistent styling
  Widget _buildErrorIcon(ThemeData theme, {required double size}) {
    return Icon(
      icon ?? Icons.error_outline,
      color: theme.colorScheme.error,
      size: size,
    );
  }
}

/// Base class for snackbar helpers
abstract class _SnackbarHelper {
  static void _showSnackBar({
    required BuildContext context,
    required String message,
    required Color backgroundColor,
    required IconData icon,
    Color? iconColor,
    Color? textColor,
    Duration? duration,
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: iconColor ?? Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: textColor ?? Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        duration: duration ?? const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        action: action,
      ),
    );
  }
}

/// Snackbar helper for showing error messages
class ErrorSnackbar {
  static void show(BuildContext context, String message, {Duration? duration}) {
    final theme = Theme.of(context);
    _SnackbarHelper._showSnackBar(
      context: context,
      message: message,
      backgroundColor: theme.colorScheme.error,
      icon: Icons.error_outline,
      iconColor: theme.colorScheme.onError,
      textColor: theme.colorScheme.onError,
      duration: duration ?? const Duration(seconds: 4),
      action: SnackBarAction(
        label: 'Dismiss',
        textColor: theme.colorScheme.onError,
        onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
      ),
    );
  }
}

/// Snackbar helper for showing success messages
class SuccessSnackbar {
  static void show(BuildContext context, String message, {Duration? duration}) {
    final theme = Theme.of(context);
    final backgroundColor =
        theme.brightness == Brightness.dark
            ? Colors.green.shade700
            : Colors.green.shade600;

    _SnackbarHelper._showSnackBar(
      context: context,
      message: message,
      backgroundColor: backgroundColor,
      icon: Icons.check_circle,
    );
  }
}
