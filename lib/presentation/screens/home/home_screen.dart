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
import 'package:spaced_learning_app/presentation/widgets/home/dashboard_section.dart';
import 'package:spaced_learning_app/presentation/widgets/home/home_app_bar.dart';
import 'package:spaced_learning_app/presentation/widgets/home/home_skeleton_screen.dart';
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

class _HomeScreenState extends State<HomeScreen>
    with ViewModelRefresher, SingleTickerProviderStateMixin {
  final ScreenRefreshManager _refreshManager = ScreenRefreshManager();
  late Future<void> _dataFuture;
  bool _isFirstLoad = true;

  // Animation controller for smooth transitions
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _refreshManager.registerRefreshCallback('/', _refreshData);

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: AppDimens.durationM),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    // Initialize data loading
    _dataFuture = _loadInitialData();
  }

  @override
  void dispose() {
    _refreshManager.unregisterRefreshCallback('/', _refreshData);
    _animationController.dispose();
    super.dispose();
  }

  @override
  void refreshData() => _refreshData();

  Future<void> _loadInitialData() async {
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

      // Start fade in animation after data is loaded
      if (mounted) {
        _animationController.forward();
      }
    } catch (e) {
      debugPrint('Error loading initial data: $e');
    }

    if (mounted) {
      setState(() {
        _isFirstLoad = false;
      });
    }
  }

  Future<void> _refreshData() async {
    if (mounted) {
      setState(() {
        _dataFuture = _loadData();
        _animationController.reset();
      });
    }
  }

  Future<void> _loadData() async {
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

      // Restart animation after refresh
      if (mounted) {
        _animationController.forward();
      }
    } catch (e) {
      debugPrint('Error refreshing data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeViewModel = context.watch<ThemeViewModel>();
    final authViewModel = context.watch<AuthViewModel>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: HomeAppBar(
        isDarkMode: themeViewModel.isDarkMode,
        onThemeToggle: themeViewModel.toggleTheme,
        onMenuPressed: () => Scaffold.of(context).openDrawer(),
      ),
      body: FutureBuilder(
        future: _dataFuture,
        builder: (context, snapshot) {
          // Show skeleton screen while loading for first time
          if (snapshot.connectionState == ConnectionState.waiting &&
              _isFirstLoad) {
            return const HomeSkeletonScreen();
          }

          // Show error state if data loading failed
          if (snapshot.hasError) {
            return Center(
              child: ErrorDisplay(
                message: 'Failed to load data: ${snapshot.error}',
                onRetry: _refreshData,
              ),
            );
          }

          return _buildBody(authViewModel.currentUser, theme, colorScheme);
        },
      ),
    );
  }

  Widget _buildBody(User? user, ThemeData theme, ColorScheme colorScheme) {
    if (user == null) {
      return Center(
        child: Text(
          'Please login to continue',
          style: theme.textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshData,
      color: colorScheme.primary,
      backgroundColor: colorScheme.surface,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppDimens.paddingL),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: _buildHomeContent(user),
        ),
      ),
    );
  }

  Widget _buildHomeContent(User user) {
    return Column(
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
    );
  }

  Widget _buildDashboardSection() {
    final statsViewModel = context.watch<LearningStatsViewModel>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
            Text(
              'No statistics available',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
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
    final theme = Theme.of(context);

    if (statsViewModel.insights.isEmpty) return const SizedBox.shrink();

    return LearningInsightsCard(
      insights: statsViewModel.insights,
      title: 'Learning Insights',
      onViewMorePressed: () {},
      theme: theme,
    );
  }

  Widget _buildDueTasksSection() {
    final progressViewModel = context.watch<ProgressViewModel>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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

    return Card(
      elevation: AppDimens.elevationS,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusL),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.assignment_late,
                  color: colorScheme.primary,
                  size: AppDimens.iconM,
                ),
                const SizedBox(width: AppDimens.spaceS),
                Text(
                  'Due Tasks',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const Divider(height: AppDimens.spaceXXL),
            dueCount > 0
                ? Text(
                    'You have $dueCount task${dueCount > 1 ? 's' : ''} due today',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  )
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppDimens.paddingL),
                      child: Text(
                        'No tasks due today!',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
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

  Widget _buildQuickActionsSection() => QuickActionsSection(
    onBrowseBooksPressed: () => GoRouter.of(context).go('/books'),
    onTodaysLearningPressed: () => GoRouter.of(context).go('/due-progress'),
    onProgressReportPressed: () => GoRouter.of(context).go('/learning'),
    onVocabularyStatsPressed: () => _showVocabularyStatsMessage(),
  );

  void _showVocabularyStatsMessage() {
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Vocabulary stats coming soon',
          style: TextStyle(color: theme.colorScheme.onPrimary),
        ),
        backgroundColor: theme.colorScheme.primary,
      ),
    );
  }
}
