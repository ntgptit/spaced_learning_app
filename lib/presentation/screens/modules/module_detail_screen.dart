// lib/presentation/screens/modules/module_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spaced_learning_app/core/di/providers.dart';
import 'package:spaced_learning_app/core/navigation/navigation_helper.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/grammar.dart';
import 'package:spaced_learning_app/domain/models/module.dart';
import 'package:spaced_learning_app/domain/models/progress.dart';
import 'package:spaced_learning_app/presentation/utils/snackbar_utils.dart';
import 'package:spaced_learning_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/module_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/progress_viewmodel.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_bar_with_back.dart';
import 'package:spaced_learning_app/presentation/widgets/common/error_display.dart';
import 'package:spaced_learning_app/presentation/widgets/common/loading_indicator.dart';
import 'package:spaced_learning_app/presentation/widgets/modules/detail/module_detail_content.dart';
import 'package:spaced_learning_app/presentation/widgets/modules/detail/module_detail_fab_section.dart';
import 'package:spaced_learning_app/presentation/widgets/modules/detail/module_detail_header.dart';
import 'package:spaced_learning_app/presentation/widgets/modules/detail/module_loading_skeleton.dart';
import 'package:spaced_learning_app/presentation/widgets/modules/detail/module_progress_card.dart';

class ModuleDetailScreen extends ConsumerStatefulWidget {
  final String moduleId;

  const ModuleDetailScreen({super.key, required this.moduleId});

  @override
  ConsumerState<ModuleDetailScreen> createState() => _ModuleDetailScreenState();
}

class _ModuleDetailScreenState extends ConsumerState<ModuleDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _isInitialLoad = true;
  bool _isRefreshing = false;
  bool _isCheckingGrammar = false;
  bool _hasGrammar = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadInitialData();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );
  }

  void _loadInitialData() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _performDataLoad();
      await _checkGrammarContent();

      if (mounted) {
        setState(() => _isInitialLoad = false);
        _fadeController.forward();
        await Future.delayed(const Duration(milliseconds: 200));
        if (mounted) {
          _slideController.forward();
        }
      }
    });
  }

  Future<void> _performDataLoad() async {
    if (_isRefreshing) return;

    setState(() => _isRefreshing = true);

    try {
      await ref
          .read(selectedModuleProvider.notifier)
          .loadModuleDetails(widget.moduleId);

      if (!mounted) return;

      final module = ref.read(selectedModuleProvider).valueOrNull;
      if (module == null) return;

      // Load progress details if available
      if (module.progress.isNotEmpty) {
        final progressId = module.progress[0].id;
        await ref
            .read(selectedProgressProvider.notifier)
            .loadProgressDetails(progressId);
      } else if (ref.read(authStateProvider).valueOrNull ?? false) {
        await ref
            .read(selectedProgressProvider.notifier)
            .loadModuleProgress(widget.moduleId);
      }
    } catch (error) {
      debugPrint('Error loading module data: $error');
    } finally {
      if (mounted) {
        setState(() => _isRefreshing = false);
      }
    }
  }

  Future<void> _checkGrammarContent() async {
    if (!mounted) return;

    final module = ref.read(selectedModuleProvider).valueOrNull;
    if (module?.bookId.isEmpty ?? true) return;

    try {
      final grammarRepository = ref.read(grammarRepositoryProvider);
      final List<GrammarSummary> grammars = await grammarRepository
          .getGrammarsByModuleId(widget.moduleId);

      if (mounted) {
        setState(() => _hasGrammar = grammars.isNotEmpty);
      }
    } catch (e) {
      debugPrint('Error checking grammar content: $e');
      if (mounted) {
        setState(() => _hasGrammar = false);
      }
    }
  }

  Future<void> _handleRefresh() async {
    setState(() => _isInitialLoad = true);
    await _performDataLoad();
    await _checkGrammarContent();
  }

  Future<void> _startLearning() async {
    if (!mounted) return;

    if (!_isAuthenticated()) {
      _showLoginSnackBar();
      return;
    }

    final module = ref.read(selectedModuleProvider).valueOrNull;
    if (module == null) {
      SnackBarUtils.show(
        context,
        'Module details not available. Please refresh.',
      );
      return;
    }

    final existingProgress = ref.read(selectedProgressProvider).valueOrNull;
    if (existingProgress != null) {
      _navigateToProgress(existingProgress.id);
      return;
    }

    try {
      final newProgress = await _createNewProgress();
      if (newProgress != null && mounted) {
        _navigateToProgress(newProgress.id);
      } else if (mounted) {
        SnackBarUtils.show(context, 'Failed to start learning progress.');
      }
    } catch (error) {
      debugPrint('Error creating progress: $error');
      if (mounted) {
        SnackBarUtils.show(
          context,
          'Error starting learning: ${error.toString()}',
        );
      }
    }
  }

  Future<void> _navigateToGrammar() async {
    if (!mounted) return;

    setState(() => _isCheckingGrammar = true);

    final module = ref.read(selectedModuleProvider).valueOrNull;
    if (module?.bookId.isEmpty ?? true) {
      if (mounted) {
        SnackBarUtils.show(context, 'Module information is not available.');
        setState(() => _isCheckingGrammar = false);
      }
      return;
    }

    try {
      final grammarRepository = ref.read(grammarRepositoryProvider);
      final List<GrammarSummary> grammars = await grammarRepository
          .getGrammarsByModuleId(widget.moduleId);

      if (!mounted) return;

      if (grammars.isEmpty) {
        SnackBarUtils.show(
          context,
          'No grammar content available for this module.',
        );
      } else if (grammars.length == 1) {
        final singleGrammar = grammars.first;
        context.push(
          '/books/${module!.bookId}/modules/${widget.moduleId}/grammars/${singleGrammar.id}',
        );
      } else {
        context.go(
          '/books/${module!.bookId}/modules/${widget.moduleId}/grammar',
        );
      }
    } catch (e) {
      if (mounted) {
        SnackBarUtils.show(
          context,
          'Failed to load grammar: ${e.toString()}',
          backgroundColor: Theme.of(context).colorScheme.errorContainer,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isCheckingGrammar = false);
      }
    }
  }

  bool _isAuthenticated() {
    final isLoggedIn = ref.watch(authStateProvider).valueOrNull ?? false;
    final currentUser = ref.watch(currentUserProvider);
    return isLoggedIn && currentUser != null;
  }

  void _showLoginSnackBar() {
    if (!mounted) return;
    SnackBarUtils.show(
      context,
      'Please log in to start learning this module.',
      backgroundColor: Theme.of(context).colorScheme.errorContainer,
    );
  }

  Future<ProgressDetail?> _createNewProgress() async {
    if (!mounted) return null;

    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null) {
      _showLoginSnackBar();
      return null;
    }

    return ref
        .read(progressStateProvider.notifier)
        .createProgress(
          moduleId: widget.moduleId,
          userId: currentUser.id,
          firstLearningDate: DateTime.now(),
          nextStudyDate: DateTime.now(),
        );
  }

  void _navigateToProgress(String progressId) {
    if (!mounted) return;

    if (progressId.isEmpty) {
      SnackBarUtils.show(context, 'Invalid progress ID. Cannot navigate.');
      return;
    }

    NavigationHelper.pushWithResult(context, '/progress/$progressId').then((_) {
      if (mounted) {
        _handleRefresh();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final moduleAsync = ref.watch(selectedModuleProvider);
    final progressAsync = ref.watch(selectedProgressProvider);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: _buildAppBar(moduleAsync.valueOrNull?.title),
      body: _buildBody(moduleAsync, progressAsync),
      floatingActionButton: _buildFloatingActionButton(
        moduleAsync.valueOrNull,
        progressAsync.valueOrNull,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  PreferredSizeWidget _buildAppBar(String? moduleTitle) {
    return AppBarWithBack(
      title: moduleTitle ?? 'Module Details',
      actions: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _isRefreshing
              ? const Padding(
                  padding: EdgeInsets.all(AppDimens.paddingM),
                  child: SizedBox(
                    width: AppDimens.iconM,
                    height: AppDimens.iconM,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : IconButton(
                  key: const ValueKey('refresh'),
                  icon: const Icon(Icons.refresh_outlined),
                  onPressed: _handleRefresh,
                  tooltip: 'Refresh module data',
                ),
        ),
      ],
    );
  }

  Widget _buildBody(
    AsyncValue<ModuleDetail?> moduleAsync,
    AsyncValue<ProgressDetail?> progressAsync,
  ) {
    if (_isInitialLoad) {
      return const ModuleLoadingSkeleton();
    }

    final combinedError = _getCombinedError(moduleAsync, progressAsync);
    if (combinedError != null) {
      return _buildErrorView(combinedError);
    }

    final module = moduleAsync.valueOrNull;
    if (module == null) {
      return _buildErrorView('Module not found.');
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: _buildModuleContent(module, progressAsync.valueOrNull),
      ),
    );
  }

  String? _getCombinedError(
    AsyncValue<ModuleDetail?> moduleAsync,
    AsyncValue<ProgressDetail?> progressAsync,
  ) {
    if (moduleAsync.hasError) {
      return moduleAsync.error.toString();
    }

    // Only consider progress error if we have a module and expected progress
    if (progressAsync.hasError && moduleAsync.valueOrNull != null) {
      final hasProgressData = moduleAsync.valueOrNull!.progress.isNotEmpty;
      if (hasProgressData) {
        return progressAsync.error.toString();
      }
    }

    return null;
  }

  Widget _buildErrorView(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingL),
        child: SLErrorView(message: "Error: $message", onRetry: _handleRefresh),
      ),
    );
  }

  Widget _buildModuleContent(
    ModuleDetail module,
    ProgressDetail? userProgress,
  ) {
    final hasProgress = userProgress != null || module.progress.isNotEmpty;

    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(AppDimens.paddingL),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                ModuleDetailHeader(module: module),
                const SizedBox(height: AppDimens.spaceXL),

                if (hasProgress) ...[
                  ModuleProgressCard(
                    progress:
                        userProgress ?? module.progress[0] as ProgressDetail,
                    moduleTitle: module.title,
                    onTap: _navigateToProgress,
                  ),
                  const SizedBox(height: AppDimens.spaceXL),
                ],

                ModuleDetailContent(module: module),
                const SizedBox(height: AppDimens.spaceXXXL), // Space for FAB
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget? _buildFloatingActionButton(
    ModuleDetail? module,
    ProgressDetail? userProgress,
  ) {
    if (module == null) return null;

    final hasProgress = userProgress != null || module.progress.isNotEmpty;

    return ModuleDetailFabSection(
      hasProgress: hasProgress,
      hasGrammar: _hasGrammar,
      isCheckingGrammar: _isCheckingGrammar,
      onStartLearning: _startLearning,
      onViewGrammar: _navigateToGrammar,
    );
  }
}
