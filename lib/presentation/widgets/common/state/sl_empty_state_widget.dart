// lib/presentation/widgets/common/states/sl_empty_state_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

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
            else
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
              ElevatedButton.icon(
                onPressed: onButtonPressed,
                icon: const Icon(Icons.add),
                label: Text(buttonText!),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.paddingXXL,
                    vertical: AppDimens.paddingM,
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
  factory SlEmptyStateWidget.noResults({
    String? message,
    VoidCallback? onReset,
  }) {
    return SlEmptyStateWidget(
      title: 'No Results Found',
      message: message ?? 'We couldn\'t find any matches for your search.',
      icon: Icons.search_off,
      buttonText: onReset != null ? 'Reset Filters' : null,
      onButtonPressed: onReset,
    );
  }

  factory SlEmptyStateWidget.noData({
    String? message,
    String? buttonText,
    VoidCallback? onButtonPressed,
  }) {
    return SlEmptyStateWidget(
      title: 'No Data Available',
      message: message ?? 'There\'s nothing here yet.',
      icon: Icons.inbox_outlined,
      buttonText: buttonText,
      onButtonPressed: onButtonPressed,
    );
  }

  factory SlEmptyStateWidget.firstUse({
    required String title,
    required String message,
    required String buttonText,
    required VoidCallback onButtonPressed,
    IconData icon = Icons.lightbulb_outline,
  }) {
    return SlEmptyStateWidget(
      title: title,
      message: message,
      icon: icon,
      buttonText: buttonText,
      onButtonPressed: onButtonPressed,
      showGradientBackground: true,
      iconColor: Colors.amber,
    );
  }
}
