import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaced_learning_app/domain/models/progress.dart';
import 'package:spaced_learning_app/presentation/screens/books/books_screen.dart';
import 'package:spaced_learning_app/presentation/screens/learning/learning_progress_screen.dart';
import 'package:spaced_learning_app/presentation/screens/progress/due_progress_screen.dart';
import 'package:spaced_learning_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/enhanced_learning_stats_viewmodel.dart';
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
import 'package:spaced_learning_app/presentation/widgets/progress/progress_card.dart';

/// Integrated home screen with dashboard functionality
class IntegratedHomeScreen extends StatefulWidget {
  const IntegratedHomeScreen({super.key});

  @override
  State<IntegratedHomeScreen> createState() => _IntegratedHomeScreenState();
}

class _IntegratedHomeScreenState extends State<IntegratedHomeScreen> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // Schedule the _loadData to run after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final authViewModel = context.read<AuthViewModel>();
    final progressViewModel = context.read<ProgressViewModel>();
    final learningStatsViewModel =
        context.read<EnhancedLearningStatsViewModel>();

    if (authViewModel.currentUser != null) {
      // Check if stats were already loaded to avoid duplicate loading
      if (!learningStatsViewModel.isInitialized) {
        // Load learning stats
        await learningStatsViewModel.loadLearningStats(
          authViewModel.currentUser!.id,
        );
      }

      // Load due progress
      await progressViewModel.loadDueProgress(authViewModel.currentUser!.id);

      // Mark as initialized
      setState(() {
        _isInitialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authViewModel = context.watch<AuthViewModel>();
    final progressViewModel = context.watch<ProgressViewModel>();
    final learningStatsViewModel =
        context.watch<EnhancedLearningStatsViewModel>();
    final themeViewModel = context.watch<ThemeViewModel>();

    if (authViewModel.currentUser == null) {
      return const Center(child: Text('Please log in to view your dashboard'));
    }

    // Display loading indicator during initial load
    final bool isLoading =
        progressViewModel.isLoading ||
        learningStatsViewModel.isLoading ||
        !_isInitialized;

    return Scaffold(
      appBar: HomeAppBar(
        isDarkMode: themeViewModel.isDarkMode,
        onThemeToggle: themeViewModel.toggleTheme,
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child:
            isLoading
                ? const Center(child: AppLoadingIndicator())
                : ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    // Welcome Section
                    WelcomeSection(user: authViewModel.currentUser!),
                    const SizedBox(height: 24),

                    // Dashboard Section
                    if (learningStatsViewModel.errorMessage != null)
                      ErrorDisplay(
                        message: learningStatsViewModel.errorMessage!,
                        onRetry: () {
                          if (authViewModel.currentUser != null) {
                            learningStatsViewModel.refreshStats(
                              authViewModel.currentUser!.id,
                            );
                          }
                        },
                        compact: true,
                      )
                    else
                      DashboardSection(
                        totalModules: learningStatsViewModel.totalModules,
                        completedModules:
                            learningStatsViewModel.completedModules,
                        inProgressModules:
                            learningStatsViewModel.inProgressModules,
                        dueToday: learningStatsViewModel.dueToday,
                        dueThisWeek: learningStatsViewModel.dueThisWeek,
                        dueThisMonth: learningStatsViewModel.dueThisMonth,
                        wordsDueToday: learningStatsViewModel.wordsDueToday,
                        wordsDueThisWeek:
                            learningStatsViewModel.wordsDueThisWeek,
                        wordsDueThisMonth:
                            learningStatsViewModel.wordsDueThisMonth,
                        completedToday: learningStatsViewModel.completedToday,
                        completedThisWeek:
                            learningStatsViewModel.completedThisWeek,
                        completedThisMonth:
                            learningStatsViewModel.completedThisMonth,
                        wordsCompletedToday:
                            learningStatsViewModel.wordsCompletedToday,
                        wordsCompletedThisWeek:
                            learningStatsViewModel.wordsCompletedThisWeek,
                        wordsCompletedThisMonth:
                            learningStatsViewModel.wordsCompletedThisMonth,
                        streakDays: learningStatsViewModel.streakDays,
                        streakWeeks: learningStatsViewModel.streakWeeks,
                        totalWords: learningStatsViewModel.totalWords,
                        learnedWords: learningStatsViewModel.learnedWords,
                        pendingWords: learningStatsViewModel.pendingWords,
                        vocabularyCompletionRate:
                            learningStatsViewModel.vocabularyCompletionRate,
                        weeklyNewWordsRate:
                            learningStatsViewModel.weeklyNewWordsRate,
                        onViewProgress: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder:
                                  (context) => const LearningProgressScreen(),
                            ),
                          );
                        },
                      ),

                    const SizedBox(height: 24),

                    // Due today section
                    Card(
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  color: theme.colorScheme.primary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Due Today',
                                  style: theme.textTheme.titleLarge,
                                ),
                                const Spacer(),
                                Chip(
                                  label: Text(
                                    '${progressViewModel.progressRecords.length} items',
                                    style: TextStyle(
                                      color: theme.colorScheme.onPrimary,
                                    ),
                                  ),
                                  backgroundColor: theme.colorScheme.primary,
                                ),
                              ],
                            ),
                            const Divider(),

                            // Progress list with error handling
                            if (progressViewModel.errorMessage != null)
                              ErrorDisplay(
                                message: progressViewModel.errorMessage!,
                                onRetry: _loadData,
                                compact: true,
                              )
                            else if (progressViewModel.progressRecords.isEmpty)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 24.0),
                                child: Center(
                                  child: Text(
                                    'No repetitions due today. Great job!',
                                  ),
                                ),
                              )
                            else
                              _buildDueProgressList(
                                progressViewModel.progressRecords,
                              ),

                            const SizedBox(height: 8),

                            // View all due button
                            if (progressViewModel.progressRecords.isNotEmpty)
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    // Navigate to Due Progress screen
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                                const DueProgressScreen(),
                                      ),
                                    );
                                  },
                                  child: const Text('View all'),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Learning insights section
                    LearningInsightsWidget(
                      vocabularyRate: learningStatsViewModel.weeklyNewWordsRate,
                      streakDays: learningStatsViewModel.streakDays,
                      pendingWords: learningStatsViewModel.pendingWords,
                      dueToday: learningStatsViewModel.dueToday,
                    ),

                    const SizedBox(height: 24),

                    // Quick actions section
                    Text('Quick Actions', style: theme.textTheme.titleLarge),
                    const SizedBox(height: 16),

                    QuickActionsSection(
                      onBrowseBooksPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const BooksScreen(),
                          ),
                        );
                      },
                      onTodaysLearningPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const DueProgressScreen(),
                          ),
                        );
                      },
                      onProgressReportPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder:
                                (context) => const LearningProgressScreen(),
                          ),
                        );
                      },
                      onVocabularyStatsPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Vocabulary Statistics coming soon'),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
      ),
    );
  }

  /// Build a list of due progress items
  Widget _buildDueProgressList(List<ProgressSummary> progressList) {
    // Take only the first 3 items for the home dashboard
    final limitedList =
        progressList.length > 3 ? progressList.sublist(0, 3) : progressList;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: limitedList.length,
      itemBuilder: (context, index) {
        final progress = limitedList[index];

        // In a real app, you would fetch the module title from a repository
        // For this demo, we'll use a placeholder
        const moduleTitle = 'Module';

        return ProgressCard(
          progress: progress,
          moduleTitle: moduleTitle,
          isDue: true,
          onTap: () {
            Navigator.of(
              context,
            ).pushNamed('/progress/detail', arguments: progress.id);
          },
        );
      },
    );
  }
}
