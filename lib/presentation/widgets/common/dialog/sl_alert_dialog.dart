// lib/presentation/widgets/common/dialog/sl_alert_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spaced_learning_app/core/extensions/color_extensions.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

/// An alert dialog with Material 3 design principles and customizable options.
class SlAlertDialog extends ConsumerWidget {
  final String title;
  final String message;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  final IconData? icon;
  final AlertType alertType;
  final bool barrierDismissible;
  final bool autoDismiss;
  final Duration autoDismissDuration;
  final Widget? customContent;
  final List<Widget>? actions;

  const SlAlertDialog({
    super.key,
    required this.title,
    required this.message,
    this.buttonText,
    this.onButtonPressed,
    this.icon,
    this.alertType = AlertType.info,
    this.barrierDismissible = true,
    this.autoDismiss = false,
    this.autoDismissDuration = const Duration(seconds: 3),
    this.customContent,
    this.actions,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Setup auto-dismissal if needed
    if (autoDismiss && context.mounted) {
      Future.delayed(autoDismissDuration, () {
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      });
    }

    // Get the alert color based on type
    final Color alertColor = _getAlertColor(colorScheme);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusL),
      ),
      backgroundColor: colorScheme.surface,
      title: Row(
        children: [
          if (icon != null || alertType != AlertType.info) ...[
            Icon(
              icon ?? _getAlertIcon(),
              color: alertColor,
              size: AppDimens.iconL,
            ),
            const SizedBox(width: AppDimens.spaceM),
          ],
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: alertType != AlertType.info ? alertColor : null,
              ),
            ),
          ),
        ],
      ),
      content: customContent ?? Text(message, style: theme.textTheme.bodyLarge),
      actions:
          actions ??
          [
            if (buttonText != null)
              FilledButton(
                onPressed: onButtonPressed ?? () => Navigator.of(context).pop(),
                style: FilledButton.styleFrom(
                  backgroundColor: alertColor,
                  foregroundColor: _getAlertTextColor(colorScheme),
                ),
                child: Text(buttonText!),
              ),
          ],
      actionsPadding: const EdgeInsets.all(AppDimens.paddingL),
    );
  }

  /// Gets the appropriate icon for the alert type
  IconData _getAlertIcon() {
    switch (alertType) {
      case AlertType.success:
        return Icons.check_circle_outline;
      case AlertType.warning:
        return Icons.warning_amber_outlined;
      case AlertType.error:
        return Icons.error_outline;
      case AlertType.info:
        return Icons.info_outline;
    }
  }

  /// Gets the appropriate color for the alert type
  Color _getAlertColor(ColorScheme colorScheme) {
    switch (alertType) {
      case AlertType.success:
        return colorScheme.success;
      case AlertType.warning:
        return colorScheme.warning;
      case AlertType.error:
        return colorScheme.error;
      case AlertType.info:
        return colorScheme.primary;
    }
  }

  /// Gets the appropriate text color for the alert type
  Color _getAlertTextColor(ColorScheme colorScheme) {
    switch (alertType) {
      case AlertType.success:
        return colorScheme.onSuccess;
      case AlertType.warning:
        return colorScheme.onWarning;
      case AlertType.error:
        return colorScheme.onError;
      case AlertType.info:
        return colorScheme.onPrimary;
    }
  }

  /// Show the alert dialog
  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    String? buttonText = 'OK',
    VoidCallback? onButtonPressed,
    IconData? icon,
    AlertType alertType = AlertType.info,
    bool barrierDismissible = true,
    bool autoDismiss = false,
    Duration autoDismissDuration = const Duration(seconds: 3),
    Widget? customContent,
    List<Widget>? actions,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.black54,
      builder: (BuildContext context) {
        return SlAlertDialog(
          title: title,
          message: message,
          buttonText: buttonText,
          onButtonPressed: onButtonPressed,
          icon: icon,
          alertType: alertType,
          autoDismiss: autoDismiss,
          autoDismissDuration: autoDismissDuration,
          customContent: customContent,
          actions: actions,
        );
      },
    );
  }

  /// Convenience method to show a success alert
  static Future<void> showSuccess(
    BuildContext context, {
    required String title,
    required String message,
    String? buttonText = 'OK',
    VoidCallback? onButtonPressed,
    bool autoDismiss = false,
  }) {
    return show(
      context,
      title: title,
      message: message,
      buttonText: buttonText,
      onButtonPressed: onButtonPressed,
      alertType: AlertType.success,
      autoDismiss: autoDismiss,
    );
  }

  /// Convenience method to show an error alert
  static Future<void> showError(
    BuildContext context, {
    required String title,
    required String message,
    String? buttonText = 'OK',
    VoidCallback? onButtonPressed,
  }) {
    return show(
      context,
      title: title,
      message: message,
      buttonText: buttonText,
      onButtonPressed: onButtonPressed,
      alertType: AlertType.error,
    );
  }

  /// Convenience method to show a warning alert
  static Future<void> showWarning(
    BuildContext context, {
    required String title,
    required String message,
    String? buttonText = 'OK',
    VoidCallback? onButtonPressed,
  }) {
    return show(
      context,
      title: title,
      message: message,
      buttonText: buttonText,
      onButtonPressed: onButtonPressed,
      alertType: AlertType.warning,
    );
  }

  /// Convenience method to show an info alert
  static Future<void> showInfo(
    BuildContext context, {
    required String title,
    required String message,
    String? buttonText = 'OK',
    VoidCallback? onButtonPressed,
    bool autoDismiss = false,
  }) {
    return show(
      context,
      title: title,
      message: message,
      buttonText: buttonText,
      onButtonPressed: onButtonPressed,
      alertType: AlertType.info,
      autoDismiss: autoDismiss,
    );
  }
}

/// Types of alerts to display with appropriate styling
enum AlertType { info, success, warning, error }
