import 'dart:async';

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
  late List<LearningModule> _sortedModules;

  // Debounce timer for sorting
  Timer? _debounceTimer;

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

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  /// Sort data based on column index and direction
  void _sortData() {
    if (_sortedModules.isEmpty) return; // Avoid sorting empty list
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
      return const Center(
        child: CircularProgressIndicator(key: Key('loading_indicator')),
      );
    }

    if (widget.modules.isEmpty) {
      return Center(
        child: Text(
          'No data found for the selected filters',
          style: theme.textTheme.bodyLarge,
          key: const Key('no_data_text'),
        ),
      );
    }

    // Responsive flex values based on screen width
    final screenWidth = MediaQuery.of(context).size.width;
    final flexRatios = _getFlexRatios(screenWidth);

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
              _buildHeaderCell(
                context,
                '#',
                'Module number',
                flex: flexRatios[0],
                onSort: null, // No sorting for index
                key: const Key('header_index'),
              ),
              _buildHeaderCell(
                context,
                'Subject',
                'Module title',
                flex: flexRatios[1],
                onSort: () => _onSortColumn(0),
                isActive: _sortColumnIndex == 0,
                key: const Key('header_subject'),
              ),
              _buildHeaderCell(
                context,
                'Next Study',
                'Date for next study session',
                flex: flexRatios[2],
                onSort: () => _onSortColumn(1),
                isActive: _sortColumnIndex == 1,
                key: const Key('header_next_study'),
              ),
              _buildHeaderCell(
                context,
                'Tasks',
                'Number of pending tasks',
                flex: flexRatios[3],
                onSort: () => _onSortColumn(2),
                isActive: _sortColumnIndex == 2,
                key: const Key('header_tasks'),
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
              return _buildTableRow(
                context,
                _sortedModules[index],
                index,
                flexRatios,
              );
            },
          ),
        ),
      ],
    );
  }

  /// Calculate responsive flex ratios based on screen width
  List<int> _getFlexRatios(double screenWidth) {
    if (screenWidth < 400) {
      return [1, 3, 2, 2]; // Smaller screens
    } else if (screenWidth < 600) {
      return [1, 4, 3, 2]; // Default mobile
    } else {
      return [1, 5, 4, 3]; // Larger screens
    }
  }

  /// Build a header cell with optional sort controls
  Widget _buildHeaderCell(
    BuildContext context,
    String title,
    String tooltip, {
    required int flex,
    VoidCallback? onSort,
    bool isActive = false,
    Key? key,
  }) {
    final theme = Theme.of(context);

    return Expanded(
      flex: flex,
      child: Tooltip(
        message: tooltip,
        child: InkWell(
          key: key,
          onTap: onSort,
          splashColor: theme.colorScheme.primary.withValues(alpha: 0.2),
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
      ),
    );
  }

  /// Build a table row for a learning module
  Widget _buildTableRow(
    BuildContext context,
    LearningModule module,
    int index,
    List<int> flexRatios,
  ) {
    final theme = Theme.of(context);
    final isEvenRow = index % 2 == 0;
    final backgroundColor =
        isEvenRow
            ? theme.colorScheme.surface
            : theme.colorScheme.surfaceContainerLowest;

    final isNearDue =
        module.nextStudyDate != null &&
        module.nextStudyDate!.isBefore(
          DateTime.now().add(const Duration(days: 3)),
        );

    return Material(
      color: backgroundColor,
      child: InkWell(
        key: Key('row_$index'),
        onTap: () => _showModuleDetails(context, module),
        splashColor: theme.colorScheme.primary.withValues(alpha: 0.2),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppDimens.paddingM,
            horizontal: AppDimens.paddingXS,
          ),
          child: Row(
            children: [
              // Index column
              Expanded(
                flex: flexRatios[0],
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
                        color: theme.colorScheme.primary.withValues(
                          alpha: AppDimens.opacityMedium,
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
                flex: flexRatios[1],
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.paddingS,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        module.subject.isEmpty ? 'Unnamed' : module.subject,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      Text(
                        module.book.isEmpty ? 'No book' : module.book,
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
                flex: flexRatios[2],
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
                flex: flexRatios[3],
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
                                  color: theme.colorScheme.primary.withValues(
                                    alpha: AppDimens.opacityMedium,
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

  /// Handle column sorting with debounce
  void _onSortColumn(int columnIndex) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        if (_sortColumnIndex == columnIndex) {
          _sortAscending = !_sortAscending;
        } else {
          _sortColumnIndex = columnIndex;
          _sortAscending = true;
        }
        _sortData();
      });
    });
  }

  /// Show module details in a bottom sheet
  void _showModuleDetails(BuildContext context, LearningModule module) {
    try {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => ModuleDetailsBottomSheet(module: module),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error showing details: $e')));
    }
  }
}
