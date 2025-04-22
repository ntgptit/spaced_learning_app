import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spaced_learning_app/core/navigation/route_observer.dart';
import 'package:spaced_learning_app/presentation/screens/auth/login_screen.dart';
import 'package:spaced_learning_app/presentation/screens/books/book_detail_screen.dart';
import 'package:spaced_learning_app/presentation/screens/books/books_screen.dart';
import 'package:spaced_learning_app/presentation/screens/help/spaced_repetition_info_screen.dart';
import 'package:spaced_learning_app/presentation/screens/learning/learning_progress_screen.dart';
import 'package:spaced_learning_app/presentation/screens/modules/module_detail_screen.dart';
import 'package:spaced_learning_app/presentation/screens/profile/profile_screen.dart';
import 'package:spaced_learning_app/presentation/screens/progress/due_progress_screen.dart';
import 'package:spaced_learning_app/presentation/screens/progress/progress_detail_screen.dart';
import 'package:spaced_learning_app/presentation/screens/report/daily_task_report_screen.dart';
import 'package:spaced_learning_app/presentation/screens/settings/reminder_settings_screen.dart';
import 'package:spaced_learning_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:spaced_learning_app/presentation/widgets/common/scaffold_with_bottom_bar.dart';

import '../../presentation/screens/home/home_screen.dart';

class AppRouter {
  final AuthViewModel authViewModel;
  final AppRouteObserver routeObserver = AppRouteObserver();

  AppRouter(this.authViewModel);

  late final router = GoRouter(
    refreshListenable: authViewModel,
    debugLogDiagnostics: true,
    initialLocation: '/',
    redirect: _handleRedirect,
    observers: [
      routeObserver,
      GoRouterObserver(
        onPop: (route, result) {
          debugPrint('Popped route: ${route.settings.name}');
        },
      ),
    ],
    routes: [
      // Auth routes (outside shell)
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),

      // Modal routes (outside shell)
      GoRoute(
        path: '/progress/:id',
        name: 'progressDetail',
        builder: (context, state) {
          final progressId = state.pathParameters['id'];
          debugPrint('Router received progressId: $progressId');

          // Early return for empty ID
          if (progressId == null || progressId.isEmpty) {
            return Scaffold(
              appBar: AppBar(title: const Text('Error')),
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Invalid progress ID'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Go Back'),
                    ),
                  ],
                ),
              ),
            );
          }

          return ProgressDetailScreen(progressId: progressId);
        },
      ),

      // Main app shell with bottom navigation
      ShellRoute(
        builder: (context, state, child) {
          int currentIndex = 0;
          final location = state.matchedLocation;
          if (location.startsWith('/books')) {
            currentIndex = 1;
          } else if (location.startsWith('/due-progress')) {
            currentIndex = 2;
          } else if (location.startsWith('/learning')) {
            currentIndex = 3;
          } else if (location.startsWith('/profile')) {
            currentIndex = 4;
          }

          return ScaffoldWithBottomBar(
            currentIndex: currentIndex,
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: '/',
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),

          GoRoute(
            path: '/books',
            name: 'books',
            builder: (context, state) => const BooksScreen(),
            routes: [
              GoRoute(
                path: ':id',
                name: 'bookDetail',
                builder: (context, state) {
                  final bookId = state.pathParameters['id'];
                  if (bookId == null || bookId.isEmpty) {
                    return _buildErrorScreen(
                      'Invalid book ID',
                      () => GoRouter.of(context).go('/books'),
                    );
                  }
                  return BookDetailScreen(bookId: bookId);
                },
                routes: [
                  GoRoute(
                    path: 'modules/:moduleId',
                    name: 'moduleDetail',
                    builder: (context, state) {
                      final moduleId = state.pathParameters['moduleId'];
                      if (moduleId == null || moduleId.isEmpty) {
                        return _buildErrorScreen(
                          'Invalid module ID',
                          () => GoRouter.of(context).pop(),
                        );
                      }
                      return ModuleDetailScreen(moduleId: moduleId);
                    },
                  ),
                ],
              ),
            ],
          ),

          GoRoute(
            path: '/learning',
            name: 'learning',
            builder: (context, state) => const LearningProgressScreen(),
            routes: [
              GoRoute(
                path: 'progress/:id',
                name: 'learningProgress',
                builder: (context, state) {
                  final progressId = state.pathParameters['id'];
                  if (progressId == null || progressId.isEmpty) {
                    return _buildErrorScreen(
                      'Invalid progress ID',
                      () => GoRouter.of(context).go('/learning'),
                    );
                  }
                  return ProgressDetailScreen(progressId: progressId);
                },
              ),
              GoRoute(
                path: 'modules/:id',
                name: 'learningModule',
                builder: (context, state) {
                  final moduleId = state.pathParameters['id'];
                  if (moduleId == null || moduleId.isEmpty) {
                    return _buildErrorScreen(
                      'Invalid module ID',
                      () => GoRouter.of(context).go('/learning'),
                    );
                  }
                  return ModuleDetailScreen(moduleId: moduleId);
                },
              ),
            ],
          ),

          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),

          GoRoute(
            path: '/due-progress',
            name: 'dueProgress',
            builder: (context, state) => const DueProgressScreen(),
          ),

          GoRoute(
            path: '/settings/reminders',
            name: 'reminderSettings',
            builder: (context, state) => const ReminderSettingsScreen(),
          ),

          GoRoute(
            path: '/help',
            name: 'help',
            builder: (context, state) =>
                const Scaffold(body: Center(child: Text('Help & Support'))),
            routes: [
              GoRoute(
                path: 'spaced-repetition',
                name: 'spacedRepetition',
                builder: (context, state) => const SpacedRepetitionInfoScreen(),
              ),
            ],
          ),

          GoRoute(
            path: '/task-report',
            name: 'taskReport',
            builder: (context, state) => const DailyTaskReportScreen(),
          ),
        ],
      ),
    ],
  );

  // Xử lý redirect dựa trên trạng thái đăng nhập
  String? _handleRedirect(BuildContext context, GoRouterState state) {
    final isLoggedIn = authViewModel.isAuthenticated;
    final isGoingToLogin = state.matchedLocation == '/login';

    // Danh sách các route không cần đăng nhập
    final publicRoutes = ['/login', '/register', '/forgot-password'];
    final isGoingToPublicRoute = publicRoutes.contains(state.matchedLocation);

    // Nếu chưa đăng nhập và đang cố truy cập route cần đăng nhập
    if (!isLoggedIn && !isGoingToPublicRoute) {
      return '/login';
    }

    // Nếu đã đăng nhập và cố truy cập route đăng nhập
    if (isLoggedIn && isGoingToLogin) {
      return '/';
    }

    // Không cần redirect
    return null;
  }

  // Widget chung cho màn hình lỗi
  Widget _buildErrorScreen(String message, VoidCallback onBack) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: onBack, child: const Text('Go Back')),
          ],
        ),
      ),
    );
  }
}

class GoRouterObserver extends NavigatorObserver {
  final Function(Route<dynamic> route, dynamic result)? onPop;

  GoRouterObserver({this.onPop});

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    onPop?.call(route, null);
  }
}
