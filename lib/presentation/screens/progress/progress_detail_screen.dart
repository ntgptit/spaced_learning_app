import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:spaced_learning_app/domain/models/repetition.dart';
import 'package:spaced_learning_app/presentation/utils/snackbar_utils.dart';
import 'package:spaced_learning_app/presentation/viewmodels/progress_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/repetition_viewmodel.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_button.dart';
import 'package:spaced_learning_app/presentation/widgets/common/error_display.dart';
import 'package:spaced_learning_app/presentation/widgets/progress/progress_header_widget.dart';
import 'package:spaced_learning_app/presentation/widgets/progress/reschedule_dialog.dart';
import 'package:spaced_learning_app/presentation/widgets/progress/score_input_dialog_content.dart';
import 'package:spaced_learning_app/presentation/widgets/repetition/repetition_list_widget.dart';

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
    _loadInitialData();
  }

  Future<void> _loadInitialData() => _fetchProgressAndRepetitions();
  Future<void> _reloadData() => _fetchProgressAndRepetitions();

  Future<void> _fetchProgressAndRepetitions() async {
    final progressViewModel = context.read<ProgressViewModel>();
    final repetitionViewModel = context.read<RepetitionViewModel>();
    await progressViewModel.loadProgressDetails(widget.progressId);
    if (!mounted) return;
    await repetitionViewModel.loadRepetitionsByProgressId(widget.progressId);
  }

  Future<void> _markRepetitionCompleted(String repetitionId) async {
    final score = await _showScoreInputDialog();
    if (score == null || !mounted) return;

    final repetitionViewModel = context.read<RepetitionViewModel>();
    final progressViewModel = context.read<ProgressViewModel>();

    final updatedRepetition = await repetitionViewModel.updateRepetition(
      repetitionId,
      status: RepetitionStatus.completed,
      percentComplete: score,
    );

    if (updatedRepetition == null || !mounted) return;

    final allCompleted = await repetitionViewModel.areAllRepetitionsCompleted(
      updatedRepetition.moduleProgressId,
    );

    if (!mounted) return;

    if (allCompleted) {
      _showCycleCompletionSnackBar();
    } else {
      _showCompletionSnackBar(score);
    }

    await _refreshRepetitionsAndProgress(
      repetitionViewModel,
      progressViewModel,
    );
  }

  Future<void> _rescheduleRepetition(
    String repetitionId,
    DateTime currentDate,
    bool rescheduleFollowing,
  ) async {
    final repetitionViewModel = context.read<RepetitionViewModel>();
    final currentRepetition = repetitionViewModel.repetitions.firstWhere(
      (r) => r.id == repetitionId,
    );

    final result = await RescheduleDialog.show(
      context,
      initialDate: currentDate,
      title: 'Reschedule ${currentRepetition.formatFullOrder()}',
    );

    if (result == null || !mounted) return;

    final newDate = result['date'] as DateTime;
    final rescheduleFollowing = result['rescheduleFollowing'] as bool;

    final updatedRepetition = await repetitionViewModel.updateRepetition(
      repetitionId,
      reviewDate: newDate,
      rescheduleFollowing: rescheduleFollowing,
    );

    if (updatedRepetition == null || !mounted) return;

    SnackBarUtils.show(
      context,
      'Repetition rescheduled to ${DateFormat('MMM dd, yyyy').format(newDate)}',
    );

    await repetitionViewModel.loadRepetitionsByProgressId(widget.progressId);
  }

  Future<void> _refreshRepetitionsAndProgress(
    RepetitionViewModel repetitionViewModel,
    ProgressViewModel progressViewModel,
  ) async {
    await repetitionViewModel.loadRepetitionsByProgressId(widget.progressId);
    await progressViewModel.loadProgressDetails(widget.progressId);
  }

  void _showCompletionSnackBar(double score) {
    SnackBarUtils.show(
      context,
      'Test score saved: ${score.toInt()}%',
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
    );
  }

  void _showCycleCompletionSnackBar() {
    if (!mounted) return;

    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Congratulations! You have completed this learning cycle.',
        ),
        backgroundColor: theme.colorScheme.tertiary,
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'Details',
          onPressed: _showCycleCompletionDialog,
          textColor: theme.colorScheme.onTertiary,
        ),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showCycleCompletionDialog() {
    if (!mounted) return;

    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Row(
              children: [
                Icon(Icons.celebration, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                const Text('Learning Cycle Completed!'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoItem(
                  theme,
                  Icons.check_circle_outline,
                  'You have completed all repetitions in this cycle.',
                ),
                const SizedBox(height: 16),
                _buildInfoItem(
                  theme,
                  Icons.schedule,
                  'The system has automatically scheduled a new review cycle with adjusted intervals based on your learning performance.',
                ),
                const SizedBox(height: 16),
                _buildInfoItem(
                  theme,
                  Icons.trending_up,
                  'Keep up with regular reviews to maximize your learning efficiency.',
                ),
              ],
            ),
            actions: [
              AppButton(
                text: 'Got it',
                type: AppButtonType.primary,
                size: AppButtonSize.small, // Changed to small
                onPressed: () => Navigator.pop(context),
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: theme.colorScheme.surface,
          ),
    );
  }

  Widget _buildInfoItem(ThemeData theme, IconData iconData, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(iconData, color: theme.colorScheme.primary, size: 20),
        const SizedBox(width: 12),
        Expanded(child: Text(text)),
      ],
    );
  }

  Future<double?> _showScoreInputDialog() async {
    final scoreNotifier = ValueNotifier<double>(80.0);

    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder:
          (dialogContext) => AlertDialog(
            title: Row(
              children: [
                Icon(
                  Icons.school,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                const Text('Enter Test Score'),
              ],
            ),
            content: ScoreInputDialogContent(scoreNotifier: scoreNotifier),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: const Text('Confirm'),
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
    );

    if (confirmed != true) {
      scoreNotifier.dispose();
      return null;
    }

    final finalScore = scoreNotifier.value;
    scoreNotifier.dispose();
    return finalScore;
  }

  @override
  Widget build(BuildContext context) {
    final progressViewModel = context.watch<ProgressViewModel>();

    return Scaffold(
      appBar: _buildAppBar(progressViewModel.selectedProgress?.moduleTitle),
      body: RefreshIndicator(
        onRefresh: _loadInitialData,
        child: _buildScreenContent(progressViewModel),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(String? moduleTitle) {
    final theme = Theme.of(context);
    return AppBar(
      title: Text(moduleTitle ?? 'Module Progress'),
      centerTitle: true,
      elevation: 0,
      backgroundColor: theme.colorScheme.surface,
      foregroundColor: theme.colorScheme.onSurface,
      actions: [
        IconButton(
          icon: const Icon(Icons.help_outline),
          tooltip: 'Learn about repetition cycles',
          onPressed: () => GoRouter.of(context).push('/help/spaced-repetition'),
        ),
      ],
    );
  }

  Widget _buildScreenContent(ProgressViewModel progressViewModel) {
    if (progressViewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (progressViewModel.errorMessage != null) {
      return Center(
        child: ErrorDisplay(
          message: progressViewModel.errorMessage!,
          onRetry: _loadInitialData,
        ),
      );
    }

    final progress = progressViewModel.selectedProgress;
    if (progress == null) {
      return const Center(child: Text('Progress not found'));
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ProgressHeaderWidget(
          progress: progress,
          onCycleCompleteDialogRequested: _showCycleCompletionDialog,
        ),
        const SizedBox(height: 32),
        _buildReviewScheduleSection(progress),
      ],
    );
  }

  Widget _buildReviewScheduleSection(progress) {
    final theme = Theme.of(context);

    return Card(
      elevation: 1,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text('Review Schedule', style: theme.textTheme.titleLarge),
              ],
            ),
            const SizedBox(height: 16),
            RepetitionListWidget(
              progressId: widget.progressId,
              currentCycleStudied: progress.cyclesStudied,
              onMarkCompleted: _markRepetitionCompleted,
              onReschedule: _rescheduleRepetition,
              onReload: _reloadData,
            ),
          ],
        ),
      ),
    );
  }
}
