import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spaced_learning_app/core/utils/date_utils.dart';
import 'package:spaced_learning_app/domain/models/learning_module.dart';
import 'package:spaced_learning_app/presentation/utils/cycle_formatter.dart';

/// Bottom sheet that displays detailed information about a learning module
/// Enhanced with better keyboard handling, SafeArea, and animations
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

    // Get the MediaQuery with view insets removed to handle keyboard properly
    final mediaQuery = MediaQuery.of(context);
    final removeInsets = mediaQuery.removeViewInsets(removeBottom: true);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutQuad,
      child: SafeArea(
        // SafeArea to protect content from system UI
        bottom: true,
        child: MediaQuery(
          // Apply the adjusted MediaQuery
          data: removeInsets,
          child: DraggableScrollableSheet(
            initialChildSize: 0.5,
            maxChildSize: 0.9,
            minChildSize: 0.3,
            expand: false,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Handle for dragging
                    Padding(
                      padding: const EdgeInsets.only(top: 12, bottom: 8),
                      child: Container(
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.onSurfaceVariant.withOpacity(
                            0.3,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),

                    // Main content
                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Module title with Hero animation
                            _buildModuleTitle(theme),

                            // Book source
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
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                          color: theme.colorScheme.primary,
                                        ),
                                  ),
                                ),
                              ],
                            ),

                            const Divider(height: 32),

                            // Details grid
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
                                      ? CycleFormatter.format(
                                        module.cyclesStudied!,
                                      )
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

                            // Dates section with animation
                            AnimatedOpacity(
                              opacity: 1.0,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
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
                                      isUpcoming: module.nextStudyDate!
                                          .isBefore(
                                            DateTime.now().add(
                                              const Duration(days: 3),
                                            ),
                                          ),
                                    ),
                                  ],
                                ],
                              ),
                            ),

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
            },
          ),
        ),
      ),
    );
  }

  /// Build the module title section with hero animation
  Widget _buildModuleTitle(ThemeData theme) {
    return heroTagPrefix != null
        ? Hero(
          tag: '${heroTagPrefix}_${module.id}',
          child: Material(
            color: Colors.transparent,
            child: Text(module.subject, style: theme.textTheme.headlineSmall),
          ),
        )
        : Text(module.subject, style: theme.textTheme.headlineSmall);
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
        size.width < 600 ? (size.width - 80) / 2 : (size.width - 96) / 3;

    return Container(
      width: containerWidth,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
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
        Row(
          children: [
            Icon(Icons.history, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              'Study History',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
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
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
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
