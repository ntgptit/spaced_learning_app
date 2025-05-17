// lib/presentation/screens/report/daily_task_report_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/presentation/utils/snackbar_utils.dart';
import 'package:spaced_learning_app/presentation/viewmodels/daily_task_report_viewmodel.dart';
import 'package:spaced_learning_app/presentation/widgets/common/loading_indicator.dart';
import 'package:spaced_learning_app/presentation/widgets/common/state/sl_error_state_widget.dart'; // Updated import
import 'package:spaced_learning_app/presentation/widgets/report/bottom_bar_widget.dart';
import 'package:spaced_learning_app/presentation/widgets/report/last_check_card_widget.dart';
import 'package:spaced_learning_app/presentation/widgets/report/log_card_widget.dart';
import 'package:spaced_learning_app/presentation/widgets/report/status_card_widget.dart';

class DailyTaskReportScreen extends ConsumerStatefulWidget {
  const DailyTaskReportScreen({super.key});

  @override
  ConsumerState<DailyTaskReportScreen> createState() =>
      _DailyTaskReportScreenState();
}

class _DailyTaskReportScreenState extends ConsumerState<DailyTaskReportScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  Future<void> _loadInitialData() async {
    await ref.read(dailyTaskReportStateProvider.notifier).loadReportData();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final viewModelState = ref.watch(dailyTaskReportStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Task Report'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            final router = GoRouter.of(context);
            if (router.canPop()) {
              router.pop();
              return;
            }
            router.go('/');
          },
          tooltip: 'Back',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref
                .read(dailyTaskReportStateProvider.notifier)
                .loadReportData(),
            tooltip: 'Refresh data',
          ),
        ],
      ),
      body: _buildBody(theme, colorScheme, viewModelState),
      bottomNavigationBar: BottomBarWidget(
        onPerformManualCheck: _handleManualCheck,
        isManualCheckInProgress: ref.watch(isManualCheckInProgressProvider),
      ),
    );
  }

  Widget _buildBody(
    ThemeData theme,
    ColorScheme colorScheme,
    AsyncValue<Map<String, dynamic>> viewModelState,
  ) {
    return viewModelState.when(
      data: (data) {
        final bool isLoading = data['isManualCheckInProgress'] == true;

        if (isLoading && !data.containsKey('isCheckerActive')) {
          return const Center(child: SLLoadingIndicator());
        }

        final errorMessage = data['errorMessage'];
        if (errorMessage != null && !data.containsKey('isCheckerActive')) {
          return Center(
            child: SlErrorStateWidget(
              // Updated widget
              title: 'Error Loading Report',
              message: errorMessage,
              onRetry: () => ref
                  .read(dailyTaskReportStateProvider.notifier)
                  .loadReportData(),
              icon: Icons.report_problem_outlined,
            ),
          );
        }

        return Stack(
          children: [
            RefreshIndicator(
              onRefresh: () => ref
                  .read(dailyTaskReportStateProvider.notifier)
                  .loadReportData(),
              child: ListView(
                padding: const EdgeInsets.all(AppDimens.paddingL),
                children: [
                  StatusCardWidget(
                    isActive: data['isCheckerActive'] ?? false,
                    onToggle: (value) => ref
                        .read(dailyTaskReportStateProvider.notifier)
                        .toggleChecker(value),
                  ),
                  const SizedBox(height: AppDimens.spaceXL),
                  LastCheckCardWidget(
                    lastCheckTime: data['lastCheckTime'],
                    lastCheckResult: data['lastCheckResult'] ?? false,
                    lastCheckTaskCount: data['lastCheckTaskCount'] ?? 0,
                    lastCheckError: data['lastCheckError'],
                  ),
                  const SizedBox(height: AppDimens.spaceXL),
                  LogCardWidget(
                    logEntries: data['logEntries'] ?? [],
                    onClearLogs: () {
                      ref
                          .read(dailyTaskReportStateProvider.notifier)
                          .clearLogs()
                          .then((_) {
                            SnackBarUtils.show(
                              context,
                              'Logs cleared successfully',
                              backgroundColor: colorScheme.primary,
                            );
                            return ref
                                .read(dailyTaskReportStateProvider.notifier)
                                .loadReportData();
                          });
                    },
                  ),
                ],
              ),
            ),
            if (isLoading && data.containsKey('isCheckerActive'))
              Positioned.fill(
                child: Container(
                  color: Colors.black.withAlpha(77), // 30% opacity
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ),
          ],
        );
      },
      loading: () => const Center(child: SLLoadingIndicator()),
      error: (error, stackTrace) => Center(
        child: SlErrorStateWidget(
          // Updated widget
          title: 'Failed to Load Report',
          message: error.toString(),
          onRetry: () =>
              ref.read(dailyTaskReportStateProvider.notifier).loadReportData(),
          icon: Icons.error_outline,
        ),
      ),
    );
  }

  Future<void> _handleManualCheck() async {
    final result = await ref
        .read(dailyTaskReportStateProvider.notifier)
        .performManualCheck();

    if (!mounted) return;

    if (result.isSuccess) {
      SnackBarUtils.show(
        context,
        result.hasDueTasks
            ? 'Found ${result.taskCount} tasks due today'
            : 'No tasks due today',
      );
    } else {
      final currentTheme = Theme.of(context);
      SnackBarUtils.show(
        context,
        'Check failed: ${result.errorMessage ?? "Unknown error"}',
        backgroundColor: currentTheme.colorScheme.errorContainer,
      );
    }
  }
}
