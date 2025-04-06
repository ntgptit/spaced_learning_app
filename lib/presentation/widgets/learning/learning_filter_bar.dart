import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';

/// Filter bar for learning screen with book and date selection
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
  late List<String> _filteredBooks;
  bool _showSearch = false;
  Timer? _debounceTimer;

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSmallScreen =
        MediaQuery.of(context).size.width < AppDimens.breakpointXS;

    return Padding(
      padding: const EdgeInsets.all(AppDimens.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(theme),
          const SizedBox(height: AppDimens.spaceS),
          isSmallScreen
              ? _buildSmallScreenFilters(theme)
              : _buildWideScreenFilters(theme),
          const SizedBox(height: AppDimens.spaceL),
          _buildStatsRow(theme),
        ],
      ),
    );
  }

  // UI Components
  Widget _buildHeader(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Filters',
          style: theme.textTheme.titleMedium,
          key: const Key('filter_header'),
        ),
        if (widget.books.length > 10)
          IconButton(
            key: const Key('search_toggle'),
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
    );
  }

  Widget _buildWideScreenFilters(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_showSearch) _buildSearchField(theme),
        Row(
          children: [
            Expanded(child: _buildBookDropdown(theme)),
            const SizedBox(width: AppDimens.spaceM),
            Expanded(child: _buildDateFilter(theme)),
          ],
        ),
      ],
    );
  }

  Widget _buildSmallScreenFilters(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_showSearch) _buildSearchField(theme),
        SizedBox(
          height: AppDimens.buttonHeightL,
          width: double.infinity,
          child: _buildBookDropdown(theme),
        ),
        const SizedBox(height: AppDimens.spaceS),
        SizedBox(
          height: AppDimens.buttonHeightL,
          width: double.infinity,
          child: _buildDateFilter(theme),
        ),
      ],
    );
  }

  Widget _buildSearchField(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.paddingS),
      child: TextField(
        key: const Key('book_search_field'),
        controller: _bookSearchController,
        decoration: InputDecoration(
          hintText: 'Search books...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon:
              _bookSearchController.text.isNotEmpty
                  ? IconButton(
                    key: const Key('clear_search'),
                    icon: const Icon(Icons.clear),
                    tooltip: 'Clear search',
                    onPressed: () {
                      _bookSearchController.clear();
                      _filterBooks('');
                    },
                  )
                  : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusS),
          ),
        ),
        onChanged: _filterBooks,
      ),
    );
  }

  Widget _buildBookDropdown(ThemeData theme) {
    final effectiveBooks =
        _filteredBooks.isEmpty
            ? ['No books available']
            : ['All Books', ..._filteredBooks];
    final effectiveValue =
        widget.books.contains(widget.selectedBook)
            ? widget.selectedBook
            : effectiveBooks.first;

    return Container(
      key: const Key('book_dropdown'),
      height: AppDimens.buttonHeightL,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusS),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(
            alpha: AppDimens.opacitySemi,
          ),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: effectiveValue,
          isExpanded: true,
          borderRadius: BorderRadius.circular(AppDimens.radiusS),
          icon: const Icon(Icons.arrow_drop_down),
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.paddingM),
          items:
              effectiveBooks
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
          onChanged: (value) {
            if (value == 'All Books') {
              widget.onBookChanged(null); // Clear book filter
            } else if (value != 'No books available') {
              widget.onBookChanged(value);
            }
          },
        ),
      ),
    );
  }

  Widget _buildDateFilter(ThemeData theme) {
    return widget.selectedDate == null
        ? OutlinedButton.icon(
          key: const Key('select_date_button'),
          icon: const Icon(Icons.calendar_today, size: AppDimens.iconS),
          label: const Text('Select Date'),
          onPressed: widget.onDateSelected,
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(AppDimens.buttonHeightL),
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.paddingM),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimens.radiusS),
            ),
          ),
        )
        : Container(
          key: const Key('selected_date_container'),
          height: AppDimens.buttonHeightL,
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.paddingM),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(AppDimens.radiusS),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(
                alpha: AppDimens.opacitySemi,
              ),
            ),
          ),
          child: Row(
            children: [
              const Tooltip(
                message: 'Selected date filter',
                child: Icon(Icons.calendar_today, size: AppDimens.iconS),
              ),
              const SizedBox(width: AppDimens.spaceS),
              Expanded(
                child: Text(
                  DateFormat('MMM dd, yyyy').format(widget.selectedDate!),
                  style: theme.textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                key: const Key('clear_date'),
                icon: const Icon(Icons.clear, size: AppDimens.iconS),
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
      key: const Key('stats_row'),
      padding: const EdgeInsets.all(AppDimens.paddingM),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppDimens.radiusS),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(theme, 'Total', widget.totalCount, Icons.book),
          _buildDivider(),
          _buildStatItem(
            theme,
            'Due',
            widget.dueCount,
            Icons.warning,
            isHighlighted: widget.dueCount > 0,
          ),
          _buildDivider(),
          _buildStatItem(
            theme,
            'Complete',
            widget.completeCount,
            Icons.check_circle,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: AppDimens.listTileHeightS - AppDimens.paddingL,
      width: AppDimens.dividerThickness,
      color: Colors.grey.withValues(alpha: AppDimens.opacityMedium),
    );
  }

  Widget _buildStatItem(
    ThemeData theme,
    String label,
    int totalCount,
    IconData icon, {
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
              Icon(icon, size: AppDimens.iconXS, color: color),
              const SizedBox(width: AppDimens.spaceXXS),
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
