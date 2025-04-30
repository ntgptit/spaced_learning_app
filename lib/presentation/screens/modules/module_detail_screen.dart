import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/module.dart';
import 'package:spaced_learning_app/domain/models/progress.dart';
import 'package:spaced_learning_app/presentation/utils/snackbar_utils.dart';
import 'package:spaced_learning_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/module_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/progress_viewmodel.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_button.dart';
import 'package:spaced_learning_app/presentation/widgets/common/error_display.dart';
import 'package:spaced_learning_app/presentation/widgets/common/loading_indicator.dart';
import 'package:spaced_learning_app/presentation/widgets/progress/progress_card.dart';

import '../../../core/navigation/navigation_helper.dart';

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

  bool _isAuthenticated() {
    final isLoggedIn = ref.read(authStateProvider).valueOrNull ?? false;
    final currentUser = ref.read(currentUserProvider);
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

          return _BodyBuilder(
            module: module,
            isLoading: moduleAsync.isLoading,
            errorMessage: moduleAsync.error?.toString(),
            userProgress: progressAsync.valueOrNull,
            onRefresh: _refreshData,
            onProgressTap: _navigateToProgress,
          );
        },
      ),
      floatingActionButton: module != null && !hasProgress
          ? FloatingActionButton.extended(
              onPressed: _startLearning,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Start Learning'),
            )
          : null,
    );
  }
}

class _BodyBuilder extends StatelessWidget {
  final ModuleDetail? module;
  final bool isLoading;
  final String? errorMessage;
  final ProgressDetail? userProgress;
  final Future<void> Function() onRefresh;
  final void Function(String) onProgressTap;

  const _BodyBuilder({
    required this.module,
    required this.isLoading,
    required this.errorMessage,
    required this.userProgress,
    required this.onRefresh,
    required this.onProgressTap,
  });

  @override
  Widget build(BuildContext context) {
    return _buildContent(context);
  }

  Widget _buildContent(BuildContext context) {
    if (isLoading) {
      return const Center(child: SLLoadingIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: SLErrorView(message: errorMessage!, onRetry: onRefresh),
      );
    }

    if (module == null) {
      return const Center(child: Text('Module not found'));
    }

    return _buildModuleView(context, module!);
  }

  Widget _buildModuleView(BuildContext context, ModuleDetail module) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        padding: const EdgeInsets.all(AppDimens.paddingL),
        children: [
          _ModuleHeader(module: module),
          const SizedBox(height: AppDimens.spaceXXL),
          if (userProgress != null) ...[
            _ProgressSection(
              progress: userProgress!,
              moduleTitle: module.title,
              onTap: onProgressTap,
            ),
            const SizedBox(height: AppDimens.spaceXXL),
          ],
          _ContentSection(module: module),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class _ModuleHeader extends StatelessWidget {
  final ModuleDetail module;

  const _ModuleHeader({required this.module});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(module.title, style: theme.textTheme.headlineSmall),
        const SizedBox(height: AppDimens.spaceM),
        Row(
          children: [
            _buildModuleTag(context),
            const SizedBox(width: AppDimens.spaceL),
            Expanded(
              child: Text(
                'Book: ${module.bookName ?? "Unknown"}',
                style: theme.textTheme.bodyMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.spaceL),
        _buildStatsCard(context),
      ],
    );
  }

  Widget _buildModuleTag(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.paddingL,
        vertical: AppDimens.paddingS,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(AppDimens.radiusXL),
      ),
      child: Text(
        'Module ${module.moduleNo}',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildStatsCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingL),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(
              context,
              module.progress.length.toString(),
              'Students',
            ),
            _buildDivider(context),
            _buildStatItem(
              context,
              module.wordCount?.toString() ?? 'N/A',
              'Words',
            ),
            _buildDivider(context),
            _buildStatItem(
              context,
              _estimateReadingTime(module.wordCount),
              'Reading Time',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String value, String label) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        Text(label, style: theme.textTheme.bodySmall),
      ],
    );
  }

  Widget _buildDivider(BuildContext context) {
    final theme = Theme.of(context);
    final dividerColor = theme.colorScheme.outline.withValues(alpha: 0.5);

    return Container(height: 40, width: 1, color: dividerColor);
  }

  String _estimateReadingTime(int? wordCount) {
    if (wordCount == null || wordCount <= 0) return 'N/A';
    final readingTimeMinutes = (wordCount / 200).ceil();
    if (readingTimeMinutes < 1) return '<1 min';
    return readingTimeMinutes == 1 ? '1 min' : '$readingTimeMinutes mins';
  }
}

class _ProgressSection extends StatelessWidget {
  final ProgressDetail progress;
  final String moduleTitle;
  final void Function(String) onTap;

  const _ProgressSection({
    required this.progress,
    required this.moduleTitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Your Progress', style: theme.textTheme.titleLarge),
        const SizedBox(height: AppDimens.spaceM),
        ProgressCard(
          progress: ProgressSummary(
            id: progress.id,
            moduleId: progress.moduleId,
            firstLearningDate: progress.firstLearningDate,
            cyclesStudied: progress.cyclesStudied,
            nextStudyDate: progress.nextStudyDate,
            percentComplete: progress.percentComplete,
            createdAt: progress.createdAt,
            updatedAt: progress.updatedAt,
            repetitionCount: progress.repetitions.length,
          ),
          moduleTitle: moduleTitle,
          onTap: () => onTap(progress.id),
        ),
        const SizedBox(height: AppDimens.spaceL),
        Center(
          child: SLButton(
            text: 'View Detailed Progress',
            type: SLButtonType.outline,
            prefixIcon: Icons.visibility,
            onPressed: () => onTap(progress.id),
          ),
        ),
      ],
    );
  }
}

class _ContentSection extends StatelessWidget {
  final ModuleDetail module;

  const _ContentSection({required this.module});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Content Overview', style: theme.textTheme.titleLarge),
        const SizedBox(height: AppDimens.spaceM),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.paddingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (module.wordCount != null && module.wordCount! > 0) ...[
                  Row(
                    children: [
                      const Icon(Icons.format_size),
                      const SizedBox(width: AppDimens.spaceM),
                      Text(
                        'Word Count: ${module.wordCount}',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimens.spaceM),
                ],
                const Text(
                  'This is where the module content would be displayed. '
                  'In a complete application, this would include text, '
                  'images, videos, and other learning materials.',
                ),
                const SizedBox(height: AppDimens.spaceL),
                _buildStudyTips(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStudyTips(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppDimens.paddingM),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb, color: theme.colorScheme.primary),
              const SizedBox(width: AppDimens.spaceM),
              Text(
                'Study Tips',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spaceM),
          const Text(
            '• Review this module regularly using the spaced repetition schedule\n'
            '• Take notes while studying\n'
            '• Try to recall the material before checking your answers\n'
            '• Connect new information to things you already know',
          ),
        ],
      ),
    );
  }
}
