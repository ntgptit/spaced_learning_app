// lib/presentation/screens/progress/progress_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:spaced_learning_app/domain/models/progress.dart';
import 'package:spaced_learning_app/domain/models/repetition.dart';
import 'package:spaced_learning_app/presentation/screens/help/spaced_repetition_info_screen.dart';
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
    final repetitionViewModel = context.read<RepetitionViewModel>();

    // Lưu trữ ID để sử dụng sau các thao tác bất đồng bộ
    final String progressId = widget.progressId;

    await progressViewModel.loadProgressDetails(progressId);

    // Kiểm tra mounted trước khi tiếp tục
    if (!mounted) return;

    await repetitionViewModel.loadRepetitionsByProgressId(progressId);
  }

  /// Mark a repetition as completed
  Future<void> _markCompleted(String repetitionId) async {
    final repetitionViewModel = context.read<RepetitionViewModel>();
    final progressViewModel = context.read<ProgressViewModel>();

    // Lưu trữ progressId để sử dụng sau các thao tác bất đồng bộ
    final String progressId = widget.progressId;

    final repetition = await repetitionViewModel.updateRepetition(
      repetitionId,
      status: RepetitionStatus.completed,
    );

    // Kiểm tra mounted sau thao tác bất đồng bộ
    if (!mounted) return;

    if (repetition != null) {
      // Check if all repetitions in cycle are completed
      final allCompleted = await repetitionViewModel.areAllRepetitionsCompleted(
        repetition.moduleProgressId,
      );

      // Kiểm tra mounted sau thao tác bất đồng bộ thứ hai
      if (!mounted) return;

      if (allCompleted) {
        // Show completion message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Chúc mừng! Bạn đã hoàn thành chu kỳ học này.'),
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

        // Reload data to reflect changes including new repetitions
        await _reloadDataSafely();
      } else {
        // Regular completion message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Repetition marked as completed')),
        );

        // Reload repetitions to update the UI
        await repetitionViewModel.loadRepetitionsByProgressId(progressId);
      }

      // Kiểm tra mounted trước khi tiếp tục
      if (!mounted) return;

      // Update progress percentage
      await _updateProgressPercentage();

      // Reload progress details to get the updated cycle information
      await progressViewModel.loadProgressDetails(progressId);
    }
  }

  // Helper method to safely reload data with mounted checks
  Future<void> _reloadDataSafely() async {
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

  /// Mark a repetition as skipped
  Future<void> _markSkipped(String repetitionId) async {
    final repetitionViewModel = context.read<RepetitionViewModel>();
    final String progressId = widget.progressId;

    final repetition = await repetitionViewModel.updateRepetition(
      repetitionId,
      status: RepetitionStatus.skipped,
    );

    // Kiểm tra mounted sau thao tác bất đồng bộ
    if (!mounted) return;

    if (repetition != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Repetition marked as skipped')),
      );

      // Reload data
      await repetitionViewModel.loadRepetitionsByProgressId(progressId);
    }
  }

  /// Reschedule a repetition
  Future<void> _rescheduleRepetition(String repetitionId) async {
    final dateFormat = DateFormat('yyyy-MM-dd');
    final repetitionViewModel = context.read<RepetitionViewModel>();
    final String progressId = widget.progressId;

    // Show date picker
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );

    // Kiểm tra mounted sau thao tác bất đồng bộ
    if (!mounted) return;

    if (date != null) {
      final repetition = await repetitionViewModel.updateRepetition(
        repetitionId,
        reviewDate: date,
      );

      // Kiểm tra mounted sau thao tác bất đồng bộ thứ hai
      if (!mounted) return;

      if (repetition != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Repetition rescheduled to ${dateFormat.format(date)}',
            ),
          ),
        );

        // Reload data
        await repetitionViewModel.loadRepetitionsByProgressId(progressId);
      }
    }
  }

  /// Update progress percentage based on completed repetitions
  Future<void> _updateProgressPercentage() async {
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

    // Kiểm tra mounted sau thao tác bất đồng bộ
    if (!mounted) return;

    // Reload progress
    await progressViewModel.loadProgressDetails(progressId);
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
    final repetitionViewModel = context.watch<RepetitionViewModel>();

    // Format dates
    final startDateText =
        progress.firstLearningDate != null
            ? dateFormat.format(progress.firstLearningDate!)
            : 'Not started';

    final nextDateText =
        progress.nextStudyDate != null
            ? dateFormat.format(progress.nextStudyDate!)
            : 'Not scheduled';

    // Calculate completed repetitions
    final completedCount =
        progress.repetitions
            .where((r) => r.status == RepetitionStatus.completed)
            .length;
    final totalCount = progress.repetitions.length;

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

            // Progress bar for overall completion
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Overall Progress',
                      style: theme.textTheme.titleMedium,
                    ),
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

            // Cycle progress section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chu kỳ học: ${_formatCycleStudied(progress.cyclesStudied)}',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 8),

                // Show progress in current cycle
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: totalCount > 0 ? completedCount / totalCount : 0,
                    minHeight: 10,
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                    color: theme.colorScheme.secondary,
                  ),
                ),

                const SizedBox(height: 4),
                Text(
                  '$completedCount/$totalCount lần ôn tập hoàn thành trong chu kỳ này',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 8),

                // Show cycle info
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lightbulb,
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          repetitionViewModel.getCycleInfo(
                            progress.cyclesStudied,
                          ),
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
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
        onRetry: () {
          if (mounted) {
            repetitionViewModel.loadRepetitionsByProgressId(widget.progressId);
          }
        },
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
                  final String progressId = widget.progressId;
                  await repetitionViewModel.createDefaultSchedule(progressId);

                  // Kiểm tra mounted trước khi làm mới dữ liệu
                  if (mounted) {
                    _loadData();
                  }
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
        return 'Chu kỳ đầu tiên';
      case CycleStudied.firstReview:
        return 'Chu kỳ ôn tập thứ nhất';
      case CycleStudied.secondReview:
        return 'Chu kỳ ôn tập thứ hai';
      case CycleStudied.thirdReview:
        return 'Chu kỳ ôn tập thứ ba';
      case CycleStudied.moreThanThreeReviews:
        return 'Đã ôn tập nhiều hơn 3 chu kỳ';
    }
  }
}
