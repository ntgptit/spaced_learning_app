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
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Schedule the _loadData to run after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    if (!mounted) return;

    try {
      final authViewModel = context.read<AuthViewModel>();
      final progressViewModel = context.read<ProgressViewModel>();
      final learningStatsViewModel =
          context.read<EnhancedLearningStatsViewModel>();

      if (authViewModel.currentUser != null) {
        // Load stats if not already loaded
        if (!learningStatsViewModel.isInitialized) {
          // Try to load learning stats but handle errors
          try {
            await learningStatsViewModel.loadLearningStats(
              authViewModel.currentUser!.id,
            );
          } catch (e) {
            debugPrint('Error loading learning stats: $e');
            // Set initialized anyway to avoid loading loop
            if (mounted) {
              setState(() {
                _isInitialized = true;
              });
            }
            return;
          }
        }

        // Try to load due progress
        try {
          await progressViewModel.loadDueProgress(
            authViewModel.currentUser!.id,
          );
        } catch (e) {
          debugPrint('Error loading due progress: $e');
        }

        // Mark as initialized even if there are errors
        // This prevents endless loading state
        if (mounted) {
          setState(() {
            _isInitialized = true;
          });
        }
      } else {
        // If no user, still set initialized to prevent loading screen
        if (mounted) {
          setState(() {
            _isInitialized = true;
          });
        }
      }
    } catch (e) {
      // Catch-all for any unexpected errors
      debugPrint('Unexpected error in _loadData: $e');

      // Always set initialized to true to avoid loading loop
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }

      // Show error to user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
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
      body: _buildCurrentScreen(
        authViewModel,
        progressViewModel,
        learningStatsViewModel,
        isLoading,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: theme.colorScheme.onSurface.withOpacity(0.6),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Books'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Due'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildCurrentScreen(
    AuthViewModel authViewModel,
    ProgressViewModel progressViewModel,
    EnhancedLearningStatsViewModel learningStatsViewModel,
    bool isLoading,
  ) {
    // Switch case for different bottom navigation tabs
    switch (_currentIndex) {
      case 0:
        return _buildHomeTab(
          authViewModel,
          progressViewModel,
          learningStatsViewModel,
          isLoading,
        );
      case 1:
        return const BooksScreen();
      case 2:
        return const DueProgressScreen();
      case 3:
        return _buildProfileTab(authViewModel);
      default:
        return _buildHomeTab(
          authViewModel,
          progressViewModel,
          learningStatsViewModel,
          isLoading,
        );
    }
  }

  /// Build the main home dashboard tab
  Widget _buildHomeTab(
    AuthViewModel authViewModel,
    ProgressViewModel progressViewModel,
    EnhancedLearningStatsViewModel learningStatsViewModel,
    bool isLoading,
  ) {
    final theme = Theme.of(context);

    return RefreshIndicator(
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
                      completedModules: learningStatsViewModel.completedModules,
                      inProgressModules:
                          learningStatsViewModel.inProgressModules,
                      dueToday: learningStatsViewModel.dueToday,
                      dueThisWeek: learningStatsViewModel.dueThisWeek,
                      dueThisMonth: learningStatsViewModel.dueThisMonth,
                      wordsDueToday: learningStatsViewModel.wordsDueToday,
                      wordsDueThisWeek: learningStatsViewModel.wordsDueThisWeek,
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
                                  // Navigate to Due Progress screen or switch to that tab
                                  setState(() {
                                    _currentIndex = 2; // Due tab
                                  });
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
                      // Switch to Books tab instead of navigating
                      setState(() {
                        _currentIndex = 1; // Books tab
                      });
                    },
                    onTodaysLearningPressed: () {
                      // Switch to Due tab instead of navigating
                      setState(() {
                        _currentIndex = 2; // Due tab
                      });
                    },
                    onProgressReportPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const LearningProgressScreen(),
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
    );
  }

  /// Build a simple profile tab
  Widget _buildProfileTab(AuthViewModel authViewModel) {
    final theme = Theme.of(context);
    final user = authViewModel.currentUser!;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Avatar
          CircleAvatar(
            radius: 60,
            backgroundColor: theme.colorScheme.primary,
            child: Text(
              _getInitials(user.displayName ?? user.email),
              style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.onPrimary,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // User name
          Text(
            user.displayName ?? 'User',
            style: theme.textTheme.headlineSmall,
          ),

          // User email
          Text(
            user.email,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),

          const SizedBox(height: 32),

          // Edit profile button
          ElevatedButton.icon(
            onPressed: () {
              // Navigate to profile edit screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Edit profile coming soon')),
              );
            },
            icon: const Icon(Icons.edit),
            label: const Text('Edit Profile'),
          ),

          const SizedBox(height: 16),

          // Logout button
          OutlinedButton.icon(
            onPressed: () async {
              await authViewModel.logout();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
          ),
        ],
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

  /// Get user initials from name or email
  String _getInitials(String text) {
    if (text.isEmpty) return '';

    // For email, use first letter
    if (text.contains('@')) {
      return text[0].toUpperCase();
    }

    // For name, use first letter of each word (max 2)
    final words = text.trim().split(' ');
    if (words.length == 1) {
      return words[0][0].toUpperCase();
    }

    return (words[0][0] + words[1][0]).toUpperCase();
  }
}
