// lib/presentation/providers/learning_stats_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spaced_learning_app/domain/models/learning_insight.dart';
import 'package:spaced_learning_app/domain/models/learning_stats.dart';

import '../../core/di/providers.dart';

part 'learning_stats_provider.g.dart';

@riverpod
class LearningStats extends _$LearningStats {
  @override
  Future<LearningStatsDTO> build() async {
    return _fetchDashboardStats();
  }

  Future<LearningStatsDTO> _fetchDashboardStats({
    bool refreshCache = false,
  }) async {
    final repository = ref.read(learningStatsRepositoryProvider);
    return repository.getDashboardStats(refreshCache: refreshCache);
  }

  Future<void> refreshStats() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _fetchDashboardStats(refreshCache: true),
    );
  }

  Future<List<LearningInsightDTO>> getLearningInsights() async {
    final repository = ref.read(learningStatsRepositoryProvider);
    return repository.getLearningInsights();
  }
}

@riverpod
Future<List<LearningInsightDTO>> learningInsights(
  LearningInsightsRef ref,
) async {
  final repository = ref.watch(learningStatsRepositoryProvider);
  return repository.getLearningInsights();
}
