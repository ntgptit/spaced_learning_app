// lib/core/navigation/router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spaced_learning_app/presentation/screens/auth/login_screen.dart';
import 'package:spaced_learning_app/presentation/screens/books/book_detail_screen.dart';
import 'package:spaced_learning_app/presentation/screens/books/books_screen.dart';
import 'package:spaced_learning_app/presentation/screens/help/spaced_repetition_info_screen.dart';
import 'package:spaced_learning_app/presentation/screens/home/home_screen.dart';
import 'package:spaced_learning_app/presentation/screens/learning/learning_progress_screen.dart';
import 'package:spaced_learning_app/presentation/screens/learning/learning_stats_screen.dart';
import 'package:spaced_learning_app/presentation/screens/modules/module_detail_screen.dart';
import 'package:spaced_learning_app/presentation/screens/profile/profile_screen.dart';
import 'package:spaced_learning_app/presentation/screens/progress/progress_detail_screen.dart';
import 'package:spaced_learning_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:spaced_learning_app/presentation/widgets/common/scaffold_with_bottom_bar.dart';

class AppRouter {
  final AuthViewModel authViewModel;

  AppRouter(this.authViewModel);

  late final router = GoRouter(
    refreshListenable: authViewModel, // Refresh khi auth state thay đổi
    debugLogDiagnostics: true,
    initialLocation: '/',
    redirect: (context, state) {
      // Kiểm tra auth và redirect nếu cần
      final isLoggedIn = authViewModel.isAuthenticated;
      final isGoingToLogin = state.location == '/login';

      if (!isLoggedIn && !isGoingToLogin) {
        return '/login';
      }
      if (isLoggedIn && isGoingToLogin) {
        return '/';
      }
      return null;
    },
    routes: [
      // Route đăng nhập
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),

      // Shell route cho main app với bottom navigation
      ShellRoute(
        builder: (context, state, child) {
          // Lấy index tab hiện tại dựa trên path
          int currentIndex = 0;
          final location = state.matchedLocation;
          if (location.startsWith('/books')) {
            currentIndex = 1;
          } else if (location.startsWith('/learning')) {
            currentIndex = 2;
          } else if (location.startsWith('/profile')) {
            currentIndex = 3;
          }

          return ScaffoldWithBottomBar(
            currentIndex: currentIndex,
            child: child,
          );
        },
        routes: [
          // Tab Home và các route con
          GoRoute(
            path: '/',
            builder: (context, state) => const HomeScreen(),
            routes: [
              GoRoute(
                path: 'learning-stats',
                builder: (context, state) => const LearningStatsScreen(),
              ),
            ],
          ),

          // Tab Books và các route con
          GoRoute(
            path: '/books',
            builder: (context, state) => const BooksScreen(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) {
                  final bookId = state.pathParameters['id'];
                  return BookDetailScreen(bookId: bookId ?? '');
                },
                routes: [
                  // Thêm các route con của BookDetailScreen nếu cần
                  GoRoute(
                    path: 'modules/:moduleId',
                    builder: (context, state) {
                      final moduleId = state.pathParameters['moduleId'];
                      return ModuleDetailScreen(moduleId: moduleId ?? '');
                    },
                  ),
                ],
              ),
            ],
          ),

          // Tab Learning Overview và các route con
          GoRoute(
            path: '/learning',
            builder: (context, state) => const LearningProgressScreen(),
            routes: [
              GoRoute(
                path: 'progress/:id',
                builder: (context, state) {
                  final progressId = state.pathParameters['id'];
                  return ProgressDetailScreen(progressId: progressId ?? '');
                },
              ),
              GoRoute(
                path: 'modules/:id',
                builder: (context, state) {
                  final moduleId = state.pathParameters['id'];
                  return ModuleDetailScreen(moduleId: moduleId ?? '');
                },
              ),
            ],
          ),

          // Tab Profile và route con nếu có
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),

          // Route cho help screens - vẫn trong shell route để giữ bottom bar
          GoRoute(
            path: '/help',
            builder:
                (context, state) =>
                    const Scaffold(body: Center(child: Text('Help & Support'))),
            routes: [
              GoRoute(
                path: 'spaced-repetition',
                builder: (context, state) => const SpacedRepetitionInfoScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
    // Thêm route observers để theo dõi các sự kiện điều hướng
    observers: [
      GoRouterObserver(
        onPop: (route, result) {
          // Logic để refresh dữ liệu khi pop về tab Home nếu cần
          debugPrint('Popped route: ${route.settings.name}');
        },
      ),
    ],
  );
}

// Helper class để theo dõi các sự kiện điều hướng
class GoRouterObserver extends NavigatorObserver {
  final Function(Route<dynamic> route, dynamic result)? onPop;

  GoRouterObserver({this.onPop});

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    onPop?.call(route, null);
  }
}
