// lib/presentation/screens/report/daily_task_report_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/presentation/utils/snackbar_utils.dart';
import 'package:spaced_learning_app/presentation/viewmodels/daily_task_report_viewmodel.dart';
import 'package:spaced_learning_app/presentation/widgets/common/error_display.dart';
import 'package:spaced_learning_app/presentation/widgets/common/loading_indicator.dart';
import 'package:spaced_learning_app/presentation/widgets/report/bottom_bar_widget.dart';
import 'package:spaced_learning_app/presentation/widgets/report/last_check_card_widget.dart';
import 'package:spaced_learning_app/presentation/widgets/report/log_card_widget.dart';
import 'package:spaced_learning_app/presentation/widgets/report/status_card_widget.dart';

class DailyTaskReportScreen extends StatefulWidget {
  const DailyTaskReportScreen({super.key});

  @override
  State<DailyTaskReportScreen> createState() => _DailyTaskReportScreenState();
}

class _DailyTaskReportScreenState extends State<DailyTaskReportScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  Future<void> _loadInitialData() async {
    final viewModel = context.read<DailyTaskReportViewModel>();
    await viewModel.loadReportData();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final viewModel = context.watch<DailyTaskReportViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Task Report'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: viewModel.loadReportData,
            tooltip: 'Refresh data',
          ),
        ],
      ),
      body: _buildBody(theme, colorScheme, viewModel),
      bottomNavigationBar: BottomBarWidget(
        onPerformManualCheck: _handleManualCheck,
        isManualCheckInProgress: viewModel.isManualCheckInProgress,
      ),
    );
  }

  Widget _buildBody(
    ThemeData theme,
    ColorScheme colorScheme,
    DailyTaskReportViewModel viewModel,
  ) {
    if (viewModel.isLoading) {
      return const Center(child: AppLoadingIndicator());
    }

    if (viewModel.errorMessage != null) {
      return Center(
        child: ErrorDisplay(
          message: viewModel.errorMessage!,
          onRetry: viewModel.loadReportData,
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimens.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StatusCardWidget(
            isActive: viewModel.isCheckerActive,
            onToggle: viewModel.toggleChecker,
          ),
          const SizedBox(height: AppDimens.spaceXL),
          LastCheckCardWidget(
            lastCheckTime: viewModel.lastCheckTime,
            lastCheckResult: viewModel.lastCheckResult,
            lastCheckTaskCount: viewModel.lastCheckTaskCount,
            lastCheckError: viewModel.lastCheckError,
          ),
          const SizedBox(height: AppDimens.spaceXL),
          LogCardWidget(
            logEntries: viewModel.logEntries,
            onClearLogs: viewModel.clearLogs,
          ),
        ],
      ),
    );
  }

  Future<void> _handleManualCheck() async {
    final viewModel = context.read<DailyTaskReportViewModel>();
    final result = await viewModel.performManualCheck();

    if (!mounted) return;

    if (result.isSuccess) {
      SnackBarUtils.show(
        context,
        result.hasDueTasks
            ? 'Found ${result.taskCount} tasks due today'
            : 'No tasks due today',
      );
    } else {
      SnackBarUtils.show(
        context,
        'Check failed: ${result.errorMessage ?? "Unknown error"}',
        backgroundColor: Theme.of(context).colorScheme.errorContainer,
      );
    }
  }
}
