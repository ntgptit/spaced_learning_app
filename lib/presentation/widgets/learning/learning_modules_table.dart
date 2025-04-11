import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/learning_module.dart';
import 'package:spaced_learning_app/presentation/widgets/learning/module_details_bottom_sheet.dart';

class SimplifiedLearningModulesTable extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(key: Key('loading_indicator')),
      );
    }

    if (modules.isEmpty) {
      return Center(
        child: Text(
          'No data found for the selected filters',
          style: theme.textTheme.bodyLarge,
          key: const Key('no_data_text'),
        ),
      );
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final flexRatios = _getFlexRatios(screenWidth);

    return Column(
      children: [
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
                key: const Key('header_index'),
              ),
              _buildHeaderCell(
                context,
                'Subject',
                'Module title',
                flex: flexRatios[1],
                key: const Key('header_subject'),
              ),
              _buildHeaderCell(
                context,
                'Next Study',
                'Date for next study session',
                flex: flexRatios[2],
                key: const Key('header_next_study'),
              ),
              _buildHeaderCell(
                context,
                'Tasks',
                'Number of pending tasks',
                flex: flexRatios[3],
                key: const Key('header_tasks'),
              ),
            ],
          ),
        ),

        Expanded(
          child: ListView.builder(
            controller: verticalScrollController,
            itemCount: modules.length,
            itemBuilder: (context, index) {
              return _buildTableRow(context, modules[index], index, flexRatios);
            },
          ),
        ),
      ],
    );
  }

  List<int> _getFlexRatios(double screenWidth) {
    if (screenWidth < 400) {
      return [1, 3, 2, 2]; // Smaller screens
    } else if (screenWidth < 600) {
      return [1, 4, 3, 2]; // Default mobile
    } else {
      return [1, 5, 4, 3]; // Larger screens
    }
  }

  Widget _buildHeaderCell(
    BuildContext context,
    String title,
    String tooltip, {
    required int flex,
    Key? key,
  }) {
    final theme = Theme.of(context);

    return Expanded(
      flex: flex,
      child: Tooltip(
        message: tooltip,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.paddingS,
            vertical: AppDimens.paddingXS,
          ),
          child: Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

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
        module.progressNextStudyDate != null &&
        module.progressNextStudyDate!.isBefore(
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
                          alpha: 0.12,
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
                        module.moduleTitle.isEmpty
                            ? 'Unnamed'
                            : module.moduleTitle,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      Text(
                        module.bookName.isEmpty ? 'No book' : module.bookName,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),

              Expanded(
                flex: flexRatios[2],
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.paddingS,
                  ),
                  child:
                      module.progressNextStudyDate != null
                          ? Text(
                            DateFormat(
                              'MMM dd, yyyy',
                            ).format(module.progressNextStudyDate!),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: isNearDue ? theme.colorScheme.error : null,
                              fontWeight: isNearDue ? FontWeight.bold : null,
                            ),
                          )
                          : const Text('-'),
                ),
              ),

              Expanded(
                flex: flexRatios[3],
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.paddingS,
                  ),
                  child:
                      module.progressDueTaskCount != null
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
                                    alpha: 0.12,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    AppDimens.radiusM,
                                  ),
                                ),
                                child: Text(
                                  module.progressDueTaskCount.toString(),
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
