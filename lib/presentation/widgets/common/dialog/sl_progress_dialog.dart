// lib/presentation/widgets/common/dialog/sl_progress_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

/// A dialog that shows a loading indicator with an optional message.
class SlProgressDialog extends ConsumerWidget {
  final String message;
  final bool barrierDismissible;
  final Color? progressColor;
  final Color? backgroundColor;
  final Duration? timeout;
  final VoidCallback? onTimeout;
  final Widget? customProgress;
  final double progressSize;

  const SlProgressDialog({
    super.key,
    this.message = 'Loading...',
    this.barrierDismissible = false,
    this.progressColor,
    this.backgroundColor,
    this.timeout,
    this.onTimeout,
    this.customProgress,
    this.progressSize = AppDimens.circularProgressSize,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Set up timeout callback if specified
    if (timeout != null && onTimeout != null) {
      Future.delayed(timeout!, onTimeout);
    }

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusL),
      ),
      backgroundColor: backgroundColor ?? colorScheme.surface,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          customProgress ??
              SizedBox(
                height: progressSize,
                width: progressSize,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    progressColor ?? colorScheme.primary,
                  ),
                  strokeWidth: 3.0,
                ),
              ),
          if (message.isNotEmpty) ...[
            const SizedBox(height: AppDimens.spaceL),
            Text(
              message,
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
      contentPadding: const EdgeInsets.all(AppDimens.paddingXL),
    );
  }

  /// Show the progress dialog
  static Future<void> show(
    BuildContext context, {
    String message = 'Loading...',
    bool barrierDismissible = false,
    Color? progressColor,
    Color? backgroundColor,
    Duration? timeout,
    VoidCallback? onTimeout,
    Widget? customProgress,
    double progressSize = AppDimens.circularProgressSize,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => SlProgressDialog(
        message: message,
        barrierDismissible: barrierDismissible,
        progressColor: progressColor,
        backgroundColor: backgroundColor,
        timeout: timeout,
        onTimeout: onTimeout,
        customProgress: customProgress,
        progressSize: progressSize,
      ),
    );
  }

  /// Show a progress dialog with auto-dismissal after the specified duration
  static Future<void> showWithTimeout(
    BuildContext context, {
    required String message,
    required Duration duration,
    required VoidCallback onComplete,
    Color? progressColor,
    Color? backgroundColor,
    Widget? customProgress,
  }) {
    return show(
      context,
      message: message,
      barrierDismissible: false,
      progressColor: progressColor,
      backgroundColor: backgroundColor,
      customProgress: customProgress,
      timeout: duration,
      onTimeout: () {
        Navigator.of(context).pop();
        onComplete();
      },
    );
  }

  /// Convenience method to show a progress dialog for data loading
  static Future<void> showLoading(
    BuildContext context, {
    String message = 'Loading data...',
    Color? progressColor,
    bool barrierDismissible = false,
  }) {
    return show(
      context,
      message: message,
      progressColor: progressColor,
      barrierDismissible: barrierDismissible,
    );
  }

  /// Convenience method to show a progress dialog for saving data
  static Future<void> showSaving(
    BuildContext context, {
    String message = 'Saving data...',
    Color? progressColor,
    bool barrierDismissible = false,
  }) {
    return show(
      context,
      message: message,
      progressColor: progressColor ?? Theme.of(context).colorScheme.secondary,
      barrierDismissible: barrierDismissible,
    );
  }

  /// Convenience method to show a progress dialog for processing data
  static Future<void> showProcessing(
    BuildContext context, {
    String message = 'Processing...',
    Color? progressColor,
    bool barrierDismissible = false,
  }) {
    return show(
      context,
      message: message,
      progressColor: progressColor ?? Theme.of(context).colorScheme.tertiary,
      barrierDismissible: barrierDismissible,
    );
  }

  /// Hide the currently displayed progress dialog
  static void hide(BuildContext context) {
    Navigator.of(context).pop();
  }
}
