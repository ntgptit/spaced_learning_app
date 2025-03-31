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

  // Data operations
  Future<void> _loadData() async {
    final progressViewModel = context.read<ProgressViewModel>();
    final repetitionViewModel = context.read<RepetitionViewModel>();
    await progressViewModel.loadProgressDetails(widget.progressId);
    if (mounted) {
      await repetitionViewModel.loadRepetitionsByProgressId(widget.progressId);
    }
  }

  Future<void> _reloadData() async {
    final progressViewModel = context.read<ProgressViewModel>();
    final repetitionViewModel = context.read<RepetitionViewModel>();
    await progressViewModel.loadProgressDetails(widget.progressId);
    if (mounted) {
      await repetitionViewModel.loadRepetitionsByProgressId(widget.progressId);
    }
  }

  Future<void> _handleMarkCompleted(String repetitionId) async {
    final score = await _showCompletionScoreDialog();
    if (score == null || !mounted) return;

    final repetitionViewModel = context.read<RepetitionViewModel>();
    final progressViewModel = context.read<ProgressViewModel>();

    final repetition = await repetitionViewModel.updateRepetition(
      repetitionId,
      status: RepetitionStatus.completed,
    );

    if (!mounted || repetition == null) return;

    await progressViewModel.updateProgress(
      widget.progressId,
      percentComplete: score,
    );
    if (!mounted) return;

    final allCompleted = await repetitionViewModel.areAllRepetitionsCompleted(
      repetition.moduleProgressId,
    );
    if (!mounted) return;

    if (allCompleted) {
      _showCycleCompletionSnackBar();
      await _reloadData();
    } else {
      _showCompletionSnackBar(score);
      await repetitionViewModel.loadRepetitionsByProgressId(widget.progressId);
      await progressViewModel.loadProgressDetails(widget.progressId);
    }
  }

  Future<void> _handleMarkSkipped(String repetitionId) async {
    final repetitionViewModel = context.read<RepetitionViewModel>();
    final repetition = await repetitionViewModel.updateRepetition(
      repetitionId,
      status: RepetitionStatus.skipped,
    );

    if (mounted && repetition != null) {
      _showSnackBar('Repetition marked as skipped');
      await repetitionViewModel.loadRepetitionsByProgressId(widget.progressId);
    }
  }

  Future<void> _handleReschedule(String repetitionId, DateTime date) async {
    final repetitionViewModel = context.read<RepetitionViewModel>();
    final repetition = await repetitionViewModel.updateRepetition(
      repetitionId,
      reviewDate: date,
    );

    if (mounted && repetition != null) {
      _showSnackBar('Repetition rescheduled');
      await repetitionViewModel.loadRepetitionsByProgressId(widget.progressId);
    }
  }

  // UI utilities
  void _showSnackBar(String message, {Color backgroundColor = Colors.grey}) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: backgroundColor),
      );
    }
  }

  void _showCompletionSnackBar(double score) {
    _showSnackBar('Đã lưu điểm bài thi: ${score.toInt()}%');
  }

  void _showCycleCompletionSnackBar() {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Chúc mừng! Bạn đã hoàn thành chu kỳ học này.'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'Chi tiết',
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
            title: const Text('Chu kỳ học hoàn thành!'),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bạn đã hoàn thành tất cả các lần ôn tập trong chu kỳ này.',
                ),
                SizedBox(height: 8),
                Text(
                  'Hệ thống đã tự động tạo lịch ôn tập mới cho chu kỳ tiếp theo với khoảng cách thời gian được điều chỉnh dựa trên hiệu suất học tập của bạn.',
                ),
                SizedBox(height: 8),
                Text(
                  'Hãy tiếp tục duy trì việc ôn tập đều đặn để đạt hiệu quả học tập tối ưu.',
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Đã hiểu'),
              ),
            ],
          ),
    );
  }

  Future<double?> _showCompletionScoreDialog() async {
    const double currentValue = 80.0;
    final controller = TextEditingController(text: '80');

    return showDialog<double>(
      context: context,
      barrierDismissible: false,
      builder:
          (dialogContext) => StatefulBuilder(
            builder:
                (context, setState) => AlertDialog(
                  title: const Text('Nhập điểm bài thi'),
                  content: _buildScoreDialogContent(
                    currentValue,
                    controller,
                    setState,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: const Text('Hủy'),
                    ),
                    ElevatedButton(
                      onPressed:
                          () => _confirmScore(
                            dialogContext,
                            controller,
                            currentValue,
                          ),
                      child: const Text('Xác nhận'),
                    ),
                  ],
                ),
          ),
    );
  }

  // Build methods
  @override
  Widget build(BuildContext context) {
    final progressViewModel = context.watch<ProgressViewModel>();
    return Scaffold(
      appBar: _buildAppBar(progressViewModel.selectedProgress?.moduleTitle),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: _buildBody(progressViewModel),
      ),
    );
  }

  AppBar _buildAppBar(String? moduleTitle) {
    return AppBar(
      title: Text(moduleTitle ?? 'Module Progress'),
      actions: [
        IconButton(
          icon: const Icon(Icons.help_outline),
          tooltip: 'Thông tin về chu kỳ học',
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

  Widget _buildBody(ProgressViewModel progressViewModel) {
    final theme = Theme.of(context);
    final progress = progressViewModel.selectedProgress;

    if (progressViewModel.isLoading)
      return const Center(child: AppLoadingIndicator());
    if (progressViewModel.errorMessage != null) {
      return Center(
        child: ErrorDisplay(
          message: progressViewModel.errorMessage!,
          onRetry: _loadData,
        ),
      );
    }
    if (progress == null)
      return const Center(child: Text('Progress not found'));

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        ProgressHeaderWidget(
          progress: progress,
          onCycleCompleteDialogRequested: _showCycleCompletionDialog,
        ),
        const SizedBox(height: 24),
        Text('Lịch ôn tập', style: theme.textTheme.titleLarge),
        const SizedBox(height: 8),
        RepetitionListWidget(
          progressId: widget.progressId,
          onMarkCompleted: _handleMarkCompleted,
          onMarkSkipped: _handleMarkSkipped,
          onReschedule: _handleReschedule,
          onReload: _reloadData,
        ),
      ],
    );
  }

  Widget _buildScoreDialogContent(
    double currentValue,
    TextEditingController controller,
    StateSetter setState,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Nhập điểm bài thi bạn đã làm ở Quizlet hoặc công cụ khác:',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 20),
        Text(
          '${currentValue.toInt()}%',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: 20),
        Slider(
          value: currentValue,
          min: 0,
          max: 100,
          divisions: 20,
          label: '${currentValue.toInt()}%',
          onChanged:
              (value) => setState(() {
                currentValue = value;
                controller.text = value.toInt().toString();
              }),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Text('Nhập chính xác: '),
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
                    setState(() => currentValue = intValue.toDouble());
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
              [0, 25, 50, 75, 100]
                  .map(
                    (score) => _buildScoreButton(
                      score,
                      currentValue,
                      setState,
                      controller,
                    ),
                  )
                  .toList(),
        ),
      ],
    );
  }

  Widget _buildScoreButton(
    int score,
    double currentValue,
    StateSetter setState,
    TextEditingController controller,
  ) {
    final isSelected = currentValue.toInt() == score;
    return InkWell(
      onTap:
          () => setState(() {
            currentValue = score.toDouble();
            controller.text = score.toString();
          }),
      borderRadius: BorderRadius.circular(8),
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

  void _confirmScore(
    BuildContext dialogContext,
    TextEditingController controller,
    double currentValue,
  ) {
    final finalValue = int.tryParse(controller.text);
    Navigator.pop(
      dialogContext,
      (finalValue != null && finalValue >= 0 && finalValue <= 100)
          ? finalValue.toDouble()
          : currentValue,
    );
  }
}
