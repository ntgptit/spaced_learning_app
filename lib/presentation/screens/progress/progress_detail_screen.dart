import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:spaced_learning_app/domain/models/repetition.dart';
import 'package:spaced_learning_app/presentation/utils/snackbar_utils.dart';
import 'package:spaced_learning_app/presentation/viewmodels/progress_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/repetition_viewmodel.dart';
import 'package:spaced_learning_app/presentation/widgets/common/error_display.dart';
import 'package:spaced_learning_app/presentation/widgets/common/loading_indicator.dart';
import 'package:spaced_learning_app/presentation/widgets/progress/progress_header_widget.dart';
import 'package:spaced_learning_app/presentation/widgets/progress/reschedule_dialog.dart';
import 'package:spaced_learning_app/presentation/widgets/progress/score_input_dialog_content.dart';
import 'package:spaced_learning_app/presentation/widgets/repetition/repetition_list_widget.dart';

@pragma('vm:entry-point')
class ProgressDetailScreen extends StatefulWidget {
  final String progressId;

  const ProgressDetailScreen({super.key, required this.progressId});

  @override
  State<ProgressDetailScreen> createState() => _ProgressDetailScreenState();
}

class _ProgressDetailScreenState extends State<ProgressDetailScreen> {
  late Future<void> _dataLoadingFuture;
  bool _isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    _dataLoadingFuture = _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      await _fetchProgressAndRepetitions();
      if (mounted) {
        setState(() {
          _isFirstLoad = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading initial data: $e');
      // Error will be handled by FutureBuilder
      rethrow;
    }
  }

  Future<void> _reloadData() async {
    if (mounted) {
      setState(() {
        _dataLoadingFuture = _fetchProgressAndRepetitions();
      });
    }
  }

  Future<void> _fetchProgressAndRepetitions() async {
    final progressViewModel = Provider.of<ProgressViewModel>(
      context,
      listen: false,
    );
    final repetitionViewModel = Provider.of<RepetitionViewModel>(
      context,
      listen: false,
    );

    // Load progress details first
    await progressViewModel.loadProgressDetails(widget.progressId);
    if (!mounted) return;

    // Then load repetitions
    await repetitionViewModel.loadRepetitionsByProgressId(widget.progressId);
  }

  Future<void> _markRepetitionCompleted(String repetitionId) async {
    final score = await _showScoreInputDialog();

    if (score == null) {
      debugPrint('Score input cancelled.');
      return;
    }
    if (!mounted) return;

    debugPrint('Score received from dialog: $score');

    final repetitionViewModel = Provider.of<RepetitionViewModel>(
      context,
      listen: false,
    );
    final progressViewModel = Provider.of<ProgressViewModel>(
      context,
      listen: false,
    );

    final updatedRepetition = await repetitionViewModel.updateRepetition(
      repetitionId,
      status: RepetitionStatus.completed,
      percentComplete: score,
    );

    if (!mounted || updatedRepetition == null) return;

    final allCompleted = await repetitionViewModel.areAllRepetitionsCompleted(
      updatedRepetition.moduleProgressId,
    );

    if (!mounted) return;

    if (allCompleted) {
      _handleCycleCompletion();
    } else {
      _handleSingleCompletion(repetitionViewModel, progressViewModel, score);
    }

    // Always reload data after any update
    await _reloadData();
  }

  Future<void> _rescheduleRepetition(
    String repetitionId,
    DateTime currentDate,
    bool rescheduleFollowing,
  ) async {
    await _showRescheduleDialog(repetitionId, currentDate);
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
    final scoreNotifier = ValueNotifier<double>(80.0);

    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder:
          (dialogContext) => AlertDialog(
            title: const Text('Enter Test Score'),
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
          ),
    );

    if (confirmed == true) {
      final finalScore = scoreNotifier.value;
      scoreNotifier.dispose();
      return finalScore;
    } else {
      scoreNotifier.dispose();
      return null;
    }
  }

  Future<void> _showRescheduleDialog(
    String repetitionId,
    DateTime currentDate,
  ) async {
    final repetitionViewModel = Provider.of<RepetitionViewModel>(
      context,
      listen: false,
    );
    final currentRepetition = repetitionViewModel.repetitions.firstWhere(
      (r) => r.id == repetitionId,
      orElse: () => throw Exception('Repetition not found'),
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
          'Repetition rescheduled to ${DateFormat('dd MMM').format(newDate)}',
        );

        // Always reload data after any update
        await _reloadData();
      }
    }
  }

  void _handleCycleCompletion() {
    _showCycleCompletionSnackBar();
  }

  void _handleSingleCompletion(
    RepetitionViewModel repetitionViewModel,
    ProgressViewModel progressViewModel,
    double score,
  ) {
    _showCompletionSnackBar(score);
  }

  @override
  Widget build(BuildContext context) {
    final progressViewModel = context.watch<ProgressViewModel>();

    return Scaffold(
      appBar: _buildAppBar(progressViewModel.selectedProgress?.moduleTitle),
      body: FutureBuilder(
        future: _dataLoadingFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              _isFirstLoad) {
            return const Center(child: AppLoadingIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: ErrorDisplay(
                message: 'Failed to load data: ${snapshot.error}',
                onRetry: _reloadData,
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _reloadData,
            child: _buildScreenContent(progressViewModel),
          );
        },
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

    if (progressViewModel.isLoading && _isFirstLoad) {
      return const Center(child: AppLoadingIndicator());
    }

    if (progressViewModel.errorMessage != null) {
      return Center(
        child: ErrorDisplay(
          message: progressViewModel.errorMessage!,
          onRetry: _reloadData,
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
          onReschedule: _rescheduleRepetition,
          onReload: _reloadData,
        ),
      ],
    );
  }
}
