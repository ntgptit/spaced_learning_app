// lib/presentation/screens/home/widgets/home_content.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/presentation/screens/home/widgets/home_header.dart';
import 'package:spaced_learning_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:spaced_learning_app/presentation/widgets/common/state/sl_unauthorized_state_widget.dart';
import 'package:spaced_learning_app/presentation/widgets/home/dashboard/dashboard_section.dart';
import 'package:spaced_learning_app/presentation/widgets/home/insights/learning_insights_section.dart';
import 'package:spaced_learning_app/presentation/widgets/home/quick_actions_section.dart';

import '../../../viewmodels/progress_viewmodel.dart';
import '../../../widgets/common/state/sl_error_state_widget.dart';
import '../../../widgets/common/state/sl_loading_state_widget.dart';
import '../../../widgets/home/due_tasks_section.dart';

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
      return SlUnauthorizedStateWidget.requiresLogin(
        onLogin: () => GoRouter.of(context).go('/login'),
        onGoBack: () => GoRouter.of(context).go('/login'),
      );
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppDimens.paddingL),
      child: FadeTransition(
        opacity: fadeAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: HomeHeader(user: user)),
            const SizedBox(height: AppDimens.spaceXL),

            const DashboardSection(),
            const SizedBox(height: AppDimens.spaceXL),

            const LearningInsightsSection(),
            const SizedBox(height: AppDimens.spaceXL),

            // 👇 Wrap with Consumer to isolate rebuild
            Consumer(
              builder: (context, ref, _) => const DueTasksSectionWidget(),
            ),
            const SizedBox(height: AppDimens.spaceXL),

            const HomeQuickActionsSection(),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
          ],
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
      data: (records) {
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);

        final due = records.where((e) {
          final d = e.nextStudyDate?.toLocal();
          if (d == null) return false;
          final n = DateTime(d.year, d.month, d.day);
          return !n.isAfter(today);
        }).toList();

        debugPrint('[DueTasksSectionWidget] Filtered ${due.length} due tasks');

        return DueTasksSection(
          tasks: due,
          onViewAllTasks: () => _navigateTo(context, '/due-progress'),
        );
      },
      loading: () =>
          SlLoadingStateWidget.small(type: SlLoadingType.threeBounce),
      error: (err, _) {
        debugPrint('[DueTasksSectionWidget] Error: $err');
        return SlErrorStateWidget.custom(
          title: 'Could not load daily tasks',
          message: 'Please try again later.',
          icon: Icons.warning_amber_rounded,
          compact: true,
        );
      },
    );
  }

  void _navigateTo(BuildContext context, String route) {
    GoRouter.of(context).go(route);
  }
}
