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
  Future<List<LearningInsightRespone>> build() async {
    return loadLearningInsights();
  }

  Future<List<LearningInsightRespone>> loadLearningInsights() async {
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

// Sửa lại provider này để không sử dụng state của Ref
@riverpod
Future<void> loadAllStats(
  Ref ref, {
  @Default(false) required bool refreshCache,
}) async {
  try {
    // Sử dụng repository trực tiếp thay vì gọi các provider khác
    final statsRepo = ref.read(learningStatsRepositoryProvider);

    // Tải dữ liệu đồng thời
    final results = await Future.wait([
      statsRepo.getDashboardStats(refreshCache: refreshCache),
      statsRepo.getLearningInsights(),
    ]);

    // Sau khi tải xong, làm mới các provider thay vì cố gắng kiểm tra trạng thái
    ref.invalidate(learningStatsStateProvider);
    ref.invalidate(learningInsightsProvider);
  } catch (e) {
    debugPrint('Error loading all stats: $e');
    rethrow;
  }
}
