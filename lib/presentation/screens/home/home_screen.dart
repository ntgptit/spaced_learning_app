// lib/presentation/screens/home/home_tab_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/learning_stats.dart';
import 'package:spaced_learning_app/domain/models/progress.dart';
import 'package:spaced_learning_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/learning_stats_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/progress_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/theme_viewmodel.dart';
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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  bool _isInitialized = false;
  DateTime? _lastLoadTime;

  @override
  bool get wantKeepAlive => true; // Giữ trạng thái màn hình khi chuyển tab

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _loadData(forceRefresh: true),
    );
  }

  // Data loading với khả năng buộc refresh
  Future<void> _loadData({bool forceRefresh = false}) async {
    // Ngăn chặn refresh quá thường xuyên
    final now = DateTime.now();
    if (!forceRefresh &&
        _lastLoadTime != null &&
        now.difference(_lastLoadTime!).inSeconds < 5) {
      return;
    }

    // Cập nhật thời gian tải dữ liệu gần nhất
    _lastLoadTime = now;

    if (!mounted) return;

    try {
      final authViewModel = context.read<AuthViewModel>();
      final progressViewModel = context.read<ProgressViewModel>();
      final learningStatsViewModel = context.read<LearningStatsViewModel>();

      // Reset error trước khi tải dữ liệu mới
      progressViewModel.clearError();
      learningStatsViewModel.clearError();

      if (authViewModel.currentUser != null) {
        // Tải dữ liệu đồng thời
        await Future.wait([
          _loadLearningStats(
            learningStatsViewModel,
            forceRefresh: forceRefresh,
          ),
          _loadDueProgress(authViewModel, progressViewModel),
        ]);
      }

      if (mounted) {
        setState(() => _isInitialized = true);
      }
    } catch (e, stackTrace) {
      _handleLoadError(e, stackTrace);
    }
  }

  Future<void> _loadLearningStats(
    LearningStatsViewModel viewModel, {
    bool forceRefresh = false,
  }) async {
    try {
      await viewModel.loadAllStats(refreshCache: forceRefresh);
    } catch (e) {
      debugPrint('Error loading learning stats: $e');
    }
  }

  Future<void> _loadDueProgress(
    AuthViewModel authViewModel,
    ProgressViewModel progressViewModel,
  ) async {
    if (authViewModel.currentUser != null) {
      try {
        await progressViewModel.loadDueProgress(authViewModel.currentUser!.id);
      } catch (e) {
        debugPrint('Error loading due progress: $e');
      }
    }
  }

  void _handleLoadError(dynamic error, StackTrace stackTrace) {
    debugPrint('Error loading home screen data: $error\n$stackTrace');
    if (mounted) {
      // Access theme for SnackBar styling
      final theme = Theme.of(context);
      setState(() => _isInitialized = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error loading data. Please try again. (${error.toString().split('\n').first})',
            // Use theme text style if defined in SnackBarTheme
            // style: theme.snackBarTheme.contentTextStyle,
          ),
          // Use theme colors
          backgroundColor: theme.colorScheme.error,
          action: SnackBarAction(
            label: 'Retry',
            onPressed: () => _loadData(forceRefresh: true),
            // Use theme colors
            textColor:
                theme.snackBarTheme.actionTextColor ??
                theme.colorScheme.primary,
          ),
        ),
      );
    }
  }

  void _navigateToLearningStats() {
    GoRouter.of(context).push('/learning-stats');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Cần thiết cho AutomaticKeepAliveClientMixin

    // Use Theme.of(context) to access the current theme data
    final theme = Theme.of(context);
    final themeViewModel = context.watch<ThemeViewModel>();
    final authViewModel = context.watch<AuthViewModel>();
    final progressViewModel = context.watch<ProgressViewModel>();
    final learningStatsViewModel = context.watch<LearningStatsViewModel>();

    return Scaffold(
      // Use theme scaffold background color implicitly
      appBar: HomeAppBar(
        isDarkMode: themeViewModel.isDarkMode,
        onThemeToggle: themeViewModel.toggleTheme,
        // Pass theme properties if needed by HomeAppBar
        // backgroundColor: theme.appBarTheme.backgroundColor,
        // foregroundColor: theme.appBarTheme.foregroundColor,
      ),
      body: _buildBody(
        authViewModel,
        progressViewModel,
        learningStatsViewModel,
        theme, // Pass theme to body builder
      ),
    );
  }

  Widget _buildBody(
    AuthViewModel authViewModel,
    ProgressViewModel progressViewModel,
    LearningStatsViewModel learningStatsViewModel,
    ThemeData theme, // Receive theme
  ) {
    // Xác định trạng thái loading
    final isLoading =
        progressViewModel.isLoading ||
        learningStatsViewModel.isLoading ||
        !_isInitialized;

    return RefreshIndicator(
      onRefresh: () => _loadData(forceRefresh: true),
      // Use theme's indicator colors
      color: theme.colorScheme.primary,
      backgroundColor: theme.progressIndicatorTheme.refreshBackgroundColor,
      child:
          isLoading
              ? Center(
                child: AppLoadingIndicator(
                  // Optionally style indicator using theme
                  color: theme.colorScheme.primary,
                ),
              )
              : _buildHomeContent(
                authViewModel,
                progressViewModel,
                learningStatsViewModel,
                theme, // Pass theme to content builder
              ),
    );
  }

  Widget _buildHomeContent(
    AuthViewModel authViewModel,
    ProgressViewModel progressViewModel,
    LearningStatsViewModel learningStatsViewModel,
    ThemeData theme, // Receive theme
  ) {
    // No need to call Theme.of(context) again, use the passed 'theme'
    final stats = learningStatsViewModel.stats;
    final insights = learningStatsViewModel.insights;
    final hasStats = stats != null;
    final hasInsights = insights.isNotEmpty;

    return ListView(
      padding: const EdgeInsets.all(AppDimens.paddingL),
      children: [
        // Pass theme if WelcomeSection needs styling
        WelcomeSection(user: authViewModel.currentUser!),
        const SizedBox(height: AppDimens.spaceXL),

        // Stats Section
        if (hasStats)
          LearningStatsCard(
            stats: stats,
            onViewDetailPressed: _navigateToLearningStats,
          )
        else
          // Pass theme if legacy dashboard needs styling
          _buildLegacyDashboard(learningStatsViewModel, theme),

        const SizedBox(height: AppDimens.spaceXL),

        // Due Today Section
        // Pass theme directly
        _buildDueTodaySection(theme, progressViewModel),

        const SizedBox(height: AppDimens.spaceXL),

        // Insights Section
        if (hasStats && hasInsights)
          LearningInsightsCard(
            insights: insights,
            onViewMorePressed: _navigateToLearningStats,
          )
        else if (hasStats)
          // Pass theme if legacy insights need styling
          _buildLegacyInsights(stats, theme),

        const SizedBox(height: AppDimens.spaceXL),

        // Quick Actions Section
        // Use theme text styles
        Text('Quick Actions', style: theme.textTheme.titleLarge),
        const SizedBox(height: AppDimens.spaceL),
        // Pass theme if QuickActionsSection needs styling
        QuickActionsSection(
          onBrowseBooksPressed: () => GoRouter.of(context).go('/books'),
          onTodaysLearningPressed: () => GoRouter.of(context).go('/learning'),
          onProgressReportPressed: () => GoRouter.of(context).go('/learning'),
          onVocabularyStatsPressed: _navigateToLearningStats,
        ),

        const SizedBox(height: AppDimens.spaceXL),
      ],
    );
  }

  Widget _buildLegacyDashboard(
    LearningStatsViewModel viewModel,
    ThemeData theme,
  ) {
    // Xử lý trạng thái lỗi trước
    if (viewModel.errorMessage != null) {
      return ErrorDisplay(
        message: viewModel.errorMessage!,
        onRetry: () => _loadData(forceRefresh: true),
        compact: true,
        // Pass theme if ErrorDisplay needs styling
      );
    }

    // Sử dụng null-aware operators an toàn
    final stats = viewModel.stats;

    // Nếu stats là null nhưng không lỗi, hiển thị loading hoặc placeholder
    if (stats == null && !viewModel.isLoading) {
      // Use Card with theme styling
      return Card(
        // Card theme is applied automatically
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.paddingL),
          // Use theme text style
          child: Center(
            child: Text(
              'Statistics not available yet.',
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ),
      );
    }
    // Hiển thị DashboardSection chỉ khi có stats
    if (stats != null) {
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
        onViewProgress: _navigateToLearningStats,
      );
    }

    // Fallback nếu đang loading (mặc dù kiểm tra bên ngoài sẽ xử lý điều này)
    return Center(child: AppLoadingIndicator(color: theme.colorScheme.primary));
  }

  Widget _buildLegacyInsights(LearningStatsDTO? stats, ThemeData theme) {
    // Sử dụng giá trị mặc định chỉ khi stats thực sự là null
    const defaultRate = 5.5; // Định nghĩa rõ ràng giá trị mặc định

    return LearningInsightsWidget(
      vocabularyRate: stats?.weeklyNewWordsRate ?? defaultRate,
      streakDays: stats?.streakDays ?? 0,
      pendingWords: stats?.pendingWords ?? 0,
      dueToday: stats?.dueToday ?? 0,
    );
  }

  Widget _buildDueTodaySection(
    ThemeData theme, // Use passed theme
    ProgressViewModel progressViewModel,
  ) {
    return Card(
      // Use CardTheme from the passed theme
      margin: EdgeInsets.zero, // Keep this customization
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Use theme icon color
                Icon(Icons.calendar_today, color: theme.iconTheme.color),
                const SizedBox(width: AppDimens.spaceS),
                // Use theme text style
                Text('Due Today', style: theme.textTheme.titleLarge),
                const Spacer(),
                Chip(
                  // Use ChipTheme properties from the passed theme
                  label: Text(
                    '${progressViewModel.progressRecords.length} items',
                    // Use theme chip label style
                    style: theme.chipTheme.labelStyle?.copyWith(
                      // Ensure selected color is handled correctly by theme or override
                      color:
                          theme.chipTheme.secondaryLabelStyle?.color ??
                          theme.colorScheme.onPrimary,
                    ),
                  ),
                  // Use theme chip background color
                  backgroundColor:
                      theme.chipTheme.secondarySelectedColor ??
                      theme.colorScheme.primary,
                  padding: theme.chipTheme.padding,
                ),
              ],
            ),
            // Use theme divider
            const Divider(height: AppDimens.paddingL * 2),
            // Pass theme to content builder
            _buildDueProgressContent(progressViewModel, theme),
            if (progressViewModel.progressRecords.isNotEmpty) ...[
              const SizedBox(height: AppDimens.spaceS),
              Align(
                alignment: Alignment.centerRight,
                // Use TextButton with theme styling
                child: TextButton(
                  // Theme is applied automatically
                  onPressed: () => GoRouter.of(context).go('/learning'),
                  child: const Text('View all'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDueProgressContent(
    ProgressViewModel progressViewModel,
    ThemeData theme,
  ) {
    if (progressViewModel.errorMessage != null) {
      return ErrorDisplay(
        message: progressViewModel.errorMessage!,
        onRetry: () => _loadData(forceRefresh: true),
        compact: true,
      );
    }
    if (progressViewModel.isLoading &&
        progressViewModel.progressRecords.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppDimens.paddingXXL),
        child: Center(
          child: AppLoadingIndicator(
            size: AppDimens.iconXL,
            // Use theme color
            color: theme.colorScheme.primary,
          ),
        ),
      );
    }
    if (progressViewModel.progressRecords.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppDimens.paddingXXL),
        // Use theme text style
        child: Center(
          child: Text(
            'No repetitions due today. Great job!',
            style: theme.textTheme.bodyMedium,
          ),
        ),
      );
    }

    // Xây dựng danh sách nếu có records
    // Pass theme to list builder
    return _buildDueProgressList(progressViewModel.progressRecords, theme);
  }

  Widget _buildDueProgressList(
    List<ProgressSummary> progressList,
    ThemeData theme,
  ) {
    // Giới hạn số lượng items hiển thị trên màn hình home
    const int maxItemsToShow = 3;
    final limitedList =
        progressList.length > maxItemsToShow
            ? progressList.sublist(0, maxItemsToShow)
            : progressList;

    return ListView.builder(
      shrinkWrap: true, // Quan trọng cho ListView trong Column
      physics: const NeverScrollableScrollPhysics(), // Tắt cuộn trong list
      itemCount: limitedList.length,
      itemBuilder: (context, index) {
        final progress = limitedList[index];

        return ProgressCard(
          progress: progress,
          moduleTitle: 'Module', // Placeholder - cần dữ liệu thực tế nếu có thể
          isDue: true,
          onTap:
              () => GoRouter.of(
                context,
              ).push('/learning/progress/${progress.id}'),
        );
      },
    );
  }
}
