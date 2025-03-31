import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Widget for displaying the filter bar on the Learning Progress screen
/// Enhanced with accessibility features and better handling of long book lists
class LearningFilterBar extends StatefulWidget {
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
  State<LearningFilterBar> createState() => _LearningFilterBarState();
}

class _LearningFilterBarState extends State<LearningFilterBar> {
  // Controller for search in the book dropdown
  final TextEditingController _bookSearchController = TextEditingController();
  // Filtered books based on search
  List<String> _filteredBooks = [];
  // Flag to show the search field
  bool _showSearch = false;

  @override
  void initState() {
    super.initState();
    _filteredBooks = widget.books;
  }

  @override
  void didUpdateWidget(LearningFilterBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update filtered books list if the books list changes
    if (oldWidget.books != widget.books) {
      _filteredBooks = widget.books;
    }
  }

  @override
  void dispose() {
    _bookSearchController.dispose();
    super.dispose();
  }

  /// Filter books based on search query
  void _filterBooks(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredBooks = widget.books;
      });
      return;
    }

    setState(() {
      _filteredBooks =
          widget.books
              .where((book) => book.toLowerCase().contains(query.toLowerCase()))
              .toList();
    });
  }

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Filters', style: theme.textTheme.titleMedium),
              if (widget.books.length > 10)
                IconButton(
                  icon: Icon(
                    _showSearch ? Icons.search_off : Icons.search,
                    semanticLabel: _showSearch ? 'Hide search' : 'Search books',
                  ),
                  tooltip: _showSearch ? 'Hide search' : 'Search books',
                  onPressed: () {
                    setState(() {
                      _showSearch = !_showSearch;
                      if (!_showSearch) {
                        _bookSearchController.clear();
                        _filteredBooks = widget.books;
                      }
                    });
                  },
                ),
            ],
          ),
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
                  totalCount: widget.totalCount,
                  icon: Icons.book,
                  theme: theme,
                ),
                _buildDivider(),
                _buildStatItem(
                  'Due',
                  totalCount: widget.dueCount,
                  icon: Icons.warning,
                  theme: theme,
                  isHighlighted: widget.dueCount > 0,
                ),
                _buildDivider(),
                _buildStatItem(
                  'Complete',
                  totalCount: widget.completeCount,
                  icon: Icons.check_circle,
                  theme: theme,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search field (conditional)
        if (_showSearch) ...[
          TextField(
            controller: _bookSearchController,
            decoration: InputDecoration(
              hintText: 'Search books...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon:
                  _bookSearchController.text.isNotEmpty
                      ? IconButton(
                        icon: const Icon(Icons.clear),
                        tooltip: 'Clear search',
                        onPressed: () {
                          _bookSearchController.clear();
                          _filterBooks('');
                        },
                      )
                      : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onChanged: _filterBooks,
          ),
          const SizedBox(height: 8),
        ],

        Row(
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
                      value:
                          widget.books.contains(widget.selectedBook)
                              ? widget.selectedBook
                              : widget.books.first,
                      isExpanded: true,
                      borderRadius: BorderRadius.circular(8),
                      icon: const Icon(Icons.arrow_drop_down),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      items:
                          _filteredBooks
                              .map(
                                (book) => DropdownMenuItem(
                                  value: book,
                                  child: Tooltip(
                                    message: book, // Tooltip for accessibility
                                    child: Text(
                                      book,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                      onChanged: widget.onBookChanged,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Date filter button or chip
            Expanded(
              child:
                  widget.selectedDate == null
                      ? OutlinedButton.icon(
                        icon: const Icon(Icons.calendar_today),
                        label: const Text('Select Date'),
                        onPressed: widget.onDateSelected,
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
                              const Tooltip(
                                message: 'Selected date filter',
                                child: Icon(Icons.calendar_today, size: 18),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  DateFormat(
                                    'MMM dd, yyyy',
                                  ).format(widget.selectedDate!),
                                  style: theme.textTheme.bodyMedium,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.clear, size: 18),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: widget.onDateCleared,
                                tooltip: 'Clear date filter', // Added tooltip
                              ),
                            ],
                          ),
                        ),
                      ),
            ),
          ],
        ),
      ],
    );
  }

  /// Build filters stacked vertically for small screens
  Widget _buildSmallScreenFilters(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search field (conditional)
        if (_showSearch) ...[
          TextField(
            controller: _bookSearchController,
            decoration: InputDecoration(
              hintText: 'Search books...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon:
                  _bookSearchController.text.isNotEmpty
                      ? IconButton(
                        icon: const Icon(Icons.clear),
                        tooltip: 'Clear search',
                        onPressed: () {
                          _bookSearchController.clear();
                          _filterBooks('');
                        },
                      )
                      : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onChanged: _filterBooks,
          ),
          const SizedBox(height: 8),
        ],

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
                value:
                    widget.books.contains(widget.selectedBook)
                        ? widget.selectedBook
                        : widget.books.first,
                isExpanded: true,
                borderRadius: BorderRadius.circular(8),
                icon: const Icon(Icons.arrow_drop_down),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                items:
                    _filteredBooks
                        .map(
                          (book) => DropdownMenuItem(
                            value: book,
                            child: Tooltip(
                              message: book, // Tooltip for accessibility
                              child: Text(
                                book,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                onChanged: widget.onBookChanged,
              ),
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Date filter button or chip - full width on small screens
        widget.selectedDate == null
            ? SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.calendar_today),
                label: const Text('Select Date'),
                onPressed: widget.onDateSelected,
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
                    const Tooltip(
                      message: 'Selected date filter',
                      child: Icon(Icons.calendar_today, size: 18),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        DateFormat('MMM dd, yyyy').format(widget.selectedDate!),
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: widget.onDateCleared,
                      tooltip: 'Clear date filter', // Added tooltip
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
    String label, {
    required int totalCount,
    required IconData icon,
    required ThemeData theme,
    bool isHighlighted = false,
  }) {
    final color =
        isHighlighted ? theme.colorScheme.error : theme.colorScheme.primary;

    return Semantics(
      label: '$label: $totalCount items',
      value: totalCount.toString(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 4),
              Text(label, style: theme.textTheme.bodySmall),
            ],
          ),
          Text(
            totalCount.toString(),
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
