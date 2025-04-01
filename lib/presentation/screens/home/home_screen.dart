import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaced_learning_app/domain/models/learning_stats.dart';
import 'package:spaced_learning_app/domain/models/progress.dart';
import 'package:spaced_learning_app/presentation/screens/books/books_screen.dart';
import 'package:spaced_learning_app/presentation/screens/learning/learning_progress_screen.dart';
import 'package:spaced_learning_app/presentation/screens/learning/learning_stats_screen.dart';
import 'package:spaced_learning_app/presentation/screens/profile/profile_screen.dart';
import 'package:spaced_learning_app/presentation/screens/progress/due_progress_screen.dart';
import 'package:spaced_learning_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/learning_stats_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/progress_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/theme_viewmodel.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_drawer.dart';
import 'package:spaced_learning_app/presentation/widgets/common/error_display.dart';
import 'package:spaced_learning_app/presentation/widgets/common/loading_indicator.dart';
import 'package:spaced_learning_app/presentation/widgets/home/dashboard_section.dart';
import 'package:spaced_learning_app/presentation/widgets/home/home_app_bar.dart';
import 'package:spaced_learning_app/presentation/widgets/home/learning_insights_widget.dart';
import 'package:spaced_learning_app/presentation/widgets/home/quick_actions_section.dart';
import 'package:spaced_learning_app/presentation/widgets/home/welcome_section.dart';
import 'package:spaced_learning_app/presentation/widgets/learning/learning_insights_card.dart';
import 'package:spaced_learning_app/presentation/widgets/learning/learning_stats_card.dart';
import 'package:spaced_learning_app/presentation/widgets/progress/progress_card.dart';

/// Integrated home screen with dashboard functionality
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // State variables
  bool _isInitialized = false;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  // Data loading
  Future<void> _loadData() async {
    if (!mounted) return;

    try {
      final authViewModel = context.read<AuthViewModel>();
      final progressViewModel = context.read<ProgressViewModel>();
      final learningStatsViewModel = context.read<LearningStatsViewModel>();

      if (authViewModel.currentUser != null) {
        await Future.wait([
          _loadLearningStats(learningStatsViewModel),
          _loadDueProgress(authViewModel, progressViewModel),
        ]);
      }

      if (mounted) {
        setState(() => _isInitialized = true);
      }
    } catch (e) {
      _handleLoadError(e);
    }
  }

  Future<void> _loadLearningStats(LearningStatsViewModel viewModel) async {
    if (!viewModel.isInitialized) {
      await viewModel.loadAllStats();
    }
  }

  Future<void> _loadDueProgress(
    AuthViewModel authViewModel,
    ProgressViewModel progressViewModel,
  ) async {
    try {
      await progressViewModel.loadDueProgress(authViewModel.currentUser!.id);
    } catch (e) {
      debugPrint('Error loading due progress: $e');
    }
  }

  void _handleLoadError(dynamic error) {
    debugPrint('Unexpected error in _loadData: $error');
    if (mounted) {
      setState(() => _isInitialized = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading data: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _navigateToLearningStats() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const LearningStatsScreen()),
    );
  }

  // Build methods
  @override
  Widget build(BuildContext context) {
    final themeViewModel = context.watch<ThemeViewModel>();
    final authViewModel = context.watch<AuthViewModel>();

    if (authViewModel.currentUser == null) {
      return const Center(child: Text('Please log in to view your dashboard'));
    }

    return Scaffold(
      appBar: HomeAppBar(
        isDarkMode: themeViewModel.isDarkMode,
        onThemeToggle: themeViewModel.toggleTheme,
      ),
      drawer: const AppDrawer(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBody() {
    final authViewModel = context.watch<AuthViewModel>();
    final progressViewModel = context.watch<ProgressViewModel>();
    final learningStatsViewModel = context.watch<LearningStatsViewModel>();
    final isLoading =
        progressViewModel.isLoading ||
        learningStatsViewModel.isLoading ||
        !_isInitialized;

    return switch (_currentIndex) {
      0 => _buildHomeTab(
        authViewModel,
        progressViewModel,
        learningStatsViewModel,
        isLoading,
      ),
      1 => const BooksScreen(),
      2 => const DueProgressScreen(),
      3 => const ProfileScreen(),
      _ => _buildHomeTab(
        authViewModel,
        progressViewModel,
        learningStatsViewModel,
        isLoading,
      ),
    };
  }

  Widget _buildBottomNavigationBar() {
    final theme = Theme.of(context);
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) => setState(() => _currentIndex = index),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: theme.colorScheme.primary,
      unselectedItemColor: theme.colorScheme.onSurface.withOpacity(0.6),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Books'),
        BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Due'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }

  Widget _buildHomeTab(
    AuthViewModel authViewModel,
    ProgressViewModel progressViewModel,
    LearningStatsViewModel learningStatsViewModel,
    bool isLoading,
  ) {
    return RefreshIndicator(
      onRefresh: _loadData,
      child:
          isLoading
              ? const Center(child: AppLoadingIndicator())
              : _buildHomeContent(
                authViewModel,
                progressViewModel,
                learningStatsViewModel,
              ),
    );
  }

  Widget _buildHomeContent(
    AuthViewModel authViewModel,
    ProgressViewModel progressViewModel,
    LearningStatsViewModel learningStatsViewModel,
  ) {
    final theme = Theme.of(context);
    final hasLearningStats = learningStatsViewModel.stats != null;

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        WelcomeSection(user: authViewModel.currentUser!),
        const SizedBox(height: 24),

        if (hasLearningStats)
          LearningStatsCard(
            stats: learningStatsViewModel.stats!,
            onViewDetailPressed: _navigateToLearningStats,
          )
        else
          _buildLegacyDashboard(learningStatsViewModel),

        const SizedBox(height: 24),
        _buildDueTodaySection(theme, progressViewModel),
        const SizedBox(height: 24),

        if (hasLearningStats && learningStatsViewModel.insights.isNotEmpty)
          LearningInsightsCard(
            insights: learningStatsViewModel.insights,
            onViewMorePressed: _navigateToLearningStats,
          )
        else
          _buildLegacyInsights(learningStatsViewModel.stats),

        const SizedBox(height: 24),
        Text('Quick Actions', style: theme.textTheme.titleLarge),
        const SizedBox(height: 16),
        QuickActionsSection(
          onBrowseBooksPressed: () => setState(() => _currentIndex = 1),
          onTodaysLearningPressed: () => setState(() => _currentIndex = 2),
          onProgressReportPressed:
              () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const LearningProgressScreen(),
                ),
              ),
          onVocabularyStatsPressed: _navigateToLearningStats,
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildLegacyDashboard(LearningStatsViewModel viewModel) {
    return viewModel.errorMessage != null
        ? ErrorDisplay(
          message: viewModel.errorMessage!,
          onRetry: _loadData,
          compact: true,
        )
        : DashboardSection(
          moduleStats: ModuleStats(
            totalModules: viewModel.stats?.totalModules ?? 0,
            cycleStats:
                viewModel.stats?.cycleStats ??
                const {
                  'FIRST_TIME': 0,
                  'FIRST_REVIEW': 0,
                  'SECOND_REVIEW': 0,
                  'THIRD_REVIEW': 0,
                  'MORE_THAN_THREE_REVIEWS': 0,
                },
          ),
          dueStats: DueStats(
            dueToday: viewModel.stats?.dueToday ?? 0,
            dueThisWeek: viewModel.stats?.dueThisWeek ?? 0,
            dueThisMonth: viewModel.stats?.dueThisMonth ?? 0,
            wordsDueToday: viewModel.stats?.wordsDueToday ?? 0,
            wordsDueThisWeek: viewModel.stats?.wordsDueThisWeek ?? 0,
            wordsDueThisMonth: viewModel.stats?.wordsDueThisMonth ?? 0,
          ),
          completionStats: CompletionStats(
            completedToday: viewModel.stats?.completedToday ?? 0,
            completedThisWeek: viewModel.stats?.completedThisWeek ?? 0,
            completedThisMonth: viewModel.stats?.completedThisMonth ?? 0,
            wordsCompletedToday: viewModel.stats?.wordsCompletedToday ?? 0,
            wordsCompletedThisWeek:
                viewModel.stats?.wordsCompletedThisWeek ?? 0,
            wordsCompletedThisMonth:
                viewModel.stats?.wordsCompletedThisMonth ?? 0,
          ),
          streakStats: StreakStats(
            streakDays: viewModel.stats?.streakDays ?? 0,
            streakWeeks: viewModel.stats?.streakWeeks ?? 0,
          ),
          vocabularyStats: VocabularyStats(
            totalWords: viewModel.stats?.totalWords ?? 0,
            learnedWords: viewModel.stats?.learnedWords ?? 0,
            pendingWords: viewModel.stats?.pendingWords ?? 0,
            vocabularyCompletionRate:
                viewModel.stats?.vocabularyCompletionRate ?? 0.0,
            weeklyNewWordsRate: viewModel.stats?.weeklyNewWordsRate ?? 0.0,
          ),
          onViewProgress: _navigateToLearningStats,
        );
  }

  Widget _buildLegacyInsights(LearningStatsDTO? stats) {
    if (stats == null) {
      return const LearningInsightsWidget(
        vocabularyRate: 5.5, // Default value
        streakDays: 0,
        pendingWords: 0,
        dueToday: 0,
      );
    }

    return LearningInsightsWidget(
      vocabularyRate: stats.weeklyNewWordsRate,
      streakDays: stats.streakDays,
      pendingWords: stats.pendingWords,
      dueToday: stats.dueToday,
    );
  }

  Widget _buildDueTodaySection(
    ThemeData theme,
    ProgressViewModel progressViewModel,
  ) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_today, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text('Due Today', style: theme.textTheme.titleLarge),
                const Spacer(),
                Chip(
                  label: Text(
                    '${progressViewModel.progressRecords.length} items',
                    style: TextStyle(color: theme.colorScheme.onPrimary),
                  ),
                  backgroundColor: theme.colorScheme.primary,
                ),
              ],
            ),
            const Divider(),
            _buildDueProgressContent(progressViewModel),
            if (progressViewModel.progressRecords.isNotEmpty) ...[
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => setState(() => _currentIndex = 2),
                  child: const Text('View all'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDueProgressContent(ProgressViewModel progressViewModel) {
    if (progressViewModel.errorMessage != null) {
      return ErrorDisplay(
        message: progressViewModel.errorMessage!,
        onRetry: _loadData,
        compact: true,
      );
    }
    if (progressViewModel.progressRecords.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24.0),
        child: Center(child: Text('No repetitions due today. Great job!')),
      );
    }
    return _buildDueProgressList(progressViewModel.progressRecords);
  }

  Widget _buildDueProgressList(List<ProgressSummary> progressList) {
    final limitedList =
        progressList.length > 3 ? progressList.sublist(0, 3) : progressList;
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: limitedList.length,
      itemBuilder: (context, index) {
        final progress = limitedList[index];
        return ProgressCard(
          progress: progress,
          moduleTitle: 'Module',
          isDue: true,
          onTap:
              () => Navigator.of(
                context,
              ).pushNamed('/progress/detail', arguments: progress.id),
        );
      },
    );
  }
}
