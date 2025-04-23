// lib/presentation/providers/repetition_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spaced_learning_app/domain/models/repetition.dart';

import '../../core/di/providers.dart';

part 'repetition_provider.g.dart';

@riverpod
class Repetitions extends _$Repetitions {
  @override
  Future<List<Repetition>> build({String? progressId}) async {
    if (progressId == null) return [];
    return _fetchRepetitions(progressId);
  }

  Future<List<Repetition>> _fetchRepetitions(String progressId) async {
    final repository = ref.read(repetitionRepositoryProvider);
    return repository.getRepetitionsByProgressId(progressId);
  }

  Future<void> refreshRepetitions(String progressId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchRepetitions(progressId));
  }

  Future<List<Repetition>> createDefaultSchedule(
    String moduleProgressId,
  ) async {
    final repository = ref.read(repetitionRepositoryProvider);
    final repetitions = await repository.createDefaultSchedule(
      moduleProgressId,
    );
    state = AsyncValue.data(repetitions);
    return repetitions;
  }

  Future<Repetition> updateRepetition(
    String id, {
    RepetitionStatus? status,
    DateTime? reviewDate,
    bool rescheduleFollowing = false,
    double? percentComplete,
  }) async {
    final repository = ref.read(repetitionRepositoryProvider);
    final updatedRepetition = await repository.updateRepetition(
      id,
      status: status,
      reviewDate: reviewDate,
      rescheduleFollowing: rescheduleFollowing,
      percentComplete: percentComplete,
    );

    // Update state with the updated repetition
    final currentRepetitions = state.valueOrNull ?? [];
    final updatedRepetitions = currentRepetitions.map((repetition) {
      if (repetition.id == id) {
        return updatedRepetition;
      }
      return repetition;
    }).toList();

    state = AsyncValue.data(updatedRepetitions);
    return updatedRepetition;
  }

  Future<int> countByModuleProgressId(String moduleProgressId) async {
    final repository = ref.read(repetitionRepositoryProvider);
    return repository.countByModuleProgressId(moduleProgressId);
  }
}

@riverpod
Future<List<Repetition>> progressRepetitions(Ref ref, String progressId) async {
  final repository = ref.watch(repetitionRepositoryProvider);
  return repository.getRepetitionsByProgressId(progressId);
}
