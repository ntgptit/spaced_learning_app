import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/book.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_card.dart';

/// A card widget displaying book summary information synced with ModuleCard
class BookCard extends StatelessWidget {
  final BookSummary book;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry margin;

  const BookCard({
    super.key,
    required this.book,
    this.onTap,
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
          color: colorScheme.primary,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      leading: Container(
        width: AppDimens.avatarSizeL,
        height: AppDimens.avatarSizeL,
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(AppDimens.radiusM),
        ),
        child: Center(
          child: Text(
            '${book.moduleCount}',
            style: theme.textTheme.titleLarge!.copyWith(
              color: colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      subtitle:
          book.category != null
              ? Text(
                book.category!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              )
              : null,
      content: _buildContent(theme, colorScheme),
      trailing: Center(
        // Wrap the Icon in a Center widget to vertically center it
        child: Icon(
          Icons.navigate_next,
          color: colorScheme.onSurfaceVariant,
          size: AppDimens.iconM,
        ),
      ),
    );
  }

  Widget _buildContent(ThemeData theme, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.only(top: AppDimens.spaceL),
      child: Wrap(
        spacing: AppDimens.spaceS,
        runSpacing: AppDimens.spaceXS,
        children: [
          _buildStatusBadge(theme, colorScheme),
          ...?_buildDifficultyBadge(theme, colorScheme),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(ThemeData theme, ColorScheme colorScheme) {
    final (
      containerColor,
      onContainerColor,
      iconData,
      statusText,
    ) = switch (book.status) {
      BookStatus.published => (
        colorScheme.primaryContainer,
        colorScheme.onPrimaryContainer,
        Icons.check_circle,
        'Published',
      ),
      BookStatus.draft => (
        colorScheme.secondaryContainer,
        colorScheme.onSecondaryContainer,
        Icons.edit,
        'Draft',
      ),
      BookStatus.archived => (
        colorScheme.surfaceContainerHighest,
        colorScheme.onSurfaceVariant,
        Icons.archive,
        'Archived',
      ),
    };

    return _Badge(
      backgroundColor: containerColor,
      foregroundColor: onContainerColor,
      icon: iconData,
      text: statusText,
      textStyle: theme.textTheme.bodySmall!,
    );
  }

  List<Widget>? _buildDifficultyBadge(
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    if (book.difficultyLevel == null) return null;

    final (containerColor, onContainerColor, difficultyText) = switch (book
        .difficultyLevel!) {
      DifficultyLevel.beginner => (
        colorScheme.primaryContainer,
        colorScheme.onPrimaryContainer,
        'Beginner',
      ),
      DifficultyLevel.intermediate => (
        colorScheme.secondaryContainer,
        colorScheme.onSecondaryContainer,
        'Intermediate',
      ),
      DifficultyLevel.advanced => (
        colorScheme.tertiaryContainer,
        colorScheme.onTertiaryContainer,
        'Advanced',
      ),
      DifficultyLevel.expert => (
        colorScheme.errorContainer,
        colorScheme.onErrorContainer,
        'Expert',
      ),
    };

    return [
      _Badge(
        backgroundColor: containerColor,
        foregroundColor: onContainerColor,
        text: difficultyText,
        textStyle: theme.textTheme.bodySmall!,
      ),
    ];
  }
}

/// Private widget for reusable badge styling
class _Badge extends StatelessWidget {
  final Color backgroundColor;
  final Color foregroundColor;
  final IconData? icon;
  final String text;
  final TextStyle textStyle;

  const _Badge({
    required this.backgroundColor,
    required this.foregroundColor,
    this.icon,
    required this.text,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.paddingS,
        vertical: AppDimens.paddingXXS + 1,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: textStyle.fontSize ?? AppDimens.iconXS,
              color: foregroundColor,
            ),
            const SizedBox(width: AppDimens.spaceXXS),
          ],
          Text(
            text,
            style: textStyle.copyWith(
              color: foregroundColor,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
