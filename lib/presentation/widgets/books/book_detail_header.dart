import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/book.dart';
import 'package:spaced_learning_app/presentation/widgets/books/book_cover.dart';
import 'package:spaced_learning_app/presentation/widgets/books/info_chip.dart';

class BookDetailHeader extends StatelessWidget {
  final BookDetail book;
  const BookDetailHeader({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final statusColor = _getStatusColor(book.status);

    return Padding(
      padding: const EdgeInsets.all(AppDimens.paddingL),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: 'book-${book.id}',
            child: BookCoverWidget(book: book, width: 80, height: 150),
          ),
          const SizedBox(width: AppDimens.spaceL),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.name,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppDimens.spaceXS),
                Row(
                  children: [
                    InfoChipWidget(
                      label: _formatStatus(book.status),
                      backgroundColor: statusColor.withValues(alpha: 0.2),
                      textColor: statusColor,
                    ),
                    if (book.difficultyLevel != null) ...[
                      const SizedBox(width: AppDimens.spaceXS),
                      InfoChipWidget(
                        label: book.difficultyLevel!.name,
                        backgroundColor: colorScheme.secondaryContainer,
                        textColor: colorScheme.onSecondaryContainer,
                      ),
                    ],
                  ],
                ),
                if (book.category != null) ...[
                  const SizedBox(height: AppDimens.spaceXS),
                  InfoChipWidget(
                    label: book.category!,
                    backgroundColor: colorScheme.tertiaryContainer,
                    textColor: colorScheme.onTertiaryContainer,
                    icon: Icons.category_outlined,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(BookStatus status) {
    switch (status) {
      case BookStatus.published:
        return Colors.green;
      case BookStatus.draft:
        return Colors.orange;
      case BookStatus.archived:
        return Colors.grey;
    }
  }

  String _formatStatus(BookStatus status) {
    switch (status) {
      case BookStatus.published:
        return 'Published';
      case BookStatus.draft:
        return 'Draft';
      case BookStatus.archived:
        return 'Archived';
    }
  }
}
