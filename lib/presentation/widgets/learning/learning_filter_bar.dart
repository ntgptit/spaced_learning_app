import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:spaced_learning_app/presentation/viewmodels/learning_progress_viewmodel.dart';

class LearningFilterBar extends StatelessWidget {
  final int totalCount;
  final int dueCount;
  final int completeCount;

  const LearningFilterBar({
    super.key,
    required this.totalCount,
    required this.dueCount,
    required this.completeCount,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<LearningProgressViewModel>(
      builder: (context, viewModel, _) {
        return _ModernFilterView(
          selectedBook: viewModel.selectedBook,
          selectedDate: viewModel.selectedDate,
          books: viewModel.getUniqueBooks(),
          onBookChanged: (book) => viewModel.setSelectedBook(book ?? 'All'),
          onDateSelected: () => _selectDate(context, viewModel),
          onDateCleared: () => viewModel.clearDateFilter(),
          totalCount: totalCount,
          dueCount: dueCount,
          completeCount: completeCount,
        );
      },
    );
  }

  Future<void> _selectDate(
    BuildContext context,
    LearningProgressViewModel viewModel,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: viewModel.selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme,
            dialogTheme: DialogThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      viewModel.setSelectedDate(picked);
    }
  }
}

class _ModernFilterView extends StatefulWidget {
  final String selectedBook;
  final DateTime? selectedDate;
  final List<String> books;
  final Function(String?) onBookChanged;
  final Function() onDateSelected;
  final Function() onDateCleared;
  final int totalCount;
  final int dueCount;
  final int completeCount;

  const _ModernFilterView({
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
  State<_ModernFilterView> createState() => _ModernFilterViewState();
}

class _ModernFilterViewState extends State<_ModernFilterView> {
  final TextEditingController _bookSearchController = TextEditingController();
  late List<String> _filteredBooks;
  final bool _showSearch = false;
  Timer? _debounceTimer;
  bool _showFilter = false;

  @override
  void initState() {
    super.initState();
    _filteredBooks = widget.books;
  }

  @override
  void didUpdateWidget(_ModernFilterView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.books != widget.books) {
      _filteredBooks = widget.books;
      if (!_showSearch) _bookSearchController.clear();
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _bookSearchController.dispose();
    super.dispose();
  }

  void _filterBooks(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        _filteredBooks =
            query.isEmpty
                ? widget.books
                : widget.books
                    .where(
                      (book) =>
                          book.toLowerCase().contains(query.toLowerCase()),
                    )
                    .toList();
      });
    });
  }

  void _toggleFilter() {
    setState(() {
      _showFilter = !_showFilter;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(
          color: colorScheme.outlineVariant.withOpacity(0.3),
          width: 1.0,
        ),
      ),
      child: Column(
        children: [
          _buildStatsRow(theme),
          if (_showFilter) ...[
            const Divider(height: 1),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: _showFilter ? null : 0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_showSearch) _buildSearchField(theme),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildBookSelector(theme)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildDateSelector(theme)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatsRow(ThemeData theme) {
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatCard(
                  count: widget.totalCount,
                  label: 'Total',
                  icon: Icons.menu_book,
                  color: colorScheme.primary,
                  theme: theme,
                ),
                _buildStatCard(
                  count: widget.dueCount,
                  label: 'Due',
                  icon: Icons.access_time,
                  color: colorScheme.error,
                  theme: theme,
                  highlight: widget.dueCount > 0,
                ),
                _buildStatCard(
                  count: widget.completeCount,
                  label: 'Complete',
                  icon: Icons.check_circle_outline,
                  color: colorScheme.tertiary,
                  theme: theme,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              _showFilter ? Icons.filter_list_off : Icons.filter_list,
              color:
                  _getActiveFilterCount() > 0
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
            ),
            tooltip: _showFilter ? 'Hide filters' : 'Show filters',
            onPressed: _toggleFilter,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required int count,
    required String label,
    required IconData icon,
    required Color color,
    required ThemeData theme,
    bool highlight = false,
  }) {
    final textTheme = theme.textTheme;
    final brightness = highlight ? 1.0 : 0.8;

    return Card(
      elevation: 0,
      color: color.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 16, color: color.withOpacity(brightness)),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              count.toString(),
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color.withOpacity(brightness),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField(ThemeData theme) {
    return TextField(
      controller: _bookSearchController,
      decoration: InputDecoration(
        hintText: 'Search books...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon:
            _bookSearchController.text.isNotEmpty
                ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _bookSearchController.clear();
                    _filterBooks('');
                  },
                )
                : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      onChanged: _filterBooks,
    );
  }

  Widget _buildBookSelector(ThemeData theme) {
    final colorScheme = theme.colorScheme;
    final effectiveBooks =
        _filteredBooks.isEmpty ? ['No books available'] : _filteredBooks;
    final hasBookFilter = widget.selectedBook != 'All';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Book',
          style: theme.textTheme.labelMedium?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color:
                  hasBookFilter
                      ? colorScheme.primary
                      : colorScheme.outline.withOpacity(0.5),
              width: hasBookFilter ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: widget.selectedBook,
              isExpanded: true,
              icon: Icon(
                Icons.arrow_drop_down,
                color: hasBookFilter ? colorScheme.primary : null,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              borderRadius: BorderRadius.circular(12),
              items:
                  effectiveBooks
                      .map(
                        (book) => DropdownMenuItem(
                          value: book,
                          child: Text(
                            book,
                            style: TextStyle(
                              color:
                                  book == widget.selectedBook && book != 'All'
                                      ? colorScheme.primary
                                      : null,
                              fontWeight:
                                  book == widget.selectedBook && book != 'All'
                                      ? FontWeight.bold
                                      : null,
                            ),
                          ),
                        ),
                      )
                      .toList(),
              onChanged: widget.onBookChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateSelector(ThemeData theme) {
    final colorScheme = theme.colorScheme;
    final hasDateFilter = widget.selectedDate != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Filter by Date',
          style: theme.textTheme.labelMedium?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 4),
        widget.selectedDate == null
            ? OutlinedButton.icon(
              icon: const Icon(Icons.calendar_today, size: 18),
              label: const Text('Select Date'),
              onPressed: widget.onDateSelected,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            )
            : Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
              decoration: BoxDecoration(
                border: Border.all(color: colorScheme.primary, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 18,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      DateFormat('MMM dd, yyyy').format(widget.selectedDate!),
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: widget.onDateCleared,
                    child: Icon(
                      Icons.close,
                      size: 18,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
      ],
    );
  }

  int _getActiveFilterCount() {
    int count = 0;
    if (widget.selectedBook != 'All') count++;
    if (widget.selectedDate != null) count++;
    return count;
  }
}
