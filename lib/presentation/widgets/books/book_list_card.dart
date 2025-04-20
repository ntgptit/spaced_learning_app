import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/extensions/color_extensions.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/book.dart';

import 'book_cover.dart';

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
              BookCover(book: book, theme: theme),

              const SizedBox(width: AppDimens.spaceL),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: AppDimens.spaceS),

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

                    Row(
                      children: [
                        _buildStatusBadge(book.status, theme, colorScheme),
                        if (book.difficultyLevel != null) ...[
                          const SizedBox(width: AppDimens.spaceXS),
                          _buildDifficultyBadge(
                            book.difficultyLevel!,
                            theme,
                            colorScheme,
                          ),
                        ],
                      ],
                    ),

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

  Widget _buildStatusBadge(
    BookStatus status,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    Color backgroundColor;
    Color textColor;
    String label;

    switch (status) {
      case BookStatus.published:
        backgroundColor = colorScheme.success.withValues(
          alpha: AppDimens.opacityLight,
        );
        textColor = colorScheme.success;
        label = 'Published';
        break;
      case BookStatus.draft:
        backgroundColor = colorScheme.secondary.withValues(
          alpha: AppDimens.opacityLight,
        );
        textColor = colorScheme.secondary;
        label = 'Draft';
        break;
      case BookStatus.archived:
        backgroundColor = colorScheme.onSurfaceVariant.withValues(
          alpha: AppDimens.opacityLight,
        );
        textColor = colorScheme.onSurfaceVariant;
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

  Widget _buildDifficultyBadge(
    DifficultyLevel level,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    Color backgroundColor;
    Color textColor;
    String label;

    switch (level) {
      case DifficultyLevel.beginner:
        backgroundColor = colorScheme.success.withValues(
          alpha: AppDimens.opacityLight,
        );
        textColor = colorScheme.success;
        label = 'Beginner';
        break;
      case DifficultyLevel.intermediate:
        backgroundColor = colorScheme.tertiary.withValues(
          alpha: AppDimens.opacityLight,
        );
        textColor = colorScheme.tertiary;
        label = 'Intermediate';
        break;
      case DifficultyLevel.advanced:
        backgroundColor = colorScheme.secondary.withValues(
          alpha: AppDimens.opacityLight,
        );
        textColor = colorScheme.secondary;
        label = 'Advanced';
        break;
      case DifficultyLevel.expert:
        backgroundColor = colorScheme.error.withValues(
          alpha: AppDimens.opacityLight,
        );
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
