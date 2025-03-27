import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:spaced_learning_app/domain/models/progress.dart';
import 'package:spaced_learning_app/domain/models/repetition.dart';
import 'package:spaced_learning_app/presentation/viewmodels/progress_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/repetition_viewmodel.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_button.dart';
import 'package:spaced_learning_app/presentation/widgets/common/error_display.dart';
import 'package:spaced_learning_app/presentation/widgets/common/loading_indicator.dart';
import 'package:spaced_learning_app/presentation/widgets/repetition/repetition_card.dart';

/// Screen for detailed view of a specific progress record
class ProgressDetailScreen extends StatefulWidget {
  final String progressId;

  const ProgressDetailScreen({super.key, required this.progressId});

  @override
  State<ProgressDetailScreen> createState() => _ProgressDetailScreenState();
}

class _ProgressDetailScreenState extends State<ProgressDetailScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final progressViewModel = context.read<ProgressViewModel>();
    await progressViewModel.loadProgressDetails(widget.progressId);

    final repetitionViewModel = context.read<RepetitionViewModel>();
    await repetitionViewModel.loadRepetitionsByProgressId(widget.progressId);
  }

  /// Mark a repetition as completed
  Future<void> _markCompleted(String repetitionId) async {
    final repetitionViewModel = context.read<RepetitionViewModel>();

    final repetition = await repetitionViewModel.updateRepetition(
      repetitionId,
      status: RepetitionStatus.completed,
    );

    if (repetition != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Repetition marked as completed')),
      );

      // Update progress percentage
      await _updateProgressPercentage();
    }
  }

  /// Mark a repetition as skipped
  Future<void> _markSkipped(String repetitionId) async {
    final repetitionViewModel = context.read<RepetitionViewModel>();

    final repetition = await repetitionViewModel.updateRepetition(
      repetitionId,
      status: RepetitionStatus.skipped,
    );

    if (repetition != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Repetition marked as skipped')),
      );
    }
  }

  /// Reschedule a repetition
  Future<void> _rescheduleRepetition(String repetitionId) async {
    final dateFormat = DateFormat('yyyy-MM-dd');

    // Show date picker
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );

    if (date != null && mounted) {
      final repetitionViewModel = context.read<RepetitionViewModel>();

      final repetition = await repetitionViewModel.updateRepetition(
        repetitionId,
        reviewDate: date,
      );

      if (repetition != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Repetition rescheduled to ${dateFormat.format(date)}',
            ),
          ),
        );
      }
    }
  }

  /// Update progress percentage based on completed repetitions
  Future<void> _updateProgressPercentage() async {
    final repetitionViewModel = context.read<RepetitionViewModel>();
    final progressViewModel = context.read<ProgressViewModel>();
    final progress = progressViewModel.selectedProgress;

    if (progress == null) return;

    // Calculate new percentage based on completed repetitions
    final totalRepetitions = repetitionViewModel.repetitions.length;
    if (totalRepetitions == 0) return;

    final completedRepetitions =
        repetitionViewModel.repetitions
            .where((r) => r.status == RepetitionStatus.completed)
            .length;

    final newPercentage = (completedRepetitions / totalRepetitions) * 100;

    // Update progress percentage
    await progressViewModel.updateProgress(
      progress.id,
      percentComplete: newPercentage,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progressViewModel = context.watch<ProgressViewModel>();
    final progress = progressViewModel.selectedProgress;

    return Scaffold(
      appBar: AppBar(title: Text(progress?.moduleTitle ?? 'Module Progress')),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: _buildBody(
          theme,
          progress,
          progressViewModel.isLoading,
          progressViewModel.errorMessage,
        ),
      ),
    );
  }

  /// Build the screen body based on loading state
  Widget _buildBody(
    ThemeData theme,
    ProgressDetail? progress,
    bool isLoading,
    String? errorMessage,
  ) {
    if (isLoading) {
      return const Center(child: AppLoadingIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: ErrorDisplay(message: errorMessage, onRetry: _loadData),
      );
    }

    if (progress == null) {
      return const Center(child: Text('Progress not found'));
    }

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Progress header
        _buildProgressHeader(theme, progress),
        const SizedBox(height: 24),

        // Repetitions section
        Text('Repetition Schedule', style: theme.textTheme.titleLarge),
        const SizedBox(height: 8),

        _buildRepetitionsList(),
      ],
    );
  }

  /// Build the progress header with stats
  Widget _buildProgressHeader(ThemeData theme, ProgressDetail progress) {
    final dateFormat = DateFormat('MMM dd, yyyy');

    // Format dates
    final startDateText =
        progress.firstLearningDate != null
            ? dateFormat.format(progress.firstLearningDate!)
            : 'Not started';

    final nextDateText =
        progress.nextStudyDate != null
            ? dateFormat.format(progress.nextStudyDate!)
            : 'Not scheduled';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Module title
            Text(
              progress.moduleTitle ?? 'Module',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            // Progress bar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Progress', style: theme.textTheme.titleMedium),
                    Text(
                      '${progress.percentComplete.toInt()}%',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress.percentComplete / 100,
                    minHeight: 10,
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Metadata
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    theme,
                    'Started',
                    startDateText,
                    Icons.play_circle_outline,
                  ),
                ),
                Expanded(
                  child: _buildInfoItem(
                    theme,
                    'Next Study',
                    nextDateText,
                    Icons.event,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    theme,
                    'Cycle',
                    _formatCycleStudied(progress.cyclesStudied),
                    Icons.sync,
                  ),
                ),
                Expanded(
                  child: _buildInfoItem(
                    theme,
                    'Repetitions',
                    progress.repetitions.length.toString(),
                    Icons.repeat,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Build an info item
  Widget _buildInfoItem(
    ThemeData theme,
    String label,
    String value,
    IconData icon,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: theme.textTheme.bodySmall),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build the list of repetitions
  Widget _buildRepetitionsList() {
    final repetitionViewModel = context.watch<RepetitionViewModel>();

    if (repetitionViewModel.isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: AppLoadingIndicator(),
        ),
      );
    }

    if (repetitionViewModel.errorMessage != null) {
      return ErrorDisplay(
        message: repetitionViewModel.errorMessage!,
        onRetry:
            () => repetitionViewModel.loadRepetitionsByProgressId(
              widget.progressId,
            ),
        compact: true,
      );
    }

    if (repetitionViewModel.repetitions.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Center(
          child: Column(
            children: [
              const Text('No repetitions found for this module'),
              const SizedBox(height: 8),
              AppButton(
                text: 'Create Schedule',
                type: AppButtonType.primary,
                onPressed: () async {
                  final repetitionViewModel =
                      context.read<RepetitionViewModel>();
                  await repetitionViewModel.createDefaultSchedule(
                    widget.progressId,
                  );
                },
              ),
            ],
          ),
        ),
      );
    }

    // Sort repetitions by order
    final repetitions = List.of(repetitionViewModel.repetitions);
    repetitions.sort(
      (a, b) => a.repetitionOrder.index.compareTo(b.repetitionOrder.index),
    );

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: repetitions.length,
      itemBuilder: (context, index) {
        final repetition = repetitions[index];
        return RepetitionCard(
          repetition: repetition,
          onMarkCompleted:
              repetition.status == RepetitionStatus.notStarted
                  ? () => _markCompleted(repetition.id)
                  : null,
          onSkip:
              repetition.status == RepetitionStatus.notStarted
                  ? () => _markSkipped(repetition.id)
                  : null,
          onReschedule:
              repetition.status == RepetitionStatus.notStarted
                  ? () => _rescheduleRepetition(repetition.id)
                  : null,
        );
      },
    );
  }

  /// Format cycle studied enum to user-friendly string
  String _formatCycleStudied(CycleStudied cycle) {
    switch (cycle) {
      case CycleStudied.firstTime:
        return 'First Time';
      case CycleStudied.firstReview:
        return 'First Review';
      case CycleStudied.secondReview:
        return 'Second Review';
      case CycleStudied.thirdReview:
        return 'Third Review';
      case CycleStudied.moreThanThreeReviews:
        return 'Multiple Reviews';
    }
  }
}
