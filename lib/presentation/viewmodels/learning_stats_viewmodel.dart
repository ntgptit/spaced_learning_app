// lib/presentation/viewmodels/learning_stats_viewmodel.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spaced_learning_app/domain/models/learning_insight.dart';
import 'package:spaced_learning_app/domain/models/learning_stats.dart';

import '../../core/di/providers.dart';

part 'learning_stats_viewmodel.g.dart';

@riverpod
class LearningStatsState extends _$LearningStatsState {
  @override
  Future<LearningStatsDTO?> build() async {
    return loadDashboardStats();
  }

  Future<LearningStatsDTO?> loadDashboardStats({
    bool refreshCache = false,
  }) async {
    state = const AsyncValue.loading();
    try {
      final stats = await ref
          .read(learningStatsRepositoryProvider)
          .getDashboardStats(refreshCache: refreshCache);
      state = AsyncValue.data(stats);
      return stats;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return null;
    }
  }
}

@riverpod
class LearningInsights extends _$LearningInsights {
  @override
  Future<List<LearningInsightDTO>> build() async {
    return loadLearningInsights();
  }

  Future<List<LearningInsightDTO>> loadLearningInsights() async {
    state = const AsyncValue.loading();
    try {
      final insights = await ref
          .read(learningStatsRepositoryProvider)
          .getLearningInsights();
      state = AsyncValue.data(insights);
      return insights;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return [];
    }
  }
}

@riverpod
Future<void> loadAllStats(
  Ref ref, {
  @Default(false) required bool refreshCache,
}) async {
  try {
    // Sử dụng repository trực tiếp
    final statsRepo = ref.read(learningStatsRepositoryProvider);

    // Tải dữ liệu
    final stats = await statsRepo.getDashboardStats(refreshCache: refreshCache);
    final insights = await statsRepo.getLearningInsights();

    // Sử dụng notifier methods thay vì truy cập state trực tiếp
    ref
        .read(learningStatsStateProvider.notifier)
        .loadDashboardStats(refreshCache: refreshCache);
    ref.read(learningInsightsProvider.notifier).loadLearningInsights();
  } catch (e) {
    debugPrint('Error loading all stats: $e');
  }
}
