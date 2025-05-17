// lib/presentation/widgets/common/dialog/sl_alert_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spaced_learning_app/core/extensions/color_extensions.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/presentation/widgets/common/button/sl_primary_button.dart';
import 'package:spaced_learning_app/presentation/widgets/common/button/sl_text_button.dart';
import 'package:spaced_learning_app/presentation/widgets/common/dialog/sl_dialog_button_bar.dart';

enum AlertType { info, success, warning, error }

/// An alert dialog with Material 3 design principles and customizable options.
class SlAlertDialog extends ConsumerWidget {
  final String title;
  final String message;
  final String? confirmButtonText;
  final VoidCallback? onConfirm;
  final IconData? icon;
  final AlertType alertType;
  final bool barrierDismissible;
  final bool autoDismiss;
  final Duration autoDismissDuration;
  final Widget? customContent;
  final List<Widget>? customActions; // For completely custom actions
  final String? cancelButtonText; // Added for two-button scenarios
  final VoidCallback? onCancel; // Added for two-button scenarios

  const SlAlertDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmButtonText,
    this.onConfirm,
    this.icon,
    this.alertType = AlertType.info,
    this.barrierDismissible = true,
    this.autoDismiss = false,
    this.autoDismissDuration = const Duration(seconds: 3),
    this.customContent,
    this.customActions,
    this.cancelButtonText,
    this.onCancel,
  });

  // Factory constructor for a generic info alert
  factory SlAlertDialog.info({
    required String title,
    required String message,
    String confirmButtonText = 'OK',
    VoidCallback? onConfirm,
    bool autoDismiss = false,
  }) {
    return SlAlertDialog(
      title: title,
      message: message,
      confirmButtonText: confirmButtonText,
      onConfirm: onConfirm,
      alertType: AlertType.info,
      icon: Icons.info_outline_rounded,
      autoDismiss: autoDismiss,
    );
  }

  // Factory constructor for a success alert
  factory SlAlertDialog.success({
    required String title,
    required String message,
    String confirmButtonText = 'Great!',
    VoidCallback? onConfirm,
    bool autoDismiss = true,
    Duration autoDismissDuration = const Duration(seconds: 2),
  }) {
    return SlAlertDialog(
      title: title,
      message: message,
      confirmButtonText: confirmButtonText,
      onConfirm: onConfirm,
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
    String confirmButtonText = 'Understood',
    VoidCallback? onConfirm,
    String? cancelButtonText = 'Cancel',
    VoidCallback? onCancel,
    List<Widget>? customActions,
  }) {
    return SlAlertDialog(
      title: title,
      message: message,
      confirmButtonText: customActions == null ? confirmButtonText : null,
      onConfirm: customActions == null ? onConfirm : null,
      cancelButtonText: customActions == null ? cancelButtonText : null,
      onCancel: customActions == null ? onCancel : null,
      alertType: AlertType.warning,
      icon: Icons.warning_amber_rounded,
      customActions: customActions,
    );
  }

  // Factory constructor for an error alert
  factory SlAlertDialog.error({
    required String title,
    required String message,
    String confirmButtonText = 'Dismiss',
    VoidCallback? onConfirm,
  }) {
    return SlAlertDialog(
      title: title,
      message: message,
      confirmButtonText: confirmButtonText,
      onConfirm: onConfirm,
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
        return colorScheme.success;
      case AlertType.warning:
        return colorScheme.warning;
      case AlertType.error:
        return colorScheme.error;
      case AlertType.info:
        return colorScheme.primary;
    }
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

    Widget? confirmActionWidget;
    if (confirmButtonText != null) {
      confirmActionWidget = SlPrimaryButton(
        text: confirmButtonText!,
        onPressed: onConfirm ?? () => Navigator.of(context).pop(),
        backgroundColor: effectiveAlertColor,
        foregroundColor: effectiveAlertColor.hasGoodContrastWith(Colors.white)
            ? Colors.white
            : Colors.black,
      );
    }

    Widget? cancelActionWidget;
    if (cancelButtonText != null) {
      cancelActionWidget = SlTextButton(
        text: cancelButtonText!,
        onPressed: onCancel ?? () => Navigator.of(context).pop(false),
      );
    }

    final List<Widget> effectiveActions =
        customActions ??
        [
          if (cancelActionWidget != null) cancelActionWidget,
          if (confirmActionWidget != null) confirmActionWidget,
        ].where((widget) => widget != null).toList().cast<Widget>();

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusL),
      ),
      backgroundColor: colorScheme.surface,
      surfaceTintColor: colorScheme.surfaceTint,
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
        (effectiveActions.isEmpty) ? AppDimens.paddingL : AppDimens.paddingS,
      ),
      actionsPadding: const EdgeInsets.symmetric(
        horizontal: AppDimens.paddingL,
        vertical: AppDimens.paddingM,
      ),
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
      actionsAlignment: MainAxisAlignment.end,
      actionsOverflowButtonSpacing: AppDimens.spaceS,
      actions: effectiveActions.isNotEmpty
          ? [
              SlDialogButtonBar(
                cancelButton: cancelActionWidget,
                confirmButton: confirmActionWidget,
              ),
            ]
          : null,
    );
  }

  /// Show the alert dialog
  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    String? confirmButtonText,
    VoidCallback? onConfirm,
    IconData? icon,
    AlertType alertType = AlertType.info,
    bool barrierDismissible = true,
    bool autoDismiss = false,
    Duration autoDismissDuration = const Duration(seconds: 3),
    Widget? customContent,
    List<Widget>? customActions,
    String? cancelButtonText,
    VoidCallback? onCancel,
  }) {
    // Determine default button text if not provided for custom actions
    String effectiveConfirmButtonText = confirmButtonText ?? 'OK';
    if (customActions == null &&
        onConfirm == null &&
        confirmButtonText == null) {
      effectiveConfirmButtonText = 'OK';
    }

    return showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return SlAlertDialog(
          title: title,
          message: message,
          confirmButtonText: effectiveConfirmButtonText,
          onConfirm: onConfirm,
          icon: icon,
          alertType: alertType,
          autoDismiss: autoDismiss,
          autoDismissDuration: autoDismissDuration,
          customContent: customContent,
          customActions: customActions,
          cancelButtonText: cancelButtonText,
          onCancel: onCancel,
        );
      },
    );
  }
}
