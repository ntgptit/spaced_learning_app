// lib/presentation/widgets/common/state/sl_offline_state_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_bar_with_back.dart';
// Import specific buttons
import 'package:spaced_learning_app/presentation/widgets/common/button/sl_primary_button.dart';
import 'package:spaced_learning_app/presentation/widgets/common/button/sl_text_button.dart';

// Consider SlOutlinedButton for secondary actions if they are more prominent than text buttons
// import 'package:spaced_learning_app/presentation/widgets/common/button/sl_outlined_button.dart';

/// A widget to display when the device is offline or content requires an internet connection.
///
/// Offers factory constructors for common offline scenarios and supports
/// both a full and a compact display mode. Action buttons for retrying
/// or performing secondary actions (like opening settings) can be included.
class SlOfflineStateWidget extends ConsumerWidget {
  /// The main title of the offline message (e.g., "No Internet Connection").
  final String title;

  /// The detailed message explaining the offline state.
  final String? message;

  /// Text for the primary action button (e.g., "Try Again").
  final String? retryButtonText;

  /// Text for the secondary action button (e.g., "Open Settings").
  final String? secondaryButtonText;

  /// Callback for the primary action button.
  final VoidCallback? onRetry;

  /// Callback for the secondary action button.
  final VoidCallback? onSecondaryAction;

  /// If true, displays a compact version of the widget, suitable for inline use.
  final bool compact;

  /// Whether to show the main offline icon/image.
  final bool showOfflineImage;

  /// The icon to display. Defaults to a Wi-Fi off icon.
  final IconData icon;

  // New properties for AppBar integration
  final bool showAppBar;
  final String? appBarTitle;
  final VoidCallback?
  onNavigateBack; // For back button on app bar or a standalone back button

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
    this.icon = Icons.wifi_off_rounded, // Default Material 3 icon
    this.showAppBar = false,
    this.appBarTitle,
    this.onNavigateBack,
  });

  /// Factory constructor for a generic offline message.
  factory SlOfflineStateWidget.generic({
    Key? key,
    String title = 'You Are Offline',
    String? message = 'Please check your internet connection and try again.',
    VoidCallback? onRetry,
    String? retryText = 'Retry',
    VoidCallback?
    onOpenSettings, // Specific secondary action for generic offline
    String? openSettingsText = 'Network Settings',
    bool compact = false,
    bool showAppBar = false,
    String? appBarTitle,
    VoidCallback? onNavigateBack,
  }) {
    return SlOfflineStateWidget(
      key: key,
      title: title,
      message: message,
      onRetry: onRetry,
      retryButtonText: retryText,
      onSecondaryAction: onOpenSettings,
      secondaryButtonText: onOpenSettings != null ? openSettingsText : null,
      compact: compact,
      icon: Icons.signal_wifi_off_outlined,
      // M3 icon
      showAppBar: showAppBar,
      appBarTitle: appBarTitle ?? title,
      onNavigateBack: onNavigateBack,
    );
  }

  /// Factory constructor for when content cannot be loaded due to being offline.
  factory SlOfflineStateWidget.contentUnavailable({
    Key? key,
    String title = 'Content Unavailable Offline',
    String? message =
        'This content requires an internet connection to load. Please connect and try again.',
    VoidCallback? onRetry,
    String? retryText = 'Refresh',
    bool compact = false,
    bool showAppBar = false,
    String? appBarTitle,
    VoidCallback? onNavigateBack,
  }) {
    return SlOfflineStateWidget(
      key: key,
      title: title,
      message: message,
      onRetry: onRetry,
      retryButtonText: retryText,
      compact: compact,
      icon: Icons.cloud_off_outlined,
      // M3 icon indicating cloud/content issue
      showAppBar: showAppBar,
      appBarTitle: appBarTitle ?? title,
      onNavigateBack: onNavigateBack,
    );
  }

  Widget _buildFullOffline(
    BuildContext context,
    ThemeData theme,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showOfflineImage) ...[
          Container(
            width: AppDimens.iconXXL,
            height: AppDimens.iconXXL,
            decoration: BoxDecoration(
              // Using a less alarming container color for offline, or errorContainer if preferred
              color: colorScheme.surfaceVariant.withOpacity(0.7),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: AppDimens.iconXL,
              color: colorScheme
                  .onSurfaceVariant, // Color that contrasts with surfaceVariant
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
        if (message != null && message!.isNotEmpty) ...[
          const SizedBox(height: AppDimens.spaceM),
          Text(
            message!,
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
        if (onRetry != null) ...[
          const SizedBox(height: AppDimens.spaceXL),
          SlPrimaryButton(
            // Replaced SlButton with SlPrimaryButton
            text: retryButtonText ?? 'Try Again',
            onPressed: onRetry!,
            prefixIcon: Icons.refresh_rounded, // Material 3 refresh icon
            // Consider styling based on context, e.g., error color for offline state
            // backgroundColor: colorScheme.error,
            // textColor: colorScheme.onError,
          ),
        ],
        if (secondaryButtonText != null && onSecondaryAction != null) ...[
          SizedBox(
            height: onRetry != null ? AppDimens.spaceM : AppDimens.spaceXL,
          ),
          SlTextButton(
            // Replaced SlButton with SlTextButton
            text: secondaryButtonText!,
            onPressed: onSecondaryAction!,
            // Optional: Add icon for secondary action, e.g., settings
            // prefixIcon: Icons.settings_outlined,
            foregroundColor: colorScheme.primary, // Standard text button color
          ),
        ],
        // Standalone navigate back button if no other actions and not in AppBar mode
        if (onRetry == null &&
            onSecondaryAction == null &&
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
  }

  Widget _buildCompactOffline(
    BuildContext context,
    ThemeData theme,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    return Card(
      // Using a less intense color for compact offline, or errorContainer if a strong error indication is needed
      color: colorScheme.surfaceVariant.withOpacity(0.5),
      elevation: 0,
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimens.paddingL,
        vertical: AppDimens.paddingS,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
        // Border color can be subtle or error-related
        side: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingM),
        child: Row(
          children: [
            Icon(
              icon,
              color: colorScheme.onSurfaceVariant,
              size: AppDimens.iconM,
            ), // Adjusted color
            const SizedBox(width: AppDimens.spaceM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: textTheme.titleSmall?.copyWith(
                      color: colorScheme.onSurface, // Adjusted color
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (message != null && message!.isNotEmpty) ...[
                    const SizedBox(height: AppDimens.spaceXS),
                    Text(
                      message!,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1, // Compact view, limit lines
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(width: AppDimens.spaceS),
              SlTextButton(
                // Replaced TextButton with SlTextButton
                text: retryButtonText ?? 'Retry',
                onPressed: onRetry!,
                foregroundColor:
                    colorScheme.primary, // Standard action color for retry
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    // Use context.typography if available from theme_extensions.dart
    final textTheme = theme.textTheme;

    Widget offlineContent;
    if (compact) {
      offlineContent = _buildCompactOffline(
        context,
        theme,
        textTheme,
        colorScheme,
      );
    } else {
      offlineContent = _buildFullOffline(
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
          onBackPressed: onNavigateBack ?? () => Navigator.maybePop(context),
        ),
        body: Center(
          child: Padding(
            padding: compact
                ? EdgeInsets.zero
                : const EdgeInsets.all(AppDimens.paddingL),
            child: offlineContent,
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
          child: offlineContent,
        ),
      ),
    );
  }
}
