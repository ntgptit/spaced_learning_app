// lib/presentation/widgets/common/states/sl_maintenance_state_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

class SlMaintenanceStateWidget extends ConsumerWidget {
  final String title;
  final String message;
  final String? estimatedTimeMessage;
  final VoidCallback? onRetryPressed;
  final String? retryButtonText;
  final bool showImage;
  final Widget? customImage;
  final bool showEstimatedTime;
  final DateTime? estimatedCompletionTime;

  const SlMaintenanceStateWidget({
    super.key,
    this.title = 'Under Maintenance',
    this.message = 'We\'re currently making some improvements to our system.',
    this.estimatedTimeMessage,
    this.onRetryPressed,
    this.retryButtonText = 'Check Again',
    this.showImage = true,
    this.customImage,
    this.showEstimatedTime = true,
    this.estimatedCompletionTime,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    String timeMessage = estimatedTimeMessage ?? '';
    if (estimatedTimeMessage == null &&
        estimatedCompletionTime != null &&
        showEstimatedTime) {
      final now = DateTime.now();
      final difference = estimatedCompletionTime!.difference(now);

      if (difference.isNegative) {
        timeMessage = 'Maintenance should be complete soon.';
      } else if (difference.inHours > 0) {
        timeMessage = 'Estimated time remaining: ${difference.inHours} hours';
      } else if (difference.inMinutes > 0) {
        timeMessage =
            'Estimated time remaining: ${difference.inMinutes} minutes';
      } else {
        timeMessage = 'Maintenance should be complete within a minute.';
      }
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showImage) ...[
              if (customImage != null)
                customImage!
              else
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: colorScheme.secondary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.build_rounded,
                    size: 64,
                    color: colorScheme.secondary,
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
            if (timeMessage.isNotEmpty) ...[
              const SizedBox(height: AppDimens.spaceL),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.paddingL,
                  vertical: AppDimens.paddingM,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(AppDimens.radiusL),
                ),
                child: Text(
                  timeMessage,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSecondaryContainer,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
            if (onRetryPressed != null) ...[
              const SizedBox(height: AppDimens.spaceXL),
              OutlinedButton.icon(
                onPressed: onRetryPressed,
                icon: const Icon(Icons.refresh),
                label: Text(retryButtonText ?? 'Check Again'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.paddingXL,
                    vertical: AppDimens.paddingM,
                  ),
                  side: BorderSide(
                    color: colorScheme.secondary,
                    width: AppDimens.outlineButtonBorderWidth,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Factory constructors
  factory SlMaintenanceStateWidget.withReason({
    required String reason,
    DateTime? estimatedEndTime,
    VoidCallback? onRetry,
  }) {
    return SlMaintenanceStateWidget(
      title: 'System Maintenance',
      message: 'We\'re temporarily down for maintenance: $reason',
      estimatedCompletionTime: estimatedEndTime,
      onRetryPressed: onRetry,
      showEstimatedTime: estimatedEndTime != null,
    );
  }

  factory SlMaintenanceStateWidget.scheduled({
    required DateTime startTime,
    required DateTime endTime,
    String? details,
  }) {
    final now = DateTime.now();
    final isActive = now.isAfter(startTime) && now.isBefore(endTime);
    final message = isActive
        ? 'Scheduled maintenance is in progress.'
        : 'Scheduled maintenance will begin at ${_formatTime(startTime)}.';

    return SlMaintenanceStateWidget(
      title: 'Scheduled Maintenance',
      message: details != null ? '$message\n\n$details' : message,
      estimatedCompletionTime: endTime,
      customImage: Icon(
        isActive ? Icons.build_circle : Icons.event,
        size: 64,
        color: Colors.orange,
      ),
    );
  }

  static String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} on ${time.day}/${time.month}/${time.year}';
  }
}
