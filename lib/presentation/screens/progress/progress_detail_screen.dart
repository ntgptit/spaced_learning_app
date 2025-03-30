// lib/presentation/screens/progress/progress_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaced_learning_app/domain/models/progress.dart';
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

  Future<void> _loadData() async {
    final progressViewModel = context.read<ProgressViewModel>();
    final repetitionViewModel = context.read<RepetitionViewModel>();

    // Lưu trữ ID để sử dụng sau các thao tác bất đồng bộ
    final String progressId = widget.progressId;

    await progressViewModel.loadProgressDetails(progressId);

    // Kiểm tra mounted trước khi tiếp tục
    if (!mounted) return;

    await repetitionViewModel.loadRepetitionsByProgressId(progressId);
  }

  /// Helper method to safely reload data with mounted checks
  Future<void> reloadDataSafely() async {
    final progressViewModel = context.read<ProgressViewModel>();
    final repetitionViewModel = context.read<RepetitionViewModel>();
    final String progressId = widget.progressId;

    // Load progress details first
    await progressViewModel.loadProgressDetails(progressId);

    // Check if still mounted
    if (!mounted) return;

    // Then load repetitions
    await repetitionViewModel.loadRepetitionsByProgressId(progressId);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progressViewModel = context.watch<ProgressViewModel>();
    final progress = progressViewModel.selectedProgress;

    return Scaffold(
      appBar: AppBar(
        title: Text(progress?.moduleTitle ?? 'Module Progress'),
        actions: [
          // Add help button
          IconButton(
            icon: const Icon(Icons.help_outline),
            tooltip: 'Thông tin về chu kỳ học',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SpacedRepetitionInfoScreen(),
                ),
              );
            },
          ),
        ],
      ),
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
        ProgressHeaderWidget(
          progress: progress,
          onCycleCompleteDialogRequested: _showCycleCompletionDialog,
        ),
        const SizedBox(height: 24),

        // Repetitions section
        Text('Lịch ôn tập', style: theme.textTheme.titleLarge),
        const SizedBox(height: 8),

        RepetitionListWidget(
          progressId: widget.progressId,
          onMarkCompleted: _handleMarkCompleted,
          onMarkSkipped: handleMarkSkipped,
          onReschedule: handleReschedule,
          onReload: reloadDataSafely,
        ),
      ],
    );
  }

  /// Show dialog explaining cycle completion
  void _showCycleCompletionDialog() {
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
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Đã hiểu'),
              ),
            ],
          ),
    );
  }

  /// Handle marking a repetition as completed
  Future<void> _handleMarkCompleted(String repetitionId) async {
    // Hiển thị dialog để nhập điểm bài thi từ Quizlet
    final double? quizScore = await _showCompletionScoreDialog();
    if (quizScore == null || !mounted) return; // Người dùng hủy

    final repetitionViewModel = context.read<RepetitionViewModel>();
    final progressViewModel = context.read<ProgressViewModel>();
    final String progressId = widget.progressId;

    // Cập nhật repetition với trạng thái hoàn thành
    final repetition = await repetitionViewModel.updateRepetition(
      repetitionId,
      status: RepetitionStatus.completed,
    );

    if (!mounted) return;

    if (repetition != null) {
      // Check if all repetitions in cycle are completed
      final allCompleted = await repetitionViewModel.areAllRepetitionsCompleted(
        repetition.moduleProgressId,
      );

      if (!mounted) return;

      // Cập nhật điểm bài thi vào cơ sở dữ liệu
      await progressViewModel.updateProgress(
        progressId,
        percentComplete: quizScore,
      );

      if (allCompleted) {
        // Show completion message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'Chúc mừng! Bạn đã hoàn thành chu kỳ học này.',
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 5),
              action: SnackBarAction(
                label: 'Chi tiết',
                onPressed: () {
                  if (mounted) {
                    _showCycleCompletionDialog();
                  }
                },
              ),
            ),
          );
        }

        // Reload data to reflect changes including new repetitions
        await reloadDataSafely();
      } else {
        // Regular completion message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Đã lưu điểm bài thi: ${quizScore.toInt()}%'),
            ),
          );
        }

        // Reload repetitions to update the UI
        await repetitionViewModel.loadRepetitionsByProgressId(progressId);
      }

      if (!mounted) return;

      // Reload progress details to get the updated cycle information
      await progressViewModel.loadProgressDetails(progressId);
    }
  }

  /// Handle marking a repetition as skipped
  Future<void> handleMarkSkipped(String repetitionId) async {
    final repetitionViewModel = context.read<RepetitionViewModel>();
    final String progressId = widget.progressId;

    final repetition = await repetitionViewModel.updateRepetition(
      repetitionId,
      status: RepetitionStatus.skipped,
    );

    if (!mounted) return;

    if (repetition != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Repetition marked as skipped')),
      );

      // Reload data
      await repetitionViewModel.loadRepetitionsByProgressId(progressId);
    }
  }

  /// Handle rescheduling a repetition
  Future<void> handleReschedule(String repetitionId, DateTime date) async {
    final repetitionViewModel = context.read<RepetitionViewModel>();
    final String progressId = widget.progressId;

    final repetition = await repetitionViewModel.updateRepetition(
      repetitionId,
      reviewDate: date,
    );

    if (!mounted) return;

    if (repetition != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Repetition rescheduled')));

      // Reload data
      await repetitionViewModel.loadRepetitionsByProgressId(progressId);
    }
  }

  /// Update progress percentage based on completed repetitions
  Future<void> updateProgressPercentage() async {
    final repetitionViewModel = context.read<RepetitionViewModel>();
    final progressViewModel = context.read<ProgressViewModel>();
    final progress = progressViewModel.selectedProgress;
    final String progressId = widget.progressId;

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

    if (!mounted) return;

    // Reload progress
    await progressViewModel.loadProgressDetails(progressId);
  }

  /// Hiển thị dialog cho phép nhập điểm bài thi
  Future<double?> _showCompletionScoreDialog() async {
    double currentValue = 80.0; // Giá trị mặc định
    final TextEditingController textController = TextEditingController(
      text: '80',
    );

    return showDialog<double>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Nhập điểm bài thi'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Nhập điểm bài thi bạn đã làm ở Quizlet hoặc công cụ khác:',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${currentValue.toInt()}%',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Slider(
                    value: currentValue,
                    min: 0,
                    max: 100,
                    divisions: 20,
                    label: '${currentValue.toInt()}%',
                    onChanged: (value) {
                      setState(() {
                        currentValue = value;
                        textController.text = value.toInt().toString();
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text('Nhập chính xác: '),
                      Expanded(
                        child: TextField(
                          controller: textController,
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
                            if (intValue != null &&
                                intValue >= 0 &&
                                intValue <= 100) {
                              setState(() {
                                currentValue = intValue.toDouble();
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildScoreButton(
                        0,
                        currentValue,
                        setState,
                        textController,
                      ),
                      _buildScoreButton(
                        25,
                        currentValue,
                        setState,
                        textController,
                      ),
                      _buildScoreButton(
                        50,
                        currentValue,
                        setState,
                        textController,
                      ),
                      _buildScoreButton(
                        75,
                        currentValue,
                        setState,
                        textController,
                      ),
                      _buildScoreButton(
                        100,
                        currentValue,
                        setState,
                        textController,
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Hủy'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Validate input again before returning
                    final int? finalValue = int.tryParse(textController.text);
                    if (finalValue != null &&
                        finalValue >= 0 &&
                        finalValue <= 100) {
                      Navigator.of(dialogContext).pop(finalValue.toDouble());
                    } else {
                      // If invalid input, return the slider value
                      Navigator.of(dialogContext).pop(currentValue);
                    }
                  },
                  child: const Text('Xác nhận'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// Helper method to build quick select score buttons
  Widget _buildScoreButton(
    int score,
    double currentValue,
    StateSetter setState,
    TextEditingController controller,
  ) {
    final bool isSelected = currentValue.toInt() == score;

    return InkWell(
      onTap: () {
        setState(() {
          currentValue = score.toDouble();
          controller.text = score.toString();
        });
      },
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
}
