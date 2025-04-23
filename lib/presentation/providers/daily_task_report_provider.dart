// lib/presentation/providers/daily_task_report_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spaced_learning_app/core/events/app_events.dart';

import '../../core/di/providers.dart';

part 'daily_task_report_provider.g.dart';

@riverpod
class DailyTaskReport extends _$DailyTaskReport {
  @override
  Future<Map<String, dynamic>> build() async {
    return _getLastReport();
  }

  Future<Map<String, dynamic>> _getLastReport() async {
    final taskChecker = ref.read(dailyTaskCheckerProvider);
    return taskChecker.getLastCheckReport();
  }

  Future<DailyTaskCheckEvent> runManualCheck() async {
    state = const AsyncValue.loading();

    final taskChecker = ref.read(dailyTaskCheckerProvider);
    final result = await taskChecker.manualCheck();

    // Update the state with the latest report
    state = await AsyncValue.guard(() => _getLastReport());

    return result;
  }

  void listenForEvents() {
    final eventBus = ref.read(eventBusProvider);
    eventBus.on<DailyTaskCheckEvent>().listen((event) {
      // When a task check event happens, refresh the report
      refreshReport();
    });
  }

  Future<void> refreshReport() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _getLastReport());
  }

  Future<bool> toggleDailyCheck(bool enabled) async {
    final storageService = ref.read(storageServiceProvider);
    await storageService.setBool('daily_task_checker_active', enabled);

    final taskChecker = ref.read(dailyTaskCheckerProvider);
    if (enabled) {
      return taskChecker.initialize();
    } else {
      return taskChecker.cancelDailyCheck();
    }
  }
}
