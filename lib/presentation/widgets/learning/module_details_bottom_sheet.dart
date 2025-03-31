import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spaced_learning_app/core/utils/date_utils.dart';
import 'package:spaced_learning_app/domain/models/learning_module.dart';
import 'package:spaced_learning_app/presentation/utils/cycle_formatter.dart';

/// Bottom sheet that displays detailed information about a learning module
/// Enhanced for mobile view with all module details that aren't visible in the simplified table
class ModuleDetailsBottomSheet extends StatelessWidget {
  final LearningModule module;
  final String? heroTagPrefix;

  const ModuleDetailsBottomSheet({
    super.key,
    required this.module,
    this.heroTagPrefix,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      constraints: BoxConstraints(maxHeight: mediaQuery.size.height * 0.8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle for dragging
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 8),
            child: Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),

          // Main content in a scrollable container
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Module title
                  Row(
                    children: [
                      Expanded(
                        child:
                            heroTagPrefix != null
                                ? Hero(
                                  tag: '${heroTagPrefix}_${module.id}',
                                  child: Material(
                                    color: Colors.transparent,
                                    child: Text(
                                      module.subject,
                                      style: theme.textTheme.headlineSmall,
                                    ),
                                  ),
                                )
                                : Text(
                                  module.subject,
                                  style: theme.textTheme.headlineSmall,
                                ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Book info
                  Row(
                    children: [
                      Icon(
                        Icons.book,
                        color: theme.colorScheme.primary,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'From: ${module.book}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const Divider(height: 32),

                  // Key details grid
                  _buildDetailSectionTitle(context, 'Module Details'),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      _buildDetailItem(
                        context,
                        'Word Count',
                        module.wordCount.toString(),
                        Icons.text_fields,
                      ),
                      _buildDetailItem(
                        context,
                        'Progress',
                        '${module.percentage}%',
                        Icons.trending_up,
                        progressValue: module.percentage / 100,
                      ),
                      _buildDetailItem(
                        context,
                        'Cycle',
                        module.cyclesStudied != null
                            ? CycleFormatter.format(module.cyclesStudied!)
                            : 'Not started',
                        Icons.loop,
                        color:
                            module.cyclesStudied != null
                                ? Color(
                                  CycleFormatter.getColorValue(
                                    module.cyclesStudied!,
                                  ),
                                )
                                : null,
                      ),
                      _buildDetailItem(
                        context,
                        'Tasks',
                        module.taskCount?.toString() ?? 'None',
                        Icons.assignment,
                      ),
                    ],
                  ),

                  const Divider(height: 32),

                  // Vocabulary statistics
                  _buildDetailSectionTitle(context, 'Vocabulary Statistics'),
                  const SizedBox(height: 8),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _buildStatRow(
                          context: context,
                          label: 'Total Words',
                          value: module.wordCount.toString(),
                          icon: Icons.menu_book,
                        ),
                        const SizedBox(height: 12),
                        _buildStatRow(
                          context: context,
                          label: 'Words Learned',
                          value: module.learnedWords.toString(),
                          icon: Icons.spellcheck,
                        ),
                        const SizedBox(height: 12),
                        _buildStatRow(
                          context: context,
                          label: 'Remaining Words',
                          value: module.remainingWords.toString(),
                          icon: Icons.hourglass_bottom,
                        ),
                        const SizedBox(height: 12),

                        // Progress bar for vocabulary completion
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: module.percentage / 100,
                            minHeight: 8,
                            backgroundColor:
                                theme.colorScheme.surfaceContainerHighest,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              module.percentage >= 90
                                  ? Colors.green
                                  : module.percentage >= 70
                                  ? Colors.orange
                                  : Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Dates section
                  _buildDetailSectionTitle(context, 'Important Dates'),
                  const SizedBox(height: 8),

                  // First learning date
                  if (module.firstLearningDate != null)
                    _buildDateItem(
                      context,
                      'First Learning',
                      module.firstLearningDate!,
                      Icons.play_circle,
                    ),

                  // Next study date
                  if (module.nextStudyDate != null) ...[
                    const SizedBox(height: 16),
                    _buildDateItem(
                      context,
                      'Next Study',
                      module.nextStudyDate!,
                      Icons.event,
                      isUpcoming: module.nextStudyDate!.isBefore(
                        DateTime.now().add(const Duration(days: 3)),
                      ),
                    ),
                  ],

                  // Last study date if available
                  if (module.lastStudyDate != null) ...[
                    const SizedBox(height: 16),
                    _buildDateItem(
                      context,
                      'Last Study',
                      module.lastStudyDate!,
                      Icons.history,
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Study history section
                  if (module.studyHistory != null &&
                      module.studyHistory!.isNotEmpty)
                    _buildStudyHistorySection(context),

                  const SizedBox(height: 24),

                  // Action buttons
                  _buildActionButtons(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build a section title
  Widget _buildDetailSectionTitle(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(Icons.info_outline, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }

  /// Build a detail item tile
  Widget _buildDetailItem(
    BuildContext context,
    String label,
    String value,
    IconData icon, {
    double? progressValue,
    Color? color,
  }) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.colorScheme.primary;
    final size = MediaQuery.of(context).size;
    final containerWidth =
        size.width < 600 ? (size.width - 64) / 2 : (size.width - 96) / 3;

    return Container(
      width: containerWidth,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: effectiveColor.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: effectiveColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: effectiveColor,
            ),
          ),

          // Progress indicator (if applicable)
          if (progressValue != null) ...[
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: progressValue,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(
                progressValue >= 0.9
                    ? Colors.green
                    : progressValue >= 0.7
                    ? Colors.orange
                    : Colors.red,
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ],
        ],
      ),
    );
  }

  /// Build a statistics row item
  Widget _buildStatRow({
    required BuildContext context,
    required String label,
    required String value,
    required IconData icon,
  }) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: 16),
        Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
        Text(
          value,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  /// Build a date information item
  Widget _buildDateItem(
    BuildContext context,
    String label,
    DateTime date,
    IconData icon, {
    bool isUpcoming = false,
  }) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('EEEE, MMMM d, yyyy');
    final color =
        isUpcoming ? theme.colorScheme.error : theme.colorScheme.primary;

    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                dateFormat.format(date),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: isUpcoming ? FontWeight.bold : null,
                  color: isUpcoming ? theme.colorScheme.error : null,
                ),
              ),
            ],
          ),
        ),

        // If upcoming, show additional visual indicator
        if (isUpcoming)
          Chip(
            label: Text(
              'Due Soon',
              style: TextStyle(color: theme.colorScheme.onError, fontSize: 12),
            ),
            backgroundColor: theme.colorScheme.error,
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
          ),
      ],
    );
  }

  /// Build the study history section
  Widget _buildStudyHistorySection(BuildContext context) {
    if (module.studyHistory == null || module.studyHistory!.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final dateFormat = DateFormat('MMM d');
    final studyHistory = List<DateTime>.from(module.studyHistory!)
      ..sort((a, b) => b.compareTo(a)); // Sort descending

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailSectionTitle(context, 'Study History'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children:
              studyHistory.take(8).map((date) {
                final isToday = AppDateUtils.isSameDay(date, DateTime.now());

                return Tooltip(
                  message: DateFormat('MMMM d, yyyy').format(date),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isToday
                              ? theme.colorScheme.primary.withOpacity(0.2)
                              : theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color:
                            isToday
                                ? theme.colorScheme.primary
                                : theme.colorScheme.outline.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      dateFormat.format(date),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight:
                            isToday ? FontWeight.bold : FontWeight.normal,
                        color:
                            isToday
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),

        // Show 'more' indicator if there are more history items
        if ((module.studyHistory?.length ?? 0) > 8) ...[
          const SizedBox(height: 4),
          Text(
            '+ ${module.studyHistory!.length - 8} more sessions',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
    );
  }

  /// Build the action buttons for the bottom of the sheet
  Widget _buildActionButtons(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (module.percentage < 100) ...[
          ElevatedButton.icon(
            icon: const Icon(Icons.play_arrow),
            label: const Text('Start Learning'),
            style: ElevatedButton.styleFrom(
              foregroundColor: theme.colorScheme.onPrimary,
              backgroundColor: theme.colorScheme.primary,
            ),
            onPressed: () {
              Navigator.pop(context);
              // Add navigation to learning screen here
            },
          ),
          const SizedBox(width: 16),
        ],

        // Close button
        OutlinedButton.icon(
          icon: const Icon(Icons.close),
          label: const Text('Close'),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
