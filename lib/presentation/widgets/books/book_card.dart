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
      content: _buildContent(theme),
      actions: _buildActions(),
    );
  }

  // UI Components
  Widget _buildModuleCountBadge(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      width: AppDimens.moduleIndicatorSize,
      height: AppDimens.moduleIndicatorSize,
      decoration: BoxDecoration(
        color: colorScheme.primary.withOpacity(AppDimens.opacityMedium),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '${book.moduleCount}',
          style: theme.textTheme.titleSmall!.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildContent(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppDimens.spaceS),
        Wrap(
          spacing: AppDimens.spaceXS + 2, // 6
          runSpacing: AppDimens.spaceXS, // 4
          children: [
            _buildStatusBadge(theme),
            if (_buildDifficultyBadge(theme) != null)
              _buildDifficultyBadge(theme)!,
          ],
        ),
      ],
    );
  }

  Widget _buildStatusBadge(ThemeData theme) {
    final (badgeColor, iconData, statusText) = switch (book.status) {
      BookStatus.published => (
        Colors.green.shade600,
        Icons.check_circle,
        'Published',
      ),
      BookStatus.draft => (Colors.amber.shade700, Icons.edit, 'Draft'),
      BookStatus.archived => (Colors.grey.shade600, Icons.archive, 'Archived'),
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

  Widget? _buildDifficultyBadge(ThemeData theme) {
    if (book.difficultyLevel == null) return null;

    final (badgeColor, difficultyText) = switch (book.difficultyLevel!) {
      DifficultyLevel.beginner => (Colors.green.shade600, 'Beginner'),
      DifficultyLevel.intermediate => (Colors.blue.shade600, 'Intermediate'),
      DifficultyLevel.advanced => (Colors.orange.shade600, 'Advanced'),
      DifficultyLevel.expert => (Colors.red.shade600, 'Expert'),
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
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.paddingXS + 2, // 6
        vertical: AppDimens.paddingXXS, // 2
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(AppDimens.opacityMedium),
        borderRadius: BorderRadius.circular(AppDimens.radiusM), // 12
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: AppDimens.iconXS, color: color),
            const SizedBox(width: AppDimens.spaceXXS), // 2
          ],
          Text(text, style: textStyle),
        ],
      ),
    );
  }
}
