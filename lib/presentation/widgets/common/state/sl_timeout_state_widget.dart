// lib/presentation/widgets/common/states/sl_timeout_state_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spaced_learning_app/core/extensions/color_extensions.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

class SlTimeoutStateWidget extends ConsumerWidget {
  final String title;
  final String message;
  final VoidCallback onRetry;
  final String retryButtonText;
  final VoidCallback? onCancel;
  final String? cancelButtonText;
  final bool isService;
  final Duration? timeout;
  final bool compact;

  const SlTimeoutStateWidget({
    super.key,
    this.title = 'Request Timeout',
    this.message = 'The operation is taking longer than expected.',
    required this.onRetry,
    this.retryButtonText = 'Try Again',
    this.onCancel,
    this.cancelButtonText,
    this.isService = false,
    this.timeout,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (compact) {
      return _buildCompactTimeout(theme, colorScheme);
    }

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
                color: colorScheme.warning.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isService ? Icons.pending_outlined : Icons.timer_off_outlined,
                size: AppDimens.iconXL,
                color: colorScheme.warning,
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
            if (timeout != null) ...[
              const SizedBox(height: AppDimens.spaceM),
              Text(
                'Timeout after ${timeout!.inSeconds} seconds',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.warning,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: AppDimens.spaceXL),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(retryButtonText),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.warning,
                foregroundColor: colorScheme.onWarning,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.paddingXL,
                  vertical: AppDimens.paddingM,
                ),
              ),
            ),
            if (cancelButtonText != null && onCancel != null) ...[
              const SizedBox(height: AppDimens.spaceM),
              TextButton(onPressed: onCancel, child: Text(cancelButtonText!)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCompactTimeout(ThemeData theme, ColorScheme colorScheme) {
    return Card(
      color: colorScheme.warning.withValues(alpha: 0.08),
      elevation: 0,
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimens.paddingL,
        vertical: AppDimens.paddingS,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
        side: BorderSide(color: colorScheme.warning.withValues(alpha: 0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingM),
        child: Row(
          children: [
            Icon(
              isService ? Icons.pending : Icons.timer_off,
              color: colorScheme.warning,
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
                      color: colorScheme.warning,
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
                foregroundColor: colorScheme.warning,
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

  // Factory constructors
  factory SlTimeoutStateWidget.networkRequest({
    required VoidCallback onRetry,
    VoidCallback? onCancel,
    Duration? timeout,
    bool compact = false,
  }) {
    return SlTimeoutStateWidget(
      title: 'Network Timeout',
      message:
          'The connection to our servers timed out. Please check your internet connection and try again.',
      onRetry: onRetry,
      retryButtonText: 'Try Again',
      onCancel: onCancel,
      cancelButtonText: onCancel != null ? 'Cancel' : null,
      isService: false,
      timeout: timeout,
      compact: compact,
    );
  }

  factory SlTimeoutStateWidget.slowProcess({
    required VoidCallback onRetry,
    VoidCallback? onCancel,
    String? processName,
    bool compact = false,
  }) {
    final message = processName != null
        ? 'The $processName process is taking longer than expected.'
        : 'This process is taking longer than expected.';

    return SlTimeoutStateWidget(
      title: 'Process Timeout',
      message: message,
      onRetry: onRetry,
      retryButtonText: 'Retry Process',
      onCancel: onCancel,
      cancelButtonText: onCancel != null ? 'Cancel' : null,
      isService: true,
      compact: compact,
    );
  }
}
