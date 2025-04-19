import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:spaced_learning_app/core/services/screen_refresh_manager.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/user.dart';
import 'package:spaced_learning_app/presentation/mixins/view_model_refresher.dart';
import 'package:spaced_learning_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/learning_stats_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/progress_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/theme_viewmodel.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_button.dart';
import 'package:spaced_learning_app/presentation/widgets/common/error_display.dart';
import 'package:spaced_learning_app/presentation/widgets/common/loading_indicator.dart';
import 'package:spaced_learning_app/presentation/widgets/home/dashboard_section.dart';
import 'package:spaced_learning_app/presentation/widgets/home/home_app_bar.dart';
import 'package:spaced_learning_app/presentation/widgets/home/quick_actions_section.dart';
import 'package:spaced_learning_app/presentation/widgets/home/welcome_section.dart';
import 'package:spaced_learning_app/presentation/widgets/learning/learning_insights_card.dart';

import '../../../domain/models/completion_stats.dart';
import '../../../domain/models/due_stats.dart';
import '../../../domain/models/module_stats.dart';
import '../../../domain/models/streak_stats.dart';
import '../../../domain/models/vocabulary_stats.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with ViewModelRefresher {
  final ScreenRefreshManager _refreshManager = ScreenRefreshManager();
  bool _isLoadingData = false;

  @override
  void initState() {
    super.initState();
    _refreshManager.registerRefreshCallback('/', _refreshData);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadInitialData());
  }

  @override
  void dispose() {
    _refreshManager.unregisterRefreshCallback('/', _refreshData);
    super.dispose();
  }

  @override
  void refreshData() => _refreshData();

  Future<void> _loadInitialData() async {
    if (_isLoadingData) return;

    setState(() => _isLoadingData = true);

    try {
      final progressViewModel = context.read<ProgressViewModel>();
      final learningStatsViewModel = context.read<LearningStatsViewModel>();
      final authViewModel = context.read<AuthViewModel>();

      final futures = [
        learningStatsViewModel.loadAllStats(refreshCache: false),
      ];

      if (authViewModel.currentUser != null) {
        futures.add(
          progressViewModel.loadDueProgress(authViewModel.currentUser!.id),
        );
      }

      await Future.wait(futures);
    } catch (e) {
      debugPrint('Error loading initial data: $e');
    }

    if (!mounted) return;

    setState(() => _isLoadingData = false);
  }

  Future<void> _refreshData() async {
    if (_isLoadingData) return;

    setState(() => _isLoadingData = true);

    try {
      final progressViewModel = context.read<ProgressViewModel>();
      final learningStatsViewModel = context.read<LearningStatsViewModel>();
      final authViewModel = context.read<AuthViewModel>();

      final futures = [learningStatsViewModel.loadAllStats(refreshCache: true)];

      if (authViewModel.currentUser != null) {
        futures.add(
          progressViewModel.loadDueProgress(authViewModel.currentUser!.id),
        );
      }

      await Future.wait(futures);
    } catch (e) {
      debugPrint('Error refreshing data: $e');
    }

    if (!mounted) return;

    setState(() => _isLoadingData = false);
  }

  @override
  Widget build(BuildContext context) {
    final themeViewModel = context.watch<ThemeViewModel>();
    final authViewModel = context.watch<AuthViewModel>();

    return Scaffold(
      appBar: HomeAppBar(
        isDarkMode: themeViewModel.isDarkMode,
        onThemeToggle: themeViewModel.toggleTheme,
        onMenuPressed: () => Scaffold.of(context).openDrawer(),
      ),
      body: _buildBody(authViewModel.currentUser),
    );
  }

  Widget _buildBody(User? user) {
    if (user == null) {
      return const Center(child: Text('Please login to continue'));
    }

    return RefreshIndicator(
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppDimens.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: WelcomeSection(user: user)),
            const SizedBox(height: AppDimens.spaceXL),
            _buildDashboardSection(),
            const SizedBox(height: AppDimens.spaceXL),
            _buildInsightsSection(),
            const SizedBox(height: AppDimens.spaceXL),
            _buildDueTasksSection(),
            const SizedBox(height: AppDimens.spaceXL),
            _buildQuickActionsSection(),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardSection() {
    final statsViewModel = context.watch<LearningStatsViewModel>();

    if (statsViewModel.isLoading) {
      return const Center(
        child: AppLoadingIndicator(type: LoadingIndicatorType.circle),
      );
    }

    if (statsViewModel.errorMessage != null) {
      return ErrorDisplay(
        message: statsViewModel.errorMessage!,
        onRetry: statsViewModel.loadDashboardStats,
        compact: true,
      );
    }

    if (statsViewModel.stats == null) {
      return Center(
        child: Column(
          children: [
            const Text('No statistics available'),
            const SizedBox(height: AppDimens.spaceM),
            AppButton(
              text: 'Load Statistics',
              type: AppButtonType.primary,
              onPressed: statsViewModel.loadDashboardStats,
            ),
          ],
        ),
      );
    }

    final stats = statsViewModel.stats!;

    return DashboardSection(
      moduleStats: ModuleStats(
        totalModules: stats.totalModules,
        cycleStats: stats.cycleStats,
      ),
      dueStats: DueStats(
        dueToday: stats.dueToday,
        dueThisWeek: stats.dueThisWeek,
        dueThisMonth: stats.dueThisMonth,
        wordsDueToday: stats.wordsDueToday,
        wordsDueThisWeek: stats.wordsDueThisWeek,
        wordsDueThisMonth: stats.wordsDueThisMonth,
      ),
      completionStats: CompletionStats(
        completedToday: stats.completedToday,
        completedThisWeek: stats.completedThisWeek,
        completedThisMonth: stats.completedThisMonth,
        wordsCompletedToday: stats.wordsCompletedToday,
        wordsCompletedThisWeek: stats.wordsCompletedThisWeek,
        wordsCompletedThisMonth: stats.wordsCompletedThisMonth,
      ),
      streakStats: StreakStats(
        streakDays: stats.streakDays,
        streakWeeks: stats.streakWeeks,
      ),
      vocabularyStats: VocabularyStats(
        totalWords: stats.totalWords,
        learnedWords: stats.learnedWords,
        pendingWords: stats.pendingWords,
        vocabularyCompletionRate: stats.vocabularyCompletionRate,
        weeklyNewWordsRate: stats.weeklyNewWordsRate,
      ),
      onViewProgress: () => GoRouter.of(context).go('/learning'),
    );
  }

  Widget _buildInsightsSection() {
    final statsViewModel = context.watch<LearningStatsViewModel>();

    if (statsViewModel.isLoading) return const SizedBox.shrink();

    if (statsViewModel.insights.isEmpty) return const SizedBox.shrink();

    return LearningInsightsCard(
      insights: statsViewModel.insights,
      title: 'Learning Insights',
      onViewMorePressed: () {},
    );
  }

  Widget _buildQuickActionsSection() => QuickActionsSection(
    onBrowseBooksPressed: () => GoRouter.of(context).go('/books'),
    onTodaysLearningPressed: () => GoRouter.of(context).go('/due-progress'),
    onProgressReportPressed: () => GoRouter.of(context).go('/learning'),
    onVocabularyStatsPressed: () => ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Vocabulary stats coming soon')),
    ),
  );

  Widget _buildDueTasksSection() {
    final progressViewModel = context.watch<ProgressViewModel>();

    if (progressViewModel.isLoading) {
      return const Center(
        child: AppLoadingIndicator(type: LoadingIndicatorType.threeBounce),
      );
    }

    if (progressViewModel.errorMessage != null) {
      return ErrorDisplay(
        message: progressViewModel.errorMessage!,
        onRetry: () {
          final authViewModel = context.read<AuthViewModel>();
          if (authViewModel.currentUser == null) return;
          progressViewModel.loadDueProgress(authViewModel.currentUser!.id);
        },
        compact: true,
      );
    }

    final dueCount = progressViewModel.progressRecords.length;

    if (dueCount == 0) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.paddingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.assignment_late,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: AppDimens.spaceS),
                  Text(
                    'Due Tasks',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
              const Divider(height: 32),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimens.paddingL),
                  child: Text(
                    'No tasks due today!',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.assignment_late,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: AppDimens.spaceS),
                Text(
                  'Due Tasks',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const Divider(height: 32),
            Text(
              'You have $dueCount task${dueCount > 1 ? 's' : ''} due today',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: AppDimens.spaceL),
            AppButton(
              text: 'View Due Tasks',
              type: AppButtonType.primary,
              prefixIcon: Icons.play_arrow,
              onPressed: () => GoRouter.of(context).go('/due-progress'),
            ),
          ],
        ),
      ),
    );
  }
}
