// lib/presentation/widgets/books/book_card.dart
import 'package:flutter/material.dart';
import 'package:spaced_learning_app/domain/models/book.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_button.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_card.dart';

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

    // Create a badge for the book status
    Widget statusBadge() {
      Color badgeColor;
      IconData iconData;
      String statusText;

      switch (book.status) {
        case BookStatus.published:
          badgeColor = Colors.green;
          iconData = Icons.check_circle;
          statusText = 'Published';
          break;
        case BookStatus.draft:
          badgeColor = Colors.amber;
          iconData = Icons.edit;
          statusText = 'Draft';
          break;
        case BookStatus.archived:
          badgeColor = Colors.grey;
          iconData = Icons.archive;
          statusText = 'Archived';
          break;
      }

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: badgeColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: badgeColor.withValues(alpha: 0.5)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(iconData, size: 12, color: badgeColor),
            const SizedBox(width: 4),
            Text(
              statusText,
              style: theme.textTheme.bodySmall!.copyWith(
                color: badgeColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    // Create a badge for difficulty level
    Widget? difficultyBadge() {
      if (book.difficultyLevel == null) return null;

      Color badgeColor;
      String difficultyText;

      switch (book.difficultyLevel) {
        case DifficultyLevel.beginner:
          badgeColor = Colors.green;
          difficultyText = 'Beginner';
          break;
        case DifficultyLevel.intermediate:
          badgeColor = Colors.blue;
          difficultyText = 'Intermediate';
          break;
        case DifficultyLevel.advanced:
          badgeColor = Colors.orange;
          difficultyText = 'Advanced';
          break;
        case DifficultyLevel.expert:
          badgeColor = Colors.red;
          difficultyText = 'Expert';
          break;
        default:
          return null;
      }

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: badgeColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: badgeColor.withValues(alpha: 0.5)),
        ),
        child: Text(
          difficultyText,
          style: theme.textTheme.bodySmall!.copyWith(
            color: badgeColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return AppCard(
      onTap: onTap,
      margin: margin,
      title: Text(book.name),
      subtitle: book.category != null ? Text(book.category!) : null,
      trailing: Container(
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
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              statusBadge(),
              if (difficultyBadge() != null) difficultyBadge()!,
            ],
          ),
        ],
      ),
      actions: [
        if (onStartPressed != null && book.status == BookStatus.published)
          AppButton(
            text: 'Start Learning',
            onPressed: onStartPressed,
            type: AppButtonType.primary,
            size: AppButtonSize.small,
            prefixIcon: Icons.play_arrow,
          ),
      ],
    );
  }
}
