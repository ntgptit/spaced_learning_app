// lib/presentation/widgets/common/dialog/sl_alert_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spaced_learning_app/core/extensions/color_extensions.dart'; // Assuming this contains success/warning/info extensions
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_button.dart'; // Assuming SLButton

enum AlertType { info, success, warning, error }

/// An alert dialog with Material 3 design principles and customizable options.
class SlAlertDialog extends ConsumerWidget {
  final String title;
  final String message;
  final String? buttonText; // Made optional
  final VoidCallback? onButtonPressed; // Made optional
  final IconData? icon;
  final AlertType alertType;
  final bool barrierDismissible;
  final bool autoDismiss;
  final Duration autoDismissDuration;
  final Widget? customContent;
  final List<Widget>? actions; // Allow multiple actions

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

  // Factory constructor for a generic info alert
  factory SlAlertDialog.info({
    required String title,
    required String message,
    String buttonText = 'OK',
    VoidCallback? onButtonPressed,
    bool autoDismiss = false,
  }) {
    return SlAlertDialog(
      title: title,
      message: message,
      buttonText: buttonText,
      onButtonPressed: onButtonPressed,
      alertType: AlertType.info,
      icon: Icons.info_outline_rounded,
      autoDismiss: autoDismiss,
    );
  }

  // Factory constructor for a success alert
  factory SlAlertDialog.success({
    required String title,
    required String message,
    String buttonText = 'Great!',
    VoidCallback? onButtonPressed,
    bool autoDismiss = true, // Success messages often auto-dismiss
    Duration autoDismissDuration = const Duration(seconds: 2),
  }) {
    return SlAlertDialog(
      title: title,
      message: message,
      buttonText: buttonText,
      onButtonPressed: onButtonPressed,
      alertType: AlertType.success,
      icon: Icons.check_circle_outline_rounded,
      autoDismiss: autoDismiss,
      autoDismissDuration: autoDismissDuration,
    );
  }

  // Factory constructor for a warning alert
  factory SlAlertDialog.warning({
    required String title,
    required String message,
    String buttonText = 'Understood',
    VoidCallback? onButtonPressed,
    List<Widget>? actions, // Allow custom actions for warnings
  }) {
    return SlAlertDialog(
      title: title,
      message: message,
      buttonText: actions == null ? buttonText : null,
      // Only use buttonText if no custom actions
      onButtonPressed: actions == null ? onButtonPressed : null,
      alertType: AlertType.warning,
      icon: Icons.warning_amber_rounded,
      actions: actions,
    );
  }

  // Factory constructor for an error alert
  factory SlAlertDialog.error({
    required String title,
    required String message,
    String buttonText = 'Dismiss',
    VoidCallback? onButtonPressed,
  }) {
    return SlAlertDialog(
      title: title,
      message: message,
      buttonText: buttonText,
      onButtonPressed: onButtonPressed,
      alertType: AlertType.error,
      icon: Icons.error_outline_rounded,
    );
  }

  IconData _getAlertIcon() {
    switch (alertType) {
      case AlertType.success:
        return icon ?? Icons.check_circle_outline_rounded;
      case AlertType.warning:
        return icon ?? Icons.warning_amber_rounded;
      case AlertType.error:
        return icon ?? Icons.error_outline_rounded;
      case AlertType.info:
        return icon ?? Icons.info_outline_rounded;
    }
  }

  Color _getAlertColor(ColorScheme colorScheme) {
    switch (alertType) {
      case AlertType.success:
        return colorScheme.success; // From color_extensions
      case AlertType.warning:
        return colorScheme.warning; // From color_extensions
      case AlertType.error:
        return colorScheme.error;
      case AlertType.info:
        return colorScheme.primary;
    }
  }

  Color _getAlertTextColor(ColorScheme colorScheme, Color alertColor) {
    // Ensure good contrast
    return alertColor.computeLuminance() > 0.5
        ? colorScheme.onSurface
        : colorScheme.surface;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (autoDismiss && context.mounted) {
      Future.delayed(autoDismissDuration, () {
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      });
    }

    final Color effectiveAlertColor = _getAlertColor(colorScheme);
    final IconData effectiveIcon = _getAlertIcon();

    List<Widget> dialogActions = actions ?? [];
    if (dialogActions.isEmpty &&
        buttonText != null &&
        onButtonPressed != null) {
      dialogActions.add(
        SLButton(
          text: buttonText!,
          onPressed: onButtonPressed ?? () => Navigator.of(context).pop(),
          type: alertType == AlertType.error || alertType == AlertType.warning
              ? SLButtonType
                    .primary // or a specific SLButtonType for error/warning
              : SLButtonType.primary,
          backgroundColor: effectiveAlertColor,
          textColor: _getAlertTextColor(colorScheme, effectiveAlertColor),
        ),
      );
    }
    if (dialogActions.isEmpty &&
        buttonText != null &&
        onButtonPressed == null) {
      dialogActions.add(
        SLButton(
          text: buttonText!,
          onPressed: () => Navigator.of(context).pop(),
          type: SLButtonType.text, // Default to text if no action
        ),
      );
    }

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusL),
      ),
      backgroundColor: colorScheme.surface,
      surfaceTintColor: colorScheme.surfaceTint,
      // M3 spec
      titlePadding: const EdgeInsets.fromLTRB(
        AppDimens.paddingL,
        AppDimens.paddingL,
        AppDimens.paddingL,
        AppDimens.paddingS,
      ),
      contentPadding: EdgeInsets.fromLTRB(
        AppDimens.paddingL,
        AppDimens.paddingS,
        AppDimens.paddingL,
        (actions == null && buttonText == null)
            ? AppDimens.paddingL
            : AppDimens.paddingS,
      ),
      actionsPadding: const EdgeInsets.all(AppDimens.paddingL),
      icon: Container(
        padding: const EdgeInsets.all(AppDimens.paddingXS),
        decoration: BoxDecoration(
          color: effectiveAlertColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          effectiveIcon,
          color: effectiveAlertColor,
          size: AppDimens.iconL,
        ),
      ),
      iconPadding: const EdgeInsets.only(
        top: AppDimens.paddingL,
        bottom: AppDimens.paddingS,
      ),
      title: Text(
        title,
        style: theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
        textAlign: TextAlign.center,
      ),
      content:
          customContent ??
          Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
      actionsAlignment: MainAxisAlignment.center,
      // Center actions for single button
      actionsOverflowButtonSpacing: AppDimens.spaceS,
      actions: dialogActions.isNotEmpty ? dialogActions : null,
    );
  }

  /// Show the alert dialog
  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    String? buttonText,
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
}
