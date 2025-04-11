import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaced_learning_app/core/di/service_locator.dart';
import 'package:spaced_learning_app/core/navigation/router.dart';
import 'package:spaced_learning_app/core/services/learning_data_service.dart';
import 'package:spaced_learning_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/book_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/learning_progress_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/learning_stats_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/module_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/progress_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/repetition_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/theme_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/user_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupServiceLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
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
          create: (_) => serviceLocator<LearningStatsViewModel>(),
        ),
        ChangeNotifierProvider(
          create: (_) => serviceLocator<LearningProgressViewModel>(),
        ),

        Provider<LearningDataService>(
          create: (_) => serviceLocator<LearningDataService>(),
        ),
      ],
      child: const AppWithRouter(),
    );
  }
}

class AppWithRouter extends StatelessWidget {
  const AppWithRouter({super.key});

  @override
  Widget build(BuildContext context) {
    final themeViewModel = context.watch<ThemeViewModel>();
    final authViewModel = context.watch<AuthViewModel>();

    final appRouter = AppRouter(authViewModel);

    return MaterialApp.router(
      title: 'Spaced Learning App',
      theme: FlexThemeData.light(
        scheme: FlexScheme.shark, // Chọn một scheme có sẵn
        useMaterial3: true, // Sử dụng Material 3
        subThemesData: const FlexSubThemesData(
          defaultRadius: 8.0, // Bo góc mặc định
          buttonMinSize: Size(80, 40), // Kích thước tối thiểu của nút
        ),
        surfaceMode: FlexSurfaceMode.highScaffoldLowSurfaces,
        blendLevel: 10, // Mức độ pha trộn màu
      ),
      darkTheme: FlexThemeData.dark(
        scheme: FlexScheme.shark, // Đảm bảo sáng và tối đồng bộ
        useMaterial3: true,
        subThemesData: const FlexSubThemesData(
          defaultRadius: 8.0,
          buttonMinSize: Size(80, 40),
        ),
        surfaceMode: FlexSurfaceMode.highScaffoldLowSurfaces,
        blendLevel: 15, // Mức độ pha trộn cho chế độ tối
      ),
      themeMode: themeViewModel.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      routerConfig: appRouter.router,
    );
  }
}
