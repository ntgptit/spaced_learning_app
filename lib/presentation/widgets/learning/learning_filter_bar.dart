import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
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
        return _LearningFilterView(
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
                borderRadius: BorderRadius.circular(AppDimens.radiusL),
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

class _LearningFilterView extends StatefulWidget {
  final String selectedBook;
  final DateTime? selectedDate;
  final List<String> books;
  final Function(String?) onBookChanged;
  final Function() onDateSelected;
  final Function() onDateCleared;
  final int totalCount;
  final int dueCount;
  final int completeCount;

  const _LearningFilterView({
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
  State<_LearningFilterView> createState() => _LearningFilterViewState();
}

class _LearningFilterViewState extends State<_LearningFilterView> {
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
  void didUpdateWidget(_LearningFilterView oldWidget) {
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

    return Card(
      elevation: 1,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme),
            const SizedBox(height: AppDimens.spaceM),
            isSmallScreen
                ? _buildSmallScreenFilters(theme)
                : _buildWideScreenFilters(theme),
            const SizedBox(height: AppDimens.spaceM),
            _buildStatsRow(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              Icons.filter_list_rounded,
              color: theme.colorScheme.primary,
              size: AppDimens.iconM,
            ),
            const SizedBox(width: AppDimens.spaceS),
            Text(
              'Filters',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary,
              ),
              key: const Key('filter_header'),
            ),
          ],
        ),
        if (widget.books.length > 10)
          IconButton(
            key: const Key('search_toggle'),
            icon: Icon(
              _showSearch ? Icons.search_off : Icons.search,
              semanticLabel: _showSearch ? 'Hide search' : 'Search books',
              color: theme.colorScheme.primary,
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
        _buildBookDropdown(theme),
        const SizedBox(height: AppDimens.spaceM),
        _buildDateFilter(theme),
      ],
    );
  }

  Widget _buildSearchField(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.paddingM),
      child: TextField(
        key: const Key('book_search_field'),
        controller: _bookSearchController,
        decoration: InputDecoration(
          hintText: 'Search books...',
          filled: true,
          fillColor: theme.colorScheme.surfaceContainerLowest,
          prefixIcon: Icon(
            Icons.search,
            color: theme.colorScheme.onSurfaceVariant,
          ),
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
            borderRadius: BorderRadius.circular(AppDimens.radiusM),
            borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusM),
            borderSide: BorderSide(
              color: theme.colorScheme.outlineVariant.withValues(
                alpha: AppDimens.opacityMedium,
              ),
            ),
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
      height: AppDimens.buttonHeightM, // Giảm chiều cao một chút
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(
            alpha: AppDimens.opacityMedium,
          ),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: AppDimens.paddingM),
              child: Icon(
                Icons.menu_book_outlined,
                size: AppDimens.iconS,
                color: theme.colorScheme.primary,
              ),
            ),
            Expanded(
              child: DropdownButton<String>(
                value: effectiveValue,
                isExpanded: true,
                borderRadius: BorderRadius.circular(AppDimens.radiusM),
                icon: const Icon(Icons.arrow_drop_down),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.paddingM,
                ),
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
          ],
        ),
      ),
    );
  }

  Widget _buildDateFilter(ThemeData theme) {
    return widget.selectedDate == null
        ? OutlinedButton.icon(
          key: const Key('select_date_button'),
          icon: Icon(
            Icons.calendar_today,
            size: AppDimens.iconS,
            color: theme.colorScheme.primary,
          ),
          label: const Text('Select Date'),
          onPressed: widget.onDateSelected,
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(
              AppDimens.buttonHeightM,
            ), // Giảm chiều cao một chút
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.paddingM),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimens.radiusM),
            ),
            side: BorderSide(
              color: theme.colorScheme.outlineVariant.withValues(
                alpha: AppDimens.opacityMedium,
              ),
            ),
            foregroundColor: theme.colorScheme.primary,
            backgroundColor: theme.colorScheme.surfaceContainerLowest,
          ),
        )
        : Container(
          key: const Key('selected_date_container'),
          height: AppDimens.buttonHeightM, // Giảm chiều cao một chút
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.paddingM),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(AppDimens.radiusM),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withValues(
                alpha: AppDimens.opacityMedium,
              ),
            ),
          ),
          child: Row(
            children: [
              Tooltip(
                message: 'Selected date filter',
                child: Icon(
                  Icons.calendar_today,
                  size: AppDimens.iconS,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: AppDimens.spaceS),
              Expanded(
                child: Text(
                  DateFormat('MMM dd, yyyy').format(widget.selectedDate!),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                key: const Key('clear_date'),
                icon: Icon(
                  Icons.clear,
                  size: AppDimens.iconS,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
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
      padding: const EdgeInsets.symmetric(
        vertical: AppDimens.paddingM,
        horizontal: AppDimens.paddingL,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(theme, 'Total', widget.totalCount, Icons.book),
          _buildDivider(theme),
          _buildStatItem(
            theme,
            'Due',
            widget.dueCount,
            Icons.pending_actions,
            isHighlighted: widget.dueCount > 0,
          ),
          _buildDivider(theme),
          _buildStatItem(
            theme,
            'Completed',
            widget.completeCount,
            Icons.check_circle_outline,
            isPositive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(ThemeData theme) {
    return Container(
      height: AppDimens.listTileHeightS - AppDimens.paddingL,
      width: AppDimens.dividerThickness,
      color: theme.colorScheme.outlineVariant.withValues(
        alpha: AppDimens.opacityMedium,
      ),
    );
  }

  Widget _buildStatItem(
    ThemeData theme,
    String label,
    int count,
    IconData icon, {
    bool isHighlighted = false,
    bool isPositive = false,
  }) {
    Color color = theme.colorScheme.primary;
    if (isHighlighted) {
      color = theme.colorScheme.error;
    } else if (isPositive) {
      color = theme.colorScheme.tertiary;
    }

    return Semantics(
      label: '$label: $count items',
      value: count.toString(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: AppDimens.iconS, color: color),
              const SizedBox(width: AppDimens.spaceXXS),
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spaceXXS),
          Text(
            count.toString(),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
