import 'package:spaced_learning_app/domain/models/learning_insight.dart';
import 'package:spaced_learning_app/domain/models/learning_stats.dart';

/// Repository interface for learning statistics operations
abstract class LearningStatsRepository {
  /// Get dashboard statistics for current user
  Future<LearningStatsDTO> getDashboardStats({bool refreshCache = false});

  /// Get dashboard statistics for a specific user (admin only)
  // Future<LearningStatsDTO> getUserDashboardStats(
  //   String userId, {
  //   bool refreshCache = false,
  // });

  /// Get learning insights for current user
  Future<List<LearningInsightDTO>> getLearningInsights();

  /// Get learning insights for a specific user (admin only)
  // Future<List<LearningInsightDTO>> getUserLearningInsights(String userId);
}
