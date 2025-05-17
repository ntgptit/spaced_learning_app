// lib/presentation/widgets/common/state/sl_empty_state_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_button.dart'; // Assuming SLButton is here

class SlEmptyStateWidget extends ConsumerWidget {
  final String title;
  final String? message;
  final IconData? icon;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  final Widget? customImage;
  final Color? iconColor;
  final bool showGradientBackground;

  const SlEmptyStateWidget({
    super.key,
    required this.title,
    this.message,
    this.icon = Icons.inbox_outlined,
    this.buttonText,
    this.onButtonPressed,
    this.customImage,
    this.iconColor,
    this.showGradientBackground = false,
  });

  // Factory constructor for "No Results" state
  factory SlEmptyStateWidget.noResults({
    String? message,
    VoidCallback? onResetFilters,
  }) {
    return SlEmptyStateWidget(
      title: 'No Results Found',
      message:
          message ??
          'We couldn\'t find any matches for your search or filters.',
      icon: Icons.search_off_rounded,
      buttonText: onResetFilters != null ? 'Reset Filters' : null,
      onButtonPressed: onResetFilters,
    );
  }

  // Factory constructor for "No Data" state
  factory SlEmptyStateWidget.noData({
    String? title = 'No Data Available',
    String? message,
    String? buttonText,
    VoidCallback? onButtonPressed,
    IconData icon = Icons.inbox_outlined,
  }) {
    return SlEmptyStateWidget(
      title: title!,
      message:
          message ??
          'There\'s nothing here yet. Try adding some data or check back later.',
      icon: icon,
      buttonText: buttonText,
      onButtonPressed: onButtonPressed,
    );
  }

  // Factory constructor for "First Use" or "Get Started" state
  factory SlEmptyStateWidget.firstUse({
    required String title,
    required String message,
    required String buttonText,
    required VoidCallback onButtonPressed,
    IconData icon = Icons.lightbulb_outline,
    Color? iconColor, // Allow custom icon color
  }) {
    return SlEmptyStateWidget(
      title: title,
      message: message,
      icon: icon,
      buttonText: buttonText,
      onButtonPressed: onButtonPressed,
      showGradientBackground: true,
      // Often good for a welcome/first-use screen
      iconColor: iconColor ?? Colors.amber, // Default to amber if not provided
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final effectiveIconColor = iconColor ?? colorScheme.primary;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (customImage != null)
              customImage!
            else if (icon !=
                null) // Ensure icon is not null before creating Container
              Container(
                width: AppDimens.iconXXL,
                height: AppDimens.iconXXL,
                decoration: BoxDecoration(
                  color: showGradientBackground
                      ? null
                      : effectiveIconColor.withValues(alpha: 0.1),
                  gradient: showGradientBackground
                      ? LinearGradient(
                          colors: [
                            effectiveIconColor.withValues(alpha: 0.05),
                            effectiveIconColor.withValues(alpha: 0.15),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: AppDimens.iconXL,
                  color: effectiveIconColor.withValues(alpha: 0.8),
                ),
              ),
            const SizedBox(height: AppDimens.spaceXL),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            if (message != null) ...[
              const SizedBox(height: AppDimens.spaceS),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.paddingL,
                ),
                child: Text(
                  message!,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
            if (buttonText != null && onButtonPressed != null) ...[
              const SizedBox(height: AppDimens.spaceXL),
              SLButton(
                text: buttonText!,
                onPressed: onButtonPressed,
                type: SLButtonType.primary, // Or tonal for a softer look
                prefixIcon: Icons
                    .add_circle_outline, // Example, make it dynamic if needed
              ),
            ],
          ],
        ),
      ),
    );
  }
}
