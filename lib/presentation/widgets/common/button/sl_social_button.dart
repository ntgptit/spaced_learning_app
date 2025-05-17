// lib/presentation/widgets/common/button/sl_social_button.dart
import 'package:flutter/material.dart';
import 'package:spaced_learning_app/presentation/widgets/common/button/sl_button.dart';

enum SocialButtonType { google, facebook, apple, twitter, github, custom }

class SlSocialButton extends StatelessWidget {
  final SocialButtonType type;
  final String text;
  final VoidCallback? onPressed;
  final IconData? customIcon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool isLoading;
  final bool isFullWidth;

  const SlSocialButton({
    super.key,
    required this.type,
    required this.text,
    this.onPressed,
    this.customIcon,
    this.backgroundColor,
    this.foregroundColor,
    this.isLoading = false,
    this.isFullWidth = false,
  }) : assert(
         type != SocialButtonType.custom || customIcon != null,
         'customIcon must be provided for custom type',
       );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SlButton(
      text: text,
      onPressed: onPressed,
      prefixIcon: _getIcon(),
      isLoading: isLoading,
      isFullWidth: isFullWidth,
      variant: SlButtonVariant.outlined,
      backgroundColor: backgroundColor ?? Colors.transparent,
      foregroundColor: foregroundColor ?? colorScheme.onSurface,
    );
  }

  IconData? _getIcon() {
    if (type == SocialButtonType.custom) {
      return customIcon;
    }

    // Default icons for social platforms
    switch (type) {
      case SocialButtonType.google:
        return Icons
            .g_mobiledata; // Placeholder - use actual Google icon in a real app
      case SocialButtonType.facebook:
        return Icons.facebook;
      case SocialButtonType.apple:
        return Icons.apple;
      case SocialButtonType.twitter:
        return Icons.tag;
      case SocialButtonType.github:
        return Icons.code;
      default:
        return null;
    }
  }
}
