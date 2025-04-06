// lib/presentation/screens/learning/learning_progress_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaced_learning_app/core/theme/app_colors.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/presentation/viewmodels/learning_progress_viewmodel.dart';
import 'package:spaced_learning_app/presentation/widgets/learning/learning_filter_bar.dart';
import 'package:spaced_learning_app/presentation/widgets/learning/learning_footer.dart';
import 'package:spaced_learning_app/presentation/widgets/learning/learning_help_dialog.dart';
import 'package:spaced_learning_app/presentation/widgets/learning/learning_modules_table.dart';

class LearningProgressScreen extends StatefulWidget {
  const LearningProgressScreen({super.key});

  @override
  State<LearningProgressScreen> createState() => _LearningProgressScreenState();
}

class _LearningProgressScreenState extends State<LearningProgressScreen> {
  final ScrollController _verticalScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Move initialization to after the first frame to avoid build-time errors
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeViewModel();
    });
  }

  void _initializeViewModel() {
    final viewModel = Provider.of<LearningProgressViewModel>(
      context,
      listen: false,
    );
    if (!viewModel.isInitialized) {
      viewModel.initialize();
    }
  }

  @override
  void dispose() {
    _verticalScrollController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(
    BuildContext context,
    LearningProgressViewModel viewModel,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: viewModel.selectedDate ?? DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2026),
    );
    if (picked != null && picked != viewModel.selectedDate && mounted) {
      viewModel.setSelectedDate(picked);
    }
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => const LearningHelpDialog(),
    );
  }

  void _showSnackBar(
    String message,
    Color backgroundColor, {
    VoidCallback? retryAction,
    Duration? duration,
  }) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: duration ?? const Duration(seconds: 4),
        action:
            retryAction != null
                ? SnackBarAction(
                  label: 'Retry',
                  onPressed: retryAction,
                  textColor: Colors.white,
                )
                : null,
      ),
    );
  }

  void _showExportResult(bool success) {
    _showSnackBar(
      success
          ? 'Data exported successfully. The file was saved to your downloads folder.'
          : 'Failed to export data. Please try again.',
      success ? AppColors.successLight : AppColors.lightError,
      duration: const Duration(seconds: 3),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(child: _buildBody()),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Learning Progress'),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            // Get the viewModel without listening to avoid build errors
            final viewModel = Provider.of<LearningProgressViewModel>(
              context,
              listen: false,
            );
            viewModel.refreshData();
          },
          tooltip: 'Refresh data',
        ),
        IconButton(
          icon: const Icon(Icons.help_outline),
          onPressed: _showHelpDialog,
          tooltip: 'Help',
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Consumer<LearningProgressViewModel>(
      builder: (context, viewModel, _) {
        // Compute values outside of widget build for cleaner code
        final dueModules = viewModel.getDueModulesCount();
        final totalModules = viewModel.filteredModules.length;
        final completedModules = viewModel.getCompletedModulesCount();

        return Column(
          children: [
            _buildFilterBar(
              viewModel,
              totalModules,
              dueModules,
              completedModules,
            ),
            if (viewModel.errorMessage != null && !viewModel.isLoading)
              _buildErrorDisplay(viewModel),
            Expanded(child: _buildModulesTable(viewModel)),
            _buildFooter(viewModel, totalModules, completedModules),
          ],
        );
      },
    );
  }

  Widget _buildFilterBar(
    LearningProgressViewModel viewModel,
    int totalModules,
    int dueModules,
    int completedModules,
  ) {
    return LearningFilterBar(
      selectedBook: viewModel.selectedBook,
      selectedDate: viewModel.selectedDate,
      books: viewModel.getUniqueBooks(),
      onBookChanged: (value) {
        if (value != null) {
          viewModel.setSelectedBook(value);
        }
      },
      onDateSelected: () => _selectDate(context, viewModel),
      onDateCleared: () => viewModel.clearDateFilter(),
      totalCount: totalModules,
      dueCount: dueModules,
      completeCount: completedModules,
    );
  }

  Widget _buildErrorDisplay(LearningProgressViewModel viewModel) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppDimens.paddingL),
      margin: const EdgeInsets.all(AppDimens.paddingL),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: theme.colorScheme.error),
          const SizedBox(width: AppDimens.spaceM),
          Expanded(
            child: Text(
              viewModel.errorMessage!,
              style: TextStyle(color: theme.colorScheme.error),
            ),
          ),
          TextButton(
            onPressed: () => viewModel.loadData(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildModulesTable(LearningProgressViewModel viewModel) {
    return SimplifiedLearningModulesTable(
      modules: viewModel.filteredModules,
      isLoading: viewModel.isLoading,
      verticalScrollController: _verticalScrollController,
    );
  }

  Widget _buildFooter(
    LearningProgressViewModel viewModel,
    int totalModules,
    int completedModules,
  ) {
    return SizedBox(
      width: double.infinity,
      child: LearningFooter(
        totalModules: totalModules,
        completedModules: completedModules,
        onExportData: () async {
          final success = await viewModel.exportData();
          _showExportResult(success);
        },
        onHelpPressed: _showHelpDialog,
      ),
    );
  }
}
