// lib/presentation/screens/learning/learning_progress_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spaced_learning_app/core/services/screen_refresh_manager.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/presentation/viewmodels/learning_progress_viewmodel.dart';
import 'package:spaced_learning_app/presentation/widgets/common/state/sl_empty_state_widget.dart';
import 'package:spaced_learning_app/presentation/widgets/common/state/sl_error_state_widget.dart';
import 'package:spaced_learning_app/presentation/widgets/common/state/sl_loading_state_widget.dart';
import 'package:spaced_learning_app/presentation/widgets/learning/learning_filter_bar/learning_filter_bar.dart';
import 'package:spaced_learning_app/presentation/widgets/learning/learning_help_dialog.dart';
import 'package:spaced_learning_app/presentation/widgets/learning/main/learning_app_bar.dart';
import 'package:spaced_learning_app/presentation/widgets/learning/main/module_list.dart';

class LearningProgressScreen extends ConsumerStatefulWidget {
  const LearningProgressScreen({super.key});

  @override
  ConsumerState<LearningProgressScreen> createState() =>
      _LearningProgressScreenState();
}

class _LearningProgressScreenState extends ConsumerState<LearningProgressScreen>
    with WidgetsBindingObserver {
  final ScrollController _mainScrollController = ScrollController();
  final ScrollController _moduleListScrollController = ScrollController();

  final ScreenRefreshManager _refreshManager = ScreenRefreshManager();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refreshManager.registerRefreshCallback('/learning', _refreshData);

    _mainScrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeViewModel();
    });
  }

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

    _mainScrollController.removeListener(_onScroll);
    _mainScrollController.dispose();
    _moduleListScrollController.dispose();

    super.dispose();
  }

  void _refreshData() {
    _runSafe(() {
      ref.read(learningProgressStateProvider.notifier).loadData();
    });
  }

  void _initializeViewModel() => _runSafe(() {
    ref.read(learningProgressStateProvider.notifier).loadData();
  });

  void _safeRefreshData() => _runSafe(() {
    try {
      ref.read(learningProgressStateProvider.notifier).refreshData();
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
        action: retryAction != null
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
    final modulesAsync = ref.watch(learningProgressStateProvider);

    return Scaffold(
      body: CustomScrollView(
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
                horizontal: AppDimens.paddingM,
                vertical: AppDimens.paddingS,
              ),
              child: _buildFilterBar(),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: true,
            child: modulesAsync.when(
              data: (modules) => _buildDataView(modules),
              loading: () => const SlLoadingStateWidget(
                message: 'Loading your learning modules...',
                type: SlLoadingType.threeBounce,
                size: SlLoadingSize.medium,
              ),
              error: (error, stackTrace) => SlErrorStateWidget(
                title: 'Could not load learning data',
                message: error.toString(),
                onRetry: _safeRefreshData,
                retryText: 'Try Again',
              ),
            ),
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

  Widget _buildDataView(List<dynamic> modules) {
    final filteredModules = ref.watch(filteredModulesProvider);

    if (filteredModules.isEmpty) {
      return SlEmptyStateWidget(
        title: 'No Modules Found',
        message: 'Try adjusting your filters or check back later',
        icon: Icons.search_off_rounded,
        buttonText: 'Change Filters',
        onButtonPressed: () {
          if (_mainScrollController.hasClients) {
            _mainScrollController.animateTo(
              0,
              duration: const Duration(milliseconds: AppDimens.durationM),
              curve: Curves.easeOut,
            );
          }
        },
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.paddingM),
      child: ModuleList(
        modules: filteredModules,
        scrollController: _moduleListScrollController,
        onRefresh: _refreshData,
      ),
    );
  }

  Widget _buildFilterBar() {
    return Consumer(
      builder: (context, ref, _) {
        final filteredModules = ref.watch(filteredModulesProvider);
        final dueCount = ref.watch(dueModulesCountProvider);
        final completedCount = ref.watch(completedModulesCountProvider);

        return LearningFilterBar(
          totalCount: filteredModules.length,
          dueCount: dueCount,
          completeCount: completedCount,
        );
      },
    );
  }

  void _runSafe(VoidCallback block) {
    if (!mounted) return;
    Future.microtask(block);
  }
}
