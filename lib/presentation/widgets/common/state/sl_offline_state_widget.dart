// lib/presentation/widgets/common/states/sl_offline_state_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

class SlOfflineStateWidget extends ConsumerWidget {
  final String title;
  final String? message;
  final String? retryButtonText;
  final String? secondaryButtonText;
  final VoidCallback? onRetry;
  final VoidCallback? onSecondaryAction;
  final bool compact;
  final bool showOfflineImage;

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
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (compact) {
      return _buildCompactOffline(theme, colorScheme);
    }

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
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: colorScheme.errorContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.wifi_off_rounded,
                  size: 64,
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
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(retryButtonText ?? 'Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.paddingXL,
                    vertical: AppDimens.paddingM,
                  ),
                ),
              ),
            ],
            if (secondaryButtonText != null && onSecondaryAction != null) ...[
              const SizedBox(height: AppDimens.spaceM),
              TextButton(
                onPressed: onSecondaryAction,
                child: Text(secondaryButtonText!),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCompactOffline(ThemeData theme, ColorScheme colorScheme) {
    return Card(
      color: colorScheme.errorContainer.withValues(alpha: 0.15),
      elevation: 0,
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimens.paddingL,
        vertical: AppDimens.paddingS,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
        side: BorderSide(color: colorScheme.error.withValues(alpha: 0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingM),
        child: Row(
          children: [
            Icon(
              Icons.wifi_off_rounded,
              color: colorScheme.error,
              size: AppDimens.iconM,
            ),
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
                  foregroundColor: colorScheme.primary,
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

  // Factory constructor
  factory SlOfflineStateWidget.withCustomMessage({
    required String message,
    VoidCallback? onRetry,
    String? retryButtonText,
    bool compact = false,
  }) {
    return SlOfflineStateWidget(
      title: 'You\'re Offline',
      message: message,
      retryButtonText: retryButtonText,
      onRetry: onRetry,
      compact: compact,
    );
  }
}
