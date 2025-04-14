import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/presentation/viewmodels/learning_progress_viewmodel.dart';
import 'package:spaced_learning_app/presentation/widgets/learning/learning_filter_bar/filter_book_selector.dart';
import 'package:spaced_learning_app/presentation/widgets/learning/learning_filter_bar/filter_date_selector.dart';
import 'package:spaced_learning_app/presentation/widgets/learning/learning_filter_bar/filter_stats_row.dart';

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
        return _FilterBarContent(
          selectedBook: viewModel.selectedBook,
          selectedDate: viewModel.selectedDate,
          books: viewModel.getUniqueBooks(),
          onBookChanged: (book) => viewModel.setSelectedBook(book ?? 'All'),
          onDateSelected: () => _selectDate(context, viewModel),
          onDateCleared: () => viewModel.clearDateFilter(),
          totalCount: totalCount,
          dueCount: dueCount,
          completeCount: completeCount,
          hasActiveFilters:
              viewModel.selectedBook != 'All' || viewModel.selectedDate != null,
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

class _FilterBarContent extends StatefulWidget {
  final String selectedBook;
  final DateTime? selectedDate;
  final List<String> books;
  final Function(String?) onBookChanged;
  final Function() onDateSelected;
  final Function() onDateCleared;
  final int totalCount;
  final int dueCount;
  final int completeCount;
  final bool hasActiveFilters;

  const _FilterBarContent({
    required this.selectedBook,
    required this.selectedDate,
    required this.books,
    required this.onBookChanged,
    required this.onDateSelected,
    required this.onDateCleared,
    required this.totalCount,
    required this.dueCount,
    required this.completeCount,
    required this.hasActiveFilters,
  });

  @override
  State<_FilterBarContent> createState() => _FilterBarContentState();
}

class _FilterBarContentState extends State<_FilterBarContent> {
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    // Automatically expand if there are active filters
    _isExpanded = widget.hasActiveFilters;
  }

  @override
  void didUpdateWidget(_FilterBarContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update expanded state if filters changed
    if (widget.hasActiveFilters != oldWidget.hasActiveFilters) {
      setState(() {
        _isExpanded = widget.hasActiveFilters;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: AppDimens.elevationS,
      margin: const EdgeInsets.symmetric(
        vertical: AppDimens.paddingS,
        horizontal: AppDimens.paddingXS,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusL),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(
            alpha: AppDimens.opacityMedium,
          ),
          width: 1.0,
        ),
      ),
      child: Column(
        children: [
          // Filter Stats Row is always visible
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: FilterStatsRow(
              totalCount: widget.totalCount,
              dueCount: widget.dueCount,
              completeCount: widget.completeCount,
              activeFilterCount: _getActiveFilterCount(),
              showFilter: _isExpanded,
              onToggleFilter: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
            ),
          ),

          // ExpansionTile replacement - manual implementation for better control
          AnimatedContainer(
            duration: const Duration(milliseconds: AppDimens.durationM),
            height: _isExpanded ? null : 0,
            curve: Curves.easeInOut,
            child: ClipRect(
              child: Visibility(
                visible: _isExpanded,
                maintainState: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(
                      height: AppDimens.dividerThickness,
                      thickness: AppDimens.dividerThickness,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(AppDimens.paddingL),
                      child: Row(
                        children: [
                          Expanded(
                            child: FilterBookSelector(
                              selectedBook: widget.selectedBook,
                              books: widget.books,
                              onBookChanged: widget.onBookChanged,
                            ),
                          ),
                          const SizedBox(width: AppDimens.spaceM),
                          Expanded(
                            child: FilterDateSelector(
                              selectedDate: widget.selectedDate,
                              onDateSelected: widget.onDateSelected,
                              onDateCleared: widget.onDateCleared,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _getActiveFilterCount() {
    int count = 0;
    if (widget.selectedBook != 'All') count++;
    if (widget.selectedDate != null) count++;
    return count;
  }
}
