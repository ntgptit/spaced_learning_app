import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Assuming AppDimens is in this path
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/learning_stats.dart';
import 'package:spaced_learning_app/domain/models/progress.dart';
import 'package:spaced_learning_app/presentation/screens/books/books_screen.dart';
import 'package:spaced_learning_app/presentation/screens/learning/learning_progress_screen.dart';
import 'package:spaced_learning_app/presentation/screens/learning/learning_stats_screen.dart';
import 'package:spaced_learning_app/presentation/screens/profile/profile_screen.dart';
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
    // Use WidgetsBinding.instance.addPostFrameCallback for safety
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  // Data loading
  Future<void> _loadData() async {
    // Ensure the widget is still mounted before proceeding
    if (!mounted) return;

    try {
      // Use context.read inside methods where context is available and needed once
      final authViewModel = context.read<AuthViewModel>();
      final progressViewModel = context.read<ProgressViewModel>();
      final learningStatsViewModel = context.read<LearningStatsViewModel>();

      if (authViewModel.currentUser != null) {
        // Load data concurrently
        await Future.wait([
          _loadLearningStats(learningStatsViewModel),
          _loadDueProgress(authViewModel, progressViewModel),
          // Add other data loading futures here if needed
        ]);
      }

      // Check mounted again before calling setState
      if (mounted) {
        setState(() => _isInitialized = true);
      }
    } catch (e, stackTrace) {
      // Catch specific exceptions if possible
      _handleLoadError(e, stackTrace);
    }
  }

  Future<void> _loadLearningStats(LearningStatsViewModel viewModel) async {
    // Avoid unnecessary loads if already initialized or loading
    if (!viewModel.isInitialized && !viewModel.isLoading) {
      try {
        await viewModel.loadAllStats();
      } catch (e) {
        debugPrint('Error loading learning stats: $e');
        // Optionally propagate or handle error specifically for this load
      }
    }
  }

  Future<void> _loadDueProgress(
    AuthViewModel authViewModel,
    ProgressViewModel progressViewModel,
  ) async {
    // Avoid unnecessary loads
    if (!progressViewModel.isLoading && authViewModel.currentUser != null) {
      try {
        await progressViewModel.loadDueProgress(authViewModel.currentUser!.id);
      } catch (e) {
        debugPrint('Error loading due progress: $e');
        // Optionally propagate or handle error specifically for this load
      }
    }
  }

  void _handleLoadError(dynamic error, StackTrace stackTrace) {
    debugPrint('Error loading home screen data: $error\n$stackTrace');
    if (mounted) {
      // Set initialized to true even on error to stop loading indicator
      setState(() => _isInitialized = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error loading data. Please try again. ($error)',
          ), // User-friendly message
          backgroundColor: Colors.redAccent,
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
    // Use context.watch only where UI needs to rebuild on changes
    final themeViewModel = context.watch<ThemeViewModel>();
    final authViewModel = context.watch<AuthViewModel>();

    if (authViewModel.currentUser == null) {
      // Provide a more informative placeholder or redirect to login
      return const Scaffold(
        body: Center(child: Text('Please log in to view your dashboard')),
      );
    }

    return Scaffold(
      appBar: HomeAppBar(
        isDarkMode: themeViewModel.isDarkMode,
        onThemeToggle: themeViewModel.toggleTheme,
        // Pass other necessary parameters if any
      ),
      drawer: const AppDrawer(),
      body: _buildBody(), // Delegate body building
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBody() {
    // Watch view models needed for the current body content
    final authViewModel = context.watch<AuthViewModel>();
    final progressViewModel = context.watch<ProgressViewModel>();
    final learningStatsViewModel = context.watch<LearningStatsViewModel>();

    // Determine loading state based on relevant view models and initialization flag
    final isLoading =
        // Check specific loading flags if available, otherwise rely on _isInitialized
        progressViewModel
            .isLoading || // Assuming ProgressViewModel has isLoading
        learningStatsViewModel
            .isLoading || // Assuming LearningStatsViewModel has isLoading
        !_isInitialized;

    // Use a switch expression for cleaner body selection
    return switch (_currentIndex) {
      0 => _buildHomeTab(
        authViewModel,
        progressViewModel,
        learningStatsViewModel,
        isLoading,
      ),
      1 => const BooksScreen(),
      2 => const LearningProgressScreen(),
      3 => const ProfileScreen(),
      // Default case, can redirect to home or show an error
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
      type: BottomNavigationBarType.fixed, // Good for 4+ items
      selectedItemColor: theme.colorScheme.primary,
      // Use a defined opacity or keep 0.6 if standard opacities don't match
      unselectedItemColor: theme.colorScheme.onSurface.withValues(alpha: 0.6),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Books'),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment),
          label: 'Learning Overview',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }

  // Builds the content for the Home tab specifically
  Widget _buildHomeTab(
    AuthViewModel authViewModel,
    ProgressViewModel progressViewModel,
    LearningStatsViewModel learningStatsViewModel,
    bool isLoading,
  ) {
    return RefreshIndicator(
      onRefresh: _loadData, // Trigger data reload on pull-to-refresh
      child:
          isLoading
              ? const Center(
                child: AppLoadingIndicator(),
              ) // Use consistent loading indicator
              : _buildHomeContent(
                authViewModel,
                progressViewModel,
                learningStatsViewModel,
              ),
    );
  }

  // Builds the scrollable content of the Home tab
  Widget _buildHomeContent(
    AuthViewModel authViewModel,
    ProgressViewModel progressViewModel,
    LearningStatsViewModel learningStatsViewModel,
  ) {
    final theme = Theme.of(context);
    // Simplify checks
    final stats = learningStatsViewModel.stats;
    final insights = learningStatsViewModel.insights;
    final hasStats = stats != null;
    final hasInsights = insights.isNotEmpty;

    return ListView(
      // Use AppDimens for padding
      padding: const EdgeInsets.all(AppDimens.paddingL), // Changed from 16.0
      children: [
        // Ensure WelcomeSection takes necessary params
        WelcomeSection(user: authViewModel.currentUser!),
        // Use AppDimens for spacing
        const SizedBox(height: AppDimens.spaceXL), // Changed from 24
        // Conditional rendering for Stats Card or Legacy Dashboard
        if (hasStats)
          LearningStatsCard(
            stats: stats,
            onViewDetailPressed: _navigateToLearningStats,
          )
        else
          // Consider showing a placeholder or specific message if stats are expected but null
          _buildLegacyDashboard(
            learningStatsViewModel,
          ), // Fallback or loading state

        const SizedBox(height: AppDimens.spaceXL), // Changed from 24
        // Due Today Section
        _buildDueTodaySection(theme, progressViewModel),
        const SizedBox(height: AppDimens.spaceXL), // Changed from 24
        // Conditional rendering for Insights Card or Legacy Insights
        if (hasStats && hasInsights)
          LearningInsightsCard(
            insights: insights,
            onViewMorePressed: _navigateToLearningStats,
          )
        else if (hasStats) // Show legacy only if stats exist but new insights don't
          _buildLegacyInsights(stats)
        // Optionally show nothing or a placeholder if no stats for insights
        else
          const SizedBox.shrink(), // Or a placeholder widget

        const SizedBox(height: AppDimens.spaceXL), // Changed from 24
        // Quick Actions Section Title
        Text('Quick Actions', style: theme.textTheme.titleLarge),
        const SizedBox(height: AppDimens.spaceL), // Changed from 16
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
        const SizedBox(
          height: AppDimens.spaceXL,
        ), // Changed from 24, consistent bottom spacing
      ],
    );
  }

  // Builds the fallback dashboard section if new LearningStatsCard isn't used
  Widget _buildLegacyDashboard(LearningStatsViewModel viewModel) {
    // Handle error state first
    if (viewModel.errorMessage != null) {
      return ErrorDisplay(
        message: viewModel.errorMessage!,
        onRetry: _loadData,
        compact: true, // Assuming this is appropriate here
      );
    }

    // Use null-aware operators safely
    final stats = viewModel.stats;

    // If stats are null but no error, show loading or placeholder
    if (stats == null && !viewModel.isLoading) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(AppDimens.paddingL),
          child: Center(child: Text('Statistics not available yet.')),
        ),
      );
    }
    // Show dashboard section only if stats are available
    if (stats != null) {
      return DashboardSection(
        // Pass stats safely using null-aware access or defaults
        moduleStats: ModuleStats(
          totalModules: stats.totalModules,
          // Provide default empty map if null
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
        // Assuming CompletionStats fields exist in LearningStatsDTO
        // Add null checks or defaults if these fields might be null in LearningStatsDTO
        completionStats: CompletionStats(
          completedToday: stats.completedToday, // Example null check
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
        onViewProgress: _navigateToLearningStats,
      );
    }

    // Fallback if still loading (though outer check should handle this)
    return const Center(child: AppLoadingIndicator());
  }

  // Builds the fallback insights widget
  Widget _buildLegacyInsights(LearningStatsDTO? stats) {
    // Use default values only if stats are truly null
    const defaultRate = 5.5; // Define default value clearly

    return LearningInsightsWidget(
      vocabularyRate: stats?.weeklyNewWordsRate ?? defaultRate,
      streakDays: stats?.streakDays ?? 0,
      pendingWords: stats?.pendingWords ?? 0,
      dueToday: stats?.dueToday ?? 0,
    );
  }

  // Builds the "Due Today" section card
  Widget _buildDueTodaySection(
    ThemeData theme,
    ProgressViewModel progressViewModel,
  ) {
    return Card(
      margin: EdgeInsets.zero, // Remove default card margin if needed
      child: Padding(
        // Use AppDimens for padding
        padding: const EdgeInsets.all(AppDimens.paddingL), // Changed from 16.0
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_today, color: theme.colorScheme.primary),
                // Use AppDimens for spacing
                const SizedBox(width: AppDimens.spaceS), // Changed from 8
                Text('Due Today', style: theme.textTheme.titleLarge),
                const Spacer(),
                Chip(
                  label: Text(
                    '${progressViewModel.progressRecords.length} items',
                    // Consider using theme text style for chip
                    style: theme.chipTheme.labelStyle?.copyWith(
                      color:
                          theme.chipTheme.selectedColor ??
                          theme.colorScheme.onPrimary,
                    ),
                  ),
                  backgroundColor:
                      theme.chipTheme.backgroundColor ??
                      theme.colorScheme.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.paddingS,
                  ), // Add padding
                ),
              ],
            ),
            const Divider(
              height: AppDimens.paddingL * 2,
            ), // Use dimens for divider spacing if needed
            _buildDueProgressContent(
              progressViewModel,
            ), // Build list or placeholder
            // Show "View all" only if there are items
            if (progressViewModel.progressRecords.isNotEmpty) ...[
              // Use AppDimens for spacing
              const SizedBox(height: AppDimens.spaceS), // Changed from 8
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

  // Builds the content inside the "Due Today" card (list or message)
  Widget _buildDueProgressContent(ProgressViewModel progressViewModel) {
    if (progressViewModel.errorMessage != null) {
      return ErrorDisplay(
        message: progressViewModel.errorMessage!,
        onRetry: _loadData, // Allow retrying the entire data load
        compact: true,
      );
    }
    if (progressViewModel.isLoading &&
        progressViewModel.progressRecords.isEmpty) {
      // Show loading specifically for this section if needed
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: AppDimens.paddingXXL),
        child: Center(
          child: AppLoadingIndicator(size: AppDimens.iconXL),
        ), // Use dimens
      );
    }
    if (progressViewModel.progressRecords.isEmpty) {
      return const Padding(
        // Use AppDimens for padding
        padding: EdgeInsets.symmetric(
          vertical: AppDimens.paddingXXL,
        ), // Changed from 24.0
        child: Center(child: Text('No repetitions due today. Great job!')),
      );
    }
    // Build the list if records exist
    return _buildDueProgressList(progressViewModel.progressRecords);
  }

  // Builds the limited list of due progress items for the home screen
  Widget _buildDueProgressList(List<ProgressSummary> progressList) {
    // Limit the number of items shown on the home screen
    const int maxItemsToShow = 3;
    final limitedList =
        progressList.length > maxItemsToShow
            ? progressList.sublist(0, maxItemsToShow)
            : progressList;

    return ListView.builder(
      shrinkWrap: true, // Important for ListView inside Column
      physics:
          const NeverScrollableScrollPhysics(), // Disable scrolling within list
      itemCount: limitedList.length,
      itemBuilder: (context, index) {
        final progress = limitedList[index];
        // Ensure ProgressCard uses AppDimens internally
        return ProgressCard(
          progress: progress,
          // TODO: Get actual module title if available
          moduleTitle: 'Module', // Placeholder - need actual data if possible
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
