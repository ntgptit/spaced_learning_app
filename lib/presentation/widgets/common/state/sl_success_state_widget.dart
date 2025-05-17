// lib/presentation/widgets/common/states/sl_success_state_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spaced_learning_app/core/extensions/color_extensions.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

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
  final bool showConfetti;
  final IconData icon;

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
    this.showConfetti = false,
    this.icon = Icons.check_circle_outline,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (compactMode) {
      return _buildCompactSuccess(theme, colorScheme);
    }

    // Handle auto-hide if duration is set
    if (autoHideDuration != null) {
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
                  color: colorScheme.success.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: AppDimens.iconXL,
                  color: colorScheme.success,
                ),
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
            ElevatedButton(
              onPressed: onPrimaryButtonPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.success,
                foregroundColor: colorScheme.onSuccess,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.paddingXXL,
                  vertical: AppDimens.paddingM,
                ),
                elevation: AppDimens.elevationS,
              ),
              child: Text(primaryButtonText),
            ),
            if (secondaryButtonText != null &&
                onSecondaryButtonPressed != null) ...[
              const SizedBox(height: AppDimens.spaceM),
              TextButton(
                onPressed: onSecondaryButtonPressed,
                child: Text(secondaryButtonText!),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCompactSuccess(ThemeData theme, ColorScheme colorScheme) {
    return Card(
      color: colorScheme.success.withValues(alpha: 0.08),
      elevation: 0,
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimens.paddingL,
        vertical: AppDimens.paddingS,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
        side: BorderSide(color: colorScheme.success.withValues(alpha: 0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingM),
        child: Row(
          children: [
            Icon(icon, color: colorScheme.success, size: AppDimens.iconM),
            const SizedBox(width: AppDimens.spaceM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: colorScheme.success,
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
            TextButton(
              onPressed: onPrimaryButtonPressed,
              style: TextButton.styleFrom(
                foregroundColor: colorScheme.success,
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

  // Factory constructors
  factory SlSuccessStateWidget.actionComplete({
    required String action,
    required VoidCallback onContinue,
    String? continueButtonText,
  }) {
    return SlSuccessStateWidget(
      title: 'Success!',
      message: '$action completed successfully.',
      primaryButtonText: continueButtonText ?? 'Continue',
      onPrimaryButtonPressed: onContinue,
      autoHideDuration: const Duration(seconds: 2),
    );
  }

  factory SlSuccessStateWidget.saved({
    required VoidCallback onContinue,
    String? message,
  }) {
    return SlSuccessStateWidget(
      title: 'Saved Successfully',
      message: message ?? 'Your changes have been saved.',
      primaryButtonText: 'Continue',
      onPrimaryButtonPressed: onContinue,
      icon: Icons.save,
    );
  }

  factory SlSuccessStateWidget.notification({
    required String title,
    required String message,
    required VoidCallback onDismiss,
    Duration? autoDismiss,
  }) {
    return SlSuccessStateWidget(
      title: title,
      message: message,
      primaryButtonText: 'Dismiss',
      onPrimaryButtonPressed: onDismiss,
      compactMode: true,
      autoHideDuration: autoDismiss,
    );
  }
}
