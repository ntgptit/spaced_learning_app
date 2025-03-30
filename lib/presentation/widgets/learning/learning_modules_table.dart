import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spaced_learning_app/domain/models/learning_module.dart';
import 'package:spaced_learning_app/presentation/utils/cycle_formatter.dart';
import 'package:spaced_learning_app/presentation/widgets/learning/module_details_bottom_sheet.dart';

/// Widget hiển thị bảng dữ liệu các module học tập
class LearningModulesTable extends StatelessWidget {
  final List<LearningModule> modules;
  final bool isLoading;

  const LearningModulesTable({
    super.key,
    required this.modules,
    this.isLoading = false,
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

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          columnSpacing: 16,
          headingRowColor: WidgetStateProperty.all(
            theme.colorScheme.primary.withValues(alpha: 0.1),
          ),
          columns: const [
            DataColumn(label: Text('Subject')),
            DataColumn(label: Text('Book'), numeric: true),
            DataColumn(label: Text('Words'), numeric: true),
            DataColumn(label: Text('Cycles'), numeric: true),
            DataColumn(label: Text('Progress'), numeric: true),
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
                      Container(
                        constraints: const BoxConstraints(maxWidth: 300),
                        child: Text(
                          module.subject,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      onTap: () => _showModuleDetails(context, module),
                    ),
                    DataCell(Text(module.book)),
                    DataCell(Text(module.wordCount.toString())),
                    DataCell(
                      Text(
                        module.cyclesStudied != null
                            ? CycleFormatter.format(module.cyclesStudied!)
                            : '-',
                      ),
                    ),
                    DataCell(
                      LinearProgressIndicator(
                        value: module.percentage / 100,
                        backgroundColor:
                            theme.colorScheme.surfaceContainerHighest,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          module.percentage >= 90
                              ? Colors.green
                              : module.percentage >= 70
                              ? Colors.orange
                              : Colors.red,
                        ),
                        minHeight: 10,
                      ),
                      onTap: () => _showModuleDetails(context, module),
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
                    DataCell(Text(module.taskCount?.toString() ?? '-')),
                  ],
                );
              }).toList(),
        ),
      ),
    );
  }

  /// Hiển thị bottom sheet với chi tiết module
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
