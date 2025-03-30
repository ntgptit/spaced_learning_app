import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaced_learning_app/domain/models/progress.dart';
import 'package:spaced_learning_app/presentation/screens/books/books_screen.dart';
import 'package:spaced_learning_app/presentation/screens/learning/learning_progress_screen.dart';
import 'package:spaced_learning_app/presentation/screens/progress/due_progress_screen.dart';
import 'package:spaced_learning_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/learning_stats_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/progress_viewmodel.dart';
import 'package:spaced_learning_app/presentation/widgets/common/error_display.dart';
import 'package:spaced_learning_app/presentation/widgets/common/loading_indicator.dart';
import 'package:spaced_learning_app/presentation/widgets/learning/learning_stats_card.dart';
import 'package:spaced_learning_app/presentation/widgets/progress/progress_card.dart';

/// Dashboard screen displaying learning overview and statistics
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final authViewModel = context.read<AuthViewModel>();
    final progressViewModel = context.read<ProgressViewModel>();
    final learningStatsViewModel = context.read<LearningStatsViewModel>();

    if (authViewModel.currentUser != null) {
      // Load learning stats and due progress in parallel
      await Future.wait([
        learningStatsViewModel.loadLearningStats(authViewModel.currentUser!.id),
        progressViewModel.loadDueProgress(authViewModel.currentUser!.id),
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authViewModel = context.watch<AuthViewModel>();
    final progressViewModel = context.watch<ProgressViewModel>();
    final learningStatsViewModel = context.watch<LearningStatsViewModel>();

    if (authViewModel.currentUser == null) {
      return const Center(child: Text('Please log in to view your dashboard'));
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Welcome message
          Text(
            'Welcome, ${authViewModel.currentUser!.displayName ?? authViewModel.currentUser!.email}!',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Your learning dashboard',
            style: theme.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // Learning Stats Card
          if (learningStatsViewModel.isLoading)
            const Center(child: AppLoadingIndicator())
          else if (learningStatsViewModel.errorMessage != null)
            ErrorDisplay(
              message: learningStatsViewModel.errorMessage!,
              onRetry: _loadData,
              compact: true,
            )
          else
            LearningStatsCard(
              totalModules: learningStatsViewModel.totalModules,
              completedModules: learningStatsViewModel.completedModules,
              inProgressModules: learningStatsViewModel.inProgressModules,
              dueModules: learningStatsViewModel.dueThisWeek,
              dueToday: learningStatsViewModel.dueToday,
              dueThisWeek: learningStatsViewModel.dueThisWeek,
              dueThisMonth: learningStatsViewModel.dueThisMonth,
              completedToday: learningStatsViewModel.completedToday,
              completedThisWeek: learningStatsViewModel.completedThisWeek,
              completedThisMonth: learningStatsViewModel.completedThisMonth,
              streakDays: learningStatsViewModel.streakDays,
              averageCompletionRate:
                  learningStatsViewModel.averageCompletionRate,
              onViewProgress: () {
                // Navigate to detailed learning progress screen
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const LearningProgressScreen(),
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
                      Text('Due Today', style: theme.textTheme.titleLarge),
                    ],
                  ),
                  const Divider(),

                  if (progressViewModel.isLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24.0),
                        child: AppLoadingIndicator(),
                      ),
                    )
                  else if (progressViewModel.errorMessage != null)
                    ErrorDisplay(
                      message: progressViewModel.errorMessage!,
                      onRetry: _loadData,
                      compact: true,
                    )
                  else if (progressViewModel.progressRecords.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24.0),
                      child: Center(
                        child: Text('No repetitions due today. Great job!'),
                      ),
                    )
                  else
                    _buildDueProgressList(progressViewModel.progressRecords),

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
                              builder: (context) => const DueProgressScreen(),
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

          // Quick actions
          Text('Quick Actions', style: theme.textTheme.titleLarge),
          const SizedBox(height: 16),

          Row(
            children: [
              _buildActionCard(context, 'Browse Books', Icons.book, () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const BooksScreen()),
                );
              }),
              const SizedBox(width: 16),
              _buildActionCard(context, 'Due Sessions', Icons.assignment, () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const DueProgressScreen(),
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  /// Build a list of due progress items
  Widget _buildDueProgressList(List<ProgressSummary> progressList) {
    // Take only the first 3 items for the dashboard
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

  /// Build an action card for quick access
  Widget _buildActionCard(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);

    return Expanded(
      child: Card(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 32, color: theme.colorScheme.primary),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: theme.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
