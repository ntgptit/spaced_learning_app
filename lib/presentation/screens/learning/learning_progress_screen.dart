import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

class _LearningProgressScreenState extends State<LearningProgressScreen>
    with WidgetsBindingObserver {
  final ScrollController _verticalScrollController = ScrollController();
  bool _isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeViewModel();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isFirstLoad) {
      _isFirstLoad = false;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshData();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _verticalScrollController.dispose();
    super.dispose();
  }

  void _initializeViewModel() {
    if (!mounted) return;

    Future.microtask(() {
      if (!mounted) return;

      final viewModel = Provider.of<LearningProgressViewModel>(
        context,
        listen: false,
      );

      debugPrint(
        'LearningProgressScreen: Initializing view model - isInitialized=${viewModel.isInitialized}',
      );

      viewModel.loadData();
    });
  }

  void _refreshData() {
    if (!mounted) return;

    Future.microtask(() {
      if (!mounted) return;

      final viewModel = Provider.of<LearningProgressViewModel>(
        context,
        listen: false,
      );

      debugPrint('LearningProgressScreen: Refreshing data');
      viewModel.refreshData();
    });
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
    final theme = Theme.of(context);
    _showSnackBar(
      success
          ? 'Data exported successfully. The file was saved to your downloads folder.'
          : 'Failed to export data. Please try again.',
      success ? theme.colorScheme.tertiary : theme.colorScheme.error,
      duration: const Duration(seconds: 3),
    );
  }

  void _safeRefreshData() {
    if (!mounted) return;

    Future.microtask(() {
      if (!mounted) return;

      try {
        final viewModel = Provider.of<LearningProgressViewModel>(
          context,
          listen: false,
        );
        viewModel.refreshData();
      } catch (e) {
        debugPrint('Error refreshing data: $e');
      }
    });
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
          onPressed: _safeRefreshData,
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
        final dueModules = viewModel.getDueModulesCount();
        final totalModules = viewModel.filteredModules.length;
        final completedModules = viewModel.getCompletedModulesCount();

        return Padding(
          padding: const EdgeInsets.fromLTRB(
            AppDimens.paddingL,
            AppDimens.paddingL,
            AppDimens.paddingL,
            2, // Bỏ padding bottom để tăng không gian
          ),
          child: Column(
            children: [
              // Sử dụng LearningFilterBar mới - chỉ cần truyền thống kê, không cần truyền các callbacks
              LearningFilterBar(
                totalCount: totalModules,
                dueCount: dueModules,
                completeCount: completedModules,
              ),
              const SizedBox(height: AppDimens.spaceL),
              if (viewModel.errorMessage != null && !viewModel.isLoading)
                _buildErrorDisplay(viewModel),
              Expanded(child: _buildModulesTable(viewModel)),
              _buildFooter(viewModel, totalModules, completedModules),
            ],
          ),
        );
      },
    );
  }

  Widget _buildErrorDisplay(LearningProgressViewModel viewModel) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppDimens.paddingL),
      margin: const EdgeInsets.symmetric(vertical: AppDimens.paddingL),
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
          TextButton(onPressed: _safeRefreshData, child: const Text('Retry')),
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
