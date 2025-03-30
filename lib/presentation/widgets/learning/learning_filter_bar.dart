import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Widget hiển thị thanh lọc dữ liệu cho màn hình Learning Progress
/// Fixed to avoid overflow issues
class LearningFilterBar extends StatelessWidget {
  final String selectedBook;
  final DateTime? selectedDate;
  final List<String> books;
  final Function(String?) onBookChanged;
  final Function() onDateSelected;
  final Function() onDateCleared;
  final int totalCount;
  final int dueCount;
  final int completeCount;

  const LearningFilterBar({
    super.key,
    required this.selectedBook,
    required this.selectedDate,
    required this.books,
    required this.onBookChanged,
    required this.onDateSelected,
    required this.onDateCleared,
    required this.totalCount,
    required this.dueCount,
    required this.completeCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Filters', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),

          // Row for filters - adapt for small screens
          if (isSmallScreen)
            _buildSmallScreenFilters(theme)
          else
            _buildWideScreenFilters(theme),

          const SizedBox(height: 16),

          // Stats row
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'Total',
                  totalCount.toString(),
                  Icons.book,
                  theme,
                ),
                _buildDivider(),
                _buildStatItem(
                  'Due',
                  dueCount.toString(),
                  Icons.warning,
                  theme,
                ),
                _buildDivider(),
                _buildStatItem(
                  'Complete',
                  completeCount.toString(),
                  Icons.check_circle,
                  theme,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build filters layout for wide screens
  Widget _buildWideScreenFilters(ThemeData theme) {
    return Row(
      children: [
        // Book filter dropdown
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.withOpacity(0.3)),
            ),
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton<String>(
                  value: selectedBook,
                  isExpanded: true,
                  borderRadius: BorderRadius.circular(8),
                  icon: const Icon(Icons.arrow_drop_down),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  items:
                      books
                          .map(
                            (book) => DropdownMenuItem(
                              value: book,
                              child: Text(
                                book,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          )
                          .toList(),
                  onChanged: onBookChanged,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),

        // Date filter button or chip
        Expanded(
          child:
              selectedDate == null
                  ? OutlinedButton.icon(
                    icon: const Icon(Icons.calendar_today),
                    label: const Text('Select Date'),
                    onPressed: onDateSelected,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  )
                  : Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              DateFormat('MMM dd, yyyy').format(selectedDate!),
                              style: theme.textTheme.bodyMedium,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: onDateCleared,
                          ),
                        ],
                      ),
                    ),
                  ),
        ),
      ],
    );
  }

  /// Build filters stacked vertically for small screens
  Widget _buildSmallScreenFilters(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Book filter dropdown
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
          ),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton<String>(
                value: selectedBook,
                isExpanded: true,
                borderRadius: BorderRadius.circular(8),
                icon: const Icon(Icons.arrow_drop_down),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                items:
                    books
                        .map(
                          (book) => DropdownMenuItem(
                            value: book,
                            child: Text(
                              book,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        )
                        .toList(),
                onChanged: onBookChanged,
              ),
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Date filter button or chip - full width on small screens
        selectedDate == null
            ? SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.calendar_today),
                label: const Text('Select Date'),
                onPressed: onDateSelected,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            )
            : Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        DateFormat('MMM dd, yyyy').format(selectedDate!),
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: onDateCleared,
                    ),
                  ],
                ),
              ),
            ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(height: 30, width: 1, color: Colors.grey.withOpacity(0.3));
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    ThemeData theme,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: theme.colorScheme.primary),
            const SizedBox(width: 4),
            Text(label, style: theme.textTheme.bodySmall),
          ],
        ),
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
