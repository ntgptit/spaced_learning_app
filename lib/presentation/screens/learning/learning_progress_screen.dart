import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaced_learning_app/core/services/screen_refresh_manager.dart';
import 'package:spaced_learning_app/presentation/mixins/view_model_refresher.dart';
import 'package:spaced_learning_app/presentation/viewmodels/learning_progress_viewmodel.dart';
import 'package:spaced_learning_app/presentation/widgets/learning/learning_filter_bar/learning_filter_bar.dart';
import 'package:spaced_learning_app/presentation/widgets/learning/learning_footer/learning_footer.dart';
import 'package:spaced_learning_app/presentation/widgets/learning/learning_help_dialog.dart';
import 'package:spaced_learning_app/presentation/widgets/learning/main/learning_app_bar.dart';
import 'package:spaced_learning_app/presentation/widgets/learning/main/learning_error_view.dart';
import 'package:spaced_learning_app/presentation/widgets/learning/main/module_list.dart';

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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LearningProgressViewModel>();

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          LearningAppBar(
            isScrolled: _isScrolled,
            onRefresh: _safeRefreshData,
            onHelp: _showHelpDialog,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: _buildFilterBar(viewModel),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: true,
            child: _buildMainContent(viewModel),
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

  Widget _buildFilterBar(LearningProgressViewModel viewModel) {
    return Selector<LearningProgressViewModel, (int, int, int)>(
      selector:
          (_, vm) => (
            vm.filteredModules.length,
            vm.getDueModulesCount(),
            vm.getCompletedModulesCount(),
          ),
      builder:
          (_, data, __) => LearningFilterBar(
            totalCount: data.$1,
            dueCount: data.$2,
            completeCount: data.$3,
          ),
    );
  }

  Widget _buildMainContent(LearningProgressViewModel viewModel) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _buildModuleList(viewModel),
          ),
        ),
        _buildFooter(viewModel),
      ],
    );
  }

  Widget _buildModuleList(LearningProgressViewModel viewModel) {
    return Selector<LearningProgressViewModel, (bool, String?, List<dynamic>)>(
      selector: (_, vm) => (vm.isLoading, vm.errorMessage, vm.filteredModules),
      builder: (_, data, __) {
        final isLoading = data.$1;
        final errorMessage = data.$2;
        final modules = data.$3;

        if (isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (errorMessage != null) {
          return LearningErrorView(
            errorMessage: errorMessage,
            onRetry: _safeRefreshData,
          );
        }

        return ModuleList(
          modules: modules,
          scrollController: _scrollController,
          onRefresh: _refreshData,
        );
      },
    );
  }

  Widget _buildFooter(LearningProgressViewModel viewModel) {
    return Selector<LearningProgressViewModel, (int, int)>(
      selector:
          (_, vm) => (vm.filteredModules.length, vm.getCompletedModulesCount()),
      builder:
          (_, data, __) => LearningFooter(
            totalModules: data.$1,
            completedModules: data.$2,
            // Đã bỏ onExportData
            onHelpPressed: _showHelpDialog,
            // Tùy chọn thêm các handler khác nếu cần
          ),
    );
  }

  void _runSafe(VoidCallback block) {
    if (!mounted) return;
    Future.microtask(block);
  }
}
