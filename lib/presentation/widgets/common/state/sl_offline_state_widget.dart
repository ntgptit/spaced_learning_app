// lib/presentation/widgets/common/state/sl_offline_state_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_button.dart'; // Assuming SLButton is here

class SlOfflineStateWidget extends ConsumerWidget {
  final String title;
  final String? message;
  final String? retryButtonText;
  final String? secondaryButtonText;
  final VoidCallback? onRetry;
  final VoidCallback? onSecondaryAction;
  final bool compact;
  final bool showOfflineImage;
  final IconData icon;

  const SlOfflineStateWidget({
    super.key,
    this.title = 'No Internet Connection',
    this.message,
    this.retryButtonText = 'Try Again',
    this.secondaryButtonText,
    this.onRetry,
    this.onSecondaryAction,
    this.compact = false,
    this.showOfflineImage = true,
    this.icon = Icons.wifi_off_rounded,
  });

  // Factory constructor for a generic offline message
  factory SlOfflineStateWidget.generic({
    String title = 'You Are Offline',
    String? message = 'Please check your internet connection and try again.',
    VoidCallback? onRetry,
    String? retryText = 'Retry',
    bool compact = false,
  }) {
    return SlOfflineStateWidget(
      title: title,
      message: message,
      onRetry: onRetry,
      retryButtonText: retryText,
      compact: compact,
      icon: Icons.signal_wifi_off_outlined,
    );
  }

  // Factory constructor for when content cannot be loaded due to being offline
  factory SlOfflineStateWidget.contentUnavailable({
    String title = 'Content Unavailable Offline',
    String? message =
        'This content requires an internet connection to load. Please connect and try again.',
    VoidCallback? onRetry,
    String? retryText = 'Refresh',
    bool compact = false,
  }) {
    return SlOfflineStateWidget(
      title: title,
      message: message,
      onRetry: onRetry,
      retryButtonText: retryText,
      compact: compact,
      icon: Icons.cloud_off_outlined,
    );
  }

  Widget _buildFullOffline(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showOfflineImage) ...[
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
            if (onRetry != null) ...[
              const SizedBox(height: AppDimens.spaceXL),
              SLButton(
                text: retryButtonText ?? 'Try Again',
                onPressed: onRetry,
                type: SLButtonType.primary,
                prefixIcon: Icons.refresh,
              ),
            ],
            if (secondaryButtonText != null && onSecondaryAction != null) ...[
              const SizedBox(height: AppDimens.spaceM),
              SLButton(
                text: secondaryButtonText!,
                onPressed: onSecondaryAction,
                type: SLButtonType.text, // Or outline
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCompactOffline(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Card(
      color: colorScheme.errorContainer.withOpacity(0.15),
      elevation: 0,
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimens.paddingL,
        vertical: AppDimens.paddingS,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
        side: BorderSide(color: colorScheme.error.withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingM),
        child: Row(
          children: [
            Icon(icon, color: colorScheme.error, size: AppDimens.iconM),
            const SizedBox(width: AppDimens.spaceM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: colorScheme.error,
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
            if (onRetry != null)
              TextButton(
                onPressed: onRetry,
                style: TextButton.styleFrom(
                  foregroundColor: colorScheme.primary, // Or error color
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.paddingS,
                  ),
                  visualDensity: VisualDensity.compact,
                ),
                child: Text(retryButtonText ?? 'Retry'),
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

    if (compact) {
      return _buildCompactOffline(context, theme, colorScheme);
    }
    return _buildFullOffline(context, theme, colorScheme);
  }
}
