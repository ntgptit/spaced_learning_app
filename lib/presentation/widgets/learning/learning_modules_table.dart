import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/learning_module.dart';
import 'package:spaced_learning_app/presentation/widgets/learning/module_details_bottom_sheet.dart';

/// Simplified table widget for displaying learning modules data
/// Optimized for mobile devices with limited columns and responsive design
class SimplifiedLearningModulesTable extends StatefulWidget {
  final List<LearningModule> modules;
  final bool isLoading;
  final ScrollController? verticalScrollController;

  const SimplifiedLearningModulesTable({
    super.key,
    required this.modules,
    this.isLoading = false,
    this.verticalScrollController,
  });

  @override
  State<SimplifiedLearningModulesTable> createState() =>
      _SimplifiedLearningModulesTableState();
}

class _SimplifiedLearningModulesTableState
    extends State<SimplifiedLearningModulesTable> {
  // Sorting state
  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  // Sorted list of modules
  List<LearningModule> _sortedModules = [];

  @override
  void initState() {
    super.initState();
    _sortedModules = List.from(widget.modules);
    _sortData();
  }

  @override
  void didUpdateWidget(SimplifiedLearningModulesTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.modules != widget.modules) {
      _sortedModules = List.from(widget.modules);
      _sortData();
    }
  }

  /// Sort data based on column index and direction
  void _sortData() {
    setState(() {
      switch (_sortColumnIndex) {
        case 0: // Subject
          _sortModules((module) => module.subject);
          break;
        case 1: // Next Study
          _sortModules(
            (module) => module.nextStudyDate?.millisecondsSinceEpoch ?? 0,
          );
          break;
        case 2: // Tasks
          _sortModules((module) => module.taskCount ?? 0);
          break;
      }
    });
  }

  /// Generic sort function using a key extractor
  void _sortModules<T>(T Function(LearningModule) getField) {
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
        comparison = (aValue as Comparable).compareTo(bValue);
      }

      return _sortAscending ? comparison : -comparison;
    });
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

    return Column(
      children: [
        // Table header
        Container(
          color: theme.colorScheme.surfaceContainerHigh,
          padding: const EdgeInsets.symmetric(
            vertical: AppDimens.paddingS,
            horizontal: AppDimens.paddingXS,
          ),
          child: Row(
            children: [
              // Index (#) column
              _buildHeaderCell(
                context,
                '#',
                'Module number',
                flex: 1,
                onSort: null, // No sorting for index
              ),
              // Subject column
              _buildHeaderCell(
                context,
                'Subject',
                'Module title',
                flex: 4,
                onSort: () => _onSortColumn(0),
                isActive: _sortColumnIndex == 0,
              ),
              // Next Study column
              _buildHeaderCell(
                context,
                'Next Study',
                'Date for next study session',
                flex: 3,
                onSort: () => _onSortColumn(1),
                isActive: _sortColumnIndex == 1,
              ),
              // Tasks column
              _buildHeaderCell(
                context,
                'Tasks',
                'Number of pending tasks',
                flex: 2,
                onSort: () => _onSortColumn(2),
                isActive: _sortColumnIndex == 2,
              ),
            ],
          ),
        ),

        // Table body
        Expanded(
          child: ListView.builder(
            controller: widget.verticalScrollController,
            itemCount: _sortedModules.length,
            itemBuilder: (context, index) {
              return _buildTableRow(context, _sortedModules[index], index);
            },
          ),
        ),
      ],
    );
  }

  /// Build a header cell with optional sort controls
  Widget _buildHeaderCell(
    BuildContext context,
    String title,
    String tooltip, {
    required int flex,
    VoidCallback? onSort,
    bool isActive = false,
  }) {
    final theme = Theme.of(context);

    return Expanded(
      flex: flex,
      child: InkWell(
        onTap: onSort,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.paddingS,
            vertical: AppDimens.paddingXS,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (isActive)
                Icon(
                  _sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                  size: AppDimens.iconXS,
                  color: theme.colorScheme.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build a table row for a learning module
  Widget _buildTableRow(
    BuildContext context,
    LearningModule module,
    int index,
  ) {
    final theme = Theme.of(context);
    final isEvenRow = index % 2 == 0;
    final backgroundColor =
        isEvenRow
            ? theme.colorScheme.surface
            : theme.colorScheme.surfaceContainerLowest;

    // Determine if this module is due soon
    final isNearDue =
        module.nextStudyDate != null &&
        module.nextStudyDate!.isBefore(
          DateTime.now().add(const Duration(days: 3)),
        );

    return Material(
      color: backgroundColor,
      child: InkWell(
        onTap: () => _showModuleDetails(context, module),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppDimens.paddingM,
            horizontal: AppDimens.paddingXS,
          ),
          child: Row(
            children: [
              // Index column
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.paddingS,
                  ),
                  child: Center(
                    child: Container(
                      width: AppDimens.moduleIndicatorSize,
                      height: AppDimens.moduleIndicatorSize,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(
                          AppDimens.opacityMedium,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Subject column
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.paddingS,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        module.subject,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      Text(
                        module.book,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),

              // Next Study column
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.paddingS,
                  ),
                  child:
                      module.nextStudyDate != null
                          ? Text(
                            DateFormat(
                              'MMM dd, yyyy',
                            ).format(module.nextStudyDate!),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: isNearDue ? theme.colorScheme.error : null,
                              fontWeight: isNearDue ? FontWeight.bold : null,
                            ),
                          )
                          : const Text('-'),
                ),
              ),

              // Tasks column
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.paddingS,
                  ),
                  child:
                      module.taskCount != null
                          ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppDimens.paddingS,
                                  vertical: AppDimens.paddingXXS,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary.withOpacity(
                                    AppDimens.opacityMedium,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    AppDimens.radiusM,
                                  ),
                                ),
                                child: Text(
                                  module.taskCount.toString(),
                                  style: TextStyle(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          )
                          : const Text('-'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Handle column sorting
  void _onSortColumn(int columnIndex) {
    setState(() {
      if (_sortColumnIndex == columnIndex) {
        // Reverse sort direction if same column is clicked
        _sortAscending = !_sortAscending;
      } else {
        // Set new sort column and default to ascending
        _sortColumnIndex = columnIndex;
        _sortAscending = true;
      }
      _sortData();
    });
  }

  /// Show module details in a bottom sheet
  void _showModuleDetails(BuildContext context, LearningModule module) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ModuleDetailsBottomSheet(module: module),
    );
  }
}
