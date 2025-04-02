import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaced_learning_app/domain/models/repetition.dart';
import 'package:spaced_learning_app/presentation/screens/help/spaced_repetition_info_screen.dart';
import 'package:spaced_learning_app/presentation/viewmodels/progress_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/repetition_viewmodel.dart';
import 'package:spaced_learning_app/presentation/widgets/common/error_display.dart';
import 'package:spaced_learning_app/presentation/widgets/common/loading_indicator.dart';
import 'package:spaced_learning_app/presentation/widgets/progress/progress_header_widget.dart';
import 'package:spaced_learning_app/presentation/widgets/progress/repetition_list_widget.dart';

/// Screen displaying detailed view of a specific progress record
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

  // Data Operations
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

  // UI Utilities
  void _showSnackBar(String message, {Color backgroundColor = Colors.grey}) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: backgroundColor),
      );
    }
  }

  void _showCompletionSnackBar(double score) {
    _showSnackBar('Test score saved: ${score.toInt()}%');
  }

  void _showCycleCompletionSnackBar() {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Congratulations! You have completed this learning cycle.',
          ),
          backgroundColor: Colors.green,
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
                SizedBox(height: 8),
                Text(
                  'The system has automatically scheduled a new review cycle with adjusted intervals based on your learning performance.',
                ),
                SizedBox(height: 8),
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
    double currentScore = 80.0;
    final controller = TextEditingController(text: '80');

    return showDialog<double>(
      context: context,
      barrierDismissible: false,
      builder:
          (dialogContext) => StatefulBuilder(
            builder:
                (context, setState) => AlertDialog(
                  title: const Text('Enter Test Score'),
                  content: ScoreInputDialogContent(
                    currentScore: currentScore,
                    controller: controller,
                    onScoreChanged: (newScore) {
                      setState(() {
                        currentScore = newScore;
                        controller.text = newScore.toInt().toString();
                      });
                    },
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed:
                          () => _confirmScore(
                            dialogContext,
                            controller,
                            currentScore,
                          ),
                      child: const Text('Confirm'),
                    ),
                  ],
                ),
          ),
    );
  }

  void _confirmScore(
    BuildContext dialogContext,
    TextEditingController controller,
    double currentScore,
  ) {
    final finalValue = int.tryParse(controller.text);
    Navigator.pop(
      dialogContext,
      (finalValue != null && finalValue >= 0 && finalValue <= 100)
          ? finalValue.toDouble()
          : currentScore,
    );
  }

  // Build Methods
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
          onPressed:
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SpacedRepetitionInfoScreen(),
                ),
              ),
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
      padding: const EdgeInsets.all(16.0),
      children: [
        ProgressHeaderWidget(
          progress: progress,
          onCycleCompleteDialogRequested: _showCycleCompletionDialog,
        ),
        const SizedBox(height: 24),
        Text('Review Schedule', style: theme.textTheme.titleLarge),
        const SizedBox(height: 8),
        RepetitionListWidget(
          progressId: widget.progressId,
          onMarkCompleted: _markRepetitionCompleted,
          onMarkSkipped: _markRepetitionSkipped,
          onReschedule: _rescheduleRepetition,
          onReload: _reloadData,
        ),
      ],
    );
  }
}

// Score Input Dialog Content Widget
class ScoreInputDialogContent extends StatelessWidget {
  final double currentScore;
  final TextEditingController controller;
  final ValueChanged<double> onScoreChanged;

  const ScoreInputDialogContent({
    super.key,
    required this.currentScore,
    required this.controller,
    required this.onScoreChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Enter the score from your test on Quizlet or another tool:',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 20),
        Text(
          '${currentScore.toInt()}%',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: 20),
        Slider(
          value: currentScore,
          min: 0,
          max: 100,
          divisions: 20,
          label: '${currentScore.toInt()}%',
          onChanged: onScoreChanged,
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Text('Enter exact score: '),
            Expanded(
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  suffixText: '%',
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  final intValue = int.tryParse(value);
                  if (intValue != null && intValue >= 0 && intValue <= 100) {
                    onScoreChanged(intValue.toDouble());
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:
              [
                0,
                25,
                50,
                75,
                100,
              ].map((score) => _buildScoreButton(score)).toList(),
        ),
      ],
    );
  }

  Widget _buildScoreButton(int score) {
    final isSelected = currentScore.toInt() == score;
    return InkWell(
      onTap: () => onScoreChanged(score.toDouble()),
      borderRadius: BorderRadius.circular(8), // Sửa lỗi cú pháp
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.green.shade700 : Colors.grey.shade400,
          ),
        ),
        child: Text(
          '$score%',
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
