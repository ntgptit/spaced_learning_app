// lib/presentation/screens/modules/module_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart'; // Đảm bảo import GoRouter
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/module.dart';
import 'package:spaced_learning_app/domain/models/progress.dart';
import 'package:spaced_learning_app/presentation/utils/snackbar_utils.dart';
import 'package:spaced_learning_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/module_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/progress_viewmodel.dart';
import 'package:spaced_learning_app/presentation/widgets/common/error_display.dart';
import 'package:spaced_learning_app/presentation/widgets/common/loading_indicator.dart';

import '../../../core/navigation/navigation_helper.dart';
import '../../widgets/common/app_button.dart'; // Import cho SLButton
import '../../widgets/modules/module_content_section.dart';
import '../../widgets/modules/module_header.dart';
import '../../widgets/modules/module_progress_section.dart';

class ModuleDetailScreen extends ConsumerStatefulWidget {
  final String moduleId;

  const ModuleDetailScreen({super.key, required this.moduleId});

  @override
  ConsumerState<ModuleDetailScreen> createState() => _ModuleDetailScreenState();
}

class _ModuleDetailScreenState extends ConsumerState<ModuleDetailScreen> {
  late Future<void> _dataFuture;
  bool _isInitialLoad = true;

  @override
  void initState() {
    super.initState();
    _dataFuture = Future.delayed(Duration.zero, _loadData);
  }

  Future<void> _loadData() async {
    final moduleId = widget.moduleId;

    try {
      await ref
          .read(selectedModuleProvider.notifier)
          .loadModuleDetails(moduleId);

      final module = ref.read(selectedModuleProvider).valueOrNull;
      if (module == null) return;

      if (module.progress.isNotEmpty) {
        final progressId = module.progress[0].id;
        await ref
            .read(selectedProgressProvider.notifier)
            .loadProgressDetails(progressId);
        debugPrint('Loaded progress directly from module: $progressId');
      } else if (ref.read(authStateProvider).valueOrNull ?? false) {
        await ref
            .read(selectedProgressProvider.notifier)
            .loadModuleProgress(moduleId);
      }

      debugPrint(
        'After loading - Progress exists: ${ref.read(selectedProgressProvider).valueOrNull != null}',
      );
      debugPrint('Module progress count: ${module.progress.length}');

      if (mounted) {
        setState(() {
          _isInitialLoad = false;
        });
      }
    } catch (error) {
      debugPrint('Error loading data: $error');
      if (mounted) {
        setState(() {
          _isInitialLoad = false;
        });
      }
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _dataFuture = Future.delayed(Duration.zero, _loadData);
    });
    return _dataFuture;
  }

  Future<void> _startLearning() async {
    final moduleId = widget.moduleId;

    if (!_isAuthenticated()) {
      _showLoginSnackBar();
      return;
    }

    final module = ref.read(selectedModuleProvider).valueOrNull;
    if (module == null) return;

    final existingProgress = ref.read(selectedProgressProvider).valueOrNull;
    if (existingProgress != null) {
      _navigateToProgress(existingProgress.id);
      return;
    }

    try {
      final newProgress = await _createNewProgress(moduleId);

      if (newProgress != null && mounted) {
        _navigateToProgress(newProgress.id);
      } else if (mounted) {
        SnackBarUtils.show(context, 'Failed to create progress');
      }
    } catch (error) {
      debugPrint('Error creating progress: $error');
      if (mounted) {
        SnackBarUtils.show(context, 'Error: ${error.toString()}');
      }
    }
  }

  // Thêm hàm để điều hướng đến màn hình grammar
  void _navigateToGrammar() {
    final module = ref.read(selectedModuleProvider).valueOrNull;
    if (module == null) return;

    // Sử dụng GoRouter để điều hướng đến màn hình grammar
    context.go('/books/${module.bookId}/modules/${widget.moduleId}/grammar');
  }

  bool _isAuthenticated() {
    final isLoggedIn = ref.watch(authStateProvider).valueOrNull ?? false;
    final currentUser = ref.watch(currentUserProvider);
    return isLoggedIn && currentUser != null;
  }

  void _showLoginSnackBar() {
    if (mounted) {
      SnackBarUtils.show(context, 'Please log in to start learning');
    }
  }

  Future<ProgressDetail?> _createNewProgress(String moduleId) async {
    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null) return null;

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
      SnackBarUtils.show(context, 'Invalid progress ID');
      return;
    }

    NavigationHelper.pushWithResult(
      context,
      '/progress/$progressId',
    ).then((_) => _refreshData()); // Refresh khi quay lại
  }

  @override
  Widget build(BuildContext context) {
    final moduleAsync = ref.watch(selectedModuleProvider);
    final progressAsync = ref.watch(selectedProgressProvider);

    final module = moduleAsync.valueOrNull;
    final bool hasProgress =
        progressAsync.valueOrNull != null ||
        (module?.progress != null && module!.progress.isNotEmpty);

    return Scaffold(
      appBar: AppBar(
        title: Text(module?.title ?? 'Module Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
            tooltip: 'Refresh data',
          ),
        ],
      ),
      body: FutureBuilder(
        future: _dataFuture,
        builder: (context, snapshot) {
          if (_isInitialLoad &&
              snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: SLLoadingIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: SLErrorView(
                message: 'Error loading data: ${snapshot.error}',
                onRetry: _refreshData,
              ),
            );
          }

          return _buildBody(
            module,
            moduleAsync.isLoading,
            moduleAsync.error?.toString(),
            progressAsync.valueOrNull,
            _refreshData,
            _navigateToProgress,
          );
        },
      ),
      floatingActionButton: module != null
          ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // // Thêm FAB để chuyển đến Grammar
                // FloatingActionButton.extended(
                //   heroTag: 'grammar',
                //   onPressed: _navigateToGrammar,
                //   icon: const Icon(Icons.menu_book),
                //   label: const Text('Grammar'),
                //   backgroundColor: Theme.of(context).colorScheme.secondary,
                // ),
                const SizedBox(width: 16),
                // FAB bắt đầu học nếu chưa có progress
                if (!hasProgress)
                  FloatingActionButton.extended(
                    heroTag: 'learn',
                    onPressed: _startLearning,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Start Learning'),
                  ),
              ],
            )
          : null,
    );
  }

  Widget _buildBody(
    ModuleDetail? module,
    bool isLoading,
    String? errorMessage,
    ProgressDetail? userProgress,
    Future<void> Function() onRefresh,
    void Function(String) onProgressTap,
  ) {
    if (isLoading) {
      return const Center(child: SLLoadingIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: SLErrorView(message: errorMessage, onRetry: onRefresh),
      );
    }

    if (module == null) {
      return const Center(child: Text('Module not found'));
    }

    return _buildModuleView(
      context,
      module,
      userProgress,
      onRefresh,
      onProgressTap,
    );
  }

  Widget _buildModuleView(
    BuildContext context,
    ModuleDetail module,
    ProgressDetail? userProgress,
    Future<void> Function() onRefresh,
    void Function(String) onProgressTap,
  ) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        padding: const EdgeInsets.all(AppDimens.paddingL),
        children: [
          ModuleHeader(module: module),
          const SizedBox(height: AppDimens.spaceXXL),
          if (userProgress != null) ...[
            ModuleProgressSection(
              progress: userProgress,
              moduleTitle: module.title,
              onTap: onProgressTap,
            ),
            const SizedBox(height: AppDimens.spaceXXL),
          ],
          ModuleContentSection(module: module),

          // Thêm phần Grammar button ở đây để tăng khả năng hiển thị
          const SizedBox(height: AppDimens.spaceXXL),
          Center(
            child: SLButton(
              text: 'View Grammar Rules',
              type: SLButtonType.outline,
              prefixIcon: Icons.book,
              onPressed: _navigateToGrammar,
            ),
          ),

          const SizedBox(height: 80), // Để không bị FloatingActionButton che
        ],
      ),
    );
  }
}
