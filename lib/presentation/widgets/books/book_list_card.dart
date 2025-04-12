// lib/presentation/widgets/books/book_list_card.dart
import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/book.dart';

class BookListCard extends StatelessWidget {
  final BookSummary book;
  final VoidCallback onTap;

  const BookListCard({super.key, required this.book, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Compute a consistent color based on book name
    final bookNameHash = book.name.hashCode;
    final hue = (bookNameHash % 360).abs().toDouble();
    const saturation = 0.6;
    const lightness = 0.75;
    final coverColor =
        HSLColor.fromAHSL(1.0, hue, saturation, lightness).toColor();

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
              // Book "Cover" - a styled container with book icon
              Container(
                width: AppDimens.thumbnailSizeS, // 80.0
                height:
                    AppDimens.thumbnailSizeM *
                    0.85, // 102.0 (adjusted to maintain aspect ratio)
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [coverColor, coverColor.withValues(alpha: 0.8)],
                  ),
                  borderRadius: BorderRadius.circular(AppDimens.radiusM),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Pattern on cover
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppDimens.radiusM),
                      child: CustomPaint(
                        painter: _BookPatternPainter(
                          patternColor: Colors.white.withValues(alpha: 0.2),
                          lineCount: 3,
                        ),
                        size: const Size(
                          AppDimens.thumbnailSizeS,
                          AppDimens.thumbnailSizeM * 0.85,
                        ),
                      ),
                    ),

                    // Book title and icon
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.menu_book,
                            size: AppDimens.iconL,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                          const SizedBox(height: AppDimens.spaceXS),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppDimens.paddingXS,
                            ),
                            child: Text(
                              book.name,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Category badge at bottom
                    if (book.category != null)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.4),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(AppDimens.radiusM),
                              bottomRight: Radius.circular(AppDimens.radiusM),
                            ),
                          ),
                          child: Text(
                            book.category ?? '',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                              fontSize: 8,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

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

class _BookPatternPainter extends CustomPainter {
  final Color patternColor;
  final int lineCount;

  _BookPatternPainter({required this.patternColor, required this.lineCount});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = patternColor
          ..strokeWidth = 0.8
          ..style = PaintingStyle.stroke;

    // Horizontal lines
    final spacingY = size.height / (lineCount + 1);
    for (int i = 1; i <= lineCount; i++) {
      final y = spacingY * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Diagonal line
    canvas.drawLine(const Offset(0, 0), Offset(size.width, size.height), paint);

    // Border
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
