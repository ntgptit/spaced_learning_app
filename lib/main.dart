import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaced_learning_app/core/di/service_locator.dart';
import 'package:spaced_learning_app/core/navigation/router.dart';
import 'package:spaced_learning_app/core/services/daily_task_checker_service.dart';
import 'package:spaced_learning_app/core/services/learning_data_service.dart';
import 'package:spaced_learning_app/core/services/storage_service.dart';
import 'package:spaced_learning_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/book_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/daily_task_report_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/learning_progress_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/learning_stats_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/module_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/progress_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/repetition_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/theme_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/user_viewmodel.dart';

import 'core/theme/app_color_scheme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupServiceLocator();

  // Khởi tạo DailyTaskChecker
  final dailyTaskChecker = serviceLocator<DailyTaskChecker>();
  final storageService = serviceLocator<StorageService>();
  final isCheckerActive =
      await storageService.getBool('daily_task_checker_active') ?? false;
  if (isCheckerActive) {
    await dailyTaskChecker.initialize();
  }

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
        ChangeNotifierProvider(
          create: (_) => serviceLocator<DailyTaskReportViewModel>(),
        ),
        Provider<LearningDataService>(
          create: (_) => serviceLocator<LearningDataService>(),
        ),
        Provider<DailyTaskChecker>(
          create: (_) => serviceLocator<DailyTaskChecker>(),
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
      // Theme sáng với màu Gemini
      theme: FlexThemeData.light(
        colors: const FlexSchemeColor(
          primary: GeminiColors.primaryBlue,
          primaryContainer: GeminiColors.paleBlue,
          secondary: GeminiColors.textSecondary,
          secondaryContainer: GeminiColors.surfaceGrey,
          tertiary: GeminiColors.lightBlue,
          tertiaryContainer: Color(0xFFD2E3FC),
          appBarColor: GeminiColors.backgroundWhite,
          error: GeminiColors.errorRed,
        ),
        appBarOpacity: 1.0,
        tabBarStyle: FlexTabBarStyle.forAppBar,
        useMaterial3: true,
        // Thiết lập chế độ bề mặt
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        blendLevel: 7,
        // Tùy chỉnh sub-themes
        subThemesData: const FlexSubThemesData(
          // Bán kính bo góc
          defaultRadius: 8.0,
          buttonMinSize: Size(80, 40),
          inputDecoratorRadius: 8.0,
          cardRadius: 12.0,
          dialogRadius: 16.0,
          bottomSheetRadius: 16.0,
          // Các tùy chỉnh khác
          elevatedButtonSchemeColor: SchemeColor.primary,
          elevatedButtonSecondarySchemeColor: SchemeColor.onPrimary,
          outlinedButtonOutlineSchemeColor: SchemeColor.primary,
          inputDecoratorSchemeColor: SchemeColor.tertiary,
          inputDecoratorIsFilled: true,
          fabSchemeColor: SchemeColor.primary,
          chipSchemeColor: SchemeColor.primary,
          chipRadius: 8.0,
          textButtonTextStyle: MaterialStatePropertyAll(
            TextStyle(fontWeight: FontWeight.w500),
          ),
          // Border styles
          thinBorderWidth: 1.0,
          thickBorderWidth: 2.0,
          // Typography contrast
          useTextTheme: true,
          // Menu styles
          popupMenuRadius: 8.0,
          popupMenuElevation: 3.0,
          // Padding
          buttonPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          // Cards
          cardElevation: 1.0,
        ),
        // Sử dụng key colors để tạo scheme từ một số màu
        keyColors: const FlexKeyColors(
          useSecondary: true,
          useTertiary: true,
          useError: true,
        ),
        // Density cho các widget
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        // Tích hợp với Cupertino widgets
        platform: TargetPlatform.android,
      ),
      // Theme tối với màu Gemini
      darkTheme: FlexThemeData.dark(
        colors: const FlexSchemeColor(
          primary: GeminiColors.brightBlue,
          primaryContainer: GeminiColors.darkAccentBlue,
          secondary: GeminiColors.darkTextSecondary,
          secondaryContainer: GeminiColors.darkSurfaceVariant,
          tertiary: Color(0xFFA8CCFD),
          tertiaryContainer: Color(0xFF004A77),
          appBarColor: GeminiColors.darkSurface,
          error: Color(0xFFF2B8B5),
        ),
        appBarOpacity: 1.0,
        tabBarStyle: FlexTabBarStyle.forAppBar,
        useMaterial3: true,
        // Thiết lập chế độ bề mặt
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        blendLevel: 10,
        // Tùy chỉnh sub-themes (giữ nhất quán với theme sáng)
        subThemesData: const FlexSubThemesData(
          defaultRadius: 8.0,
          buttonMinSize: Size(80, 40),
          inputDecoratorRadius: 8.0,
          cardRadius: 12.0,
          dialogRadius: 16.0,
          bottomSheetRadius: 16.0,
          elevatedButtonSchemeColor: SchemeColor.primary,
          elevatedButtonSecondarySchemeColor: SchemeColor.onPrimary,
          outlinedButtonOutlineSchemeColor: SchemeColor.primary,
          inputDecoratorSchemeColor: SchemeColor.tertiary,
          inputDecoratorIsFilled: true,
          fabSchemeColor: SchemeColor.primary,
          chipSchemeColor: SchemeColor.primary,
          chipRadius: 8.0,
          textButtonTextStyle: MaterialStatePropertyAll(
            TextStyle(fontWeight: FontWeight.w500),
          ),
          thinBorderWidth: 1.0,
          thickBorderWidth: 2.0,
          useTextTheme: true,
          popupMenuRadius: 8.0,
          popupMenuElevation: 3.0,
          buttonPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          cardElevation: 1.0,
        ),
        // Sử dụng key colors để tạo scheme từ một số màu
        keyColors: const FlexKeyColors(
          useSecondary: true,
          useTertiary: true,
          useError: true,
        ),
        // Density cho các widget
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        // Tích hợp với Cupertino widgets
        platform: TargetPlatform.android,
      ),
      themeMode: themeViewModel.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      routerConfig: appRouter.router,
    );
  }
}
