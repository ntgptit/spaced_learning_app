import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/presentation/utils/snackbar_utils.dart';
import 'package:spaced_learning_app/presentation/viewmodels/daily_task_report_viewmodel.dart';
import 'package:spaced_learning_app/presentation/widgets/common/app_button.dart';
import 'package:spaced_learning_app/presentation/widgets/common/error_display.dart';
import 'package:spaced_learning_app/presentation/widgets/common/loading_indicator.dart';

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
      context.read<DailyTaskReportViewModel>().loadReportData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final viewModel = context.watch<DailyTaskReportViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Báo cáo kiểm tra nhiệm vụ'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: viewModel.loadReportData,
            tooltip: 'Làm mới dữ liệu',
          ),
        ],
      ),
      body: viewModel.isLoading
          ? const Center(child: AppLoadingIndicator())
          : viewModel.errorMessage != null
          ? Center(
              child: ErrorDisplay(
                message: viewModel.errorMessage!,
                onRetry: viewModel.loadReportData,
              ),
            )
          : _buildContent(theme, colorScheme, viewModel),
      bottomNavigationBar: _buildBottomBar(theme, colorScheme, viewModel),
    );
  }

  Widget _buildContent(
    ThemeData theme,
    ColorScheme colorScheme,
    DailyTaskReportViewModel viewModel,
  ) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm:ss');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimens.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatusCard(theme, colorScheme, viewModel),
          const SizedBox(height: AppDimens.spaceXL),
          _buildLastCheckCard(theme, colorScheme, viewModel, dateFormat),
          const SizedBox(height: AppDimens.spaceXL),
          _buildLogCard(theme, colorScheme, viewModel),
        ],
      ),
    );
  }

  Widget _buildStatusCard(
    ThemeData theme,
    ColorScheme colorScheme,
    DailyTaskReportViewModel viewModel,
  ) {
    final isActive = viewModel.isCheckerActive;

    return Card(
      elevation: AppDimens.elevationM,
      color: colorScheme.surfaceContainerLowest,
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isActive ? Icons.check_circle : Icons.error_outline,
                  color: isActive ? colorScheme.primary : colorScheme.error,
                  size: AppDimens.iconL,
                ),
                const SizedBox(width: AppDimens.spaceM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Trạng thái kiểm tra tự động',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppDimens.spaceXS),
                      Text(
                        isActive ? 'Đang hoạt động' : 'Không hoạt động',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isActive
                              ? colorScheme.primary
                              : colorScheme.error,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: isActive,
                  onChanged: viewModel.toggleChecker,
                  activeColor: colorScheme.primary,
                ),
              ],
            ),
            const SizedBox(height: AppDimens.spaceM),
            const Divider(height: 1),
            const SizedBox(height: AppDimens.spaceM),
            Text(
              'Thời gian kiểm tra: 00:05 sáng hàng ngày',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: AppDimens.spaceS),
            Text(
              'Hệ thống sẽ tự động kiểm tra nhiệm vụ đến hạn và lên lịch các thông báo nhắc nhở.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLastCheckCard(
    ThemeData theme,
    ColorScheme colorScheme,
    DailyTaskReportViewModel viewModel,
    DateFormat dateFormat,
  ) {
    final lastCheckTime = viewModel.lastCheckTime;
    final lastCheckResult = viewModel.lastCheckResult;
    final lastCheckTaskCount = viewModel.lastCheckTaskCount;

    return Card(
      elevation: AppDimens.elevationM,
      color: colorScheme.surfaceContainerLowest,
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kết quả kiểm tra gần nhất',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppDimens.spaceM),
            const Divider(height: 1),
            const SizedBox(height: AppDimens.spaceM),
            _buildInfoRow(
              theme,
              colorScheme,
              'Thời gian:',
              lastCheckTime != null
                  ? dateFormat.format(lastCheckTime)
                  : 'Chưa có dữ liệu',
              Icons.access_time,
            ),
            const SizedBox(height: AppDimens.spaceM),
            _buildInfoRow(
              theme,
              colorScheme,
              'Trạng thái:',
              lastCheckResult ? 'Thành công' : 'Thất bại',
              lastCheckResult ? Icons.check_circle : Icons.error,
              valueColor: lastCheckResult
                  ? colorScheme.primary
                  : colorScheme.error,
            ),
            const SizedBox(height: AppDimens.spaceM),
            _buildInfoRow(
              theme,
              colorScheme,
              'Nhiệm vụ:',
              lastCheckTaskCount > 0
                  ? '$lastCheckTaskCount nhiệm vụ đến hạn'
                  : 'Không có nhiệm vụ đến hạn',
              Icons.assignment,
            ),
            if (viewModel.lastCheckError != null) ...[
              const SizedBox(height: AppDimens.spaceM),
              _buildInfoRow(
                theme,
                colorScheme,
                'Lỗi:',
                viewModel.lastCheckError!,
                Icons.warning_amber,
                valueColor: colorScheme.error,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    ThemeData theme,
    ColorScheme colorScheme,
    String label,
    String value,
    IconData icon, {
    Color? valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: AppDimens.iconM, color: colorScheme.primary),
        const SizedBox(width: AppDimens.spaceM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppDimens.spaceXS),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: valueColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLogCard(
    ThemeData theme,
    ColorScheme colorScheme,
    DailyTaskReportViewModel viewModel,
  ) {
    final logs = viewModel.logEntries;

    return Card(
      elevation: AppDimens.elevationM,
      color: colorScheme.surfaceContainerLowest,
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Nhật ký kiểm tra',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: viewModel.clearLogs,
                  icon: const Icon(Icons.delete_outline, size: 18),
                  label: const Text('Xóa nhật ký'),
                  style: TextButton.styleFrom(
                    foregroundColor: colorScheme.error,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimens.spaceM),
            const Divider(height: 1),
            const SizedBox(height: AppDimens.spaceM),
            logs.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppDimens.paddingXL),
                      child: Column(
                        children: [
                          Icon(
                            Icons.history,
                            size: AppDimens.iconXXL,
                            color: colorScheme.onSurfaceVariant.withValues(
                              alpha: 0.3,
                            ),
                          ),
                          const SizedBox(height: AppDimens.spaceM),
                          Text(
                            'Chưa có nhật ký',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: logs.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: AppDimens.spaceL),
                    itemBuilder: (context, index) {
                      final log = logs[index];
                      final dateFormat = DateFormat('dd/MM/yyyy HH:mm:ss');
                      return _buildLogEntry(
                        theme,
                        colorScheme,
                        log,
                        dateFormat,
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogEntry(
    ThemeData theme,
    ColorScheme colorScheme,
    LogEntry log,
    DateFormat dateFormat,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              log.isSuccess ? Icons.check_circle : Icons.error,
              size: AppDimens.iconS,
              color: log.isSuccess ? colorScheme.primary : colorScheme.error,
            ),
            const SizedBox(width: AppDimens.spaceXS),
            Text(
              dateFormat.format(log.timestamp),
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.spaceXS),
        Text(log.message, style: theme.textTheme.bodyMedium),
        if (log.detail != null) ...[
          const SizedBox(height: AppDimens.spaceXS),
          Text(
            log.detail!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: log.isSuccess
                  ? colorScheme.onSurfaceVariant
                  : colorScheme.error,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildBottomBar(
    ThemeData theme,
    ColorScheme colorScheme,
    DailyTaskReportViewModel viewModel,
  ) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingL),
        child: Row(
          children: [
            Expanded(
              child: AppButton(
                text: 'Kiểm tra ngay',
                prefixIcon: Icons.refresh,
                type: AppButtonType.primary,
                isLoading: viewModel.isManualCheckInProgress,
                onPressed: () async {
                  final result = await viewModel.performManualCheck();
                  if (mounted) {
                    if (result.isSuccess) {
                      SnackBarUtils.show(
                        context,
                        result.hasDueTasks
                            ? 'Đã tìm thấy ${result.taskCount} nhiệm vụ đến hạn'
                            : 'Không có nhiệm vụ đến hạn hôm nay',
                      );
                    } else {
                      SnackBarUtils.show(
                        context,
                        'Kiểm tra thất bại: ${result.errorMessage ?? "Lỗi không xác định"}',
                        backgroundColor: colorScheme.errorContainer,
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
