import 'package:flutter/material.dart';
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
    this.margin = const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppCard(
      onTap: onTap,
      margin: margin,
      title: Text(book.name),
      subtitle: book.category != null ? Text(book.category!) : null,
      trailing: _buildModuleCountBadge(theme, colorScheme),
      content: _buildContent(theme),
      actions: _buildActions(),
    );
  }

  // UI Components
  Widget _buildModuleCountBadge(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          '${book.moduleCount}',
          style: theme.textTheme.titleLarge!.copyWith(
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
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
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
      BookStatus.published => (Colors.green, Icons.check_circle, 'Published'),
      BookStatus.draft => (Colors.amber, Icons.edit, 'Draft'),
      BookStatus.archived => (Colors.grey, Icons.archive, 'Archived'),
    };

    return _Badge(
      color: badgeColor,
      icon: iconData,
      text: statusText,
      textStyle: theme.textTheme.bodySmall!.copyWith(
        color: badgeColor,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget? _buildDifficultyBadge(ThemeData theme) {
    if (book.difficultyLevel == null) return null;

    final (badgeColor, difficultyText) = switch (book.difficultyLevel!) {
      DifficultyLevel.beginner => (Colors.green, 'Beginner'),
      DifficultyLevel.intermediate => (Colors.blue, 'Intermediate'),
      DifficultyLevel.advanced => (Colors.orange, 'Advanced'),
      DifficultyLevel.expert => (Colors.red, 'Expert'),
    };

    return _Badge(
      color: badgeColor,
      text: difficultyText,
      textStyle: theme.textTheme.bodySmall!.copyWith(
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
          ],
          Text(text, style: textStyle),
        ],
      ),
    );
  }
}
