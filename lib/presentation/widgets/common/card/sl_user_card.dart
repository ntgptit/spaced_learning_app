// lib/presentation/widgets/common/card/sl_user_card.dart
import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/presentation/widgets/common/card/sl_card.dart';

enum SlUserCardSize { small, medium, large }

class SlUserCard extends StatelessWidget {
  final String displayName;
  final String? email;
  final String? role;
  final String? avatarUrl;
  final String? initials;
  final VoidCallback? onTap;
  final List<Widget>? actions;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color? backgroundColor;
  final SlUserCardSize size;
  final SlCardType cardType;
  final bool showEmail;
  final Widget? trailing;

  const SlUserCard({
    super.key,
    required this.displayName,
    this.email,
    this.role,
    this.avatarUrl,
    this.initials,
    this.onTap,
    this.actions,
    this.padding = const EdgeInsets.all(AppDimens.paddingL),
    this.margin = const EdgeInsets.symmetric(vertical: AppDimens.paddingS),
    this.backgroundColor,
    this.size = SlUserCardSize.medium,
    this.cardType = SlCardType.elevated,
    this.showEmail = true,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine avatar size based on card size
    final double avatarSize = _getAvatarSize();

    // Determine text styles based on card size
    final TextStyle nameStyle = _getNameStyle(theme);
    final TextStyle? subtitleStyle = _getSubtitleStyle(theme, colorScheme);

    return SlCard(
      type: cardType,
      backgroundColor: backgroundColor,
      padding: padding,
      margin: margin,
      onTap: onTap,
      child: Column(
        children: [
          Row(
            children: [
              _buildAvatar(context, avatarSize),
              const SizedBox(width: AppDimens.spaceL),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: nameStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (showEmail && email != null) ...[
                      const SizedBox(height: AppDimens.spaceXS),
                      Text(
                        email!,
                        style: subtitleStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (role != null) ...[
                      const SizedBox(height: AppDimens.spaceXS),
                      Text(
                        role!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          if (actions != null && actions!.isNotEmpty) ...[
            const SizedBox(height: AppDimens.spaceM),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: actions!),
          ],
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, double size) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: size / 2,
        backgroundImage: NetworkImage(avatarUrl!),
      );
    }

    // Use initials if available, otherwise use first letter of display name
    final String displayInitials =
        initials ??
        (displayName.isNotEmpty ? displayName[0].toUpperCase() : '?');

    return CircleAvatar(
      radius: size / 2,
      backgroundColor: colorScheme.primaryContainer,
      child: Text(
        displayInitials,
        style: theme.textTheme.titleLarge?.copyWith(
          color: colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  double _getAvatarSize() {
    switch (size) {
      case SlUserCardSize.small:
        return AppDimens.avatarSizeS;
      case SlUserCardSize.medium:
        return AppDimens.avatarSizeM;
      case SlUserCardSize.large:
        return AppDimens.avatarSizeL;
    }
  }

  TextStyle _getNameStyle(ThemeData theme) {
    switch (size) {
      case SlUserCardSize.small:
        return theme.textTheme.titleSmall!;
      case SlUserCardSize.medium:
        return theme.textTheme.titleMedium!;
      case SlUserCardSize.large:
        return theme.textTheme.titleLarge!;
    }
  }

  TextStyle? _getSubtitleStyle(ThemeData theme, ColorScheme colorScheme) {
    final baseStyle = colorScheme.onSurfaceVariant;

    switch (size) {
      case SlUserCardSize.small:
        return theme.textTheme.bodySmall?.copyWith(color: baseStyle);
      case SlUserCardSize.medium:
        return theme.textTheme.bodyMedium?.copyWith(color: baseStyle);
      case SlUserCardSize.large:
        return theme.textTheme.bodyLarge?.copyWith(color: baseStyle);
    }
  }
}
