// lib/presentation/viewmodels/progress_viewmodel.dart
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spaced_learning_app/core/events/app_events.dart';
import 'package:spaced_learning_app/domain/models/progress.dart';

import '../../core/di/providers.dart';

part 'progress_viewmodel.g.dart';

@riverpod
class ProgressState extends _$ProgressState {
  @override
  Future<List<ProgressSummary>> build() async {
    return [];
  }

  String? _sanitizeId(String id) {
    if (id.isEmpty) {
      debugPrint('WARNING: Empty ID detected in ProgressViewModel');
      return null;
    }

    final sanitizedId = id.trim();
    if (sanitizedId != id) {
      debugPrint('ID sanitized from "$id" to "$sanitizedId"');
    }
    return sanitizedId;
  }

  Future<void> loadDueProgress(
    String userId, {
    DateTime? studyDate,
    int page = 0,
    int size = 20,
  }) async {
    final sanitizedId = _sanitizeId(userId);
    if (sanitizedId == null) {
      throw Exception('Invalid user ID: Empty ID provided');
    }

    state = const AsyncValue.loading();

    try {
      debugPrint(
        '[ProgressViewModel] Starting loadDueProgress for userId: $sanitizedId, date: $studyDate',
      );

      final List<ProgressSummary> result = await ref
          .read(progressRepositoryProvider)
          .getDueProgress(
            sanitizedId,
            studyDate: studyDate,
            page: page,
            size: size,
          );

      debugPrint(
        '[ProgressViewModel] Received ${result.length} records from repository for due progress.',
      );

      if (result.isNotEmpty) {
        final idList = result.take(3).map((p) => p.id).join(', ');
        debugPrint(
          'First few progress IDs: $idList${result.length > 3 ? '...' : ''}',
        );
      }

      ref
          .read(eventBusProvider)
          .fire(
            ProgressChangedEvent(
              userId: sanitizedId,
              hasDueTasks: result.isNotEmpty,
            ),
          );

      state = AsyncValue.data(result);
    } catch (e) {
      debugPrint('Error loading due progress: $e');
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<ProgressDetail?> createProgress({
    required String moduleId,
    String? userId,
    DateTime? firstLearningDate,
    CycleStudied? cyclesStudied,
    DateTime? nextStudyDate,
    double? percentComplete,
  }) async {
    final sanitizedModuleId = _sanitizeId(moduleId);
    if (sanitizedModuleId == null) {
      throw Exception('Invalid module ID: Empty ID provided');
    }

    try {
      debugPrint('Creating progress for moduleId: $sanitizedModuleId');
      final progress = await ref
          .read(progressRepositoryProvider)
          .createProgress(
            moduleId: sanitizedModuleId,
            userId: userId,
            firstLearningDate: firstLearningDate,
            cyclesStudied: cyclesStudied,
            nextStudyDate: nextStudyDate,
            percentComplete: percentComplete,
          );

      if (userId != null) {
        ref
            .read(eventBusProvider)
            .fire(ProgressChangedEvent(userId: userId, hasDueTasks: true));
      }

      debugPrint('Progress created successfully: ${progress.id}');
      return progress;
    } catch (e) {
      debugPrint('Failed to create progress: $e');
      return null;
    }
  }

  Future<ProgressDetail?> updateProgress(
    String id, {
    DateTime? firstLearningDate,
    CycleStudied? cyclesStudied,
    DateTime? nextStudyDate,
    double? percentComplete,
  }) async {
    final sanitizedId = _sanitizeId(id);
    if (sanitizedId == null) {
      throw Exception('Invalid progress ID: Empty ID provided');
    }

    try {
      debugPrint('Updating progress with id: $sanitizedId');
      final progress = await ref
          .read(progressRepositoryProvider)
          .updateProgress(
            sanitizedId,
            firstLearningDate: firstLearningDate,
            cyclesStudied: cyclesStudied,
            nextStudyDate: nextStudyDate,
            percentComplete: percentComplete,
          );

      final userData = await ref.read(storageServiceProvider).getUserData();
      final userId = userData?['id'];
      if (userId != null) {
        ref
            .read(eventBusProvider)
            .fire(
              TaskCompletedEvent(
                userId: userId.toString(),
                progressId: sanitizedId,
              ),
            );
      }

      debugPrint('Progress updated successfully');
      return progress;
    } catch (e) {
      debugPrint('Error updating progress: $e');
      return null;
    }
  }
}

@riverpod
class SelectedProgress extends _$SelectedProgress {
  @override
  Future<ProgressDetail?> build() async {
    return null;
  }

  Future<void> loadProgressDetails(String id) async {
    if (id.trim().isEmpty) {
      state = const AsyncValue.data(null);
      return;
    }

    state = const AsyncValue.loading();

    try {
      final progress = await ref
          .read(progressRepositoryProvider)
          .getProgressById(id.trim());
      state = AsyncValue.data(progress);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> loadModuleProgress(String moduleId) async {
    if (moduleId.trim().isEmpty) {
      state = const AsyncValue.data(null);
      return;
    }

    state = const AsyncValue.loading();

    try {
      final progressList = await ref
          .read(progressRepositoryProvider)
          .getProgressByModuleId(moduleId.trim(), page: 0, size: 1);

      if (progressList.isEmpty) {
        state = const AsyncValue.data(null);
        return;
      }

      final progressId = progressList[0].id;
      debugPrint('Found progress with ID: $progressId for module: $moduleId');

      final progressDetail = await ref
          .read(progressRepositoryProvider)
          .getProgressById(progressId);
      state = AsyncValue.data(progressDetail);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  void clearSelectedProgress() {
    state = const AsyncValue.data(null);
  }
}

@riverpod
bool isUpdatingProgress(IsUpdatingProgressRef ref) {
  final progressState = ref.watch(progressStateProvider);
  return progressState.isLoading;
}
