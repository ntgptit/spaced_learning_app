import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:spaced_learning_app/domain/models/repetition.dart';
import 'package:spaced_learning_app/presentation/utils/snackbar_utils.dart';
import 'package:spaced_learning_app/presentation/viewmodels/progress_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/repetition_viewmodel.dart';
import 'package:spaced_learning_app/presentation/widgets/common/error_display.dart';
import 'package:spaced_learning_app/presentation/widgets/progress/progress_header_widget.dart';
import 'package:spaced_learning_app/presentation/widgets/progress/repetition_list_widget.dart';
import 'package:spaced_learning_app/presentation/widgets/progress/reschedule_dialog.dart';
import 'package:spaced_learning_app/presentation/widgets/progress/score_input_dialog_content.dart';

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
    );
    if (!mounted || updatedRepetition == null) return;
    await progressViewModel.updateProgress(
      widget.progressId,
      percentComplete: score,
    );
    if (!mounted) return;
    final allCompleted = await repetitionViewModel.areAllRepetitionsCompleted(
      updatedRepetition.moduleProgressId,
    );
    if (!mounted) return;
    allCompleted
        ? _handleCycleCompletion()
        : _handleSingleCompletion(
          repetitionViewModel,
          progressViewModel,
          score,
        );
  }

  Future<void> _markRepetitionSkipped(String repetitionId) async {
    final repetitionViewModel = context.read<RepetitionViewModel>();
    final updatedRepetition = await repetitionViewModel.updateRepetition(
      repetitionId,
      status: RepetitionStatus.skipped,
    );
    if (!mounted || updatedRepetition == null) return;
    SnackBarUtils.show(context, 'Repetition marked as skipped');
    await repetitionViewModel.loadRepetitionsByProgressId(widget.progressId);
  }

  Future<void> _rescheduleRepetition(
    String repetitionId,
    DateTime currentDate,
    bool rescheduleFollowing,
  ) async {
    await _showRescheduleDialog(repetitionId, currentDate);
  }

  Future<void> _refreshRepetitionsAndProgress(
    RepetitionViewModel repetitionViewModel,
    ProgressViewModel progressViewModel,
  ) async {
    await repetitionViewModel.loadRepetitionsByProgressId(widget.progressId);
    await progressViewModel.loadProgressDetails(widget.progressId);
  }

  void _showSnackBar(String message, {Color? backgroundColor}) {
    SnackBarUtils.show(context, message, backgroundColor: backgroundColor);
  }

  void _showCompletionSnackBar(double score) =>
      _showSnackBar('Test score saved: ${score.toInt()}%');

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
        ),
      ),
    );
  }

  void _showCycleCompletionDialog() {
    if (!mounted) return;
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Learning Cycle Completed!'),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('You have completed all repetitions in this cycle.'),
                SizedBox(height: 16),
                Text(
                  'The system has automatically scheduled a new review cycle with adjusted intervals based on your learning performance.',
                ),
                SizedBox(height: 16),
                Text(
                  'Keep up with regular reviews to maximize your learning efficiency.',
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Got it'),
              ),
            ],
          ),
    );
  }

  Future<double?> _showScoreInputDialog() async {
    double? selectedScore;
    return showDialog<double>(
      context: context,
      barrierDismissible: false,
      builder:
          (dialogContext) => AlertDialog(
            title: const Text('Enter Test Score'),
            content: ScoreInputDialogContent(
              initialScore: 80.0,
              onScoreChangedFinal: (score) => selectedScore = score,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed:
                    () => Navigator.pop(dialogContext, selectedScore ?? 80.0),
                child: const Text('Confirm'),
              ),
            ],
          ),
    );
  }

  Future<void> _showRescheduleDialog(
    String repetitionId,
    DateTime currentDate,
  ) async {
    final repetitionViewModel = context.read<RepetitionViewModel>();
    final currentRepetition = repetitionViewModel.repetitions.firstWhere(
      (r) => r.id == repetitionId,
    );
    final result = await RescheduleDialog.show(
      context,
      initialDate: currentDate,
      title: 'Reschedule Repetition #${currentRepetition.formatOrder()}',
    );
    if (result != null && mounted) {
      final newDate = result['date'] as DateTime;
      final rescheduleFollowing = result['rescheduleFollowing'] as bool;
      final updatedRepetition = await repetitionViewModel.updateRepetition(
        repetitionId,
        reviewDate: newDate,
        rescheduleFollowing: rescheduleFollowing,
      );
      if (mounted && updatedRepetition != null) {
        _showSnackBar(
          'Repetition rescheduled to ${DateFormat('dd MMM yyyy').format(newDate)}',
        );
        await repetitionViewModel.loadRepetitionsByProgressId(
          widget.progressId,
        );
      }
    }
  }

  void _handleCycleCompletion() {
    _showCycleCompletionSnackBar();
    _reloadData();
  }

  void _handleSingleCompletion(
    RepetitionViewModel repetitionViewModel,
    ProgressViewModel progressViewModel,
    double score,
  ) {
    _showCompletionSnackBar(score);
    _refreshRepetitionsAndProgress(repetitionViewModel, progressViewModel);
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

  AppBar _buildAppBar(String? moduleTitle) => AppBar(
    title: Text(moduleTitle ?? 'Module Progress'),
    actions: [
      IconButton(
        icon: const Icon(Icons.help_outline),
        tooltip: 'Learn about repetition cycles',
        onPressed: () => GoRouter.of(context).push('/help/spaced-repetition'),
      ),
    ],
  );

  Widget _buildScreenContent(ProgressViewModel progressViewModel) {
    final theme = Theme.of(context);
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
        Text('Review Schedule', style: theme.textTheme.titleLarge),
        const SizedBox(height: 16),
        RepetitionListWidget(
          progressId: widget.progressId,
          currentCycleStudied: progress.cyclesStudied,
          onMarkCompleted: _markRepetitionCompleted,
          onMarkSkipped: _markRepetitionSkipped,
          onReschedule: _rescheduleRepetition,
          onReload: _reloadData,
        ),
      ],
    );
  }
}
