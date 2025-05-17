// lib/presentation/widgets/common/state/sl_maintenance_state_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart'; // For improved date formatting
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_bar_with_back.dart';
import 'package:spaced_learning_app/presentation/widgets/common/button/sl_outlined_button.dart';
import 'package:spaced_learning_app/presentation/widgets/common/button/sl_text_button.dart';

/// A widget to display when the application or a feature is undergoing maintenance.
///
/// This widget is designed to be flexible, offering several factory constructors
/// for common maintenance scenarios like generic messages, specific reasons,
/// or scheduled downtimes. It supports displaying estimated completion times
/// and provides an optional action button (e.g., "Check Again").
///
/// It can be displayed as a full screen with an AppBar or as an embedded component.
class SlMaintenanceStateWidget extends ConsumerWidget {
  /// The main title of the maintenance message (e.g., "Under Maintenance").
  final String title;

  /// The detailed message explaining the maintenance.
  final String message;

  /// A pre-formatted string for the estimated time. If null, it might be calculated.
  final String? estimatedTimeMessageText;

  /// Callback for the action button (e.g., to check if maintenance is complete).
  final VoidCallback? onRetryPressed;

  /// Text for the action button. Defaults to "Check Again".
  final String? retryButtonText;

  /// Whether to show the main maintenance icon/image.
  final bool showImage;

  /// A custom widget to display instead of the default icon.
  final Widget? customImage;

  /// Whether to display the estimated time information.
  final bool showEstimatedTime;

  /// The specific date and time when maintenance is expected to complete.
  final DateTime? estimatedCompletionTime;

  /// The icon to display if `customImage` is null and `showImage` is true.
  final IconData icon;

  /// If true, wraps the content in a Scaffold with an AppBar.
  final bool showAppBar;

  /// The title for the AppBar if `showAppBar` is true. Defaults to `title`.
  final String? appBarTitle;

  /// Callback for the back button in the AppBar or a standalone "Go Back" button.
  final VoidCallback? onNavigateBack;

  const SlMaintenanceStateWidget({
    super.key,
    this.title = 'Under Maintenance',
    this.message =
        'We\'re currently making some improvements. Please check back shortly.',
    this.estimatedTimeMessageText,
    this.onRetryPressed,
    this.retryButtonText = 'Check Again',
    this.showImage = true,
    this.customImage,
    this.showEstimatedTime = true,
    this.estimatedCompletionTime,
    this.icon = Icons.build_rounded, // Default Material 3 icon
    this.showAppBar = false,
    this.appBarTitle,
    this.onNavigateBack,
  });

  /// Factory constructor for a generic maintenance message.
  factory SlMaintenanceStateWidget.generic({
    Key? key,
    String title = 'System Maintenance',
    String message =
        'Our services are temporarily unavailable as we perform scheduled maintenance. We apologize for any inconvenience.',
    VoidCallback? onRetry,
    bool showAppBar = false,
    String? appBarTitle,
    VoidCallback? onNavigateBack,
  }) {
    return SlMaintenanceStateWidget(
      key: key,
      title: title,
      message: message,
      onRetryPressed: onRetry,
      icon: Icons.settings_applications_outlined,
      showAppBar: showAppBar,
      appBarTitle: appBarTitle ?? title,
      onNavigateBack: onNavigateBack,
    );
  }

  /// Factory constructor for maintenance with a specific reason provided.
  factory SlMaintenanceStateWidget.withReason({
    Key? key,
    required String reason,
    String title = 'System Maintenance',
    DateTime? estimatedEndTime,
    VoidCallback? onRetry,
    String retryText = 'Try Again',
    bool showAppBar = false,
    String? appBarTitle,
    VoidCallback? onNavigateBack,
  }) {
    return SlMaintenanceStateWidget(
      key: key,
      title: title,
      message:
          'We\'re temporarily down for maintenance: $reason. We expect to be back soon.',
      estimatedCompletionTime: estimatedEndTime,
      onRetryPressed: onRetry,
      retryButtonText: retryText,
      showEstimatedTime: estimatedEndTime != null,
      icon: Icons.miscellaneous_services_outlined,
      showAppBar: showAppBar,
      appBarTitle: appBarTitle ?? title,
      onNavigateBack: onNavigateBack,
    );
  }

  /// Factory constructor for scheduled maintenance periods.
  ///
  /// Automatically determines the message and icon based on whether the maintenance
  /// is upcoming, active, or completed.
  factory SlMaintenanceStateWidget.scheduled({
    Key? key,
    required DateTime startTime,
    required DateTime endTime,
    String? details,
    String title = 'Scheduled Maintenance',
    bool showAppBar = false,
    String? appBarTitle,
    VoidCallback? onNavigateBack,
    VoidCallback? onRetryIfActive,
  }) {
    final now = DateTime.now();
    final bool isActive = now.isAfter(startTime) && now.isBefore(endTime);
    final String effectiveMessage;

    final DateFormat timeFormatter = DateFormat.jm(); // Example: 5:08 PM
    final DateFormat dateFormatter =
        DateFormat.yMMMd(); // Example: May 17, 2025

    if (isActive) {
      effectiveMessage =
          'Scheduled maintenance is currently in progress. We appreciate your patience.';
    } else if (now.isBefore(startTime)) {
      effectiveMessage =
          'We will be undergoing scheduled maintenance starting at ${timeFormatter.format(startTime)} on ${dateFormatter.format(startTime)}.';
    } else {
      effectiveMessage = 'Scheduled maintenance has been completed.';
    }

    return SlMaintenanceStateWidget(
      key: key,
      title: title,
      message: details != null
          ? '$effectiveMessage\n\nDetails: $details'
          : effectiveMessage,
      estimatedCompletionTime: endTime,
      icon: isActive
          ? Icons.build_circle_outlined
          : Icons.event_available_outlined,
      showEstimatedTime: isActive || now.isBefore(endTime),
      onRetryPressed: isActive ? onRetryIfActive : null,
      retryButtonText: isActive ? 'Check Status' : null,
      showAppBar: showAppBar,
      appBarTitle: appBarTitle ?? title,
      onNavigateBack: onNavigateBack,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    // Use context.typography if defined for custom typography sets
    final textTheme = theme.textTheme;

    String displayTimeMessage = estimatedTimeMessageText ?? '';
    if (estimatedTimeMessageText == null &&
        estimatedCompletionTime != null &&
        showEstimatedTime) {
      final now = DateTime.now();
      final difference = estimatedCompletionTime!.difference(now);

      if (difference.isNegative) {
        displayTimeMessage = 'Maintenance should be complete. Try refreshing.';
      } else if (difference.inDays > 0) {
        final hours = difference.inHours % 24;
        displayTimeMessage =
            'Estimated completion: In ${difference.inDays} day(s)${hours > 0 ? ' and $hours hour(s)' : ''}.';
      } else if (difference.inHours > 0) {
        final minutes = difference.inMinutes % 60;
        displayTimeMessage =
            'Estimated time remaining: ~${difference.inHours} hour(s)${minutes > 0 ? ' and $minutes minute(s)' : ''}.';
      } else if (difference.inMinutes > 0) {
        displayTimeMessage =
            'Estimated time remaining: ~${difference.inMinutes} minute(s).';
      } else {
        // This case handles remaining time less than a minute or very close to completion
        displayTimeMessage = 'Maintenance should be complete very soon.';
      }
    }

    // The main content of the maintenance screen
    Widget maintenanceContent = Column(
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
                  color: colorScheme.secondaryContainer.withOpacity(0.7),
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
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimens.spaceM),
        Text(
          message,
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        if (displayTimeMessage.isNotEmpty) ...[
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
              displayTimeMessage,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onTertiaryContainer,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
        if (onRetryPressed != null && retryButtonText != null) ...[
          const SizedBox(height: AppDimens.spaceXL),
          SlOutlinedButton(
            text: retryButtonText!,
            onPressed: onRetryPressed!,
            prefixIcon: Icons.refresh_rounded,
          ),
        ],
        if (onRetryPressed == null &&
            onNavigateBack != null &&
            !showAppBar) ...[
          const SizedBox(height: AppDimens.spaceM),
          SlTextButton(
            text: 'Go Back',
            onPressed: onNavigateBack!,
            foregroundColor: colorScheme.primary,
          ),
        ],
      ],
    );

    if (showAppBar) {
      return Scaffold(
        appBar: AppBarWithBack(
          title: appBarTitle ?? title,
          onBackPressed: onNavigateBack ?? () => Navigator.maybePop(context),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.paddingXL),
            child: maintenanceContent,
          ),
        ),
      );
    }

    return Material(
      color: theme.scaffoldBackgroundColor,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.paddingXL),
          child: maintenanceContent,
        ),
      ),
    );
  }
}
