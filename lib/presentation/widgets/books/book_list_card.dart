import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/book.dart';

import 'book_cover.dart'; // Import widget mới

class BookListCard extends StatelessWidget {
  final BookSummary book;
  final VoidCallback onTap;

  const BookListCard({super.key, required this.book, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: AppDimens.elevationS,
      margin: const EdgeInsets.only(bottom: AppDimens.paddingM),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusL),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.paddingM),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sử dụng BookCover widget
              BookCover(book: book, theme: theme),

              // Spacing
              const SizedBox(width: AppDimens.spaceL),

              // Book details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      book.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: AppDimens.spaceS),

                    // Module count
                    Row(
                      children: [
                        Icon(
                          Icons.library_books_outlined,
                          size: AppDimens.iconS,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: AppDimens.spaceXS),
                        Text(
                          '${book.moduleCount} ${book.moduleCount == 1 ? 'module' : 'modules'}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppDimens.spaceS),

                    // Status and difficulty badges
                    Row(
                      children: [
                        _buildStatusBadge(book.status, theme),
                        if (book.difficultyLevel != null) ...[
                          const SizedBox(width: AppDimens.spaceXS),
                          _buildDifficultyBadge(book.difficultyLevel!, theme),
                        ],
                      ],
                    ),

                    // Timestamps
                    if (book.createdAt != null) ...[
                      const SizedBox(height: AppDimens.spaceS),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: AppDimens.iconXS,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: AppDimens.spaceXXS),
                          Text(
                            'Created: ${_formatDate(book.createdAt!)}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // Navigation chevron
              Icon(
                Icons.chevron_right,
                color: colorScheme.onSurfaceVariant,
                size: AppDimens.iconL,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Các phương thức còn lại (_buildStatusBadge, _buildDifficultyBadge, _formatDate) giữ nguyên
  Widget _buildStatusBadge(BookStatus status, ThemeData theme) {
    final colorScheme = theme.colorScheme;

    Color backgroundColor;
    Color textColor;
    String label;

    switch (status) {
      case BookStatus.published:
        backgroundColor = Colors.green.withValues(alpha: 0.2);
        textColor = Colors.green.shade800;
        label = 'Published';
        break;
      case BookStatus.draft:
        backgroundColor = colorScheme.secondary.withValues(alpha: 0.2);
        textColor = colorScheme.secondary;
        label = 'Draft';
        break;
      case BookStatus.archived:
        backgroundColor = Colors.grey.withValues(alpha: 0.2);
        textColor = Colors.grey.shade700;
        label = 'Archived';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.paddingXS,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppDimens.radiusS),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDifficultyBadge(DifficultyLevel level, ThemeData theme) {
    final colorScheme = theme.colorScheme;

    Color backgroundColor;
    Color textColor;
    String label;

    switch (level) {
      case DifficultyLevel.beginner:
        backgroundColor = Colors.green.withValues(alpha: 0.2);
        textColor = Colors.green.shade800;
        label = 'Beginner';
        break;
      case DifficultyLevel.intermediate:
        backgroundColor = colorScheme.tertiary.withValues(alpha: 0.2);
        textColor = colorScheme.tertiary;
        label = 'Intermediate';
        break;
      case DifficultyLevel.advanced:
        backgroundColor = colorScheme.secondary.withValues(alpha: 0.2);
        textColor = colorScheme.secondary;
        label = 'Advanced';
        break;
      case DifficultyLevel.expert:
        backgroundColor = colorScheme.error.withValues(alpha: 0.2);
        textColor = colorScheme.error;
        label = 'Expert';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.paddingXS,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppDimens.radiusS),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
