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

    if (compact) {
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(
                icon ?? Icons.error_outline,
                color: theme.colorScheme.error,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(child: Text(message, style: theme.textTheme.bodyMedium)),
              if (onRetry != null) ...[
                const SizedBox(width: 10),
                AppButton(
                  text: 'Retry',
                  type: AppButtonType.text,
                  onPressed: onRetry,
                ),
              ],
            ],
          ),
        ),
      );
    }

    // Full version
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon ?? Icons.error_outline,
              color: theme.colorScheme.error,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              AppButton(
                text: 'Try Again',
                type: AppButtonType.outline,
                onPressed: onRetry,
                prefixIcon:
                    Icons.refresh, // Changed from 'icon' to 'prefixIcon'
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Snackbar helper for showing error messages
class ErrorSnackbar {
  static void show(BuildContext context, String message, {Duration? duration}) {
    final theme = Theme.of(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: theme.colorScheme.onError,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: theme.colorScheme.onError),
              ),
            ),
          ],
        ),
        backgroundColor: theme.colorScheme.error,
        duration: duration ?? const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: theme.colorScheme.onError,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
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

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(message, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        duration: duration ?? const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
