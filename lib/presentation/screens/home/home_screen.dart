import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaced_learning_app/core/constants/app_constants.dart';
import 'package:spaced_learning_app/domain/models/progress.dart';
import 'package:spaced_learning_app/presentation/screens/books/books_screen.dart';
import 'package:spaced_learning_app/presentation/screens/profile/profile_screen.dart';
import 'package:spaced_learning_app/presentation/screens/progress/due_progress_screen.dart';
import 'package:spaced_learning_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/progress_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/theme_viewmodel.dart';
import 'package:spaced_learning_app/presentation/widgets/common/error_display.dart';
import 'package:spaced_learning_app/presentation/widgets/common/loading_indicator.dart';
import 'package:spaced_learning_app/presentation/widgets/progress/progress_card.dart';

/// Home screen displaying dashboard and navigation
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const _DashboardTab(),
    const BooksScreen(),
    const DueProgressScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final themeViewModel = context.watch<ThemeViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        actions: [
          // Dark mode toggle
          IconButton(
            icon: Icon(
              themeViewModel.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () {
              themeViewModel.toggleTheme();
            },
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.book), label: 'Books'),
          NavigationDestination(icon: Icon(Icons.assignment), label: 'Due'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

/// Dashboard tab showing summary and recent progress
class _DashboardTab extends StatefulWidget {
  const _DashboardTab();

  @override
  State<_DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<_DashboardTab> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final authViewModel = context.read<AuthViewModel>();
    final progressViewModel = context.read<ProgressViewModel>();

    if (authViewModel.currentUser != null) {
      await progressViewModel.loadDueProgress(authViewModel.currentUser!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authViewModel = context.watch<AuthViewModel>();
    final progressViewModel = context.watch<ProgressViewModel>();

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
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text('Your learning dashboard', style: theme.textTheme.titleMedium),
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
                          setState(() {
                            // Navigate to Due tab
                            (context
                                    .findAncestorStateOfType<
                                      _HomeScreenState
                                    >())
                                ?._currentIndex = 2;
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

          // Recent progress or stats could be added here

          // Quick actions
          Text('Quick Actions', style: theme.textTheme.titleLarge),
          const SizedBox(height: 16),

          Row(
            children: [
              _buildActionCard(context, 'Browse Books', Icons.book, () {
                setState(() {
                  (context.findAncestorStateOfType<_HomeScreenState>())
                      ?._currentIndex = 1;
                });
              }),
              const SizedBox(width: 16),
              _buildActionCard(context, 'Due Today', Icons.assignment, () {
                setState(() {
                  (context.findAncestorStateOfType<_HomeScreenState>())
                      ?._currentIndex = 2;
                });
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
