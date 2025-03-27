import 'package:flutter/material.dart';
import 'package:spaced_learning_app/domain/models/book.dart';

/// Card widget to display book summary information
class BookCard extends StatelessWidget {
  final BookSummary book;
  final VoidCallback onTap;
  final bool showStatus;
  final bool isActive;

  const BookCard({
    super.key,
    required this.book,
    required this.onTap,
    this.showStatus = true,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine status color
    Color statusColor;
    switch (book.status) {
      case BookStatus.published:
        statusColor = Colors.green;
        break;
      case BookStatus.draft:
        statusColor = Colors.amber;
        break;
      case BookStatus.archived:
        statusColor = Colors.grey;
        break;
    }

    // Determine difficulty color
    Color difficultyColor;
    String difficultyText = 'Unknown';

    if (book.difficultyLevel != null) {
      switch (book.difficultyLevel!) {
        case DifficultyLevel.beginner:
          difficultyColor = Colors.green;
          difficultyText = 'Beginner';
          break;
        case DifficultyLevel.intermediate:
          difficultyColor = Colors.blue;
          difficultyText = 'Intermediate';
          break;
        case DifficultyLevel.advanced:
          difficultyColor = Colors.orange;
          difficultyText = 'Advanced';
          break;
        case DifficultyLevel.expert:
          difficultyColor = Colors.red;
          difficultyText = 'Expert';
          break;
      }
    } else {
      difficultyColor = Colors.grey;
    }

    return Card(
      elevation: isActive ? 4 : 2,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side:
            isActive
                ? BorderSide(color: colorScheme.primary, width: 2)
                : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      book.name,
                      style: theme.textTheme.titleLarge,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (showStatus)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _formatStatus(book.status),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Display category if available
                  if (book.category != null) ...[
                    Chip(
                      label: Text(
                        book.category!,
                        style: theme.textTheme.bodySmall,
                      ),
                      backgroundColor: colorScheme.surfaceContainerHighest,
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    ),
                    const SizedBox(width: 8),
                  ],

                  // Display difficulty level
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: difficultyColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      difficultyText,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: difficultyColor,
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Module count
                  Row(
                    children: [
                      const Icon(Icons.book, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${book.moduleCount} modules',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Format status enum value to display string
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
