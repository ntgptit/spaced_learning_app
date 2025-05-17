// lib/presentation/widgets/common/state/sl_unauthorized_state_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_bar_with_back.dart';
// Import specific buttons
import 'package:spaced_learning_app/presentation/widgets/common/button/sl_primary_button.dart';
import 'package:spaced_learning_app/presentation/widgets/common/button/sl_text_button.dart';

/// A widget to display when a user is unauthorized or needs to log in.
///
/// Offers factory constructors for common scenarios like session expiration,
/// login requirements, or insufficient permissions. Provides clear calls to action.
/// Can be displayed as a full screen with an AppBar or as an embedded component.
class SlUnauthorizedStateWidget extends ConsumerWidget {
  /// The main title of the message (e.g., "Access Denied").
  final String title;

  /// The detailed message explaining the unauthorized state.
  final String message;

  /// Text for the primary action button (e.g., "Login", "Request Access").
  final String primaryButtonText;

  /// Callback for the primary action button. This is required.
  final VoidCallback onPrimaryButtonPressed;

  /// Text for an optional secondary action button (e.g., "Go Back").
  final String? secondaryButtonText;

  /// Callback for the optional secondary action button.
  final VoidCallback? onSecondaryButtonPressed;

  /// Whether to display the icon.
  final bool showIcon;

  /// The icon to display. Defaults to a lock icon.
  final IconData icon;

  // New properties for AppBar integration
  final bool showAppBar;
  final String? appBarTitle;

  // onNavigateBack is primarily for the AppBar's back button if onSecondaryButtonPressed is not suitable.
  final VoidCallback? onNavigateBack;

  const SlUnauthorizedStateWidget({
    super.key,
    this.title = 'Access Denied',
    this.message = 'You don\'t have permission to access this content.',
    this.primaryButtonText = 'Login',
    required this.onPrimaryButtonPressed,
    this.secondaryButtonText,
    this.onSecondaryButtonPressed,
    this.showIcon = true,
    this.icon = Icons.lock_outline_rounded, // Default M3 lock icon
    this.showAppBar = false,
    this.appBarTitle,
    this.onNavigateBack,
  });

  /// Factory constructor for a session expired state.
  factory SlUnauthorizedStateWidget.sessionExpired({
    Key? key,
    required VoidCallback onLoginAgain,
    String title = 'Session Expired',
    String message =
        'Your session has expired. Please log in again to continue.',
    bool showAppBar = false,
    String? appBarTitle,
  }) {
    return SlUnauthorizedStateWidget(
      key: key,
      title: title,
      message: message,
      primaryButtonText: 'Login Again',
      onPrimaryButtonPressed: onLoginAgain,
      icon: Icons.refresh_rounded,
      // Icon indicating a refresh/re-login action
      showAppBar: showAppBar,
      appBarTitle: appBarTitle ?? title,
      // No explicit onNavigateBack here as login is the primary recovery.
      // AppBar back button will pop by default.
    );
  }

  /// Factory constructor for a state where login is required.
  factory SlUnauthorizedStateWidget.requiresLogin({
    Key? key,
    required VoidCallback onLogin,
    VoidCallback? onGoBack, // Secondary action to go back
    String title = 'Login Required',
    String message = 'You need to be logged in to access this feature.',
    String primaryButtonText = 'Login',
    String? goBackButtonText = 'Go Back', // Text for the go back button
    bool showAppBar = false,
    String? appBarTitle,
  }) {
    return SlUnauthorizedStateWidget(
      key: key,
      title: title,
      message: message,
      primaryButtonText: primaryButtonText,
      onPrimaryButtonPressed: onLogin,
      secondaryButtonText: onGoBack != null ? goBackButtonText : null,
      onSecondaryButtonPressed: onGoBack,
      icon: Icons.login_rounded,
      // M3 login icon
      showAppBar: showAppBar,
      appBarTitle: appBarTitle ?? title,
      onNavigateBack:
          onGoBack, // If AppBar is shown, its back button can use onGoBack
    );
  }

  /// Factory constructor for a state where the user has insufficient permissions.
  factory SlUnauthorizedStateWidget.insufficientPermissions({
    Key? key,
    VoidCallback? onRequestAccess, // Primary action might be to request access
    VoidCallback? onGoBack, // Secondary or alternative primary action
    String title = 'Access Restricted',
    String message =
        'You don\'t have sufficient permissions for this action or content.',
    String defaultPrimaryButtonText =
        'Go Back', // Used if onRequestAccess is null
    bool showAppBar = false,
    String? appBarTitle,
  }) {
    final bool canRequestAccess = onRequestAccess != null;
    final String effectivePrimaryText = canRequestAccess
        ? 'Request Access'
        : defaultPrimaryButtonText;
    final VoidCallback effectivePrimaryAction = canRequestAccess
        ? onRequestAccess
        : (onGoBack ?? () {});

    return SlUnauthorizedStateWidget(
      key: key,
      title: title,
      message: message,
      primaryButtonText: effectivePrimaryText,
      onPrimaryButtonPressed: effectivePrimaryAction,
      // Secondary "Go Back" button if "Request Access" is primary and onGoBack is available
      secondaryButtonText: canRequestAccess && onGoBack != null
          ? 'Go Back'
          : null,
      onSecondaryButtonPressed: canRequestAccess ? onGoBack : null,
      icon: Icons.gpp_maybe_outlined,
      // M3 icon for permission issues
      showAppBar: showAppBar,
      appBarTitle: appBarTitle ?? title,
      onNavigateBack: onGoBack,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    // Use context.typography if available from your theme_extensions.dart
    final textTheme = theme.textTheme;

    // Use a neutral container color for the icon background, or errorContainer for strong emphasis.
    // For unauthorized, secondary or tertiary often works well to not be too alarming.
    final iconContainerColor = colorScheme.secondaryContainer;
    final onIconContainerColor = colorScheme.onSecondaryContainer;

    Widget unauthorizedContent = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showIcon) ...[
          Container(
            width: AppDimens.iconXXL,
            height: AppDimens.iconXXL,
            decoration: BoxDecoration(
              color: iconContainerColor.withOpacity(0.7),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: AppDimens.iconXL,
              color: onIconContainerColor,
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
        const SizedBox(height: AppDimens.spaceXL),
        // Space before the primary button
        SlPrimaryButton(
          // Replaced SlButton with SlPrimaryButton
          text: primaryButtonText,
          onPressed: onPrimaryButtonPressed,
          // Icon can be passed to SlPrimaryButton if it supports it and if relevant
          // prefixIcon: iconForPrimaryAction, (e.g. Icons.login for login button)
        ),
        if (secondaryButtonText != null &&
            onSecondaryButtonPressed != null) ...[
          const SizedBox(height: AppDimens.spaceM),
          SlTextButton(
            // Replaced SlButton with SlTextButton
            text: secondaryButtonText!,
            onPressed: onSecondaryButtonPressed!,
            // foregroundColor: colorScheme.primary, // Optional: specific color
          ),
        ],
        // Standalone navigate back button if no secondary action and not in AppBar mode
        if (secondaryButtonText == null &&
            onSecondaryButtonPressed == null &&
            onNavigateBack != null &&
            !showAppBar) ...[
          const SizedBox(height: AppDimens.spaceM),
          SlTextButton(
            text: 'Go Back', // Default text, consider making it configurable
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
          // Back action for AppBar: prioritize onSecondaryButtonPressed if it's for "Go Back",
          // then onNavigateBack, then default pop.
          onBackPressed:
              onSecondaryButtonPressed ??
              onNavigateBack ??
              () => Navigator.maybePop(context),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.paddingXL),
            child: unauthorizedContent,
          ),
        ),
      );
    }

    return Material(
      color: theme.scaffoldBackgroundColor,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.paddingXL),
          child: unauthorizedContent,
        ),
      ),
    );
  }
}
