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
  final ScrollController _scrollController = ScrollController();
  final ScreenRefreshManager _refreshManager = ScreenRefreshManager();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refreshManager.registerRefreshCallback('/learning', _refreshData);
    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeViewModel();
    });
  }

  void _onScroll() {
    final isScrolled = _scrollController.offset > 10;
    if (isScrolled != _isScrolled) {
      setState(() {
        _isScrolled = isScrolled;
      });
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
    _refreshManager.unregisterRefreshCallback('/learning', _refreshData);
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
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
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusM),
        ),
        margin: const EdgeInsets.all(16.0),
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          _buildAppBar(colorScheme),
          SliverToBoxAdapter(child: _buildFilterSection()),
          SliverFillRemaining(
            hasScrollBody: true,
            child: _buildContentSection(),
          ),
        ],
      ),
      floatingActionButton: AnimatedOpacity(
        opacity: _isScrolled ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: FloatingActionButton(
          onPressed: () {
            _scrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOut,
            );
          },
          mini: true,
          child: const Icon(Icons.arrow_upward),
        ),
      ),
    );
  }

  SliverAppBar _buildAppBar(ColorScheme colorScheme) {
    return SliverAppBar(
      title: const Text('Learning Progress'),
      pinned: true,
      floating: true,
      elevation: _isScrolled ? 4 : 0,
      shadowColor: Colors.black26,
      backgroundColor:
          _isScrolled
              ? colorScheme.surface
              : colorScheme.surface.withOpacity(0.95),
      foregroundColor: colorScheme.onSurface,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          tooltip: 'Refresh data',
          onPressed: _safeRefreshData,
        ),
        IconButton(
          icon: const Icon(Icons.help_outline),
          tooltip: 'Help',
          onPressed: _showHelpDialog,
        ),
      ],
    );
  }

  Widget _buildFilterSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: [
          Selector<LearningProgressViewModel, (int, int, int)>(
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
          ),
        ],
      ),
    );
  }

  Widget _buildContentSection() {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _buildContentList(),
          ),
        ),
        _buildFooter(),
      ],
    );
  }

  Widget _buildContentList() {
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

        return RefreshIndicator(
          onRefresh: () async => _refreshData(),
          child: SimplifiedLearningModulesTable(
            modules: modules,
            isLoading: false,
            verticalScrollController: _scrollController,
          ),
        );
      },
    );
  }

  Widget _buildErrorDisplay(String errorMessage) {
    final theme = Theme.of(context);
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: theme.colorScheme.errorContainer.withOpacity(0.8),
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: theme.colorScheme.onErrorContainer,
            ),
            const SizedBox(height: 16),
            Text(
              'Oops! Something went wrong',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onErrorContainer,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onErrorContainer,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _safeRefreshData,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
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
