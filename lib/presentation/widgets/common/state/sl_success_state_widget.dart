// lib/presentation/widgets/common/state/sl_success_state_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/presentation/widgets/common/button/sl_button.dart';

class SlSuccessStateWidget extends ConsumerWidget {
  final String title;
  final String? message;
  final String primaryButtonText;
  final VoidCallback onPrimaryButtonPressed;
  final String? secondaryButtonText;
  final VoidCallback? onSecondaryButtonPressed;
  final bool showIcon;
  final bool compactMode;
  final Duration? autoHideDuration;
  final IconData icon;
  final Color? accentColor;

  const SlSuccessStateWidget({
    super.key,
    required this.title,
    this.message,
    required this.primaryButtonText,
    required this.onPrimaryButtonPressed,
    this.secondaryButtonText,
    this.onSecondaryButtonPressed,
    this.showIcon = true,
    this.compactMode = false,
    this.autoHideDuration,
    this.icon = Icons.check_circle_outline_rounded,
    this.accentColor,
  });

  // Factory constructor for generic action completion
  factory SlSuccessStateWidget.actionComplete({
    required String actionName,
    required VoidCallback onContinue,
    String? continueButtonText = 'Continue',
    String? successMessage,
    Duration? autoHideDuration = const Duration(seconds: 3),
  }) {
    return SlSuccessStateWidget(
      title: '$actionName Successful!',
      message:
          successMessage ??
          'The $actionName operation was completed successfully.',
      primaryButtonText: continueButtonText!,
      onPrimaryButtonPressed: onContinue,
      autoHideDuration: autoHideDuration,
      icon: Icons.task_alt_rounded,
    );
  }

  // Continuing sl_success_state_widget.dart
  // Factory constructor for data saved successfully
  factory SlSuccessStateWidget.saved({
    required VoidCallback onContinue,
    String title = 'Saved Successfully',
    String? message,
    String continueButtonText = 'OK',
  }) {
    return SlSuccessStateWidget(
      title: title,
      message: message ?? 'Your changes have been saved.',
      primaryButtonText: continueButtonText,
      onPrimaryButtonPressed: onContinue,
      icon: Icons.save_alt_rounded,
      accentColor: Colors.green.shade700,
    );
  }

  // Factory constructor for a compact notification-style success message
  factory SlSuccessStateWidget.notification({
    required String title,
    String? message,
    required VoidCallback onDismiss,
    Duration? autoDismissDuration = const Duration(seconds: 4),
    IconData icon = Icons.notifications_active_outlined,
  }) {
    return SlSuccessStateWidget(
      title: title,
      message: message,
      primaryButtonText: 'Dismiss',
      onPrimaryButtonPressed: onDismiss,
      compactMode: true,
      autoHideDuration: autoDismissDuration,
      icon: icon,
    );
  }

  Color _getContrastColor(Color backgroundColor, ColorScheme colorScheme) {
    return backgroundColor.computeLuminance() > 0.5
        ? colorScheme.onSurface
        : colorScheme.surface;
  }

  Widget _buildFullSuccess(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    Color successColor,
  ) {
    // Handle auto-hide if duration is set
    if (autoHideDuration != null && context.mounted) {
      Future.delayed(autoHideDuration!, () {
        if (context.mounted) {
          onPrimaryButtonPressed();
        }
      });
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showIcon) ...[
              Container(
                width: AppDimens.iconXXL,
                height: AppDimens.iconXXL,
                decoration: BoxDecoration(
                  color: successColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: AppDimens.iconXL, color: successColor),
              ),
              const SizedBox(height: AppDimens.spaceXL),
            ],
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              const SizedBox(height: AppDimens.spaceM),
              Text(
                message!,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: AppDimens.spaceXXL),
            SlButton(
              text: primaryButtonText,
              onPressed: onPrimaryButtonPressed,
              variant: SlButtonVariant.filled,
              backgroundColor: successColor,
              foregroundColor: _getContrastColor(successColor, colorScheme),
            ),
            if (secondaryButtonText != null &&
                onSecondaryButtonPressed != null) ...[
              const SizedBox(height: AppDimens.spaceM),
              SlButton(
                text: secondaryButtonText!,
                onPressed: onSecondaryButtonPressed!,
                variant: SlButtonVariant.text,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCompactSuccess(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    Color successColor,
  ) {
    // Handle auto-hide if duration is set
    if (autoHideDuration != null && context.mounted) {
      Future.delayed(autoHideDuration!, () {
        if (context.mounted) {
          onPrimaryButtonPressed();
        }
      });
    }
    return Card(
      color: successColor.withOpacity(0.08),
      elevation: 0,
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimens.paddingL,
        vertical: AppDimens.paddingS,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
        side: BorderSide(color: successColor.withOpacity(0.4)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingM),
        child: Row(
          children: [
            Icon(icon, color: successColor, size: AppDimens.iconM),
            const SizedBox(width: AppDimens.spaceM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: successColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (message != null) ...[
                    const SizedBox(height: AppDimens.spaceXS),
                    Text(
                      message!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            if (primaryButtonText.isNotEmpty)
              TextButton(
                onPressed: onPrimaryButtonPressed,
                style: TextButton.styleFrom(
                  foregroundColor: successColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.paddingS,
                  ),
                  visualDensity: VisualDensity.compact,
                ),
                child: Text(primaryButtonText),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final successColor = accentColor ?? colorScheme.primary;

    if (compactMode) {
      return _buildCompactSuccess(context, theme, colorScheme, successColor);
    }
    return _buildFullSuccess(context, theme, colorScheme, successColor);
  }
}
