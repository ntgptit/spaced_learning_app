import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spaced_learning_app/core/services/screen_refresh_manager.dart';
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
  DateTime? _lastTabChangeTime;
  final ScreenRefreshManager _refreshManager = ScreenRefreshManager();

  @override
  void didUpdateWidget(ScaffoldWithBottomBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.currentIndex != oldWidget.currentIndex) {
      final now = DateTime.now();
      if (_lastTabChangeTime == null ||
          now.difference(_lastTabChangeTime!).inSeconds > 2) {
        _lastTabChangeTime = now;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;

          switch (widget.currentIndex) {
            case 0:
              _refreshManager.refreshScreen('/');
              break;
            case 1:
              _refreshManager.refreshScreen('/books');
              break;
            case 2:
              _refreshManager.refreshScreen('/due-progress');
              break;
            case 3:
              _refreshManager.refreshScreen('/learning');
              break;
            case 4:
              _refreshManager.refreshScreen('/profile');
              break;
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
    if (index == widget.currentIndex) {
      switch (index) {
        case 0:
          _refreshManager.refreshScreen('/');
          break;
        case 1:
          _refreshManager.refreshScreen('/books');
          break;
        case 2:
          _refreshManager.refreshScreen('/due-progress');
          break;
        case 3:
          _refreshManager.refreshScreen('/learning');
          break;
        case 4:
          _refreshManager.refreshScreen('/profile');
          break;
      }
    }

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
}
