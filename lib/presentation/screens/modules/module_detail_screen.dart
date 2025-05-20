// lib/presentation/screens/modules/module_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spaced_learning_app/core/navigation/navigation_helper.dart'; // For navigation
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/module.dart';
import 'package:spaced_learning_app/domain/models/progress.dart';
import 'package:spaced_learning_app/presentation/utils/snackbar_utils.dart';
import 'package:spaced_learning_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/module_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/progress_viewmodel.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_bar_with_back.dart'; // Common AppBar
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
  // Future to track initial data loading.
  late Future<void> _dataLoadingFuture;
  bool _isInitialLoad = true;

  @override
  void initState() {
    super.initState();
    // Initialize data loading. Using Future.delayed to ensure it runs after first frame.
    _dataLoadingFuture = Future.delayed(
      Duration.zero,
      _loadDataAndSetInitialLoadComplete,
    );
  }

  // Combined data loading and initial load flag management
  Future<void> _loadDataAndSetInitialLoadComplete() async {
    // Guard clause: if widget is disposed, do nothing.
    if (!mounted) return;

    // Set initial load to true at the start of the operation.
    // This ensures the skeleton or loading indicator is shown correctly.
    if (_isInitialLoad) {
      // Only set to true if it's genuinely the initial load.
      setState(() {
        _isInitialLoad = true;
      });
    }

    await _loadData(); // Perform actual data loading.

    // After data loading (success or fail), mark initial load as complete.
    if (mounted) {
      setState(() {
        _isInitialLoad = false;
      });
    }
  }

  // Asynchronously loads module and progress details.
  Future<void> _loadData() async {
    // Ensure widget is still in the tree.
    if (!mounted) return;

    final moduleId = widget.moduleId;

    try {
      // Load module details first.
      await ref
          .read(selectedModuleProvider.notifier)
          .loadModuleDetails(moduleId);

      // Guard clause: if module loading failed or widget disposed, exit.
      if (!mounted) return;
      final module = ref.read(selectedModuleProvider).valueOrNull;
      if (module == null) return; // Stop if module details couldn't be loaded.

      // Check if progress data is already part of the module details.
      if (module.progress.isNotEmpty) {
        final progressId =
            module.progress[0].id; // Assuming first progress entry is relevant
        await ref
            .read(selectedProgressProvider.notifier)
            .loadProgressDetails(progressId);
      }
      // If user is authenticated and no progress in module, try loading user's module progress.
      else if (ref.read(authStateProvider).valueOrNull ?? false) {
        await ref
            .read(selectedProgressProvider.notifier)
            .loadModuleProgress(moduleId);
      }
    } catch (error) {
      // Log error and allow UI to show error state via FutureBuilder.
      debugPrint('Error loading module/progress data: $error');
      if (mounted) {
        // Let FutureBuilder handle error state based on _dataLoadingFuture
        // No need to call setState here as FutureBuilder will react to future completion.
      }
    }
  }

  // Refreshes data for the screen.
  Future<void> _refreshData() async {
    // Trigger a re-run of the _loadData logic by re-assigning the future.
    // setState is used to make FutureBuilder rebuild.
    if (!mounted) return;
    setState(() {
      _isInitialLoad = true; // Show loading indicator during refresh
      _dataLoadingFuture = _loadDataAndSetInitialLoadComplete();
    });
    await _dataLoadingFuture; // Await completion to allow RefreshIndicator to complete.
  }

  // Handles starting the learning process for the module.
  Future<void> _startLearning() async {
    if (!mounted) return;

    final moduleId = widget.moduleId;

    // Guard clause: Ensure user is authenticated.
    if (!_isAuthenticated()) {
      _showLoginSnackBar();
      return;
    }

    final module = ref.read(selectedModuleProvider).valueOrNull;
    // Guard clause: Ensure module details are loaded.
    if (module == null) {
      SnackBarUtils.show(
        context,
        'Module details not available. Please refresh.',
      );
      return;
    }

    // Check if there's existing progress.
    final existingProgress = ref.read(selectedProgressProvider).valueOrNull;
    if (existingProgress != null) {
      _navigateToProgress(
        existingProgress.id,
      ); // Navigate to existing progress.
      return;
    }

    // If no existing progress, create new progress.
    try {
      final newProgress = await _createNewProgress(moduleId);
      if (newProgress != null && mounted) {
        _navigateToProgress(
          newProgress.id,
        ); // Navigate to newly created progress.
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

  // Navigates to the grammar rules screen for the current module.
  void _navigateToGrammar() {
    if (!mounted) return;
    final module = ref.read(selectedModuleProvider).valueOrNull;
    // Guard clause: Ensure module and bookId are available for route construction.
    if (module == null || module.bookId.isEmpty) {
      SnackBarUtils.show(
        context,
        'Cannot navigate: Module or Book ID missing.',
      );
      return;
    }
    // Use GoRouter to navigate to the module's grammar screen.
    context.go('/books/${module.bookId}/modules/${widget.moduleId}/grammar');
  }

  // Checks if the user is currently authenticated.
  bool _isAuthenticated() {
    final isLoggedIn = ref.watch(authStateProvider).valueOrNull ?? false;
    final currentUser = ref.watch(
      currentUserProvider,
    ); // Direct read, assumes authState is source of truth
    return isLoggedIn && currentUser != null;
  }

  // Shows a SnackBar prompting the user to log in.
  void _showLoginSnackBar() {
    if (!mounted) return;
    SnackBarUtils.show(
      context,
      'Please log in to start learning this module.',
      backgroundColor: Theme.of(context).colorScheme.errorContainer,
    );
  }

  // Creates new learning progress for the current user and module.
  Future<ProgressDetail?> _createNewProgress(String moduleId) async {
    if (!mounted) return null;
    final currentUser = ref.read(currentUserProvider);
    // Guard clause: Ensure there is a current user.
    if (currentUser == null) {
      _showLoginSnackBar(); // Should ideally be handled before calling this
      return null;
    }

    return ref
        .read(progressStateProvider.notifier)
        .createProgress(
          moduleId: moduleId,
          userId: currentUser.id,
          firstLearningDate: DateTime.now(), // Set current date as start
          nextStudyDate: DateTime.now(), // Initial study date is today
        );
  }

  // Navigates to the detailed progress screen for the given progress ID.
  void _navigateToProgress(String progressId) {
    if (!mounted) return;
    // Guard clause: Ensure progressId is valid.
    if (progressId.isEmpty) {
      SnackBarUtils.show(context, 'Invalid progress ID. Cannot navigate.');
      return;
    }
    // Use NavigationHelper for consistent navigation, expecting a result for potential refresh.
    NavigationHelper.pushWithResult(context, '/progress/$progressId').then((_) {
      if (mounted) {
        _refreshData(); // Refresh data when returning from the progress screen.
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Watch relevant providers for UI updates.
    final moduleAsync = ref.watch(selectedModuleProvider);
    final progressAsync = ref.watch(selectedProgressProvider);

    // Determine if progress exists, either directly in progressAsync or within module details.
    final moduleValue = moduleAsync.valueOrNull;
    final bool hasProgress =
        progressAsync.valueOrNull != null ||
        (moduleValue?.progress.isNotEmpty ?? false);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      // M3 surface color
      appBar: AppBarWithBack(
        title: moduleValue?.title ?? 'Module Details', // Dynamic title
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
        // FutureBuilder to handle initial loading state.
        builder: (context, snapshot) {
          // Show loading indicator during initial data fetch.
          if (_isInitialLoad ||
              snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SLLoadingIndicator(
                type: LoadingIndicatorType.fadingCircle,
              ),
            );
          }

          // Show error view if data loading failed.
          if (snapshot.hasError ||
              moduleAsync.hasError ||
              (progressAsync.hasError && hasProgress)) {
            String errorMessage = "Error loading module details.";
            if (snapshot.hasError) errorMessage = snapshot.error.toString();
            if (moduleAsync.hasError)
              errorMessage = moduleAsync.error.toString();
            if (progressAsync.hasError && hasProgress)
              errorMessage = progressAsync.error.toString();

            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppDimens.paddingL),
                child: SLErrorView(
                  message: errorMessage,
                  onRetry: _refreshData,
                ),
              ),
            );
          }

          // Guard clause: If module data is still null after loading, show error.
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

          // Build main content once data is available.
          return _buildModuleDetailContent(
            context,
            theme,
            moduleValue,
            progressAsync.valueOrNull, // Pass potentially null progress
            hasProgress,
          );
        },
      ),
      // Floating Action Buttons for primary actions.
      floatingActionButton: moduleValue != null
          ? Padding(
              padding: const EdgeInsets.only(
                bottom: AppDimens.paddingS,
                right: AppDimens.paddingXS,
              ),
              child: Column(
                // Using Column for multiple FABs if needed in future
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SLButton(
                    text: 'View Grammar',
                    type: SLButtonType.secondary,
                    // Secondary style
                    prefixIcon: Icons.menu_book_rounded,
                    onPressed: _navigateToGrammar,
                    size: SLButtonSize.medium,
                  ),
                  // Only show "Start Learning" if no progress exists.
                  if (!hasProgress) ...[
                    const SizedBox(height: AppDimens.spaceM),
                    SLButton(
                      text: 'Start Learning',
                      type: SLButtonType.primary,
                      // Primary action style
                      prefixIcon: Icons.play_arrow_rounded,
                      onPressed: _startLearning,
                      size: SLButtonSize
                          .large, // Larger button for primary action
                    ),
                  ],
                ],
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  // Builds the main content of the module detail screen.
  Widget _buildModuleDetailContent(
    BuildContext context,
    ThemeData theme,
    ModuleDetail module,
    ProgressDetail? userProgress, // User's specific progress, can be null
    bool hasProgress, // Indicates if any progress record exists
  ) {
    return RefreshIndicator(
      onRefresh: _refreshData, // Enable pull-to-refresh.
      color: theme.colorScheme.primary,
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppDimens.paddingL,
          AppDimens.paddingL,
          AppDimens.paddingL,
          AppDimens.paddingXXXL +
              AppDimens.paddingXXXL, // Ensure enough space for FABs
        ),
        children: [
          ModuleHeader(module: module),
          // Redesigned header.
          const SizedBox(height: AppDimens.spaceXL),

          // Display user's progress section if progress exists.
          // Use userProgress if available (specific to current user), otherwise first from module.progress
          if (hasProgress) ...[
            ModuleProgressSection(
              // Prioritize userProgress, then the first progress item from the module's list
              progress: userProgress ?? module.progress[0] as ProgressDetail,
              moduleTitle: module.title,
              onTap: _navigateToProgress,
            ),
            const SizedBox(height: AppDimens.spaceXL),
          ],

          ModuleContentSection(module: module),
          // Redesigned content section.
          // Add extra space at the bottom if there's no FAB, or adjust FAB padding.
        ],
      ),
    );
  }
}
