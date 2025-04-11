import 'package:spaced_learning_app/domain/models/learning_insight.dart';
import 'package:spaced_learning_app/domain/models/learning_stats.dart';
import 'package:spaced_learning_app/domain/repositories/learning_stats_repository.dart';
import 'package:spaced_learning_app/presentation/viewmodels/base_viewmodel.dart';

class LearningStatsViewModel extends BaseViewModel {
  final LearningStatsRepository _repository;

  LearningStatsDTO? _stats;
  List<LearningInsightDTO> _insights = [];

  LearningStatsDTO? get stats => _stats;
  List<LearningInsightDTO> get insights => _insights;

  LearningStatsViewModel({required LearningStatsRepository repository})
    : _repository = repository;

  Future<void> loadDashboardStats({bool refreshCache = false}) async {
    if (!beginRefresh()) return;

    await safeCall(
      action: () async {
        _stats = await _repository.getDashboardStats(
          refreshCache: refreshCache,
        );
        setInitialized(true);
        return _stats;
      },
      errorPrefix: 'Failed to load dashboard statistics',
      handleLoading: false, // Already handled by beginRefresh
      updateTimestamp: true,
    );
    endRefresh();
  }

  Future<void> loadLearningInsights() async {
    if (!beginRefresh()) return;

    await safeCall(
      action: () async {
        _insights = await _repository.getLearningInsights();
        return _insights;
      },
      errorPrefix: 'Failed to load learning insights',
      handleLoading: false, // Already handled by beginRefresh
      updateTimestamp: true,
    );
    endRefresh();
  }

  Future<void> loadAllStats({bool refreshCache = false}) async {
    if (!beginRefresh()) return;

    await safeCall(
      action: () async {
        final results = await Future.wait([
          _repository.getDashboardStats(refreshCache: refreshCache),
          _repository.getLearningInsights(),
        ]);

        _stats = results[0] as LearningStatsDTO;
        _insights = results[1] as List<LearningInsightDTO>;
        setInitialized(true);
        return true;
      },
      errorPrefix: 'Failed to load learning statistics',
      handleLoading: false, // Already handled by beginRefresh
      updateTimestamp: true,
    );
    endRefresh();
  }




}
