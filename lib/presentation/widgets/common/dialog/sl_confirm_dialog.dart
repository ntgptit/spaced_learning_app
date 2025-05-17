// lib/presentation/widgets/common/dialog/sl_confirm_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/presentation/widgets/common/button/sl_button.dart';

/// A confirmation dialog with customizable title, content, and action buttons.
class SlConfirmDialog extends ConsumerWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool isDanger;
  final bool barrierDismissible;
  final IconData? icon;
  final Color? iconColor;
  final Color? confirmButtonColor;
  final Color? cancelButtonColor;

  const SlConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.onConfirm,
    this.onCancel,
    this.isDanger = false,
    this.barrierDismissible = true,
    this.icon,
    this.iconColor,
    this.confirmButtonColor,
    this.cancelButtonColor,
  });

  // Factory constructor for a standard confirmation
  factory SlConfirmDialog.standard({
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    IconData icon = Icons.help_outline_rounded,
  }) {
    return SlConfirmDialog(
      title: title,
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
      onConfirm: onConfirm,
      onCancel: onCancel,
      isDanger: false,
      icon: icon,
    );
  }

  // Factory constructor for a delete confirmation (dangerous action)
  factory SlConfirmDialog.delete({
    required String title,
    required String message,
    String confirmText = 'Delete',
    String cancelText = 'Cancel',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return SlConfirmDialog(
      title: title,
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
      onConfirm: onConfirm,
      onCancel: onCancel,
      isDanger: true,
      icon: Icons.delete_outline_rounded,
    );
  }

  // Factory constructor for a warning confirmation
  factory SlConfirmDialog.warning({
    required String title,
    required String message,
    String confirmText = 'Continue',
    String cancelText = 'Cancel',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return SlConfirmDialog(
      title: title,
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
      onConfirm: onConfirm,
      onCancel: onCancel,
      isDanger: false,
      icon: Icons.warning_amber_rounded,
      iconColor: Colors.orange,
      confirmButtonColor: Colors.orange,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveIconColor =
        iconColor ?? (isDanger ? colorScheme.error : colorScheme.primary);
    final effectiveConfirmButtonColor =
        confirmButtonColor ??
        (isDanger ? colorScheme.error : colorScheme.primary);
    final effectiveConfirmButtonTextColor =
        effectiveConfirmButtonColor.computeLuminance() > 0.5
        ? colorScheme.onSurface
        : colorScheme.surface;
    final effectiveCancelButtonColor =
        cancelButtonColor ?? colorScheme.onSurfaceVariant;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusL),
      ),
      backgroundColor: colorScheme.surfaceContainerLowest,
      surfaceTintColor: colorScheme.surfaceTint,
      iconPadding: const EdgeInsets.only(
        top: AppDimens.paddingL,
        bottom: AppDimens.paddingS,
      ),
      icon: icon != null
          ? Icon(icon, color: effectiveIconColor, size: AppDimens.iconL)
          : null,
      titlePadding: const EdgeInsets.fromLTRB(
        AppDimens.paddingL,
        AppDimens.paddingM,
        AppDimens.paddingL,
        AppDimens.paddingS,
      ),
      contentPadding: const EdgeInsets.fromLTRB(
        AppDimens.paddingL,
        AppDimens.paddingS,
        AppDimens.paddingL,
        AppDimens.paddingL,
      ),
      actionsPadding: const EdgeInsets.all(AppDimens.paddingL),
      actionsAlignment: MainAxisAlignment.end,
      title: Text(
        title,
        style: theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: isDanger ? colorScheme.error : colorScheme.onSurface,
        ),
        textAlign: icon != null ? TextAlign.center : TextAlign.start,
      ),
      content: Text(
        message,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        textAlign: icon != null ? TextAlign.center : TextAlign.start,
      ),
      actions: [
        SlButton(
          text: cancelText,
          onPressed: () {
            if (onCancel != null) {
              onCancel!();
              return;
            }
            Navigator.of(context).pop(false);
          },
          variant: SlButtonVariant.text,
          foregroundColor: effectiveCancelButtonColor,
        ),
        SlButton(
          text: confirmText,
          onPressed: () {
            if (onConfirm != null) {
              onConfirm!();
              return;
            }
            Navigator.of(context).pop(true);
          },
          variant: isDanger ? SlButtonVariant.filled : SlButtonVariant.filled,
          backgroundColor: effectiveConfirmButtonColor,
          foregroundColor: effectiveConfirmButtonTextColor,
        ),
      ],
    );
  }

  /// Show the confirmation dialog with the given parameters
  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool isDanger = false,
    bool barrierDismissible = true,
    IconData? icon,
    Color? iconColor,
    Color? confirmButtonColor,
    Color? cancelButtonColor,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => SlConfirmDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        onCancel: onCancel,
        isDanger: isDanger,
        barrierDismissible: barrierDismissible,
        icon: icon,
        iconColor: iconColor,
        confirmButtonColor: confirmButtonColor,
        cancelButtonColor: cancelButtonColor,
      ),
    );
  }
}
