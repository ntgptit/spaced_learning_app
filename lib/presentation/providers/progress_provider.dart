// lib/presentation/providers/progress_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spaced_learning_app/core/events/app_events.dart';
import 'package:spaced_learning_app/domain/models/progress.dart';

import '../../core/di/providers.dart';

part 'progress_provider.g.dart';

@riverpod
class Progress extends _$Progress {
  @override
  Future<List<ProgressSummary>> build({int page = 0, int size = 20}) async {
    return _fetchProgress(page, size);
  }

  Future<List<ProgressSummary>> _fetchProgress(int page, int size) async {
    final repository = ref.read(progressRepositoryProvider);
    return repository.getAllProgress(page: page, size: size);
  }

  Future<void> refreshProgress({int page = 0, int size = 20}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchProgress(page, size));
  }

  Future<List<ProgressSummary>> getProgressByModuleId(
    String moduleId, {
    int page = 0,
    int size = 20,
  }) async {
    final repository = ref.read(progressRepositoryProvider);
    return repository.getProgressByModuleId(moduleId, page: page, size: size);
  }

  Future<List<ProgressSummary>> getDueProgress(
    String userId, {
    DateTime? studyDate,
    int page = 0,
    int size = 20,
  }) async {
    final repository = ref.read(progressRepositoryProvider);
    return repository.getDueProgress(
      userId,
      studyDate: studyDate,
      page: page,
      size: size,
    );
  }

  Future<ProgressDetail> createProgress({
    required String moduleId,
    String? userId,
    DateTime? firstLearningDate,
    CycleStudied? cyclesStudied,
    DateTime? nextStudyDate,
    double? percentComplete,
  }) async {
    final repository = ref.read(progressRepositoryProvider);
    final newProgress = await repository.createProgress(
      moduleId: moduleId,
      userId: userId,
      firstLearningDate: firstLearningDate,
      cyclesStudied: cyclesStudied,
      nextStudyDate: nextStudyDate,
      percentComplete: percentComplete,
    );

    // Refresh progress list
    refreshProgress();

    // Notify other parts of the app
    _notifyProgressChanged(userId ?? '', true);

    return newProgress;
  }

  Future<ProgressDetail> updateProgress(
    String id, {
    DateTime? firstLearningDate,
    CycleStudied? cyclesStudied,
    DateTime? nextStudyDate,
    double? percentComplete,
  }) async {
    final repository = ref.read(progressRepositoryProvider);
    final updatedProgress = await repository.updateProgress(
      id,
      firstLearningDate: firstLearningDate,
      cyclesStudied: cyclesStudied,
      nextStudyDate: nextStudyDate,
      percentComplete: percentComplete,
    );

    // Refresh progress list
    refreshProgress();

    // Notify other parts of the app
    _notifyTaskCompleted(updatedProgress.id);

    return updatedProgress;
  }

  void _notifyProgressChanged(String userId, bool hasDueTasks) {
    final eventBus = ref.read(eventBusProvider);
    eventBus.fire(
      ProgressChangedEvent(userId: userId, hasDueTasks: hasDueTasks),
    );
  }

  void _notifyTaskCompleted(String progressId) {
    final eventBus = ref.read(eventBusProvider);
    eventBus.fire(
      TaskCompletedEvent(
        userId:
            'current-user', // You might want to get this from a user provider
        progressId: progressId,
      ),
    );
  }
}

@riverpod
Future<ProgressDetail?> currentUserModuleProgress(
  Ref ref,
  String moduleId,
) async {
  final repository = ref.watch(progressRepositoryProvider);
  return repository.getCurrentUserProgressByModule(moduleId);
}

@riverpod
Future<ProgressDetail> progressDetail(Ref ref, String id) async {
  final repository = ref.watch(progressRepositoryProvider);
  return repository.getProgressById(id);
}

@riverpod
Future<List<ProgressSummary>> dueProgress(
  Ref ref,
  String userId, {
  DateTime? studyDate,
  int page = 0,
  int size = 20,
}) async {
  final repository = ref.watch(progressRepositoryProvider);
  return repository.getDueProgress(
    userId,
    studyDate: studyDate,
    page: page,
    size: size,
  );
}
