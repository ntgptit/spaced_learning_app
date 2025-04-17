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

  ProgressDetailScreen({super.key, required this.progressId}) {
    // Thêm log để kiểm tra giá trị khi khởi tạo
    debugPrint('ProgressDetailScreen created with progressId: $progressId');
  }

  @override
  State<ProgressDetailScreen> createState() => _ProgressDetailScreenState();
}

class _ProgressDetailScreenState extends State<ProgressDetailScreen> {
  late Future<void> _dataLoadingFuture;
  bool _isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    if (widget.progressId.isEmpty) {
      debugPrint('WARNING: Empty progressId passed to ProgressDetailScreen!');
    }
    _dataLoadingFuture = Future.value();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isFirstLoad) {
      _isFirstLoad = false;
      // Khởi tạo _dataLoadingFuture để FutureBuilder có thể sử dụng
      _dataLoadingFuture = Future(() async {
        // Sử dụng một microtask để đảm bảo chờ build hoàn thành
        await Future.microtask(() async {
          await _loadInitialData();
        });
      });
    }
  }

  Future<void> _loadInitialData() async {
    try {
      debugPrint(
        'Starting initial data load for progressId: ${widget.progressId}',
      );
      await _fetchProgressAndRepetitions();
    } catch (e) {
      debugPrint('Error loading initial data: $e');
      rethrow;
    }
  }

  Future<void> _reloadData() async {
    if (mounted) {
      debugPrint('Reloading data for progressId: ${widget.progressId}');
      setState(() {
        _dataLoadingFuture = _fetchProgressAndRepetitions();
      });
    }
  }

  Future<void> _fetchProgressAndRepetitions() async {
    // Validate progressId before proceeding
    if (widget.progressId.isEmpty) {
      throw Exception('Invalid progress ID: Empty ID provided');
    }

    debugPrint('Fetching data for progressId: ${widget.progressId}');

    final progressViewModel = Provider.of<ProgressViewModel>(
      context,
      listen: false,
    );
    final repetitionViewModel = Provider.of<RepetitionViewModel>(
      context,
      listen: false,
    );

    // Clear any previous data
    progressViewModel.clearSelectedProgress();
    repetitionViewModel.clearRepetitions();

    // Load progress details first
    await progressViewModel.loadProgressDetails(widget.progressId);
    if (!mounted) return;

    // Log the result for debugging
    debugPrint(
      'Progress details loaded: ${progressViewModel.selectedProgress?.id}',
    );

    // Then load repetitions
    await repetitionViewModel.loadRepetitionsByProgressId(widget.progressId);
    if (!mounted) return;

    debugPrint('Repetitions loaded: ${repetitionViewModel.repetitions.length}');
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
      builder: (context) => AlertDialog(
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
      builder: (dialogContext) => AlertDialog(
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
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.warning_amber, size: 48, color: Colors.orange),
            const SizedBox(height: 16),
            Text(
              'Progress with ID ${widget.progressId} not found',
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _reloadData,
              child: const Text('Try Again'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => GoRouter.of(context).go('/due-progress'),
              child: const Text('Go Back'),
            ),
          ],
        ),
      );
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
