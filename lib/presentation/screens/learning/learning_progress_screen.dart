import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaced_learning_app/core/services/screen_refresh_manager.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/presentation/mixins/view_model_refresher.dart';
import 'package:spaced_learning_app/presentation/viewmodels/learning_progress_viewmodel.dart';
import 'package:spaced_learning_app/presentation/widgets/learning/learning_filter_bar/learning_filter_bar.dart';
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
  // Tạo hai controller riêng biệt: một cho CustomScrollView và một cho ModuleList
  final ScrollController _mainScrollController = ScrollController();
  final ScrollController _moduleListScrollController = ScrollController();

  final ScreenRefreshManager _refreshManager = ScreenRefreshManager();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refreshManager.registerRefreshCallback('/learning', _refreshData);

    // Chỉ theo dõi controller chính cho sự kiện scroll
    _mainScrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeViewModel();
    });
  }

  // Cập nhật hàm _onScroll để chỉ sử dụng _mainScrollController
  void _onScroll() {
    final isScrolled = _mainScrollController.offset > AppDimens.paddingL;
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

    // Đảm bảo dispose cả hai controller
    _mainScrollController.removeListener(_onScroll);
    _mainScrollController.dispose();
    _moduleListScrollController.dispose();

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
          borderRadius: BorderRadius.circular(AppDimens.radiusL),
        ),
        margin: const EdgeInsets.all(AppDimens.paddingL),
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
        // Sử dụng controller chính cho CustomScrollView
        controller: _mainScrollController,
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
                horizontal: AppDimens.paddingL,
                vertical: AppDimens.paddingS,
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
        duration: const Duration(milliseconds: AppDimens.durationS),
        child: FloatingActionButton(
          onPressed: () {
            _mainScrollController.animateTo(
              0,
              duration: const Duration(milliseconds: AppDimens.durationM),
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
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.paddingL),
            child: _buildModuleList(viewModel),
          ),
        ),
        // _buildFooter(viewModel),
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
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(AppDimens.paddingL),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (errorMessage != null) {
          return LearningErrorView(
            errorMessage: errorMessage,
            onRetry: _safeRefreshData,
          );
        }

        return ModuleList(
          modules: modules,
          // Sử dụng controller riêng cho ModuleList
          scrollController: _moduleListScrollController,
          onRefresh: _refreshData,
        );
      },
    );
  }

  // Widget _buildFooter(LearningProgressViewModel viewModel) {
  //   return Selector<LearningProgressViewModel, (int, int)>(
  //     selector:
  //         (_, vm) => (vm.filteredModules.length, vm.getCompletedModulesCount()),
  //     builder:
  //         (_, data, __) => LearningFooter(
  //           totalModules: data.$1,
  //           completedModules: data.$2,
  //           onHelpPressed: _showHelpDialog,
  //         ),
  //   );
  // }

  void _runSafe(VoidCallback block) {
    if (!mounted) return;
    Future.microtask(block);
  }
}
