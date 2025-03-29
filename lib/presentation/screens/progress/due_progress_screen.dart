// lib/presentation/screens/progress/due_progress_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:spaced_learning_app/domain/models/progress.dart';
import 'package:spaced_learning_app/presentation/screens/progress/progress_detail_screen.dart';
import 'package:spaced_learning_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/progress_viewmodel.dart';
import 'package:spaced_learning_app/presentation/widgets/common/error_display.dart';
import 'package:spaced_learning_app/presentation/widgets/common/loading_indicator.dart';
import 'package:spaced_learning_app/presentation/widgets/progress/progress_card.dart';

/// Screen displaying progress items due for review
class DueProgressScreen extends StatefulWidget {
  const DueProgressScreen({super.key});

  @override
  State<DueProgressScreen> createState() => _DueProgressScreenState();
}

class _DueProgressScreenState extends State<DueProgressScreen> {
  DateTime? _selectedDate;
  final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final authViewModel = context.read<AuthViewModel>();
    final progressViewModel = context.read<ProgressViewModel>();

    if (authViewModel.currentUser != null) {
      await progressViewModel.loadDueProgress(
        authViewModel.currentUser!.id,
        studyDate: _selectedDate,
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });

      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authViewModel = context.watch<AuthViewModel>();
    final progressViewModel = context.watch<ProgressViewModel>();

    if (authViewModel.currentUser == null) {
      return const Center(child: Text('Please log in to view your due items'));
    }

    return Scaffold(
      body: Column(
        children: [
          // Date filter
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedDate == null
                        ? 'Due Today'
                        : 'Due by ${_dateFormat.format(_selectedDate!)}',
                    style: theme.textTheme.titleLarge,
                  ),
                ),
                OutlinedButton.icon(
                  icon: const Icon(Icons.calendar_today),
                  label: Text(_selectedDate == null ? 'Select Date' : 'Change'),
                  onPressed: () => _selectDate(context),
                ),
                if (_selectedDate != null) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        _selectedDate = null;
                      });
                      _loadData();
                    },
                    tooltip: 'Clear date filter',
                  ),
                ],
              ],
            ),
          ),

          // Progress list
          Expanded(child: _buildProgressList(progressViewModel)),
        ],
      ),
    );
  }

  /// Build the progress list based on loading state
  Widget _buildProgressList(ProgressViewModel viewModel) {
    if (viewModel.isLoading) {
      return const Center(child: AppLoadingIndicator());
    }

    if (viewModel.errorMessage != null) {
      return Center(
        child: ErrorDisplay(
          message: viewModel.errorMessage!,
          onRetry: _loadData,
        ),
      );
    }

    if (viewModel.progressRecords.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle_outline,
              size: 64,
              color: Colors.green,
            ),
            const SizedBox(height: 16),
            Text(
              _selectedDate == null
                  ? 'No modules due for review today!'
                  : 'No modules due for review by ${_dateFormat.format(_selectedDate!)}',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Great job keeping up with your studies!',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: viewModel.progressRecords.length,
        itemBuilder: (context, index) {
          final progress = viewModel.progressRecords[index];
          return _buildProgressItem(progress);
        },
      ),
    );
  }

  /// Build a progress card for a single item
  Widget _buildProgressItem(ProgressSummary progress) {
    // Determine if this progress is due
    bool isDue = false;
    if (progress.nextStudyDate != null) {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final nextDate = DateTime(
        progress.nextStudyDate!.year,
        progress.nextStudyDate!.month,
        progress.nextStudyDate!.day,
      );

      final targetDate =
          _selectedDate != null
              ? DateTime(
                _selectedDate!.year,
                _selectedDate!.month,
                _selectedDate!.day,
              )
              : today;

      isDue = nextDate.compareTo(targetDate) <= 0;
    }

    // In a real app, you would fetch the module title from a repository
    // For this demo, we'll use a placeholder
    const moduleTitle = 'Module';

    // Format cycle studied for subtitle
    final String cycleText = _formatCycleStudied(progress.cyclesStudied);

    return ProgressCard(
      progress: progress,
      moduleTitle: moduleTitle,
      isDue: isDue,
      subtitle: 'Chu kỳ: $cycleText',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProgressDetailScreen(progressId: progress.id),
          ),
        ).then((_) => _loadData()); // Refresh on return
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
