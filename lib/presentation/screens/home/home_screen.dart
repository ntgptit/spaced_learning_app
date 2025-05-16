// lib/presentation/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spaced_learning_app/core/services/screen_refresh_manager.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/presentation/screens/home/widgets/home_content.dart';
import 'package:spaced_learning_app/presentation/viewmodels/home_viewmodel.dart';
import 'package:spaced_learning_app/presentation/widgets/common/state/sl_error_state_widget.dart';
import 'package:spaced_learning_app/presentation/widgets/common/state/sl_loading_state_widget.dart';
import 'package:spaced_learning_app/presentation/widgets/common/state/sl_offline_state_widget.dart';
import 'package:spaced_learning_app/presentation/widgets/common/state/sl_timeout_state_widget.dart';

import '../../../core/theme/app_theme_data.dart';
import '../../widgets/home/home_app_bar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  final ScreenRefreshManager _refreshManager = ScreenRefreshManager();

  // Animation controller for smooth transitions
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  bool _isInitialLoading = true;

  @override
  void initState() {
    super.initState();
    _refreshManager.registerRefreshCallback('/', _refreshData);

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: AppDimens.durationM),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    // Schedule data loading after the frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  @override
  void dispose() {
    _refreshManager.unregisterRefreshCallback('/', _refreshData);
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isInitialLoading = true;
    });

    await ref.read(homeViewModelProvider.notifier).loadInitialData();

    if (mounted) {
      setState(() {
        _isInitialLoading = false;
      });
      _animationController.forward();
    }
  }

  Future<void> _refreshData() async {
    if (!mounted) return;

    setState(() {
      _isInitialLoading = true;
    });

    _animationController.reset();

    // Ensure all data is reloaded simultaneously
    await ref.read(homeViewModelProvider.notifier).refreshData();

    if (mounted) {
      setState(() {
        _isInitialLoading = false;
      });
      _animationController.forward();
    }
  }

  Widget _buildErrorWidget(String? errorMessage) {
    // Check for connection error
    if (errorMessage?.contains('No internet connection') == true ||
        errorMessage?.contains('Connection Error') == true ||
        errorMessage?.contains('Failed to connect') == true) {
      return SlOfflineStateWidget(
        onRetry: _refreshData,
        message: 'Please check your internet connection and try again.',
      );
    }

    // Check for timeout error
    if (errorMessage?.contains('timeout') == true ||
        errorMessage?.contains('Timeout') == true) {
      return SlTimeoutStateWidget(
        onRetry: _refreshData,
        onCancel: () => GoRouter.of(context).go('/books'),
        cancelButtonText: 'Explore Books',
      );
    }

    // General error
    return SlErrorStateWidget(
      title: 'An error occurred',
      message: errorMessage,
      onRetry: _refreshData,
      retryText: 'Try Again',
    );
  }

  @override
  Widget build(BuildContext context) {
    // Change how to track isDarkMode, using themeModeStateProvider
    final themeMode = ref.watch(themeModeStateProvider);
    final isDarkMode = themeMode == ThemeMode.dark;

    final homeState = ref.watch(homeViewModelProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: HomeAppBar(
        isDarkMode: isDarkMode,
        onThemeToggle: () =>
            ref.read(themeModeStateProvider.notifier).toggleTheme(),
        onMenuPressed: () => Scaffold.of(context).openDrawer(),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: Theme.of(context).colorScheme.primary,
        backgroundColor: Theme.of(context).colorScheme.surface,
        child: Builder(
          builder: (context) {
            // Check loading state
            if (_isInitialLoading ||
                ref.read(homeViewModelProvider.notifier).isFirstLoading) {
              return const SlLoadingStateWidget(
                message: "Loading your learning data...",
                type: SlLoadingType.fadingCircle,
                size: SlLoadingSize.large,
              );
            }

            // Check error state
            if (ref.read(homeViewModelProvider.notifier).hasError) {
              return _buildErrorWidget(homeState.errorMessage);
            }

            return HomeContent(
              onRefresh: _refreshData,
              animationController: _animationController,
              fadeAnimation: _fadeAnimation,
            );
          },
        ),
      ),
    );
  }
}
