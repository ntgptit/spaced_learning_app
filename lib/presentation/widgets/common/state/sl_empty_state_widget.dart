// lib/presentation/widgets/common/state/sl_empty_state_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/presentation/widgets/common/button/sl_primary_button.dart';
import 'package:spaced_learning_app/presentation/widgets/common/button/sl_text_button.dart';

enum SlEmptyStateType { general, noResults, noData, firstUse }

class SlEmptyStateWidget extends ConsumerWidget {
  final String title;
  final String? message;
  final IconData? icon;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  final IconData? buttonIcon;
  final Widget? customImage;
  final Color? iconColor;
  final bool showGradientBackground;
  final SlEmptyStateType type; // To distinguish button types if needed

  const SlEmptyStateWidget({
    super.key,
    required this.title,
    this.message,
    this.icon = Icons.inbox_outlined,
    this.buttonText,
    this.onButtonPressed,
    this.buttonIcon,
    this.customImage,
    this.iconColor,
    this.showGradientBackground = false,
    this.type = SlEmptyStateType.general,
  });

  factory SlEmptyStateWidget.noResults({
    Key? key,
    String? message,
    VoidCallback? onResetFilters,
  }) {
    return SlEmptyStateWidget(
      key: key,
      title: 'No Results Found',
      message:
          message ??
          'We couldn\'t find any matches for your search or filters.',
      icon: Icons.search_off_rounded,
      buttonText: onResetFilters != null ? 'Reset Filters' : null,
      onButtonPressed: onResetFilters,
      buttonIcon: onResetFilters != null ? Icons.filter_alt_off_outlined : null,
      type: SlEmptyStateType.noResults,
    );
  }

  factory SlEmptyStateWidget.noData({
    Key? key,
    String title = 'No Data Available',
    String? message,
    String? buttonText,
    VoidCallback? onButtonPressed,
    IconData icon = Icons.dataset_outlined,
    IconData? buttonIcon,
  }) {
    return SlEmptyStateWidget(
      key: key,
      title: title,
      message:
          message ??
          'There\'s nothing here yet. Try adding some data or check back later.',
      icon: icon,
      buttonText: buttonText,
      onButtonPressed: onButtonPressed,
      buttonIcon: buttonText != null
          ? (buttonIcon ?? Icons.add_circle_outline_rounded)
          : null,
      type: SlEmptyStateType.noData,
    );
  }

  factory SlEmptyStateWidget.firstUse({
    Key? key,
    required String title,
    required String message,
    required String buttonText,
    required VoidCallback onButtonPressed,
    IconData icon = Icons.lightbulb_outline_rounded,
    IconData buttonIcon = Icons.arrow_forward_rounded,
    Color? iconColor, // Will default to primary if null
    bool showGradientBackground = true,
  }) {
    return SlEmptyStateWidget(
      key: key,
      title: title,
      message: message,
      icon: icon,
      buttonText: buttonText,
      onButtonPressed: onButtonPressed,
      buttonIcon: buttonIcon,
      showGradientBackground: showGradientBackground,
      iconColor: iconColor,
      type: SlEmptyStateType.firstUse,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme; // Or context.typography if available
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
              Padding(
                padding: const EdgeInsets.only(bottom: AppDimens.spaceXL),
                child: customImage!,
              )
            else if (icon != null)
              Container(
                width: AppDimens.iconXXL,
                height: AppDimens.iconXXL,
                decoration: BoxDecoration(
                  color: showGradientBackground
                      ? null
                      : effectiveIconColor.withOpacity(0.1),
                  gradient: showGradientBackground
                      ? LinearGradient(
                          colors: [
                            effectiveIconColor.withOpacity(0.05),
                            effectiveIconColor.withOpacity(0.15),
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
                  color: effectiveIconColor.withOpacity(
                    showGradientBackground ? 1.0 : 0.8,
                  ),
                ),
              ),
            const SizedBox(height: AppDimens.spaceXL),
            Text(
              title,
              textAlign: TextAlign.center,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            if (message != null && message!.isNotEmpty) ...[
              const SizedBox(height: AppDimens.spaceS),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.paddingL,
                ),
                child: Text(
                  message!,
                  textAlign: TextAlign.center,
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
            if (buttonText != null && onButtonPressed != null) ...[
              const SizedBox(height: AppDimens.spaceXL),
              if (type == SlEmptyStateType.noResults)
                SlTextButton(
                  text: buttonText!,
                  onPressed: onButtonPressed!,
                  prefixIcon: buttonIcon,
                  foregroundColor: colorScheme.primary,
                )
              else
                SlPrimaryButton(
                  text: buttonText!,
                  onPressed: onButtonPressed!,
                  prefixIcon: buttonIcon,
                ),
            ],
          ],
        ),
      ),
    );
  }
}
