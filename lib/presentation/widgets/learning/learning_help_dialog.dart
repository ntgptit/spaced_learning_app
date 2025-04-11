import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/progress.dart';
import 'package:spaced_learning_app/presentation/utils/cycle_formatter.dart';

class LearningHelpDialog extends StatelessWidget {
  const LearningHelpDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    final bool isSmallScreen = size.width < AppDimens.breakpointS;
    final double maxDialogWidth = isSmallScreen ? size.width * 0.95 : 500.0;
    final double maxDialogHeight = size.height * 0.7;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusL),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: maxDialogWidth,
          maxHeight: maxDialogHeight,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppDimens.paddingL),
              child: Row(
                children: [
                  Icon(Icons.help_outline, color: theme.colorScheme.primary),
                  const SizedBox(width: AppDimens.spaceS),
                  Expanded(
                    child: Text(
                      'Learning Progress Help',
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip: 'Close',
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
            const Divider(height: AppDimens.dividerThickness),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimens.paddingL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'This screen shows your learning progress across all modules.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppDimens.spaceL),
                    _buildHelpSection(context, 'Features', [
                      '• Use the Book filter to view modules from a specific book',
                      '• Use the Date filter to see modules due on a specific date',
                      '• Click on any module to see detailed information',
                      '• The Progress column shows your completion percentage',
                      '• Due dates highlighted in red are approaching soon',
                      '• Export your data using the Export button in the footer',
                    ]),
                    const SizedBox(height: AppDimens.spaceL),
                    _buildHelpSection(context, 'Learning Cycles', [
                      for (final cycle in CycleStudied.values)
                        '• ${CycleFormatter.format(cycle)}: ${CycleFormatter.getDescription(cycle)}',
                    ]),
                    const SizedBox(height: AppDimens.spaceL),
                    _buildHelpSection(context, 'Tips', [
                      '• Review your learning material according to the spaced repetition schedule',
                      '• Focus on modules that are due soon',
                      '• Complete all repetitions in a cycle before moving to the next one',
                      '• Use the export feature to keep track of your progress over time',
                    ]),
                  ],
                ),
              ),
            ),
            const Divider(height: AppDimens.dividerThickness),
            Padding(
              padding: const EdgeInsets.all(AppDimens.paddingM),
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpSection(
    BuildContext context,
    String title,
    List<String> items,
  ) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isCompact = size.width < AppDimens.breakpointXS;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: AppDimens.spaceXS),
        ...items.map(
          (item) => Padding(
            padding: EdgeInsets.only(
              bottom: isCompact ? AppDimens.spaceXXS : AppDimens.spaceXS,
              left: isCompact ? 0 : AppDimens.paddingXS,
            ),
            child: Text(
              item,
              style:
                  isCompact
                      ? theme.textTheme.bodySmall
                      : theme.textTheme.bodyMedium,
            ),
          ),
        ),
      ],
    );
  }
}
