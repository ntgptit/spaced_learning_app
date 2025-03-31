import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  final TextEditingController _bookSearchController = TextEditingController();
  List<String> _filteredBooks = [];
  bool _showSearch = false;

  @override
  void initState() {
    super.initState();
    _filteredBooks = widget.books;
  }

  @override
  void didUpdateWidget(LearningFilterBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.books != widget.books) {
      _filteredBooks = widget.books;
    }
  }

  @override
  void dispose() {
    _bookSearchController.dispose();
    super.dispose();
  }

  void _filterBooks(String query) {
    setState(() {
      _filteredBooks =
          query.isEmpty
              ? widget.books
              : widget.books
                  .where(
                    (book) => book.toLowerCase().contains(query.toLowerCase()),
                  )
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
          if (isSmallScreen)
            _buildSmallScreenFilters(theme)
          else
            _buildWideScreenFilters(theme),
          const SizedBox(height: 16),
          _buildStatsRow(theme),
        ],
      ),
    );
  }

  Widget _buildWideScreenFilters(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
            Expanded(
              flex: 1, // Tỷ lệ 1:1 cho cả hai filter
              child: _buildBookDropdown(theme),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 1, // Tỷ lệ 1:1 cho cả hai filter
              child: _buildDateFilter(theme),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSmallScreenFilters(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        SizedBox(
          height: 48,
          width: double.infinity,
          child: _buildBookDropdown(theme),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 48,
          width: double.infinity,
          child: _buildDateFilter(theme),
        ),
      ],
    );
  }

  Widget _buildBookDropdown(ThemeData theme) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value:
              widget.books.contains(widget.selectedBook)
                  ? widget.selectedBook
                  : widget.books.first,
          isExpanded: true,
          borderRadius: BorderRadius.circular(8),
          icon: const Icon(Icons.arrow_drop_down),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          items:
              _filteredBooks
                  .map(
                    (book) => DropdownMenuItem(
                      value: book,
                      child: Tooltip(
                        message: book,
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
    );
  }

  Widget _buildDateFilter(ThemeData theme) {
    return widget.selectedDate == null
        ? OutlinedButton.icon(
          icon: const Icon(Icons.calendar_today, size: 18),
          label: const Text('Select Date'),
          onPressed: widget.onDateSelected,
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        )
        : Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
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
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.clear, size: 18),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: widget.onDateCleared,
                tooltip: 'Clear date filter',
              ),
            ],
          ),
        );
  }

  Widget _buildStatsRow(ThemeData theme) {
    return Container(
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
