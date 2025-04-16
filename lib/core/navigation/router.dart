import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spaced_learning_app/core/navigation/route_observer.dart';
import 'package:spaced_learning_app/presentation/screens/auth/login_screen.dart';
import 'package:spaced_learning_app/presentation/screens/books/book_detail_screen.dart';
import 'package:spaced_learning_app/presentation/screens/books/books_screen.dart';
import 'package:spaced_learning_app/presentation/screens/help/spaced_repetition_info_screen.dart';
import 'package:spaced_learning_app/presentation/screens/home/home_screen.dart';
import 'package:spaced_learning_app/presentation/screens/learning/learning_progress_screen.dart';
import 'package:spaced_learning_app/presentation/screens/modules/module_detail_screen.dart';
import 'package:spaced_learning_app/presentation/screens/profile/profile_screen.dart';
import 'package:spaced_learning_app/presentation/screens/progress/due_progress_screen.dart';
import 'package:spaced_learning_app/presentation/screens/progress/progress_detail_screen.dart';
import 'package:spaced_learning_app/presentation/screens/settings/reminder_settings_screen.dart';
import 'package:spaced_learning_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:spaced_learning_app/presentation/widgets/common/scaffold_with_bottom_bar.dart';

class AppRouter {
  final AuthViewModel authViewModel;
  final AppRouteObserver routeObserver = AppRouteObserver();

  AppRouter(this.authViewModel);

  late final router = GoRouter(
    refreshListenable: authViewModel,
    debugLogDiagnostics: true,
    initialLocation: '/',
    redirect: (context, state) {
      final isLoggedIn = authViewModel.isAuthenticated;
      final isGoingToLogin = state.uri.toString() == '/login';

      if (!isLoggedIn && !isGoingToLogin) {
        return '/login';
      }
      if (isLoggedIn && isGoingToLogin) {
        return '/';
      }
      return null;
    },
    observers: [
      routeObserver,
      GoRouterObserver(
        onPop: (route, result) {
          debugPrint('Popped route: ${route.settings.name}');
        },
      ),
    ],
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),

      // Thêm route trực tiếp cho Progress Detail screen
      GoRoute(
        path: '/progress/:id',
        name: 'progressDetail',
        builder: (context, state) {
          final progressId = state.pathParameters['id'];
          return ProgressDetailScreen(progressId: progressId ?? '');
        },
      ),

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
            builder: (context, state) => const HomeScreen(),
            routes: [],
          ),

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

          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),

          GoRoute(
            path: '/due-progress',
            builder: (context, state) => const DueProgressScreen(),
          ),

          GoRoute(
            path: '/settings/reminders',
            builder: (context, state) => const ReminderSettingsScreen(),
          ),

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
  );
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
