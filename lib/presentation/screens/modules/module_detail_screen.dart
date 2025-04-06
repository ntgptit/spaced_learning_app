import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaced_learning_app/core/theme/app_colors.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/module.dart';
import 'package:spaced_learning_app/domain/models/progress.dart';
import 'package:spaced_learning_app/presentation/screens/progress/progress_detail_screen.dart';
import 'package:spaced_learning_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/module_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/progress_viewmodel.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_button.dart';
import 'package:spaced_learning_app/presentation/widgets/common/error_display.dart';
import 'package:spaced_learning_app/presentation/widgets/common/loading_indicator.dart';
import 'package:spaced_learning_app/presentation/widgets/progress/progress_card.dart';

class ModuleDetailScreen extends StatefulWidget {
  final String moduleId;

  const ModuleDetailScreen({super.key, required this.moduleId});

  @override
  State<ModuleDetailScreen> createState() => _ModuleDetailScreenState();
}

class _ModuleDetailScreenState extends State<ModuleDetailScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final moduleViewModel = context.read<ModuleViewModel>();
    final authViewModel = context.read<AuthViewModel>();
    final progressViewModel = context.read<ProgressViewModel>();
    final moduleId = widget.moduleId;

    await moduleViewModel.loadModuleDetails(moduleId);
    if (!mounted) return;

    if (authViewModel.isAuthenticated) {
      await progressViewModel.loadCurrentUserProgressByModule(moduleId);
    }
  }

  Future<void> _startLearning() async {
    final authViewModel = context.read<AuthViewModel>();
    final moduleViewModel = context.read<ModuleViewModel>();
    final progressViewModel = context.read<ProgressViewModel>();
    final moduleId = widget.moduleId;

    if (!_isAuthenticated(authViewModel)) {
      _showLoginSnackBar();
      return;
    }

    final module = moduleViewModel.selectedModule;
    if (module == null) return;

    final existingProgress = progressViewModel.selectedProgress;
    if (existingProgress != null) {
      _navigateToProgress(existingProgress.id);
      return;
    }

    final newProgress = await _createNewProgress(
      progressViewModel,
      authViewModel,
      moduleId,
    );

    if (newProgress != null && mounted) {
      _navigateToProgress(newProgress.id);
    }
  }

  bool _isAuthenticated(AuthViewModel authViewModel) {
    return authViewModel.isAuthenticated && authViewModel.currentUser != null;
  }

  void _showLoginSnackBar() {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to start learning')),
      );
    }
  }

  Future<ProgressDetail?> _createNewProgress(
    ProgressViewModel progressViewModel,
    AuthViewModel authViewModel,
    String moduleId,
  ) async {
    return progressViewModel.createProgress(
      moduleId: moduleId,
      userId: authViewModel.currentUser!.id,
      firstLearningDate: DateTime.now(),
      nextStudyDate: DateTime.now(),
    );
  }

  void _navigateToProgress(String progressId) {
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProgressDetailScreen(progressId: progressId),
        ),
      ).then((_) {
        if (mounted) _loadData();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final moduleViewModel = context.watch<ModuleViewModel>();
    final progressViewModel = context.watch<ProgressViewModel>();
    final module = moduleViewModel.selectedModule;

    return Scaffold(
      appBar: AppBar(title: Text(module?.title ?? 'Module Details')),
      body: _BodyBuilder(
        theme: theme,
        module: module,
        isLoading: moduleViewModel.isLoading,
        errorMessage: moduleViewModel.errorMessage,
        userProgress: progressViewModel.selectedProgress,
        onRefresh: _loadData,
        onProgressTap: _navigateToProgress,
      ),
      floatingActionButton:
          module != null && progressViewModel.selectedProgress == null
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
  final ThemeData theme;
  final ModuleDetail? module;
  final bool isLoading;
  final String? errorMessage;
  final ProgressDetail? userProgress;
  final Future<void> Function() onRefresh;
  final void Function(String) onProgressTap;

  const _BodyBuilder({
    required this.theme,
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
      return const Center(child: AppLoadingIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: ErrorDisplay(message: errorMessage!, onRetry: onRefresh),
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
          _ModuleHeader(theme: theme, module: module),
          const SizedBox(height: AppDimens.spaceXXL),
          if (userProgress != null) ...[
            _ProgressSection(
              theme: theme,
              progress: userProgress!,
              moduleTitle: module.title,
              onTap: onProgressTap,
            ),
            const SizedBox(height: AppDimens.spaceXXL),
          ],
          _ContentSection(theme: theme, module: module),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class _ModuleHeader extends StatelessWidget {
  final ThemeData theme;
  final ModuleDetail module;

  const _ModuleHeader({required this.theme, required this.module});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(module.title, style: theme.textTheme.headlineSmall),
        const SizedBox(height: AppDimens.spaceM),
        Row(
          children: [
            _buildModuleTag(),
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
        _buildStatsCard(),
      ],
    );
  }

  Widget _buildModuleTag() {
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

  Widget _buildStatsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingL),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(module.progress.length.toString(), 'Students'),
            _buildDivider(),
            _buildStatItem(module.wordCount?.toString() ?? 'N/A', 'Words'),
            _buildDivider(),
            _buildStatItem(
              _estimateReadingTime(module.wordCount),
              'Reading Time',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
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

  Widget _buildDivider() {
    return Container(height: 40, width: 1, color: AppColors.lightDivider);
  }

  String _estimateReadingTime(int? wordCount) {
    if (wordCount == null || wordCount <= 0) return 'N/A';
    final readingTimeMinutes = (wordCount / 200).ceil();
    if (readingTimeMinutes < 1) return '<1 min';
    return readingTimeMinutes == 1 ? '1 min' : '$readingTimeMinutes mins';
  }
}

class _ProgressSection extends StatelessWidget {
  final ThemeData theme;
  final ProgressDetail progress;
  final String moduleTitle;
  final void Function(String) onTap;

  const _ProgressSection({
    required this.theme,
    required this.progress,
    required this.moduleTitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Your Progress', style: theme.textTheme.titleLarge),
        const SizedBox(height: AppDimens.spaceM),
        ProgressCard(
          progress: ProgressSummary(
            id: progress.id,
            moduleId: progress.moduleId,
            userId: progress.userId,
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
          child: AppButton(
            text: 'View Detailed Progress',
            type: AppButtonType.outline,
            prefixIcon: Icons.visibility,
            onPressed: () => onTap(progress.id),
          ),
        ),
      ],
    );
  }
}

class _ContentSection extends StatelessWidget {
  final ThemeData theme;
  final ModuleDetail module;

  const _ContentSection({required this.theme, required this.module});

  @override
  Widget build(BuildContext context) {
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
                _buildStudyTips(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStudyTips() {
    return Container(
      padding: const EdgeInsets.all(AppDimens.paddingM),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.1),
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
