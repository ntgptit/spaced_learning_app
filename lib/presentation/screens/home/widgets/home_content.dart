// lib/presentation/screens/home/widgets/home_content.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/presentation/screens/home/widgets/home_header.dart';
import 'package:spaced_learning_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/progress_viewmodel.dart';
import 'package:spaced_learning_app/presentation/widgets/home/dashboard/dashboard_section.dart';
import 'package:spaced_learning_app/presentation/widgets/home/due_tasks_section.dart';
import 'package:spaced_learning_app/presentation/widgets/home/insights/learning_insights_section.dart';
import 'package:spaced_learning_app/presentation/widgets/home/quick_actions_section.dart';

class HomeContent extends ConsumerWidget {
  final Future<void> Function() onRefresh;
  final AnimationController animationController;
  final Animation<double> fadeAnimation;

  const HomeContent({
    super.key,
    required this.onRefresh,
    required this.animationController,
    required this.fadeAnimation,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    if (user == null) {
      return const Center(child: Text('Please log in to view your content'));
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      color: Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppDimens.paddingL),
        child: FadeTransition(
          opacity: fadeAnimation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: HomeHeader(user: user)),
              const SizedBox(height: AppDimens.spaceXL),

              // Dashboard section
              const DashboardSection(),
              const SizedBox(height: AppDimens.spaceXL),

              // Insights section
              const LearningInsightsSection(),
              const SizedBox(height: AppDimens.spaceXL),

              // Due tasks section
              const DueTasksSectionWidget(),
              const SizedBox(height: AppDimens.spaceXL),

              // Quick actions
              const HomeQuickActionsSection(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeQuickActionsSection extends ConsumerWidget {
  const HomeQuickActionsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return QuickActionsSection(
      onBrowseBooksPressed: () => _navigateTo(context, '/books'),
      onTodaysLearningPressed: () => _navigateTo(context, '/due-progress'),
      onProgressReportPressed: () => _navigateTo(context, '/learning'),
      onVocabularyStatsPressed: () => _showVocabularyStatsMessage(context),
    );
  }

  void _navigateTo(BuildContext context, String route) {
    GoRouter.of(context).go(route);
  }

  void _showVocabularyStatsMessage(BuildContext context) {
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Vocabulary stats coming soon',
          style: TextStyle(color: theme.colorScheme.onPrimary),
        ),
        backgroundColor: theme.colorScheme.primary,
      ),
    );
  }
}

class DueTasksSectionWidget extends ConsumerWidget {
  const DueTasksSectionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(progressStateProvider);

    return progressAsync.when(
      data: (progressRecords) {
        // Truyền trực tiếp progressRecords (ProgressDetail) vào DueTasksSection
        return DueTasksSection(
          tasks: progressRecords,
          onViewAllTasks: () => _navigateTo(context, '/due-progress'),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  void _navigateTo(BuildContext context, String route) {
    GoRouter.of(context).go(route);
  }
}
