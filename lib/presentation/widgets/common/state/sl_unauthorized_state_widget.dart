// lib/presentation/widgets/common/state/sl_unauthorized_state_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/presentation/widgets/common/button/sl_button.dart';

class SlUnauthorizedStateWidget extends ConsumerWidget {
  final String title;
  final String message;
  final String primaryButtonText;
  final VoidCallback onPrimaryButtonPressed;
  final String? secondaryButtonText;
  final VoidCallback? onSecondaryButtonPressed;
  final bool showIcon;
  final IconData icon;

  const SlUnauthorizedStateWidget({
    super.key,
    this.title = 'Access Denied',
    this.message = 'You don\'t have permission to access this content.',
    this.primaryButtonText = 'Login',
    required this.onPrimaryButtonPressed,
    this.secondaryButtonText,
    this.onSecondaryButtonPressed,
    this.showIcon = true,
    this.icon = Icons.lock_outline_rounded,
  });

  // Factory constructor for session expired state
  factory SlUnauthorizedStateWidget.sessionExpired({
    required VoidCallback onLoginAgain,
    String title = 'Session Expired',
    String message =
        'Your session has expired. Please log in again to continue.',
  }) {
    return SlUnauthorizedStateWidget(
      title: title,
      message: message,
      primaryButtonText: 'Login Again',
      onPrimaryButtonPressed: onLoginAgain,
      icon: Icons.refresh_rounded,
    );
  }

  // Factory constructor for login required state
  factory SlUnauthorizedStateWidget.requiresLogin({
    required VoidCallback onLogin,
    VoidCallback? onGoBack,
    String title = 'Login Required',
    String message = 'You need to be logged in to access this feature.',
    String primaryButtonText = 'Login',
    String? secondaryButtonText,
  }) {
    return SlUnauthorizedStateWidget(
      title: title,
      message: message,
      primaryButtonText: primaryButtonText,
      onPrimaryButtonPressed: onLogin,
      secondaryButtonText: onGoBack != null
          ? (secondaryButtonText ?? 'Go Back')
          : null,
      onSecondaryButtonPressed: onGoBack,
      icon: Icons.login_rounded,
    );
  }

  // Factory constructor for insufficient permissions state
  factory SlUnauthorizedStateWidget.insufficientPermissions({
    VoidCallback? onRequestAccess,
    VoidCallback? onGoBack,
    String title = 'Access Restricted',
    String message = 'You don\'t have sufficient permissions for this action.',
    String primaryButtonText = 'Go Back',
  }) {
    final bool hasRequestAccess = onRequestAccess != null;
    final String effectivePrimaryText = hasRequestAccess
        ? 'Request Access'
        : primaryButtonText;
    final VoidCallback effectivePrimaryAction = hasRequestAccess
        ? onRequestAccess
        : (onGoBack ?? () {});

    return SlUnauthorizedStateWidget(
      title: title,
      message: message,
      primaryButtonText: effectivePrimaryText,
      onPrimaryButtonPressed: effectivePrimaryAction,
      secondaryButtonText: hasRequestAccess && onGoBack != null
          ? 'Go Back'
          : null,
      onSecondaryButtonPressed: hasRequestAccess ? onGoBack : null,
      icon: Icons.no_accounts_outlined,
    );
  }

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
                  color: colorScheme.errorContainer.withOpacity(0.7),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: AppDimens.iconXL,
                  color: colorScheme.onErrorContainer,
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
            SlButton(
              text: primaryButtonText,
              onPressed: onPrimaryButtonPressed,
              variant: SlButtonVariant.filled,
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
}
