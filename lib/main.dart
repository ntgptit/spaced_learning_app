import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaced_learning_app/core/di/service_locator.dart';
import 'package:spaced_learning_app/core/services/learning_data_service.dart';
import 'package:spaced_learning_app/core/theme/app_theme.dart';
import 'package:spaced_learning_app/presentation/screens/auth/login_screen.dart';
import 'package:spaced_learning_app/presentation/screens/home/integrated_home_screen.dart';
import 'package:spaced_learning_app/presentation/screens/learning/learning_progress_screen.dart';
import 'package:spaced_learning_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/book_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/enhanced_learning_stats_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/module_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/progress_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/repetition_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/theme_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/user_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await setupServiceLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ViewModels
        ChangeNotifierProvider(create: (_) => serviceLocator<ThemeViewModel>()),
        ChangeNotifierProvider(create: (_) => serviceLocator<AuthViewModel>()),
        ChangeNotifierProvider(create: (_) => serviceLocator<UserViewModel>()),
        ChangeNotifierProvider(create: (_) => serviceLocator<BookViewModel>()),
        ChangeNotifierProvider(
          create: (_) => serviceLocator<ModuleViewModel>(),
        ),
        ChangeNotifierProvider(
          create: (_) => serviceLocator<ProgressViewModel>(),
        ),
        ChangeNotifierProvider(
          create: (_) => serviceLocator<RepetitionViewModel>(),
        ),
        ChangeNotifierProvider(
          create: (_) => serviceLocator<EnhancedLearningStatsViewModel>(),
        ),
        Provider<LearningDataService>(
          create: (_) => serviceLocator<LearningDataService>(),
        ),
      ],
      child: const AppWithTheme(),
    );
  }
}

class AppWithTheme extends StatelessWidget {
  const AppWithTheme({super.key});

  @override
  Widget build(BuildContext context) {
    final themeViewModel = context.watch<ThemeViewModel>();
    final authViewModel = context.watch<AuthViewModel>();

    return MaterialApp(
      title: 'Spaced Learning App',
      theme: AppTheme.getLightTheme(),
      darkTheme: AppTheme.getDarkTheme(),
      themeMode: themeViewModel.isDarkMode ? ThemeMode.dark : ThemeMode.light,

      // Start with the appropriate screen based on authentication status
      home:
          authViewModel.isAuthenticated
              ? const IntegratedHomeScreen()
              : const LoginScreen(),

      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const IntegratedHomeScreen(),
        '/learning/progress': (context) => const LearningProgressScreen(),
      },
    );
  }
}
