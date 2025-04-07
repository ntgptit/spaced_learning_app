import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/book.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_button.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_card.dart';

/// A card widget displaying book summary information
class BookCard extends StatelessWidget {
  final BookSummary book;
  final VoidCallback? onTap;
  final VoidCallback? onStartPressed;
  final EdgeInsetsGeometry margin;

  const BookCard({
    super.key,
    required this.book,
    this.onTap,
    this.onStartPressed,
    this.margin = const EdgeInsets.symmetric(
      vertical: AppDimens.paddingS,
      horizontal: AppDimens.paddingL,
    ),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppCard(
      onTap: onTap,
      margin: margin,
      title: Text(
        book.name,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface,
        ),
      ),
      subtitle:
          book.category != null
              ? Text(
                book.category!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              )
              : null,
      trailing: _buildModuleCountBadge(theme, colorScheme),
      content: _buildContent(theme, colorScheme),
      actions: _buildActions(),
    );
  }

  // UI Components
  Widget _buildModuleCountBadge(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      width: AppDimens.moduleIndicatorSize,
      height: AppDimens.moduleIndicatorSize,
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '${book.moduleCount}',
          style: theme.textTheme.titleSmall!.copyWith(
            color: colorScheme.onSecondaryContainer,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildContent(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppDimens.spaceS),
        Wrap(
          spacing: AppDimens.spaceS,
          runSpacing: AppDimens.spaceXS,
          children: [
            _buildStatusBadge(theme, colorScheme),
            if (_buildDifficultyBadge(theme, colorScheme) != null)
              _buildDifficultyBadge(theme, colorScheme)!,
          ],
        ),
      ],
    );
  }

  Widget _buildStatusBadge(ThemeData theme, ColorScheme colorScheme) {
    final (badgeColor, iconData, statusText) = switch (book.status) {
      BookStatus.published => (
        colorScheme.primary,
        Icons.check_circle,
        'Published',
      ),
      BookStatus.draft => (colorScheme.secondary, Icons.edit, 'Draft'),
      BookStatus.archived => (
        colorScheme.onSurfaceVariant,
        Icons.archive,
        'Archived',
      ),
    };

    return _Badge(
      color: badgeColor,
      icon: iconData,
      text: statusText,
      textStyle: theme.textTheme.labelSmall!.copyWith(
        color: badgeColor,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget? _buildDifficultyBadge(ThemeData theme, ColorScheme colorScheme) {
    if (book.difficultyLevel == null) return null;

    final (badgeColor, difficultyText) = switch (book.difficultyLevel!) {
      DifficultyLevel.beginner => (colorScheme.primary, 'Beginner'),
      DifficultyLevel.intermediate => (colorScheme.secondary, 'Intermediate'),
      DifficultyLevel.advanced => (colorScheme.tertiary, 'Advanced'),
      DifficultyLevel.expert => (colorScheme.error, 'Expert'),
    };

    return _Badge(
      color: badgeColor,
      text: difficultyText,
      textStyle: theme.textTheme.labelSmall!.copyWith(
        color: badgeColor,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  List<Widget> _buildActions() {
    return [
      if (onStartPressed != null && book.status == BookStatus.published)
        AppButton(
          text: 'Start Learning',
          onPressed: onStartPressed,
          type: AppButtonType.primary,
          size: AppButtonSize.small,
          prefixIcon: Icons.play_arrow,
        ),
    ];
  }
}

/// Private widget for reusable badge styling
class _Badge extends StatelessWidget {
  final Color color;
  final IconData? icon;
  final String text;
  final TextStyle textStyle;

  const _Badge({
    required this.color,
    this.icon,
    required this.text,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.paddingS,
        vertical: AppDimens.paddingXXS,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: AppDimens.iconXS, color: color),
            const SizedBox(width: AppDimens.spaceXXS),
          ],
          Text(
            text,
            style: textStyle.copyWith(
              color:
                  colorScheme.brightness == Brightness.dark
                      ? color.withValues(alpha: 0.9)
                      : color,
            ),
          ),
        ],
      ),
    );
  }
}
