import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:spaced_learning_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/learning_stats_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/progress_viewmodel.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_drawer.dart';

class ScaffoldWithBottomBar extends StatefulWidget {
  final Widget child;
  final int currentIndex;

  const ScaffoldWithBottomBar({
    super.key,
    required this.child,
    required this.currentIndex,
  });

  @override
  State<ScaffoldWithBottomBar> createState() => _ScaffoldWithBottomBarState();
}

class _ScaffoldWithBottomBarState extends State<ScaffoldWithBottomBar> {
  // Track last refresh time to avoid too frequent refreshes
  DateTime? _lastHomeRefreshTime;
  DateTime? _lastTabChangeTime;
  bool _needsRefresh = false;

  @override
  void didUpdateWidget(ScaffoldWithBottomBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If we've switched tabs, schedule a state update after build completes
    if (widget.currentIndex != oldWidget.currentIndex) {
      // Prevent double refreshes by tracking time
      final now = DateTime.now();
      if (_lastTabChangeTime == null ||
          now.difference(_lastTabChangeTime!).inSeconds > 2) {
        _lastTabChangeTime = now;

        // Schedule refresh after the build is complete
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // Check if widget is still mounted before proceeding
          if (!mounted) return;

          // If switching to Home tab, refresh data
          if (widget.currentIndex == 0) {
            _refreshHomeData();
          }
          // If switching to Stats tab (Learning Progress)
          else if (widget.currentIndex == 3) {
            _refreshLearningData();
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      body: widget.child,
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    final theme = Theme.of(context);

    return BottomNavigationBar(
      currentIndex: widget.currentIndex,
      onTap: (index) => _onTabTapped(context, index),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: theme.colorScheme.primary,
      unselectedItemColor: theme.colorScheme.onSurface.withOpacity(0.6),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Books'),
        BottomNavigationBarItem(icon: Icon(Icons.today), label: 'Due'),
        BottomNavigationBarItem(
          icon: Icon(Icons.analytics_outlined),
          label: 'Stats',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }

  void _onTabTapped(BuildContext context, int index) {
    // If clicking the current tab (same tab), consider refreshing
    if (index == widget.currentIndex) {
      // For Home tab, refresh data
      if (index == 0) {
        _refreshHomeData();
      }
    }

    // Navigate to the corresponding tab
    switch (index) {
      case 0:
        GoRouter.of(context).go('/');
        break;
      case 1:
        GoRouter.of(context).go('/books');
        break;
      case 2:
        GoRouter.of(context).go('/due-progress');
        break;
      case 3:
        GoRouter.of(context).go('/learning');
        break;
      case 4:
        GoRouter.of(context).go('/profile');
        break;
    }
  }

  void _refreshHomeData() {
    // Update refresh time
    final now = DateTime.now();
    if (_lastHomeRefreshTime != null &&
        now.difference(_lastHomeRefreshTime!).inSeconds < 5) {
      // Avoid refreshing too frequently
      return;
    }
    _lastHomeRefreshTime = now;

    try {
      final progressViewModel = context.read<ProgressViewModel>();
      final learningStatsViewModel = context.read<LearningStatsViewModel>();

      // Reset error and prepare to load new data
      progressViewModel.clearError();
      learningStatsViewModel.clearError();

      // Load new data from server
      learningStatsViewModel.loadAllStats(refreshCache: true);

      // Load progress data if logged in
      final authViewModel = context.read<AuthViewModel>();
      if (authViewModel.currentUser != null) {
        progressViewModel.loadDueProgress(authViewModel.currentUser!.id);
      }
    } catch (e) {
      debugPrint('Error in _refreshHomeData: $e');
    }
  }

  void _refreshLearningData() {
    // Safety check to prevent multiple calls
    if (_needsRefresh) return;
    _needsRefresh = true;

    try {
      // Schedule data update outside of the build cycle
      Future.microtask(() {
        if (!mounted) return;

        try {
          // Don't use context.read here, use Provider.of with listen: false
          final viewModel = Provider.of<LearningStatsViewModel>(
            context,
            listen: false,
          );
          viewModel.loadAllStats(refreshCache: false);
        } catch (e) {
          debugPrint('Error refreshing learning data: $e');
        } finally {
          _needsRefresh = false;
        }
      });
    } catch (e) {
      _needsRefresh = false;
      debugPrint('Error scheduling learning data refresh: $e');
    }
  }
}
