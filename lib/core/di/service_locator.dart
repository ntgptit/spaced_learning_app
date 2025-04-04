import 'package:get_it/get_it.dart';
import 'package:spaced_learning_app/core/network/api_client.dart';
import 'package:spaced_learning_app/core/services/learning_data_service.dart';
import 'package:spaced_learning_app/core/services/learning_data_service_impl.dart';
import 'package:spaced_learning_app/core/services/storage_service.dart';
import 'package:spaced_learning_app/data/repositories/auth_repository_impl.dart';
import 'package:spaced_learning_app/data/repositories/book_repository_impl.dart';
import 'package:spaced_learning_app/data/repositories/learning_stats_repository_impl.dart';
import 'package:spaced_learning_app/data/repositories/module_repository_impl.dart';
import 'package:spaced_learning_app/data/repositories/progress_repository_impl.dart';
import 'package:spaced_learning_app/data/repositories/repetition_repository_impl.dart';
import 'package:spaced_learning_app/data/repositories/user_repository_impl.dart';
import 'package:spaced_learning_app/domain/repositories/auth_repository.dart';
import 'package:spaced_learning_app/domain/repositories/book_repository.dart';
import 'package:spaced_learning_app/domain/repositories/learning_stats_repository.dart';
import 'package:spaced_learning_app/domain/repositories/module_repository.dart';
import 'package:spaced_learning_app/domain/repositories/progress_repository.dart';
import 'package:spaced_learning_app/domain/repositories/repetition_repository.dart';
import 'package:spaced_learning_app/domain/repositories/user_repository.dart';
import 'package:spaced_learning_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/book_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/learning_stats_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/module_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/progress_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/repetition_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/theme_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/user_viewmodel.dart';

final GetIt serviceLocator = GetIt.instance;

/// Initialize all dependencies
Future<void> setupServiceLocator() async {
  // Core services
  serviceLocator.registerLazySingleton<ApiClient>(() => ApiClient());
  serviceLocator.registerLazySingleton<StorageService>(() => StorageService());

  // Services - Make sure to register LearningDataService properly
  serviceLocator.registerLazySingleton<LearningDataService>(
    () => LearningDataServiceImpl(),
  );

  // Repositories
  serviceLocator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(serviceLocator<ApiClient>()),
  );
  serviceLocator.registerLazySingleton<BookRepository>(
    () => BookRepositoryImpl(serviceLocator<ApiClient>()),
  );
  serviceLocator.registerLazySingleton<ModuleRepository>(
    () => ModuleRepositoryImpl(serviceLocator<ApiClient>()),
  );
  serviceLocator.registerLazySingleton<ProgressRepository>(
    () => ProgressRepositoryImpl(serviceLocator<ApiClient>()),
  );
  serviceLocator.registerLazySingleton<RepetitionRepository>(
    () => RepetitionRepositoryImpl(serviceLocator<ApiClient>()),
  );
  serviceLocator.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(serviceLocator<ApiClient>()),
  );
  // New repository registration
  serviceLocator.registerLazySingleton<LearningStatsRepository>(
    () => LearningStatsRepositoryImpl(serviceLocator<ApiClient>()),
  );

  // ViewModels
  serviceLocator.registerFactory<AuthViewModel>(
    () => AuthViewModel(
      authRepository: serviceLocator<AuthRepository>(),
      storageService: serviceLocator<StorageService>(),
    ),
  );
  serviceLocator.registerFactory<BookViewModel>(
    () => BookViewModel(bookRepository: serviceLocator<BookRepository>()),
  );
  serviceLocator.registerFactory<ModuleViewModel>(
    () => ModuleViewModel(moduleRepository: serviceLocator<ModuleRepository>()),
  );
  serviceLocator.registerFactory<ProgressViewModel>(
    () => ProgressViewModel(
      progressRepository: serviceLocator<ProgressRepository>(),
    ),
  );
  serviceLocator.registerFactory<RepetitionViewModel>(
    () => RepetitionViewModel(
      repetitionRepository: serviceLocator<RepetitionRepository>(),
    ),
  );
  serviceLocator.registerFactory<UserViewModel>(
    () => UserViewModel(userRepository: serviceLocator<UserRepository>()),
  );
  serviceLocator.registerFactory<ThemeViewModel>(
    () => ThemeViewModel(storageService: serviceLocator<StorageService>()),
  );
  // serviceLocator.registerFactory<EnhancedLearningStatsViewModel>(
  //   () => EnhancedLearningStatsViewModel(
  //     progressRepository: serviceLocator<ProgressRepository>(),
  //     learningDataService: serviceLocator<LearningDataService>(),
  //   ),
  // );
  // New viewmodel registration
  serviceLocator.registerFactory<LearningStatsViewModel>(
    () => LearningStatsViewModel(
      repository: serviceLocator<LearningStatsRepository>(),
    ),
  );
}
