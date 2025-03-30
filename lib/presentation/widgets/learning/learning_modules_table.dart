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

    // Create a fixed table layout
    return LayoutBuilder(
      builder: (context, constraints) {
        final double tableWidth =
            constraints.maxWidth < 800 ? 800 : constraints.maxWidth;

        return Scrollbar(
          controller: verticalScrollController,
          thumbVisibility: true,
          thickness: 8,
          child: SingleChildScrollView(
            controller: verticalScrollController,
            child: Scrollbar(
              controller: horizontalScrollController,
              thumbVisibility: true,
              thickness: 8,
              scrollbarOrientation: ScrollbarOrientation.bottom,
              child: SingleChildScrollView(
                controller: horizontalScrollController,
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: tableWidth,
                  child: DataTable(
                    columnSpacing: 16,
                    headingRowColor: WidgetStatePropertyAll(
                      theme.colorScheme.primary.withOpacity(0.1),
                    ),
                    dataRowMinHeight: 64,
                    dataRowMaxHeight: 80,
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
                              DataCell(
                                ConstrainedBox(
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
                              DataCell(
                                ConstrainedBox(
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
                              DataCell(Text(module.wordCount.toString())),
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
