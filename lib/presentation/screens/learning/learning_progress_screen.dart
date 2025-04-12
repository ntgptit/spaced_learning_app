// lib/presentation/screens/learning/learning_progress_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaced_learning_app/core/services/screen_refresh_manager.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/learning_module.dart';
import 'package:spaced_learning_app/presentation/mixins/view_model_refresher.dart';
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
    with WidgetsBindingObserver, ViewModelRefresher {
  final ScrollController _verticalScrollController = ScrollController();
  final ScreenRefreshManager _refreshManager = ScreenRefreshManager();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Đăng ký refresh callback với key duy nhất
    _refreshManager.registerRefreshCallback('/learning', _refreshData);

    // Khởi tạo ViewModel sau khi khung hình đầu tiên được vẽ
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeViewModel();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshData();
    }
  }

  @override
  void dispose() {
    _refreshManager.unregisterRefreshCallback('/learning', _refreshData);
    WidgetsBinding.instance.removeObserver(this);
    _verticalScrollController.dispose();
    super.dispose();
  }

  @override
  void refreshData() {
    _refreshData();
  }

  void _initializeViewModel() => _runSafe(() {
    final viewModel = context.read<LearningProgressViewModel?>();
    if (viewModel != null) {
      viewModel.loadData();
    } else {
      _showSnackBar(
        'Error: Learning data not available',
        Theme.of(context).colorScheme.error,
      );
    }
  });

  void _refreshData() => _runSafe(() {
    final viewModel = context.read<LearningProgressViewModel?>();
    if (viewModel != null) {
      viewModel.refreshData();
    } else {
      _showSnackBar(
        'Error: Unable to refresh data',
        Theme.of(context).colorScheme.error,
      );
    }
  });

  void _safeRefreshData() => _runSafe(() {
    final viewModel = context.read<LearningProgressViewModel?>();
    if (viewModel == null) {
      _showSnackBar(
        'Error: Unable to refresh data',
        Theme.of(context).colorScheme.error,
      );
      return;
    }
    try {
      viewModel.refreshData();
    } catch (e) {
      _showSnackBar(
        'Failed to refresh data: $e',
        Theme.of(context).colorScheme.error,
        retryAction: _safeRefreshData,
      );
    }
  });

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

  void _showExportResult(bool success, {String? errorMessage}) {
    final theme = Theme.of(context);
    final message =
        success
            ? 'Data exported successfully. The file was saved to your downloads folder.'
            : errorMessage ?? 'Failed to export data. Please try again.';
    final color =
        success ? theme.colorScheme.tertiary : theme.colorScheme.error;

    _showSnackBar(message, color, duration: const Duration(seconds: 3));
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
    return Padding(
      padding: const EdgeInsets.only(
        left: AppDimens.paddingL,
        right: AppDimens.paddingL,
        top: AppDimens.paddingL,
        bottom: 2, // Bỏ padding bottom
      ),
      child: Column(
        children: [
          _buildFilterBar(),
          const SizedBox(height: AppDimens.spaceL),
          Expanded(child: _buildContent()),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Selector<LearningProgressViewModel, (int, int, int)>(
      selector:
          (_, viewModel) => (
            viewModel.filteredModules.length,
            viewModel.getDueModulesCount(),
            viewModel.getCompletedModulesCount(),
          ),
      builder:
          (_, data, __) => LearningFilterBar(
            totalCount: data.$1,
            dueCount: data.$2,
            completeCount: data.$3,
          ),
    );
  }

  Widget _buildContent() {
    return Selector<
      LearningProgressViewModel,
      (bool, String?, List<LearningModule>)
    >(
      selector:
          (_, viewModel) => (
            viewModel.isLoading,
            viewModel.errorMessage,
            viewModel.filteredModules,
          ),
      builder: (_, data, __) {
        final isLoading = data.$1;
        final errorMessage = data.$2;
        final modules = data.$3;

        if (isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (errorMessage != null) {
          return _buildErrorDisplay(errorMessage);
        }

        return SimplifiedLearningModulesTable(
          modules: modules,
          isLoading: false,
          verticalScrollController: _verticalScrollController,
        );
      },
    );
  }

  Widget _buildErrorDisplay(String errorMessage) {
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
              errorMessage,
              style: TextStyle(color: theme.colorScheme.error),
            ),
          ),
          TextButton(onPressed: _safeRefreshData, child: const Text('Retry')),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Selector<LearningProgressViewModel, (int, int)>(
      selector:
          (_, viewModel) => (
            viewModel.filteredModules.length,
            viewModel.getCompletedModulesCount(),
          ),
      builder:
          (_, data, __) => SizedBox(
            width: double.infinity,
            child: LearningFooter(
              totalModules: data.$1,
              completedModules: data.$2,
              onExportData: () async {
                final viewModel = context.read<LearningProgressViewModel?>();
                if (viewModel == null) {
                  _showSnackBar(
                    'Error: Unable to export data',
                    Theme.of(context).colorScheme.error,
                  );
                  return;
                }
                try {
                  final success = await viewModel.exportData();
                  _showExportResult(success);
                } catch (e) {
                  _showExportResult(
                    false,
                    errorMessage: 'Failed to export data: $e',
                  );
                }
              },
              onHelpPressed: _showHelpDialog,
            ),
          ),
    );
  }

  void _runSafe(VoidCallback block) {
    if (!mounted) return;
    Future.microtask(block);
  }
}
