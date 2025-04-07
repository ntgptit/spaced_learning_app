// lib/presentation/widgets/common/scaffold_with_bottom_bar.dart
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
  // Sử dụng để theo dõi lần cuối cập nhật dữ liệu
  DateTime? _lastHomeRefreshTime;

  @override
  void didUpdateWidget(ScaffoldWithBottomBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Nếu chuyển sang tab Home, refresh dữ liệu
    if (widget.currentIndex == 0 && oldWidget.currentIndex != 0) {
      _refreshHomeData();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tự động cập nhật dữ liệu khi vào tab Home, nhưng không quá thường xuyên
    final now = DateTime.now();
    if (widget.currentIndex == 0 &&
        (_lastHomeRefreshTime == null ||
            now.difference(_lastHomeRefreshTime!).inSeconds > 30)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _refreshHomeData();
      });
    }

    return Scaffold(
      drawer: const AppDrawer(),
      body: widget.child,
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  // Thay đổi trong ScaffoldWithBottomBar (_buildBottomNavigationBar)
  Widget _buildBottomNavigationBar(BuildContext context) {
    final theme = Theme.of(context);

    return BottomNavigationBar(
      currentIndex: widget.currentIndex,
      onTap: (index) => _onTabTapped(context, index),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: theme.colorScheme.primary,
      unselectedItemColor: theme.colorScheme.onSurface.withValues(alpha: 0.6),
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
    // Nếu đang ở tab hiện tại và đó là tab Home, refresh data
    if (index == widget.currentIndex && index == 0) {
      _refreshHomeData();
    }

    // Điều hướng đến tab tương ứng
    switch (index) {
      case 0:
        GoRouter.of(context).go('/');
        break;
      case 1:
        GoRouter.of(context).go('/books');
        break;
      case 2:
        GoRouter.of(context).go('/due-progress'); // Tab DueProgress mới
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
    // Cập nhật thời gian refresh
    _lastHomeRefreshTime = DateTime.now();

    final progressViewModel = context.read<ProgressViewModel>();
    final learningStatsViewModel = context.read<LearningStatsViewModel>();

    // Reset error và load dữ liệu mới
    progressViewModel.clearError();
    learningStatsViewModel.clearError();

    // Load dữ liệu mới từ server
    learningStatsViewModel.loadAllStats(refreshCache: true);

    // Load progress data nếu đã đăng nhập
    final authViewModel = context.read<AuthViewModel>();
    if (authViewModel.currentUser != null) {
      progressViewModel.loadDueProgress(authViewModel.currentUser!.id);
    }
  }
}
