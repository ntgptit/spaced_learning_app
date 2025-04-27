// lib/presentation/viewmodels/home_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spaced_learning_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/learning_stats_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/progress_viewmodel.dart';

part 'home_viewmodel.g.dart';

enum HomeLoadingStatus { initial, loading, loaded, error }

class HomeState {
  final HomeLoadingStatus status;
  final String? errorMessage;

  const HomeState({required this.status, this.errorMessage});

  const HomeState.initial() : this(status: HomeLoadingStatus.initial);

  HomeState copyWith({HomeLoadingStatus? status, String? errorMessage}) {
    return HomeState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

@riverpod
class HomeViewModel extends _$HomeViewModel {
  @override
  HomeState build() {
    return const HomeState.initial();
  }

  Future<void> loadInitialData() async {
    if (state.status == HomeLoadingStatus.loading) return;

    state = state.copyWith(status: HomeLoadingStatus.loading);

    try {
      final user = ref.read(currentUserProvider);

      // Load stats một cách an toàn
      await ref.read(loadAllStatsProvider(refreshCache: false).future);

      // Load due progress if user is logged in
      if (user != null) {
        await ref.read(progressStateProvider.notifier).loadDueProgress(user.id);
      }

      state = state.copyWith(status: HomeLoadingStatus.loaded);
    } catch (e) {
      debugPrint('Error loading initial data: $e');
      state = state.copyWith(
        status: HomeLoadingStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> refreshData() async {
    try {
      final user = ref.read(currentUserProvider);

      // Always refresh stats
      await ref.read(loadAllStatsProvider(refreshCache: true).future);

      // Refresh due progress if user is logged in
      if (user != null) {
        await ref.read(progressStateProvider.notifier).loadDueProgress(user.id);
      }

      state = state.copyWith(status: HomeLoadingStatus.loaded);
    } catch (e) {
      debugPrint('Error refreshing data: $e');
      // Keep previous state on error, just log it
    }
  }

  bool get isFirstLoading =>
      state.status == HomeLoadingStatus.initial ||
      (state.status == HomeLoadingStatus.loading && state.errorMessage == null);

  bool get hasError => state.status == HomeLoadingStatus.error;

  bool get isLoaded => state.status == HomeLoadingStatus.loaded;
}
