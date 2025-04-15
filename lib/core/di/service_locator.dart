// lib/core/di/service_locator.dart
import 'package:event_bus/event_bus.dart';
import 'package:get_it/get_it.dart';
import 'package:spaced_learning_app/core/network/api_client.dart';
import 'package:spaced_learning_app/core/services/learning_data_service.dart';
import 'package:spaced_learning_app/core/services/learning_data_service_impl.dart';
import 'package:spaced_learning_app/core/services/platform/device_settings_service.dart';
import 'package:spaced_learning_app/core/services/reminder/alarm_manager_service.dart';
import 'package:spaced_learning_app/core/services/reminder/cloud_reminder_service.dart';
import 'package:spaced_learning_app/core/services/reminder/device_specific_service.dart';
import 'package:spaced_learning_app/core/services/reminder/notification_service.dart';
import 'package:spaced_learning_app/core/services/reminder/reminder_service.dart';
import 'package:spaced_learning_app/core/services/storage_service.dart';
import 'package:spaced_learning_app/data/repositories/auth_repository_impl.dart';
import 'package:spaced_learning_app/data/repositories/book_repository_impl.dart';
import 'package:spaced_learning_app/data/repositories/learning_progress_repository_impl.dart';
import 'package:spaced_learning_app/data/repositories/learning_stats_repository_impl.dart';
import 'package:spaced_learning_app/data/repositories/module_repository_impl.dart';
import 'package:spaced_learning_app/data/repositories/progress_repository_impl.dart';
import 'package:spaced_learning_app/data/repositories/repetition_repository_impl.dart';
import 'package:spaced_learning_app/data/repositories/user_repository_impl.dart';
import 'package:spaced_learning_app/domain/repositories/auth_repository.dart';
import 'package:spaced_learning_app/domain/repositories/book_repository.dart';
import 'package:spaced_learning_app/domain/repositories/learning_progress_repository.dart';
import 'package:spaced_learning_app/domain/repositories/learning_stats_repository.dart';
import 'package:spaced_learning_app/domain/repositories/module_repository.dart';
import 'package:spaced_learning_app/domain/repositories/progress_repository.dart';
import 'package:spaced_learning_app/domain/repositories/repetition_repository.dart';
import 'package:spaced_learning_app/domain/repositories/user_repository.dart';
import 'package:spaced_learning_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/book_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/learning_progress_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/learning_stats_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/module_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/progress_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/reminder_settings_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/repetition_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/theme_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/user_viewmodel.dart';

final GetIt serviceLocator = GetIt.instance;

/// Initialize all dependencies
Future<void> setupServiceLocator() async {
  // === CORE SERVICES ===
  serviceLocator.registerLazySingleton<ApiClient>(() => ApiClient());
  serviceLocator.registerLazySingleton<StorageService>(() => StorageService());

  // Event Bus (singleton để chia sẻ cùng instance)
  serviceLocator.registerLazySingleton<EventBus>(() => EventBus());

  // Device Specific Services
  serviceLocator.registerLazySingleton<DeviceSpecificService>(
    () => DeviceSpecificService(),
  );

  serviceLocator.registerLazySingleton<DeviceSettingsService>(
    () => DeviceSettingsService(),
  );

  // === REPOSITORIES ===
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

  serviceLocator.registerLazySingleton<LearningStatsRepository>(
    () => LearningStatsRepositoryImpl(serviceLocator<ApiClient>()),
  );

  serviceLocator.registerLazySingleton<LearningProgressRepository>(
    () => LearningProgressRepositoryImpl(serviceLocator<ApiClient>()),
  );

  // === NOTIFICATION SERVICES ===
  // NotificationService
  serviceLocator.registerLazySingleton<NotificationService>(
    () => NotificationService(
      deviceSpecificService: serviceLocator<DeviceSpecificService>(),
    ),
  );

  // AlarmManagerService
  serviceLocator.registerLazySingleton<AlarmManagerService>(
    () => AlarmManagerService(
      deviceSpecificService: serviceLocator<DeviceSpecificService>(),
    ),
  );

  // === DATA SERVICES ===
  // LearningDataService
  serviceLocator.registerLazySingleton<LearningDataService>(
    () => LearningDataServiceImpl(serviceLocator<LearningProgressRepository>()),
  );

  // CloudReminderService
  serviceLocator.registerLazySingleton<CloudReminderService>(
    () => CloudReminderService(
      storageService: serviceLocator<StorageService>(),
      notificationService: serviceLocator<NotificationService>(),
    ),
  );

  // ReminderService (thay thế ReminderManager)
  serviceLocator.registerLazySingleton<ReminderService>(
    () => ReminderService(
      notificationService: serviceLocator<NotificationService>(),
      storageService: serviceLocator<StorageService>(),
      deviceSpecificService: serviceLocator<DeviceSpecificService>(),
      progressRepository: serviceLocator<ProgressRepository>(),
      eventBus: serviceLocator<EventBus>(),
    ),
  );

  // === VIEWMODELS ===
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

  // Cập nhật ProgressViewModel với EventBus thay vì ReminderManager
  serviceLocator.registerFactory<ProgressViewModel>(
    () => ProgressViewModel(
      progressRepository: serviceLocator<ProgressRepository>(),
      eventBus: serviceLocator<EventBus>(),
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

  serviceLocator.registerFactory<LearningStatsViewModel>(
    () => LearningStatsViewModel(
      repository: serviceLocator<LearningStatsRepository>(),
    ),
  );

  serviceLocator.registerFactory<LearningProgressViewModel>(
    () => LearningProgressViewModel(
      learningDataService: serviceLocator<LearningDataService>(),
    ),
  );

  // Đăng ký ReminderSettingsViewModel với ReminderService & EventBus
  serviceLocator.registerFactory<ReminderSettingsViewModel>(
    () => ReminderSettingsViewModel(
      reminderService: serviceLocator<ReminderService>(),
      deviceSettingsService: serviceLocator<DeviceSettingsService>(),
      eventBus: serviceLocator<EventBus>(),
    ),
  );
}
