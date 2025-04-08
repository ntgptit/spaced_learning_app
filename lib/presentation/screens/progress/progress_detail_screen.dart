import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/repetition.dart';
import 'package:spaced_learning_app/presentation/viewmodels/progress_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/repetition_viewmodel.dart';
import 'package:spaced_learning_app/presentation/widgets/common/error_display.dart';
import 'package:spaced_learning_app/presentation/widgets/common/loading_indicator.dart';
import 'package:spaced_learning_app/presentation/widgets/progress/progress_header_widget.dart';
import 'package:spaced_learning_app/presentation/widgets/progress/repetition_list_widget.dart';
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

  Future<void> _loadInitialData() async {
    await _fetchProgressAndRepetitions();
  }

  Future<void> _reloadData() async {
    await _fetchProgressAndRepetitions();
  }

  Future<void> _fetchProgressAndRepetitions() async {
    final progressViewModel = context.read<ProgressViewModel>();
    final repetitionViewModel = context.read<RepetitionViewModel>();

    await progressViewModel.loadProgressDetails(widget.progressId);
    if (mounted) {
      await repetitionViewModel.loadRepetitionsByProgressId(widget.progressId);
    }
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

    if (allCompleted) {
      _showCycleCompletionSnackBar();
      await _reloadData();
    } else {
      _showCompletionSnackBar(score);
      await _refreshRepetitionsAndProgress(
        repetitionViewModel,
        progressViewModel,
      );
    }
  }

  Future<void> _markRepetitionSkipped(String repetitionId) async {
    final repetitionViewModel = context.read<RepetitionViewModel>();
    final updatedRepetition = await repetitionViewModel.updateRepetition(
      repetitionId,
      status: RepetitionStatus.skipped,
    );

    if (mounted && updatedRepetition != null) {
      _showSnackBar('Repetition marked as skipped');
      await repetitionViewModel.loadRepetitionsByProgressId(widget.progressId);
    }
  }

  Future<void> _rescheduleRepetition(
    String repetitionId,
    DateTime newDate,
  ) async {
    final repetitionViewModel = context.read<RepetitionViewModel>();
    final updatedRepetition = await repetitionViewModel.updateRepetition(
      repetitionId,
      reviewDate: newDate,
    );

    if (mounted && updatedRepetition != null) {
      _showSnackBar('Repetition rescheduled');
      await repetitionViewModel.loadRepetitionsByProgressId(widget.progressId);
    }
  }

  Future<void> _refreshRepetitionsAndProgress(
    RepetitionViewModel repetitionViewModel,
    ProgressViewModel progressViewModel,
  ) async {
    await repetitionViewModel.loadRepetitionsByProgressId(widget.progressId);
    await progressViewModel.loadProgressDetails(widget.progressId);
  }

  void _showSnackBar(String message, {Color? backgroundColor}) {
    if (mounted) {
      final theme = Theme.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor:
              backgroundColor ?? theme.colorScheme.surfaceContainerHighest,
        ),
      );
    }
  }

  void _showCompletionSnackBar(double score) {
    _showSnackBar('Test score saved: ${score.toInt()}%');
  }

  void _showCycleCompletionSnackBar() {
    if (mounted) {
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
                SizedBox(height: AppDimens.spaceM),
                Text(
                  'The system has automatically scheduled a new review cycle with adjusted intervals based on your learning performance.',
                ),
                SizedBox(height: AppDimens.spaceM),
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
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Enter Test Score'),
          content: ScoreInputDialogContent(
            initialScore: 80.0,
            onScoreChangedFinal: (score) {
              selectedScore = score;
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, selectedScore ?? 80.0);
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
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

  AppBar _buildAppBar(String? moduleTitle) {
    return AppBar(
      title: Text(moduleTitle ?? 'Module Progress'),
      actions: [
        IconButton(
          icon: const Icon(Icons.help_outline),
          tooltip: 'Learn about repetition cycles',
          onPressed: () {
            GoRouter.of(context).push('/help/spaced-repetition');
          },
        ),
      ],
    );
  }

  Widget _buildScreenContent(ProgressViewModel progressViewModel) {
    final theme = Theme.of(context);
    final progress = progressViewModel.selectedProgress;

    if (progressViewModel.isLoading) {
      return const Center(child: AppLoadingIndicator());
    }
    if (progressViewModel.errorMessage != null) {
      return Center(
        child: ErrorDisplay(
          message: progressViewModel.errorMessage!,
          onRetry: _loadInitialData,
        ),
      );
    }
    if (progress == null) {
      return const Center(child: Text('Progress not found'));
    }

    return ListView(
      padding: const EdgeInsets.all(AppDimens.paddingL),
      children: [
        ProgressHeaderWidget(
          progress: progress,
          onCycleCompleteDialogRequested: _showCycleCompletionDialog,
        ),
        const SizedBox(height: AppDimens.spaceXXL),
        Text('Review Schedule', style: theme.textTheme.titleLarge),
        const SizedBox(height: AppDimens.spaceM),
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
