// lib/presentation/widgets/common/state/sl_success_state_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_bar_with_back.dart';
// Import specific buttons
import 'package:spaced_learning_app/presentation/widgets/common/button/sl_primary_button.dart';
import 'package:spaced_learning_app/presentation/widgets/common/button/sl_text_button.dart';

/// A widget to display a success message or confirmation.
///
/// Offers factory constructors for common success scenarios like action completion,
/// data saving, or notifications. Supports different display modes (full, compact)
/// and action buttons. The `autoHideDuration` parameter is a suggestion for the
/// calling widget to implement auto-dismissal.
class SlSuccessStateWidget extends ConsumerWidget {
  /// The main title of the success message (e.g., "Action Complete!").
  final String title;

  /// An optional detailed message.
  final String? message;

  /// Text for the primary action button (e.g., "Continue", "OK").
  final String primaryButtonText;

  /// Callback for the primary action button.
  final VoidCallback onPrimaryButtonPressed;

  /// Text for an optional secondary action button.
  final String? secondaryButtonText;

  /// Callback for the optional secondary action button.
  final VoidCallback? onSecondaryButtonPressed;

  /// Whether to display the success icon.
  final bool showIcon;

  /// If true, displays a compact version of the widget.
  final bool compactMode;

  /// Suggested duration after which the success state might be automatically hidden
  /// by the calling widget/logic by invoking `onPrimaryButtonPressed` or navigating.
  final Duration? autoHideDuration;

  /// The icon to display. Defaults to a checkmark circle.
  final IconData icon;

  /// Overrides the default success color (usually theme's primary color).
  final Color? accentColor;

  // New properties for AppBar integration
  final bool showAppBar;
  final String? appBarTitle;

  // onNavigateBack is not typically needed for a success screen that auto-dismisses or has explicit actions.
  // If a specific back navigation is needed when showAppBar is true, onPrimaryButtonPressed or onSecondaryButtonPressed
  // should handle that navigation. The AppBarWithBack will provide a default pop.

  const SlSuccessStateWidget({
    super.key,
    required this.title,
    this.message,
    required this.primaryButtonText,
    required this.onPrimaryButtonPressed,
    this.secondaryButtonText,
    this.onSecondaryButtonPressed,
    this.showIcon = true,
    this.compactMode = false,
    this.autoHideDuration, // This widget will not self-dismiss. Parent should handle.
    this.icon = Icons.check_circle_outline_rounded, // Default M3 icon
    this.accentColor,
    this.showAppBar = false,
    this.appBarTitle,
  });

  /// Factory constructor for generic action completion.
  factory SlSuccessStateWidget.actionComplete({
    Key? key,
    required String actionName,
    required VoidCallback onContinue,
    String? continueButtonText = 'Continue',
    String? successMessage,
    Duration? autoHideDuration, // Suggestion for parent
    bool showAppBar = false,
    String? appBarTitle,
  }) {
    return SlSuccessStateWidget(
      key: key,
      title: '$actionName Successful!',
      message:
          successMessage ??
          'The $actionName operation was completed successfully.',
      primaryButtonText: continueButtonText!,
      onPrimaryButtonPressed: onContinue,
      autoHideDuration: autoHideDuration,
      icon: Icons.task_alt_rounded,
      // M3 icon for task completion
      showAppBar: showAppBar,
      appBarTitle: appBarTitle ?? '$actionName Successful!',
    );
  }

  /// Factory constructor for data saved successfully.
  factory SlSuccessStateWidget.saved({
    Key? key,
    required VoidCallback onContinue, // Typically to close dialog or navigate
    String title = 'Saved Successfully',
    String? message,
    String continueButtonText = 'OK',
    Color? accentColor, // Allow custom accent, defaults to green in original
    bool showAppBar = false,
    String? appBarTitle,
  }) {
    return SlSuccessStateWidget(
      key: key,
      title: title,
      message: message ?? 'Your changes have been saved.',
      primaryButtonText: continueButtonText,
      onPrimaryButtonPressed: onContinue,
      icon: Icons.save_alt_rounded,
      // M3 icon for save
      accentColor: accentColor,
      // Example: Colors.green.shade700
      showAppBar: showAppBar,
      appBarTitle: appBarTitle ?? title,
    );
  }

  /// Factory constructor for a compact notification-style success message.
  factory SlSuccessStateWidget.notification({
    Key? key,
    required String title,
    String? message,
    required VoidCallback onDismiss, // Primary action is to dismiss
    Duration? autoDismissDuration, // Suggestion for parent
    IconData icon = Icons.notifications_active_outlined, // M3 icon
  }) {
    return SlSuccessStateWidget(
      key: key,
      title: title,
      message: message,
      primaryButtonText: 'Dismiss',
      // Or an empty string if no button text is desired
      onPrimaryButtonPressed: onDismiss,
      compactMode: true,
      autoHideDuration: autoDismissDuration,
      icon: icon,
      showIcon: true, // Typically show icon for notifications
    );
  }

  // This helper might not be strictly necessary if SlPrimaryButton handles its own contrast.
  Color _getContrastColor(Color backgroundColor, ColorScheme colorScheme) {
    return backgroundColor.computeLuminance() > 0.5
        ? colorScheme
              .onSurface // Or a specific dark color like Colors.black
        : colorScheme.surface; // Or a specific light color like Colors.white
  }

  Widget _buildFullSuccess(
    BuildContext context,
    ThemeData theme,
    TextTheme textTheme,
    ColorScheme colorScheme,
    Color effectiveSuccessColor,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showIcon) ...[
          Container(
            width: AppDimens.iconXXL,
            height: AppDimens.iconXXL,
            decoration: BoxDecoration(
              color: effectiveSuccessColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: AppDimens.iconXL,
              color: effectiveSuccessColor,
            ),
          ),
          const SizedBox(height: AppDimens.spaceXL),
        ],
        Text(
          title,
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: effectiveSuccessColor, // Emphasize title with success color
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
        const SizedBox(height: AppDimens.spaceXXL),
        // More space before primary button
        SlPrimaryButton(
          // Replaced SlButton with SlPrimaryButton
          text: primaryButtonText,
          onPressed: onPrimaryButtonPressed,
          backgroundColor: effectiveSuccessColor,
          // SlPrimaryButton should ideally handle its foreground color.
          // If explicit control is needed:
          // foregroundColor: _getContrastColor(effectiveSuccessColor, colorScheme),
        ),
        if (secondaryButtonText != null &&
            onSecondaryButtonPressed != null) ...[
          const SizedBox(height: AppDimens.spaceM),
          SlTextButton(
            // Replaced SlButton with SlTextButton
            text: secondaryButtonText!,
            onPressed: onSecondaryButtonPressed!,
            foregroundColor: effectiveSuccessColor, // Align with success color
          ),
        ],
      ],
    );
  }

  Widget _buildCompactSuccess(
    BuildContext context,
    ThemeData theme,
    TextTheme textTheme,
    ColorScheme colorScheme,
    Color effectiveSuccessColor,
  ) {
    return Card(
      color: effectiveSuccessColor.withOpacity(0.08),
      // Subtle background tint
      elevation: 0,
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimens.paddingL,
        vertical: AppDimens.paddingS,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
        side: BorderSide(
          color: effectiveSuccessColor.withOpacity(0.4),
        ), // Subtle border
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingM),
        child: Row(
          children: [
            if (showIcon) ...[
              Icon(icon, color: effectiveSuccessColor, size: AppDimens.iconM),
              const SizedBox(width: AppDimens.spaceM),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: textTheme.titleSmall?.copyWith(
                      color: effectiveSuccessColor,
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
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            // "Dismiss" button for notification style
            // Only show if primaryButtonText is not empty, allowing for icon-only notifications
            if (primaryButtonText.isNotEmpty) ...[
              const SizedBox(width: AppDimens.spaceS),
              SlTextButton(
                // Replaced TextButton with SlTextButton
                text: primaryButtonText,
                onPressed: onPrimaryButtonPressed,
                foregroundColor: effectiveSuccessColor,
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
    // Use context.typography if available from your theme_extensions.dart
    final textTheme = theme.textTheme;
    final effectiveSuccessColor =
        accentColor ??
        colorScheme.primary; // Use primary color for success by default

    // The `autoHideDuration` logic has been removed from this widget.
    // The parent widget or ViewModel is responsible for handling auto-dismissal if needed.

    Widget successContent;
    if (compactMode) {
      successContent = _buildCompactSuccess(
        context,
        theme,
        textTheme,
        colorScheme,
        effectiveSuccessColor,
      );
    } else {
      successContent = _buildFullSuccess(
        context,
        theme,
        textTheme,
        colorScheme,
        effectiveSuccessColor,
      );
    }

    if (showAppBar) {
      return Scaffold(
        appBar: AppBarWithBack(
          title: appBarTitle ?? title,
          // For success screens, back navigation might be handled by primary/secondary actions
          // or simply pop the current screen.
          onBackPressed: () => Navigator.maybePop(context),
        ),
        body: Center(
          child: Padding(
            padding: compactMode
                ? EdgeInsets.zero
                : const EdgeInsets.all(AppDimens.paddingL),
            child: successContent,
          ),
        ),
      );
    }

    return Material(
      color: compactMode ? Colors.transparent : theme.scaffoldBackgroundColor,
      child: Center(
        child: Padding(
          // No padding for compact mode if it's meant to be like a toast/snackbar
          padding: compactMode
              ? EdgeInsets.zero
              : const EdgeInsets.all(AppDimens.paddingL),
          child: successContent,
        ),
      ),
    );
  }
}
