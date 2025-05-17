// lib/presentation/widgets/common/state/sl_timeout_state_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/presentation/widgets/common/button/sl_button.dart';

class SlTimeoutStateWidget extends ConsumerWidget {
  final String title;
  final String message;
  final VoidCallback onRetry;
  final String retryButtonText;
  final VoidCallback? onCancel;
  final String? cancelButtonText;
  final bool isServiceTimeout;
  final Duration? timeoutDuration;
  final bool compact;
  final IconData icon;

  const SlTimeoutStateWidget({
    super.key,
    this.title = 'Request Timeout',
    this.message =
        'The operation is taking longer than expected. Please try again.',
    required this.onRetry,
    this.retryButtonText = 'Try Again',
    this.onCancel,
    this.cancelButtonText,
    this.isServiceTimeout = false,
    this.timeoutDuration,
    this.compact = false,
    this.icon = Icons.timer_off_outlined,
  });

  // Factory constructor for network request timeouts
  factory SlTimeoutStateWidget.networkRequest({
    required VoidCallback onRetry,
    VoidCallback? onCancel,
    String? message,
    Duration? timeout,
    bool compact = false,
  }) {
    return SlTimeoutStateWidget(
      title: 'Network Timeout',
      message:
          message ??
          'The connection to our servers timed out. Please check your internet connection and try again.',
      onRetry: onRetry,
      retryButtonText: 'Retry',
      onCancel: onCancel,
      cancelButtonText: onCancel != null ? 'Cancel' : null,
      isServiceTimeout: false,
      timeoutDuration: timeout,
      compact: compact,
      icon: Icons.signal_wifi_statusbar_connected_no_internet_4_outlined,
    );
  }

  // Factory constructor for slow process timeouts
  factory SlTimeoutStateWidget.slowProcess({
    required VoidCallback onRetry,
    VoidCallback? onCancel,
    String? processName,
    String? message,
    bool compact = false,
  }) {
    final effectiveMessage =
        message ??
        (processName != null
            ? 'The $processName process is taking longer than expected. You can wait or try again.'
            : 'This process is taking longer than expected. You can wait or try again.');

    return SlTimeoutStateWidget(
      title: 'Process Timeout',
      message: effectiveMessage,
      onRetry: onRetry,
      retryButtonText: 'Retry Process',
      onCancel: onCancel,
      cancelButtonText: onCancel != null ? 'Cancel' : null,
      isServiceTimeout: true,
      compact: compact,
      icon: Icons.hourglass_empty_rounded,
    );
  }

  Widget _buildFullTimeout(
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
            Container(
              width: AppDimens.iconXXL,
              height: AppDimens.iconXXL,
              decoration: BoxDecoration(
                color: colorScheme.tertiaryContainer.withOpacity(0.7),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: AppDimens.iconXL,
                color: colorScheme.onTertiaryContainer,
              ),
            ),
            const SizedBox(height: AppDimens.spaceXL),
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
            if (timeoutDuration != null) ...[
              const SizedBox(height: AppDimens.spaceM),
              Text(
                'Timeout occurred after ${timeoutDuration!.inSeconds} seconds.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.tertiary,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: AppDimens.spaceXL),
            SlButton(
              text: retryButtonText,
              onPressed: onRetry,
              variant: SlButtonVariant.filled,
              prefixIcon: Icons.refresh,
            ),
            if (cancelButtonText != null && onCancel != null) ...[
              const SizedBox(height: AppDimens.spaceM),
              SlButton(
                text: cancelButtonText!,
                onPressed: onCancel!,
                variant: SlButtonVariant.text,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCompactTimeout(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Card(
      color: colorScheme.tertiaryContainer.withOpacity(0.15),
      elevation: 0,
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimens.paddingL,
        vertical: AppDimens.paddingS,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
        side: BorderSide(color: colorScheme.tertiary.withOpacity(0.4)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingM),
        child: Row(
          children: [
            Icon(icon, color: colorScheme.tertiary, size: AppDimens.iconM),
            const SizedBox(width: AppDimens.spaceM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: colorScheme.tertiary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (message.isNotEmpty) ...[
                    const SizedBox(height: AppDimens.spaceXS),
                    Text(
                      message,
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
              onPressed: onRetry,
              style: TextButton.styleFrom(
                foregroundColor: colorScheme.tertiary,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.paddingS,
                ),
                visualDensity: VisualDensity.compact,
              ),
              child: Text(retryButtonText),
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
      return _buildCompactTimeout(context, theme, colorScheme);
    }
    return _buildFullTimeout(context, theme, colorScheme);
  }
}
