import 'package:flutter/foundation.dart';
import 'package:spaced_learning_app/core/exceptions/app_exceptions.dart';
import 'package:spaced_learning_app/domain/models/learning_insight.dart';
import 'package:spaced_learning_app/domain/models/learning_stats.dart';
import 'package:spaced_learning_app/domain/repositories/learning_stats_repository.dart';

/// ViewModel for learning statistics operations
class LearningStatsViewModel extends ChangeNotifier {
  final LearningStatsRepository _repository;

  bool _isLoading = false;
  LearningStatsDTO? _stats;
  List<LearningInsightDTO> _insights = [];
  String? _errorMessage;
  bool _isInitialized = false;
  DateTime? _lastUpdated;
  bool _isRefreshing = false;

  // Getters
  bool get isLoading => _isLoading;
  LearningStatsDTO? get stats => _stats;
  List<LearningInsightDTO> get insights => _insights;
  String? get errorMessage => _errorMessage;
  bool get isInitialized => _isInitialized;
  DateTime? get lastUpdated => _lastUpdated;

  LearningStatsViewModel({required LearningStatsRepository repository})
    : _repository = repository;

  /// Load dashboard statistics
  Future<void> loadDashboardStats({bool refreshCache = false}) async {
    // Prevent multiple concurrent loads
    if (_isRefreshing) return;
    _isRefreshing = true;

    final bool wasLoading = _isLoading;
    _isLoading = true;
    if (!wasLoading) {
      notifyListeners();
    }

    _errorMessage = null;

    try {
      _stats = await _repository.getDashboardStats(refreshCache: refreshCache);
      _isInitialized = true;
      _lastUpdated = DateTime.now();
    } on AppException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred while loading statistics';
      debugPrint('Error loading dashboard stats: $e');
    } finally {
      _isLoading = false;
      _isRefreshing = false;
      notifyListeners();
    }
  }

  /// Load learning insights
  Future<void> loadLearningInsights() async {
    // Prevent multiple concurrent loads
    if (_isRefreshing) return;
    _isRefreshing = true;

    final bool wasLoading = _isLoading;
    _isLoading = true;
    if (!wasLoading) {
      notifyListeners();
    }

    _errorMessage = null;

    try {
      _insights = await _repository.getLearningInsights();
      _lastUpdated = DateTime.now();
    } on AppException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred while loading insights';
      debugPrint('Error loading learning insights: $e');
    } finally {
      _isLoading = false;
      _isRefreshing = false;
      notifyListeners();
    }
  }

  /// Load both dashboard statistics and learning insights
  Future<void> loadAllStats({bool refreshCache = false}) async {
    // Prevent multiple concurrent loads
    if (_isRefreshing) return;
    _isRefreshing = true;

    final bool wasLoading = _isLoading;
    _isLoading = true;
    if (!wasLoading) {
      notifyListeners();
    }

    _errorMessage = null;

    try {
      // Load both in parallel
      final results = await Future.wait([
        _repository.getDashboardStats(refreshCache: refreshCache),
        _repository.getLearningInsights(),
      ]);

      _stats = results[0] as LearningStatsDTO;
      _insights = results[1] as List<LearningInsightDTO>;
      _isInitialized = true;
      _lastUpdated = DateTime.now();
    } on AppException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred while loading data';
      debugPrint('Error loading all stats: $e');
    } finally {
      _isLoading = false;
      _isRefreshing = false;
      notifyListeners();
    }
  }

  /// Load dashboard statistics for a specific user (admin only)
  Future<void> loadUserDashboardStats(
    String userId, {
    bool refreshCache = false,
  }) async {
    // Prevent multiple concurrent loads
    if (_isRefreshing) return;
    _isRefreshing = true;

    final bool wasLoading = _isLoading;
    _isLoading = true;
    if (!wasLoading) {
      notifyListeners();
    }

    _errorMessage = null;

    try {
      _stats = await _repository.getUserDashboardStats(
        userId,
        refreshCache: refreshCache,
      );
      _isInitialized = true;
      _lastUpdated = DateTime.now();
    } on AppException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage =
          'An unexpected error occurred while loading user statistics';
      debugPrint('Error loading user dashboard stats: $e');
    } finally {
      _isLoading = false;
      _isRefreshing = false;
      notifyListeners();
    }
  }

  /// Load learning insights for a specific user (admin only)
  Future<void> loadUserLearningInsights(String userId) async {
    // Prevent multiple concurrent loads
    if (_isRefreshing) return;
    _isRefreshing = true;

    final bool wasLoading = _isLoading;
    _isLoading = true;
    if (!wasLoading) {
      notifyListeners();
    }

    _errorMessage = null;

    try {
      _insights = await _repository.getUserLearningInsights(userId);
      _lastUpdated = DateTime.now();
    } on AppException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage =
          'An unexpected error occurred while loading user insights';
      debugPrint('Error loading user learning insights: $e');
    } finally {
      _isLoading = false;
      _isRefreshing = false;
      notifyListeners();
    }
  }

  /// Clear error message
  void clearError() {
    if (_errorMessage == null) return; // Avoid unnecessary updates

    _errorMessage = null;
    notifyListeners();
  }
}
