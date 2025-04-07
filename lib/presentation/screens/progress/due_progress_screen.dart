import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:spaced_learning_app/core/theme/app_colors.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/progress.dart';
import 'package:spaced_learning_app/presentation/screens/progress/progress_detail_screen.dart';
import 'package:spaced_learning_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/progress_viewmodel.dart';
import 'package:spaced_learning_app/presentation/widgets/common/error_display.dart';
import 'package:spaced_learning_app/presentation/widgets/common/loading_indicator.dart';
import 'package:spaced_learning_app/presentation/widgets/progress/progress_card.dart';

class DueProgressScreen extends StatefulWidget {
  const DueProgressScreen({super.key});

  @override
  State<DueProgressScreen> createState() => _DueProgressScreenState();
}

class _DueProgressScreenState extends State<DueProgressScreen> {
  DateTime? _selectedDate;
  final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Sử dụng listen: false vì đang ở trong hàm không thuộc build context trực tiếp
    final authViewModel = context.read<AuthViewModel>();
    final progressViewModel = context.read<ProgressViewModel>();
    if (authViewModel.currentUser != null) {
      // DEBUG: Log trước khi gọi loadDueProgress từ màn hình
      debugPrint(
        '[DueProgressScreen] Calling loadDueProgress from screen. UserId: ${authViewModel.currentUser!.id}, Date: $_selectedDate',
      );
      await progressViewModel.loadDueProgress(
        authViewModel.currentUser!.id,
        studyDate: _selectedDate,
      );
      // DEBUG: Log sau khi gọi loadDueProgress từ màn hình
      debugPrint(
        '[DueProgressScreen] Finished calling loadDueProgress from screen.',
      );
    } else {
      debugPrint('[DueProgressScreen] Cannot load data: currentUser is null.');
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
      await _loadData();
    }
  }

  void _clearDateFilter() {
    setState(() => _selectedDate = null);
    _loadData();
  }

  String _formatCycleStudied(CycleStudied cycle) {
    return switch (cycle) {
      CycleStudied.firstTime => 'Chu kỳ đầu tiên',
      CycleStudied.firstReview => 'Chu kỳ ôn tập thứ nhất',
      CycleStudied.secondReview => 'Chu kỳ ôn tập thứ hai',
      CycleStudied.thirdReview => 'Chu kỳ ôn tập thứ ba',
      CycleStudied.moreThanThreeReviews => 'Đã ôn tập nhiều hơn 3 chu kỳ',
    };
  }

  bool _isDue(ProgressSummary progress) {
    if (progress.nextStudyDate == null) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final nextDate = DateTime(
      progress.nextStudyDate!.year,
      progress.nextStudyDate!.month,
      progress.nextStudyDate!.day,
    );
    final targetDate =
        _selectedDate != null
            ? DateTime(
              _selectedDate!.year,
              _selectedDate!.month,
              _selectedDate!.day,
            )
            : today;
    return nextDate.compareTo(targetDate) <= 0;
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();
    if (authViewModel.currentUser == null) {
      return const Center(child: Text('Please log in to view your due items'));
    }
    return Scaffold(body: _buildBody());
  }

  Widget _buildBody() {
    return Column(
      children: [_buildDateFilter(), Expanded(child: _buildProgressList())],
    );
  }

  Widget _buildDateFilter() {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(AppDimens.paddingL),
      child: Row(
        children: [
          Expanded(
            child: Text(
              _selectedDate == null
                  ? 'Due Today'
                  : 'Due by ${_dateFormat.format(_selectedDate!)}',
              style: theme.textTheme.titleLarge,
            ),
          ),
          OutlinedButton.icon(
            icon: const Icon(Icons.calendar_today),
            label: Text(_selectedDate == null ? 'Select Date' : 'Change'),
            onPressed: _selectDate,
          ),
          if (_selectedDate != null) ...[
            const SizedBox(width: AppDimens.spaceM),
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: _clearDateFilter,
              tooltip: 'Clear date filter',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProgressList() {
    // Sử dụng watch ở đây vì UI cần rebuild khi state của ProgressViewModel thay đổi
    final progressViewModel = context.watch<ProgressViewModel>();

    // DEBUG: Log trạng thái ViewModel trong hàm build
    debugPrint('[DueProgressScreen] _buildProgressList rebuild triggered.');
    debugPrint('  isLoading: ${progressViewModel.isLoading}');
    debugPrint('  errorMessage: ${progressViewModel.errorMessage}');
    debugPrint(
      '  progressRecords.length: ${progressViewModel.progressRecords.length}',
    );

    if (progressViewModel.isLoading &&
        progressViewModel.progressRecords.isEmpty) {
      // Chỉ hiển thị loading indicator toàn màn hình khi đang tải lần đầu và chưa có dữ liệu
      debugPrint('[DueProgressScreen] Showing global loading indicator.');
      return const Center(child: AppLoadingIndicator());
    }

    if (progressViewModel.errorMessage != null) {
      debugPrint('[DueProgressScreen] Showing error display.');
      return Center(
        child: ErrorDisplay(
          message: progressViewModel.errorMessage!,
          onRetry: _loadData, // Gọi _loadData thay vì chỉ loadDueProgress
        ),
      );
    }

    if (progressViewModel.progressRecords.isEmpty &&
        !progressViewModel.isLoading) {
      debugPrint('[DueProgressScreen] Showing empty state.');
      // Hiển thị trạng thái rỗng chỉ khi không loading và không có lỗi
      return _buildEmptyState();
    }

    // Nếu không loading, không lỗi, và có dữ liệu (hoặc đang loading nhưng đã có dữ liệu cũ)
    debugPrint(
      '[DueProgressScreen] Building ListView with ${progressViewModel.progressRecords.length} items.',
    );
    return RefreshIndicator(
      onRefresh: _loadData, // Gọi hàm load chung
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.paddingM,
          vertical: AppDimens.paddingS,
        ),
        itemCount: progressViewModel.progressRecords.length,
        itemBuilder: (context, index) {
          final progress = progressViewModel.progressRecords[index];
          // DEBUG: Log thông tin của từng item
          // debugPrint('[DueProgressScreen] Building item $index: ID ${progress.id}, ModuleID ${progress.moduleId}, NextDate ${progress.nextStudyDate}');
          return _buildProgressItem(progress);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check_circle_outline,
            size: AppDimens.iconXXL,
            color: AppColors.successLight,
          ),
          const SizedBox(height: AppDimens.spaceL),
          Text(
            _selectedDate == null
                ? 'No modules due for review today!'
                : 'No modules due for review by ${_dateFormat.format(_selectedDate!)}',
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimens.spaceM),
          const Text(
            'Great job keeping up with your studies!',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressItem(ProgressSummary progress) {
    // Tạm thời gán cứng để test, lý tưởng là lấy từ module liên quan
    const moduleTitle = 'Unknown Module'; // Hoặc lấy title từ API nếu có
    final cycleText = _formatCycleStudied(progress.cyclesStudied);
    final bool isItemDue = _isDue(progress); // Tính toán isDue

    // DEBUG: Log thông tin của ProgressCard sẽ được tạo
    debugPrint(
      '[DueProgressScreen] Creating ProgressCard for ID ${progress.id}, Module: $moduleTitle, isDue: $isItemDue',
    );

    return ProgressCard(
      key: ValueKey(progress.id), // Thêm key để tối ưu rebuild
      progress: progress,
      moduleTitle: moduleTitle,
      isDue: isItemDue,
      subtitle: 'Cycle: $cycleText', // Đổi thành 'Cycle' cho nhất quán
      onTap:
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => ProgressDetailScreen(progressId: progress.id),
            ),
            // Reload data khi quay lại từ màn hình chi tiết
          ).then((_) => _loadData()),
    );
  }
}
