// lib/presentation/widgets/common/state/sl_timeout_state_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_bar_with_back.dart';
// Import specific buttons
import 'package:spaced_learning_app/presentation/widgets/common/button/sl_primary_button.dart';
import 'package:spaced_learning_app/presentation/widgets/common/button/sl_text_button.dart';

/// A widget to display when an operation or request times out.
///
/// Provides factory constructors for common timeout scenarios like network requests
/// or slow processes. Supports a primary retry action and an optional cancel action.
/// Can be displayed in a full or compact mode, and optionally with an AppBar.
class SlTimeoutStateWidget extends ConsumerWidget {
  /// The main title for the timeout message (e.g., "Request Timeout").
  final String title;

  /// Detailed message explaining the timeout.
  final String message;

  /// Callback for the primary "Try Again" action. This is required.
  final VoidCallback onRetry;

  /// Text for the primary action button. Defaults to "Try Again".
  final String retryButtonText;

  /// Optional callback for a "Cancel" action.
  final VoidCallback? onCancel;

  /// Text for the cancel button. Only shown if `onCancel` is also provided.
  final String? cancelButtonText;

  /// Indicates if the timeout is related to a service rather than a network issue.
  /// This might influence iconography or specific messaging in factories.
  final bool isServiceTimeout;

  /// The duration after which the timeout occurred, for display purposes.
  final Duration? timeoutDuration;

  /// If true, displays a compact version of the widget.
  final bool compact;

  /// The icon to display. Defaults to a timer off icon.
  final IconData icon;

  // New properties for AppBar integration
  final bool showAppBar;
  final String? appBarTitle;

  // onNavigateBack can be used if onCancel is null and we want a general back action
  final VoidCallback? onNavigateBack;

  const SlTimeoutStateWidget({
    super.key,
    this.title = 'Request Timeout',
    this.message =
        'The operation is taking longer than expected. Please try again.',
    required this.onRetry,
    this.retryButtonText = 'Try Again',
    this.onCancel,
    this.cancelButtonText, // Defaults to null, button only shown if this and onCancel are set
    this.isServiceTimeout = false,
    this.timeoutDuration,
    this.compact = false,
    this.icon = Icons.timer_off_outlined, // Default M3 icon
    this.showAppBar = false,
    this.appBarTitle,
    this.onNavigateBack,
  });

  /// Factory constructor for network request timeouts.
  factory SlTimeoutStateWidget.networkRequest({
    Key? key,
    required VoidCallback onRetry,
    VoidCallback? onCancel,
    String? message,
    Duration? timeout,
    bool compact = false,
    bool showAppBar = false,
    String? appBarTitle,
    VoidCallback? onNavigateBack,
  }) {
    return SlTimeoutStateWidget(
      key: key,
      title: 'Network Timeout',
      message:
          message ??
          'The connection to our servers timed out. Please check your internet connection and try again.',
      onRetry: onRetry,
      retryButtonText: 'Retry',
      onCancel: onCancel,
      cancelButtonText: onCancel != null ? 'Cancel' : null,
      isServiceTimeout: false,
      // Explicitly network, not service
      timeoutDuration: timeout,
      compact: compact,
      icon: Icons.signal_wifi_statusbar_connected_no_internet_4_outlined,
      // M3 icon for network issues
      showAppBar: showAppBar,
      appBarTitle: appBarTitle ?? 'Network Timeout',
      onNavigateBack:
          onNavigateBack ??
          onCancel, // If cancel exists, it might serve as navigate back
    );
  }

  /// Factory constructor for slow process timeouts.
  factory SlTimeoutStateWidget.slowProcess({
    Key? key,
    required VoidCallback onRetry,
    VoidCallback? onCancel,
    String? processName,
    String? message,
    bool compact = false,
    bool showAppBar = false,
    String? appBarTitle,
    VoidCallback? onNavigateBack,
  }) {
    final effectiveMessage =
        message ??
        (processName != null
            ? 'The $processName process is taking longer than expected. You can wait or try again.'
            : 'This process is taking longer than expected. You can wait or try again.');

    return SlTimeoutStateWidget(
      key: key,
      title: processName != null ? '$processName Timeout' : 'Process Timeout',
      message: effectiveMessage,
      onRetry: onRetry,
      retryButtonText: 'Retry Process',
      onCancel: onCancel,
      cancelButtonText: onCancel != null ? 'Cancel Process' : null,
      isServiceTimeout: true,
      // Indicates a service/process timeout
      compact: compact,
      icon: Icons.hourglass_empty_rounded,
      // M3 icon for pending/slow processes
      showAppBar: showAppBar,
      appBarTitle:
          appBarTitle ??
          (processName != null ? '$processName Timeout' : 'Process Timeout'),
      onNavigateBack: onNavigateBack ?? onCancel,
    );
  }

  Widget _buildFullTimeout(
    BuildContext context,
    ThemeData theme,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    // Timeout is generally an error-like state, so using error or tertiary colors
    final effectiveDisplayColor = isServiceTimeout
        ? colorScheme.tertiary
        : colorScheme.error;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: AppDimens.iconXXL,
          height: AppDimens.iconXXL,
          decoration: BoxDecoration(
            // Use a container color that fits the timeout context (tertiary or error)
            color: effectiveDisplayColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: AppDimens.iconXL,
            color: effectiveDisplayColor,
          ),
        ),
        const SizedBox(height: AppDimens.spaceXL),
        Text(
          title,
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface, // Title remains prominent
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimens.spaceM),
        Text(
          message,
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurfaceVariant, // Standard message color
          ),
          textAlign: TextAlign.center,
        ),
        if (timeoutDuration != null) ...[
          const SizedBox(height: AppDimens.spaceS),
          // Smaller space for this detail
          Text(
            'Timeout occurred after ${timeoutDuration!.inSeconds} seconds.',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant.withOpacity(
                0.8,
              ), // Subtle detail color
            ),
            textAlign: TextAlign.center,
          ),
        ],
        const SizedBox(height: AppDimens.spaceXL),
        // Space before buttons
        SlPrimaryButton(
          // Replaced SlButton with SlPrimaryButton
          text: retryButtonText,
          onPressed: onRetry,
          prefixIcon: Icons.refresh_rounded, // M3 refresh icon
          // Style the primary button to reflect timeout (e.g., error color)
          backgroundColor: effectiveDisplayColor,
          // SlPrimaryButton should handle its own foreground color, or use _getContrastColor
        ),
        if (cancelButtonText != null && onCancel != null) ...[
          const SizedBox(height: AppDimens.spaceM),
          SlTextButton(
            // Replaced SlButton with SlTextButton
            text: cancelButtonText!,
            onPressed: onCancel!,
            // foregroundColor: effectiveDisplayColor, // Optional: color the cancel button
          ),
        ],
        // Standalone navigate back button if no other actions and not in AppBar mode
        if (onCancel == null && onNavigateBack != null && !showAppBar) ...[
          const SizedBox(height: AppDimens.spaceM),
          SlTextButton(
            text: 'Go Back',
            onPressed: onNavigateBack!,
            foregroundColor: colorScheme.primary,
          ),
        ],
      ],
    );
  }

  Widget _buildCompactTimeout(
    BuildContext context,
    ThemeData theme,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    final effectiveDisplayColor = isServiceTimeout
        ? colorScheme.tertiary
        : colorScheme.error;

    return Card(
      color: effectiveDisplayColor.withOpacity(0.08),
      // Subtle tint for the card
      elevation: 0,
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimens.paddingL,
        vertical: AppDimens.paddingS,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
        side: BorderSide(
          color: effectiveDisplayColor.withOpacity(0.4),
        ), // Subtle border
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingM),
        child: Row(
          children: [
            Icon(icon, color: effectiveDisplayColor, size: AppDimens.iconM),
            const SizedBox(width: AppDimens.spaceM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: textTheme.titleSmall?.copyWith(
                      color: effectiveDisplayColor,
                      // Title matches the icon/border color
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (message.isNotEmpty) ...[
                    const SizedBox(height: AppDimens.spaceXS),
                    Text(
                      message,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme
                            .onSurfaceVariant, // Standard message color
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            // Retry button is mandatory for timeout state, so no null check on onRetry here
            const SizedBox(width: AppDimens.spaceS),
            SlTextButton(
              // Replaced TextButton with SlTextButton
              text: retryButtonText, // Retry button is always present
              onPressed: onRetry,
              foregroundColor:
                  effectiveDisplayColor, // Match the theme of the compact card
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
    // Use context.typography if defined in your theme_extensions.dart
    final textTheme = theme.textTheme;

    Widget timeoutContent;
    if (compact) {
      timeoutContent = _buildCompactTimeout(
        context,
        theme,
        textTheme,
        colorScheme,
      );
    } else {
      timeoutContent = _buildFullTimeout(
        context,
        theme,
        textTheme,
        colorScheme,
      );
    }

    if (showAppBar) {
      return Scaffold(
        appBar: AppBarWithBack(
          title: appBarTitle ?? title,
          // If onCancel exists, it could be the AppBar's back action.
          // Otherwise, use onNavigateBack or default pop.
          onBackPressed:
              onCancel ?? onNavigateBack ?? () => Navigator.maybePop(context),
        ),
        body: Center(
          child: Padding(
            padding: compact
                ? EdgeInsets.zero
                : const EdgeInsets.all(AppDimens.paddingL),
            child: timeoutContent,
          ),
        ),
      );
    }

    return Material(
      color: theme.scaffoldBackgroundColor,
      child: Center(
        child: Padding(
          padding: compact
              ? EdgeInsets.zero
              : const EdgeInsets.all(AppDimens.paddingL),
          child: timeoutContent,
        ),
      ),
    );
  }
}
