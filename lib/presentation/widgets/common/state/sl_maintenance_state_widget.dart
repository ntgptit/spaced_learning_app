// lib/presentation/widgets/common/state/sl_maintenance_state_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_button.dart'; // Assuming SLButton is here

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
  final IconData icon;

  const SlMaintenanceStateWidget({
    super.key,
    this.title = 'Under Maintenance',
    this.message =
        'We\'re currently making some improvements. Please check back shortly.',
    this.estimatedTimeMessage,
    this.onRetryPressed,
    this.retryButtonText = 'Check Again',
    this.showImage = true,
    this.customImage,
    this.showEstimatedTime = true,
    this.estimatedCompletionTime,
    this.icon = Icons.build_rounded,
  });

  // Factory constructor for a generic maintenance message
  factory SlMaintenanceStateWidget.generic({
    String title = 'System Maintenance',
    String message =
        'Our services are temporarily unavailable as we perform scheduled maintenance. We apologize for any inconvenience.',
    VoidCallback? onRetry,
  }) {
    return SlMaintenanceStateWidget(
      title: title,
      message: message,
      onRetryPressed: onRetry,
      icon: Icons.settings_applications_outlined,
    );
  }

  // Factory constructor with a specific reason
  factory SlMaintenanceStateWidget.withReason({
    required String reason,
    String title = 'System Maintenance',
    DateTime? estimatedEndTime,
    VoidCallback? onRetry,
    String retryText = 'Try Again',
  }) {
    return SlMaintenanceStateWidget(
      title: title,
      message:
          'We\'re temporarily down for maintenance: $reason. We expect to be back soon.',
      estimatedCompletionTime: estimatedEndTime,
      onRetryPressed: onRetry,
      retryButtonText: retryText,
      showEstimatedTime: estimatedEndTime != null,
      icon: Icons.miscellaneous_services_outlined,
    );
  }

  // Factory constructor for scheduled maintenance
  factory SlMaintenanceStateWidget.scheduled({
    required DateTime startTime,
    required DateTime endTime,
    String? details,
    String title = 'Scheduled Maintenance',
  }) {
    final now = DateTime.now();
    final bool isActive = now.isAfter(startTime) && now.isBefore(endTime);
    final String effectiveMessage;
    if (isActive) {
      effectiveMessage =
          'Scheduled maintenance is currently in progress. We appreciate your patience.';
    } else if (now.isBefore(startTime)) {
      effectiveMessage =
          'We will be undergoing scheduled maintenance starting at ${_formatTime(startTime)}.';
    } else {
      effectiveMessage = 'Scheduled maintenance has been completed.';
    }

    return SlMaintenanceStateWidget(
      title: title,
      message: details != null
          ? '$effectiveMessage\n\nDetails: $details'
          : effectiveMessage,
      estimatedCompletionTime: endTime,
      icon: isActive
          ? Icons.build_circle_outlined
          : Icons.event_available_outlined,
      showEstimatedTime: isActive || now.isBefore(endTime),
    );
  }

  static String _formatTime(DateTime time) {
    // Consider using intl package for more robust date/time formatting
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} on ${time.day}/${time.month}/${time.year}';
  }

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
        timeMessage = 'Maintenance should be complete. Try refreshing.';
      } else if (difference.inHours > 0) {
        timeMessage =
            'Estimated time remaining: ~${difference.inHours} hour(s).';
      } else if (difference.inMinutes > 0) {
        timeMessage =
            'Estimated time remaining: ~${difference.inMinutes} minute(s).';
      } else {
        timeMessage = 'Maintenance should be complete very soon.';
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
              customImage ??
                  Container(
                    width: AppDimens.iconXXL,
                    height: AppDimens.iconXXL,
                    decoration: BoxDecoration(
                      color: colorScheme.secondaryContainer.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      size: AppDimens.iconXL,
                      color: colorScheme.onSecondaryContainer,
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
                  color: colorScheme.tertiaryContainer.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(AppDimens.radiusM),
                ),
                child: Text(
                  timeMessage,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onTertiaryContainer,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
            if (onRetryPressed != null) ...[
              const SizedBox(height: AppDimens.spaceXL),
              SLButton(
                text: retryButtonText ?? 'Check Again',
                onPressed: onRetryPressed,
                type: SLButtonType.outline, // Or tonal for a softer look
                prefixIcon: Icons.refresh,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
