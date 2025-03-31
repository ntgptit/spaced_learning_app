import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spaced_learning_app/domain/models/learning_module.dart';
import 'package:spaced_learning_app/presentation/utils/cycle_formatter.dart';
import 'package:spaced_learning_app/presentation/widgets/learning/module_details_bottom_sheet.dart';

/// Enhanced widget for displaying learning modules data in a sortable table
/// with sticky headers and accessibility improvements
class LearningModulesTable extends StatefulWidget {
  final List<LearningModule> modules;
  final bool isLoading;
  final ScrollController? horizontalScrollController;
  final ScrollController? verticalScrollController;

  const LearningModulesTable({
    super.key,
    required this.modules,
    this.isLoading = false,
    this.horizontalScrollController,
    this.verticalScrollController,
  });

  @override
  State<LearningModulesTable> createState() => _LearningModulesTableState();
}

class _LearningModulesTableState extends State<LearningModulesTable> {
  // Sorting state
  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  // List of column definitions for the table
  late List<_ColumnDefinition> _columns;

  // Sorted list of modules
  List<LearningModule> _sortedModules = [];

  @override
  void initState() {
    super.initState();
    _initializeColumns();
    _sortedModules = List.from(widget.modules);
    _sortData();
  }

  @override
  void didUpdateWidget(LearningModulesTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.modules != widget.modules) {
      _sortedModules = List.from(widget.modules);
      _sortData();
    }
  }

  /// Initialize column definitions
  void _initializeColumns() {
    _columns = [
      _ColumnDefinition(
        label: 'Subject',
        tooltip: 'Module subject or title',
        onSort:
            (index, ascending) =>
                _onSort(index, ascending, (module) => module.subject),
        cellBuilder: (context, module) => _buildSubjectCell(context, module),
        flex: 3,
      ),
      _ColumnDefinition(
        label: 'Book',
        tooltip: 'Book containing this module',
        onSort:
            (index, ascending) =>
                _onSort(index, ascending, (module) => module.book),
        cellBuilder: (context, module) => _buildBookCell(context, module),
        flex: 2,
      ),
      _ColumnDefinition(
        label: 'Words',
        tooltip: 'Number of words in this module',
        numeric: true,
        onSort:
            (index, ascending) =>
                _onSort(index, ascending, (module) => module.wordCount),
        cellBuilder: (context, module) => _buildWordsCell(context, module),
        flex: 1,
      ),
      _ColumnDefinition(
        label: 'Cycles',
        tooltip: 'Learning cycle status',
        onSort:
            (index, ascending) => _onSort(
              index,
              ascending,
              (module) => module.cyclesStudied?.index ?? -1,
            ),
        cellBuilder: (context, module) => _buildCyclesCell(context, module),
        flex: 2,
      ),
      _ColumnDefinition(
        label: 'Progress',
        tooltip: 'Completion percentage',
        onSort:
            (index, ascending) =>
                _onSort(index, ascending, (module) => module.percentage),
        cellBuilder: (context, module) => _buildProgressCell(context, module),
        flex: 2,
      ),
      _ColumnDefinition(
        label: 'Next Study',
        tooltip: 'Scheduled date for next study session',
        onSort:
            (index, ascending) => _onSort(
              index,
              ascending,
              (module) => module.nextStudyDate?.millisecondsSinceEpoch ?? 0,
            ),
        cellBuilder: (context, module) => _buildNextStudyCell(context, module),
        flex: 2,
      ),
      _ColumnDefinition(
        label: 'Tasks',
        tooltip: 'Number of learning tasks',
        numeric: true,
        onSort:
            (index, ascending) =>
                _onSort(index, ascending, (module) => module.taskCount ?? 0),
        cellBuilder: (context, module) => _buildTasksCell(context, module),
        flex: 1,
      ),
    ];
  }

  /// General sort handler using a key extractor function
  void _onSort<T>(
    int columnIndex,
    bool ascending,
    T Function(LearningModule) getField,
  ) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;

      _sortedModules.sort((a, b) {
        final aValue = getField(a);
        final bValue = getField(b);

        int comparison;
        if (aValue == null && bValue == null) {
          comparison = 0;
        } else if (aValue == null) {
          comparison = -1;
        } else if (bValue == null) {
          comparison = 1;
        } else if (aValue is String && bValue is String) {
          comparison = aValue.toLowerCase().compareTo(bValue.toLowerCase());
        } else {
          // Using Comparable interface
          comparison = (aValue as Comparable).compareTo(bValue);
        }

        return ascending ? comparison : -comparison;
      });
    });
  }

  /// Sort data based on current sort parameters
  void _sortData() {
    if (_columns.isNotEmpty) {
      _columns[_sortColumnIndex].onSort?.call(_sortColumnIndex, _sortAscending);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (widget.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (widget.modules.isEmpty) {
      return Center(
        child: Text(
          'No data found for the selected filters',
          style: theme.textTheme.bodyLarge,
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final double tableWidth =
            constraints.maxWidth < 800 ? 800 : constraints.maxWidth;

        return Column(
          children: [
            // Sticky header with sort controls
            Container(
              color: theme.colorScheme.surface,
              child: Scrollbar(
                controller: widget.horizontalScrollController,
                thumbVisibility: true,
                trackVisibility: true,
                thickness: 8,
                scrollbarOrientation: ScrollbarOrientation.bottom,
                child: SingleChildScrollView(
                  controller: widget.horizontalScrollController,
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: tableWidth,
                    child: Row(children: _buildTableHeaders(theme)),
                  ),
                ),
              ),
            ),
            // Scrollable content
            Expanded(
              child: Scrollbar(
                controller: widget.verticalScrollController,
                thumbVisibility: true,
                thickness: 8,
                child: Scrollbar(
                  controller: widget.horizontalScrollController,
                  thumbVisibility: true,
                  thickness: 8,
                  scrollbarOrientation: ScrollbarOrientation.bottom,
                  child: SingleChildScrollView(
                    controller: widget.verticalScrollController,
                    child: SingleChildScrollView(
                      controller: widget.horizontalScrollController,
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: tableWidth,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _sortedModules.length,
                          itemBuilder: (context, index) {
                            final module = _sortedModules[index];
                            return _buildTableRow(
                              context,
                              module,
                              index,
                              theme,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Build the table headers with sort controls
  List<Widget> _buildTableHeaders(ThemeData theme) {
    return _columns.asMap().entries.map((entry) {
      final index = entry.key;
      final column = entry.value;

      final isCurrentSortColumn = _sortColumnIndex == index;

      return Expanded(
        flex: column.flex,
        child: InkWell(
          onTap: () {
            if (column.onSort != null) {
              final newAscending =
                  _sortColumnIndex == index ? !_sortAscending : true;
              column.onSort!(index, newAscending);
            }
          },
          child: Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              border: Border(
                bottom: BorderSide(color: theme.colorScheme.outline, width: 1),
              ),
            ),
            child: Tooltip(
              message: column.tooltip,
              child: Row(
                mainAxisAlignment:
                    column.numeric
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                children: [
                  if (isCurrentSortColumn) ...[
                    Icon(
                      _sortAscending
                          ? Icons.arrow_upward
                          : Icons.arrow_downward,
                      size: 16,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 4),
                  ],
                  Expanded(
                    child: Text(
                      column.label,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign:
                          column.numeric ? TextAlign.right : TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  /// Build a table row with interactive cells
  Widget _buildTableRow(
    BuildContext context,
    LearningModule module,
    int index,
    ThemeData theme,
  ) {
    final isEvenRow = index % 2 == 0;
    final backgroundColor =
        isEvenRow
            ? theme.colorScheme.surface
            : theme.colorScheme.surfaceContainerLowest;

    return Material(
      color: backgroundColor,
      child: InkWell(
        onTap: () => _showModuleDetails(context, module),
        child: Container(
          constraints: const BoxConstraints(minHeight: 64),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: theme.colorScheme.outlineVariant.withOpacity(0.5),
                width: 0.5,
              ),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children:
                _columns.map((column) {
                  return Expanded(
                    flex: column.flex,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: column.cellBuilder(context, module),
                    ),
                  );
                }).toList(),
          ),
        ),
      ),
    );
  }

  // Cell builders for each column

  Widget _buildSubjectCell(BuildContext context, LearningModule module) {
    return Tooltip(
      message: module.subject,
      child: Text(module.subject, overflow: TextOverflow.ellipsis, maxLines: 2),
    );
  }

  Widget _buildBookCell(BuildContext context, LearningModule module) {
    return Tooltip(
      message: module.book,
      child: Text(module.book, overflow: TextOverflow.ellipsis, maxLines: 1),
    );
  }

  Widget _buildWordsCell(BuildContext context, LearningModule module) {
    return Semantics(
      value: '${module.wordCount} words',
      child: Text(module.wordCount.toString(), textAlign: TextAlign.right),
    );
  }

  Widget _buildCyclesCell(BuildContext context, LearningModule module) {
    return Text(
      module.cyclesStudied != null
          ? CycleFormatter.format(module.cyclesStudied!)
          : '-',
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildProgressCell(BuildContext context, LearningModule module) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 120,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            value: '${module.percentage}% complete',
            child: Text('${module.percentage}%'),
          ),
          const SizedBox(height: 4),
          Semantics(
            label: 'Progress bar showing ${module.percentage}% completion',
            child: LinearProgressIndicator(
              value: module.percentage / 100,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(
                module.percentage >= 90
                    ? Colors.green
                    : module.percentage >= 70
                    ? Colors.orange
                    : Colors.red,
              ),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextStudyCell(BuildContext context, LearningModule module) {
    final theme = Theme.of(context);
    final isNearDue =
        module.nextStudyDate != null &&
        module.nextStudyDate!.isBefore(
          DateTime.now().add(const Duration(days: 3)),
        );

    return module.nextStudyDate != null
        ? Tooltip(
          message:
              'Due on ${DateFormat('EEEE, MMMM d, yyyy').format(module.nextStudyDate!)}',
          child: Text(
            DateFormat('MMM dd, yyyy').format(module.nextStudyDate!),
            style:
                isNearDue
                    ? TextStyle(
                      color: theme.colorScheme.error,
                      fontWeight: FontWeight.bold,
                    )
                    : null,
          ),
        )
        : const Text('-');
  }

  Widget _buildTasksCell(BuildContext context, LearningModule module) {
    return Text(
      module.taskCount?.toString() ?? '-',
      textAlign: TextAlign.right,
    );
  }

  /// Show module details in a bottom sheet
  void _showModuleDetails(BuildContext context, LearningModule module) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => ModuleDetailsBottomSheet(module: module),
    );
  }
}

/// Internal class to define table columns
class _ColumnDefinition {
  final String label;
  final String tooltip;
  final bool numeric;
  final void Function(int columnIndex, bool ascending)? onSort;
  final Widget Function(BuildContext context, LearningModule module)
  cellBuilder;
  final int flex;

  _ColumnDefinition({
    required this.label,
    required this.tooltip,
    this.numeric = false,
    this.onSort,
    required this.cellBuilder,
    this.flex = 1,
  });
}
