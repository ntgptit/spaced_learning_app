// lib/presentation/widgets/learning/learning_modules_table.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spaced_learning_app/domain/models/learning_module.dart';
import 'package:spaced_learning_app/presentation/utils/cycle_formatter.dart';
import 'package:spaced_learning_app/presentation/widgets/learning/module_details_bottom_sheet.dart';

/// Widget for displaying learning modules data in a horizontally scrollable table
/// with fixes for overflow errors
class LearningModulesTable extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (modules.isEmpty) {
      return Center(
        child: Text(
          'No data found for the selected filters',
          style: theme.textTheme.bodyLarge,
        ),
      );
    }

    // Use a fixed row height and column widths for better control
    const double rowHeight = 64.0;

    // Create a data table with fixed dimensions
    return LayoutBuilder(
      builder: (context, constraints) {
        // Ensure table is wide enough for all content
        final double tableWidth =
            constraints.maxWidth < 800 ? 800 : constraints.maxWidth;

        // Create the table with scrollbars
        return Scrollbar(
          controller: verticalScrollController,
          thumbVisibility: true,
          child: SingleChildScrollView(
            controller: verticalScrollController,
            child: Scrollbar(
              controller: horizontalScrollController,
              thumbVisibility: true,
              scrollbarOrientation: ScrollbarOrientation.bottom,
              child: SingleChildScrollView(
                controller: horizontalScrollController,
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: tableWidth,
                  child: DataTable(
                    // Set horizontal spacing
                    columnSpacing: 16,
                    // Control row height
                    dataRowMinHeight: rowHeight,
                    dataRowMaxHeight: rowHeight,
                    // Style the header row
                    headingRowColor: WidgetStatePropertyAll(
                      theme.colorScheme.primary.withOpacity(0.1),
                    ),
                    // Define fixed-width columns
                    columns: const [
                      DataColumn(label: Text('Subject')),
                      DataColumn(label: Text('Book')),
                      DataColumn(label: Text('Words'), numeric: true),
                      DataColumn(label: Text('Cycles')),
                      DataColumn(label: Text('Progress')),
                      DataColumn(label: Text('Next Study')),
                      DataColumn(label: Text('Tasks'), numeric: true),
                    ],
                    rows:
                        modules.map((module) {
                          final isNearDue =
                              module.nextStudyDate != null &&
                              module.nextStudyDate!.isBefore(
                                DateTime.now().add(const Duration(days: 3)),
                              );

                          return DataRow(
                            cells: [
                              // Column 1: Subject - limit width
                              DataCell(
                                Container(
                                  constraints: BoxConstraints(
                                    maxWidth: tableWidth * 0.25,
                                  ),
                                  child: Text(
                                    module.subject,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                                onTap:
                                    () => _showModuleDetails(context, module),
                              ),
                              // Column 2: Book - limit width
                              DataCell(
                                Container(
                                  constraints: BoxConstraints(
                                    maxWidth: tableWidth * 0.15,
                                  ),
                                  child: Text(
                                    module.book,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                              // Column 3: Word count
                              DataCell(Text(module.wordCount.toString())),
                              // Column 4: Cycles
                              DataCell(
                                Text(
                                  module.cyclesStudied != null
                                      ? CycleFormatter.format(
                                        module.cyclesStudied!,
                                      )
                                      : '-',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              // Column 5: Progress bar
                              DataCell(
                                SizedBox(
                                  width: 120,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('${module.percentage}%'),
                                      const SizedBox(height: 4),
                                      LinearProgressIndicator(
                                        value: module.percentage / 100,
                                        backgroundColor:
                                            theme
                                                .colorScheme
                                                .surfaceContainerHighest,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              module.percentage >= 90
                                                  ? Colors.green
                                                  : module.percentage >= 70
                                                  ? Colors.orange
                                                  : Colors.red,
                                            ),
                                        minHeight: 8,
                                      ),
                                    ],
                                  ),
                                ),
                                onTap:
                                    () => _showModuleDetails(context, module),
                              ),
                              // Column 6: Next study date
                              DataCell(
                                module.nextStudyDate != null
                                    ? Text(
                                      DateFormat(
                                        'MMM dd, yyyy',
                                      ).format(module.nextStudyDate!),
                                      style:
                                          isNearDue
                                              ? TextStyle(
                                                color: theme.colorScheme.error,
                                                fontWeight: FontWeight.bold,
                                              )
                                              : null,
                                    )
                                    : const Text('-'),
                              ),
                              // Column 7: Task count
                              DataCell(
                                Text(module.taskCount?.toString() ?? '-'),
                              ),
                            ],
                          );
                        }).toList(),
                  ),
                ),
              ),
            ),
          ),
        );
      },
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
