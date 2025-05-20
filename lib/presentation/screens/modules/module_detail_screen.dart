// lib/presentation/screens/modules/module_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spaced_learning_app/core/di/providers.dart'; // For grammarRepositoryProvider
import 'package:spaced_learning_app/core/navigation/navigation_helper.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/grammar.dart'; // For GrammarSummary
import 'package:spaced_learning_app/domain/models/module.dart';
import 'package:spaced_learning_app/domain/models/progress.dart';
import 'package:spaced_learning_app/presentation/utils/snackbar_utils.dart';
import 'package:spaced_learning_app/presentation/viewmodels/auth_viewmodel.dart';
// import 'package:spaced_learning_app/presentation/viewmodels/grammar_viewmodel.dart'; // Not directly needed for state watching here for this logic
import 'package:spaced_learning_app/presentation/viewmodels/module_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/progress_viewmodel.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_bar_with_back.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_button.dart';
import 'package:spaced_learning_app/presentation/widgets/common/error_display.dart';
import 'package:spaced_learning_app/presentation/widgets/common/loading_indicator.dart';
import 'package:spaced_learning_app/presentation/widgets/modules/module_content_section.dart';
import 'package:spaced_learning_app/presentation/widgets/modules/module_header.dart';
import 'package:spaced_learning_app/presentation/widgets/modules/module_progress_section.dart';

class ModuleDetailScreen extends ConsumerStatefulWidget {
  final String moduleId;

  const ModuleDetailScreen({super.key, required this.moduleId});

  @override
  ConsumerState<ModuleDetailScreen> createState() => _ModuleDetailScreenState();
}

class _ModuleDetailScreenState extends ConsumerState<ModuleDetailScreen> {
  late Future<void> _dataLoadingFuture;
  bool _isInitialLoad = true;
  bool _isCheckingGrammar = false; // State for grammar check loading indicator
  bool _hasGrammar = false; // Flag to track if the module has grammar content

  @override
  void initState() {
    super.initState();
    _dataLoadingFuture = Future.delayed(
      Duration.zero,
      _loadDataAndSetInitialLoadComplete,
    );
    // Check if module has grammar content after initial data load
    _dataLoadingFuture.then((_) => _checkGrammarContent());
  }

  // Check if the module has any grammar content
  Future<void> _checkGrammarContent() async {
    if (!mounted) return;

    final module = ref.read(selectedModuleProvider).valueOrNull;
    if (module == null || module.bookId.isEmpty) return;

    try {
      final grammarRepository = ref.read(grammarRepositoryProvider);
      final List<GrammarSummary> grammars = await grammarRepository
          .getGrammarsByModuleId(widget.moduleId);

      if (mounted) {
        setState(() {
          _hasGrammar = grammars.isNotEmpty;
        });
      }
    } catch (e) {
      debugPrint('Error checking grammar content: $e');
      // If there's an error, we'll assume no grammar content to be safe
      if (mounted) {
        setState(() {
          _hasGrammar = false;
        });
      }
    }
  }

  Future<void> _loadDataAndSetInitialLoadComplete() async {
    if (!mounted) return;
    // Set initial load to true only once at the very beginning
    if (_isInitialLoad) {
      // Check _isInitialLoad before setting it.
      setState(() {
        // This _isInitialLoad is for the FutureBuilder, not to be confused
        // with the refresh indicator's own loading state.
      });
    }
    await _loadData();
    if (mounted) {
      setState(() {
        _isInitialLoad = false; // Mark initial load as complete
      });
    }
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    final moduleId = widget.moduleId;
    try {
      // Load module details
      await ref
          .read(selectedModuleProvider.notifier)
          .loadModuleDetails(moduleId);

      if (!mounted) return; // Re-check after await
      final module = ref.read(selectedModuleProvider).valueOrNull;
      if (module == null) return; // Exit if module details couldn't be loaded

      // Load progress details
      // If progress info is already embedded in module, use that first
      if (module.progress.isNotEmpty) {
        final progressId = module.progress[0].id;
        await ref
            .read(selectedProgressProvider.notifier)
            .loadProgressDetails(progressId);
      } else if (ref.read(authStateProvider).valueOrNull ?? false) {
        // Otherwise, if user is logged in, fetch their specific progress for this module
        await ref
            .read(selectedProgressProvider.notifier)
            .loadModuleProgress(moduleId);
      }
    } catch (error) {
      debugPrint(
        'Error loading module/progress data for ModuleDetailScreen: $error',
      );
      // Errors will be handled by the FutureBuilder based on _dataLoadingFuture's state
    }
  }

  Future<void> _refreshData() async {
    if (!mounted) return;
    setState(() {
      // Set _isInitialLoad to true to show the main loading indicator via FutureBuilder
      _isInitialLoad = true;
      _dataLoadingFuture = _loadDataAndSetInitialLoadComplete();
    });
    // Await the future so the RefreshIndicator knows when to stop.
    await _dataLoadingFuture;
    // Re-check grammar content after refresh
    _checkGrammarContent();
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
      final newProgress = await _createNewProgress(widget.moduleId);
      if (newProgress != null && mounted) {
        _navigateToProgress(newProgress.id);
      } else if (mounted) {
        SnackBarUtils.show(
          context,
          'Failed to create or start learning progress.',
        );
      }
    } catch (error) {
      debugPrint('Error creating new progress: $error');
      if (mounted) {
        SnackBarUtils.show(
          context,
          'Error starting learning: ${error.toString()}',
        );
      }
    }
  }

  Future<void> _navigateToGrammarOrDetail() async {
    if (!mounted) return;

    setState(() {
      _isCheckingGrammar = true;
    });

    final module = ref.read(selectedModuleProvider).valueOrNull;
    if (module == null || module.bookId.isEmpty) {
      if (mounted) {
        SnackBarUtils.show(
          context,
          'Module information is not available to view grammar.',
        );
        setState(() {
          _isCheckingGrammar = false;
        });
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
          '/books/${module.bookId}/modules/${widget.moduleId}/grammars/${singleGrammar.id}',
        );
      } else {
        context.go(
          '/books/${module.bookId}/modules/${widget.moduleId}/grammar',
        );
      }
    } catch (e) {
      if (mounted) {
        SnackBarUtils.show(
          context,
          'Failed to load grammar information: ${e.toString()}',
          backgroundColor: Theme.of(context).colorScheme.errorContainer,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCheckingGrammar = false;
        });
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

  Future<ProgressDetail?> _createNewProgress(String moduleId) async {
    if (!mounted) return null;
    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null) {
      _showLoginSnackBar();
      return null;
    }
    return ref
        .read(progressStateProvider.notifier)
        .createProgress(
          moduleId: moduleId,
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
        _refreshData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final moduleAsync = ref.watch(selectedModuleProvider);
    final progressAsync = ref.watch(selectedProgressProvider);
    final moduleValue = moduleAsync.valueOrNull;
    final bool hasProgress =
        progressAsync.valueOrNull != null ||
        (moduleValue?.progress.isNotEmpty ?? false);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBarWithBack(
        title: moduleValue?.title ?? 'Module Details',
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_outlined),
            onPressed: _refreshData,
            tooltip: 'Refresh module data',
          ),
        ],
      ),
      body: FutureBuilder<void>(
        future: _dataLoadingFuture,
        builder: (context, snapshot) {
          if (_isInitialLoad ||
              snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SLLoadingIndicator(
                type: LoadingIndicatorType.fadingCircle,
              ),
            );
          }

          String? combinedErrorMessage;
          if (snapshot.hasError) {
            combinedErrorMessage = snapshot.error.toString();
          } else if (moduleAsync.hasError) {
            combinedErrorMessage = moduleAsync.error.toString();
          } else if (progressAsync.hasError &&
              (progressAsync.valueOrNull != null ||
                  (moduleValue?.progress.isNotEmpty ?? false))) {
            // Only consider progressAsync error if we expected progress data
            combinedErrorMessage = progressAsync.error.toString();
          }

          if (combinedErrorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppDimens.paddingL),
                child: SLErrorView(
                  message: "Error: $combinedErrorMessage",
                  onRetry: _refreshData,
                ),
              ),
            );
          }

          if (moduleValue == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppDimens.paddingL),
                child: SLErrorView(
                  message: 'Module not found.',
                  onRetry: _refreshData,
                ),
              ),
            );
          }

          return _buildModuleDetailContent(
            context,
            theme,
            moduleValue,
            progressAsync.valueOrNull,
            hasProgress,
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: moduleValue != null
          ? Padding(
              padding: const EdgeInsets.only(
                bottom: AppDimens.paddingS,
                right: AppDimens.paddingXS,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Only show "View Grammar" button if the module has grammar content
                  if (_hasGrammar) ...[
                    SizedBox(
                      width: 175, // Cố định chiều rộng của nút
                      child: SLButton(
                        text: 'View Grammar',
                        isLoading: _isCheckingGrammar,
                        onPressed: _isCheckingGrammar
                            ? null
                            : _navigateToGrammarOrDetail,
                        type: SLButtonType.secondary,
                        prefixIcon: Icons.menu_book_rounded,
                        size: SLButtonSize.medium,
                        isFullWidth: true, // Đảm bảo nút lấp đầy không gian cha
                      ),
                    ),
                    if (!hasProgress) const SizedBox(height: AppDimens.spaceM),
                  ],
                  if (!hasProgress)
                    SizedBox(
                      width: 175, // Cùng chiều rộng với nút trên
                      child: SLButton(
                        text: 'Start Learning',
                        onPressed: _startLearning,
                        type: SLButtonType.primary,
                        prefixIcon: Icons.play_arrow_rounded,
                        size: SLButtonSize.medium,
                        isFullWidth: true, // Đảm bảo nút lấp đầy không gian cha
                      ),
                    ),
                ],
              ),
            )
          : null,
    );
  }

  Widget _buildModuleDetailContent(
    BuildContext context,
    ThemeData theme,
    ModuleDetail module,
    ProgressDetail? userProgress,
    bool hasProgress,
  ) {
    // Calculate bottom padding dynamically based on the number of FABs visible
    double fabAreaHeight = 0;
    if (module.id.isNotEmpty) {
      // Check if module is valid before calculating FAB height
      if (_hasGrammar) {
        fabAreaHeight = AppDimens.buttonHeightM; // Height for "View Grammar"
        if (!hasProgress) {
          fabAreaHeight +=
              AppDimens.spaceM +
              AppDimens
                  .buttonHeightM; // Add height for "Start Learning" + spacing
        }
      } else if (!hasProgress) {
        fabAreaHeight = AppDimens.buttonHeightM; // Only "Start Learning" button
      }
    }
    final double bottomPaddingForFab =
        fabAreaHeight + AppDimens.paddingXL; // Add some extra clearance

    return RefreshIndicator(
      onRefresh: _refreshData,
      color: theme.colorScheme.primary,
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
      child: ListView(
        padding: EdgeInsets.fromLTRB(
          AppDimens.paddingL,
          AppDimens.paddingL,
          AppDimens.paddingL,
          bottomPaddingForFab,
        ),
        children: [
          ModuleHeader(module: module),
          const SizedBox(height: AppDimens.spaceXL),
          if (hasProgress) ...[
            ModuleProgressSection(
              progress: userProgress ?? module.progress[0] as ProgressDetail,
              moduleTitle: module.title,
              onTap: _navigateToProgress,
            ),
            const SizedBox(height: AppDimens.spaceXL),
          ],
          ModuleContentSection(module: module),
          // Extra space already handled by ListView padding
        ],
      ),
    );
  }
}
