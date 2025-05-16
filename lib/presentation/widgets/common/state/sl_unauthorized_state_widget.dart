// lib/presentation/widgets/common/states/sl_unauthorized_state_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

class SlUnauthorizedStateWidget extends ConsumerWidget {
  final String title;
  final String message;
  final String primaryButtonText;
  final VoidCallback onPrimaryButtonPressed;
  final String? secondaryButtonText;
  final VoidCallback? onSecondaryButtonPressed;
  final bool showIcon;
  final IconData? customIcon;

  const SlUnauthorizedStateWidget({
    super.key,
    this.title = 'Access Denied',
    this.message = 'You don\'t have permission to access this content.',
    this.primaryButtonText = 'Login',
    required this.onPrimaryButtonPressed,
    this.secondaryButtonText,
    this.onSecondaryButtonPressed,
    this.showIcon = true,
    this.customIcon,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
                  color: colorScheme.errorContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  customIcon ?? Icons.lock_outline,
                  size: AppDimens.iconXL,
                  color: colorScheme.error,
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
            const SizedBox(height: AppDimens.spaceM),
            Text(
              message,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimens.spaceXL),
            ElevatedButton(
              onPressed: onPrimaryButtonPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primaryContainer,
                foregroundColor: colorScheme.onPrimaryContainer,
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

  // Factory constructors
  factory SlUnauthorizedStateWidget.sessionExpired({
    required VoidCallback onLoginAgain,
  }) {
    return SlUnauthorizedStateWidget(
      title: 'Session Expired',
      message: 'Your session has expired. Please log in again to continue.',
      primaryButtonText: 'Login Again',
      onPrimaryButtonPressed: onLoginAgain,
      customIcon: Icons.access_time_filled,
    );
  }

  factory SlUnauthorizedStateWidget.requiresLogin({
    required VoidCallback onLogin,
    VoidCallback? onGoBack,
  }) {
    return SlUnauthorizedStateWidget(
      title: 'Login Required',
      message: 'You need to be logged in to access this feature.',
      primaryButtonText: 'Login',
      onPrimaryButtonPressed: onLogin,
      secondaryButtonText: onGoBack != null ? 'Go Back' : null,
      onSecondaryButtonPressed: onGoBack,
    );
  }

  factory SlUnauthorizedStateWidget.insufficientPermissions({
    required VoidCallback onRequestAccess,
    VoidCallback? onGoBack,
  }) {
    return SlUnauthorizedStateWidget(
      title: 'Access Restricted',
      message: 'You don\'t have sufficient permissions to access this content.',
      primaryButtonText: 'Request Access',
      onPrimaryButtonPressed: onRequestAccess,
      secondaryButtonText: onGoBack != null ? 'Go Back' : null,
      onSecondaryButtonPressed: onGoBack,
      customIcon: Icons.no_accounts,
    );
  }
}
