import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/domain/models/progress.dart';
import 'package:spaced_learning_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/module_viewmodel.dart';
import 'package:spaced_learning_app/presentation/viewmodels/progress_viewmodel.dart';
import 'package:spaced_learning_app/presentation/widgets/common/error_display.dart';
import 'package:spaced_learning_app/presentation/widgets/common/loading_indicator.dart';

class DueProgressScreen extends StatefulWidget {
  const DueProgressScreen({super.key});

  @override
  State<DueProgressScreen> createState() => _DueProgressScreenState();
}

class _DueProgressScreenState extends State<DueProgressScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  DateTime? _selectedDate;
  final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');
  final Map<String, String> _moduleTitles = {};
  bool _isLoadingModules = false;
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();

    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  void _onScroll() {
    final isScrolled = _scrollController.offset > 10;
    if (isScrolled == _isScrolled) return;
    setState(() => _isScrolled = isScrolled);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    if (!mounted) return;

    final authViewModel = context.read<AuthViewModel>();
    final progressViewModel = context.read<ProgressViewModel>();

    if (authViewModel.currentUser == null) {
      return;
    }

    await progressViewModel.loadDueProgress(
      authViewModel.currentUser!.id,
      studyDate: _selectedDate,
    );

    if (!mounted || progressViewModel.progressRecords.isEmpty) return;

    await _loadModuleTitles(progressViewModel.progressRecords);
  }

  Future<void> _loadModuleTitles(List<ProgressSummary> progressList) async {
    setState(() => _isLoadingModules = true);

    final moduleViewModel = context.read<ModuleViewModel>();
    final moduleIds = progressList
        .map((progress) => progress.moduleId)
        .where((id) => !_moduleTitles.containsKey(id))
        .toSet()
        .toList();

    for (final moduleId in moduleIds) {
      try {
        await moduleViewModel.loadModuleDetails(moduleId);
        if (moduleViewModel.selectedModule == null) {
          _moduleTitles[moduleId] = 'Module $moduleId';
          continue;
        }
        _moduleTitles[moduleId] = moduleViewModel.selectedModule!.title;
      } catch (e) {
        _moduleTitles[moduleId] = 'Module $moduleId';
      }
    }

    setState(() => _isLoadingModules = false);
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme,
          dialogTheme: DialogThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimens.radiusL),
            ),
          ),
        ),
        child: child!,
      ),
    );

    if (picked == null || picked == _selectedDate) return;

    setState(() => _selectedDate = picked);
    _animationController.reset();
    _animationController.forward();
    await _loadData();
  }

  void _clearDateFilter() {
    setState(() => _selectedDate = null);
    _animationController.reset();
    _animationController.forward();
    _loadData();
  }

  String _formatCycleStudied(CycleStudied cycle) => switch (cycle) {
    CycleStudied.firstTime => 'First Cycle',
    CycleStudied.firstReview => 'First Review',
    CycleStudied.secondReview => 'Second Review',
    CycleStudied.thirdReview => 'Third Review',
    CycleStudied.moreThanThreeReviews => 'Advanced Review',
  };

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
        _selectedDate?.copyWith(
          hour: 0,
          minute: 0,
          second: 0,
          millisecond: 0,
          microsecond: 0,
        ) ??
        today;

    return nextDate.compareTo(targetDate) <= 0;
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();
    final theme = Theme.of(context);

    if (authViewModel.currentUser == null) return _buildLoginPrompt(theme);

    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            title: Text(
              _selectedDate == null
                  ? 'Due Today'
                  : 'Due by ${_dateFormat.format(_selectedDate!)}',
            ),
            pinned: true,
            floating: true,
            elevation: _isScrolled ? 2.0 : 0.0,
            forceElevated: _isScrolled || innerBoxIsScrolled,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _loadData,
                tooltip: 'Refresh data',
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(80),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                color: theme.scaffoldBackgroundColor,
                child: Card(
                  elevation: 0,
                  color: theme.colorScheme.surfaceContainerLow,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: theme.colorScheme.outlineVariant.withValues(
                        alpha: 0.5,
                      ),
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 20,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _selectedDate == null
                                ? 'Due Today'
                                : 'Due by ${_dateFormat.format(_selectedDate!)}',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                        if (_selectedDate != null)
                          IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: _clearDateFilter,
                            tooltip: 'Clear date filter',
                            iconSize: 20,
                            visualDensity: VisualDensity.compact,
                          ),
                        IconButton(
                          icon: const Icon(Icons.calendar_month),
                          onPressed: _selectDate,
                          tooltip: 'Select date',
                          iconSize: 20,
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
        body: _buildBody(),
      ),
    );
  }

  Widget _buildLoginPrompt(ThemeData theme) => Scaffold(
    appBar: AppBar(title: const Text('Due Progress')),
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.lock_outline,
                size: 64,
                color: theme.colorScheme.primary.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Please sign in',
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'You need to be signed in to view your due progress',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              icon: const Icon(Icons.login),
              label: const Text('Sign in'),
              onPressed: () {},
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _buildBody() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        _buildSummarySection(),
        Expanded(child: _buildProgressList()),
      ],
    ),
  );

  Widget _buildSummarySection() {
    final progressViewModel = context.watch<ProgressViewModel>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (progressViewModel.isLoading &&
        progressViewModel.progressRecords.isEmpty) {
      return const SizedBox.shrink();
    }

    if (progressViewModel.errorMessage != null) return const SizedBox.shrink();

    final totalCount = progressViewModel.progressRecords.length;
    final dueCount = progressViewModel.progressRecords.where(_isDue).length;
    final completedPercent = totalCount == 0
        ? 0
        : ((totalCount - dueCount) / totalCount * 100).toInt();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Card(
        elevation: 0,
        color: colorScheme.surfaceContainerLowest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              _buildStatItem(
                theme,
                'Total',
                totalCount.toString(),
                Icons.book,
                colorScheme.primary,
              ),
              const SizedBox(width: 8),
              _buildStatItem(
                theme,
                'Due',
                dueCount.toString(),
                Icons.event_available,
                dueCount > 0 ? colorScheme.error : colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              _buildStatItem(
                theme,
                'Completed',
                '$completedPercent%',
                Icons.task_alt,
                colorScheme.tertiary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(
    ThemeData theme,
    String label,
    String value,
    IconData icon,
    Color color,
  ) => Expanded(
    child: Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    ),
  );

  Widget _buildProgressList() {
    final progressViewModel = context.watch<ProgressViewModel>();
    final theme = Theme.of(context);

    if (progressViewModel.isLoading &&
        progressViewModel.progressRecords.isEmpty) {
      return const Center(child: AppLoadingIndicator());
    }

    if (progressViewModel.errorMessage != null) {
      return Center(
        child: ErrorDisplay(
          message: progressViewModel.errorMessage!,
          onRetry: _loadData,
        ),
      );
    }

    if (_isLoadingModules) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppLoadingIndicator(),
            SizedBox(height: 16),
            Text('Loading module information...'),
          ],
        ),
      );
    }

    if (progressViewModel.progressRecords.isEmpty) {
      return _buildEmptyState();
    }

    final today = DateTime.now();
    final todayProgressRecords = <ProgressSummary>[];
    final overdueProgressRecords = <ProgressSummary>[];
    final upcomingProgressRecords = <ProgressSummary>[];

    for (final progress in progressViewModel.progressRecords) {
      if (progress.nextStudyDate == null) continue;

      final progressDate = DateTime(
        progress.nextStudyDate!.year,
        progress.nextStudyDate!.month,
        progress.nextStudyDate!.day,
      );
      final nowDate = DateTime(today.year, today.month, today.day);

      if (progressDate.isAtSameMomentAs(nowDate)) {
        todayProgressRecords.add(progress);
        continue;
      }
      if (progressDate.isBefore(nowDate)) {
        overdueProgressRecords.add(progress);
        continue;
      }
      upcomingProgressRecords.add(progress);
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: RefreshIndicator(
        onRefresh: _loadData,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 80),
          children: [
            if (overdueProgressRecords.isNotEmpty) ...[
              _buildSectionHeader(
                theme,
                'Overdue',
                Icons.warning_amber,
                theme.colorScheme.error,
              ),
              ...overdueProgressRecords.map(_buildProgressItem),
              const SizedBox(height: 24),
            ],
            if (todayProgressRecords.isNotEmpty) ...[
              _buildSectionHeader(
                theme,
                'Due Today',
                Icons.today,
                theme.colorScheme.tertiary,
              ),
              ...todayProgressRecords.map(_buildProgressItem),
              const SizedBox(height: 24),
            ],
            if (upcomingProgressRecords.isNotEmpty &&
                _selectedDate != null) ...[
              _buildSectionHeader(
                theme,
                'Upcoming',
                Icons.event,
                theme.colorScheme.primary,
              ),
              ...upcomingProgressRecords.map(_buildProgressItem),
            ],
            if (todayProgressRecords.isEmpty &&
                overdueProgressRecords.isEmpty &&
                upcomingProgressRecords.isEmpty)
              _buildEmptyState(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    ThemeData theme,
    String title,
    IconData icon,
    Color color,
  ) => Padding(
    padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
    child: Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 8),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    ),
  );

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_outline,
                size: 64,
                color: colorScheme.tertiary.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              _selectedDate == null
                  ? 'No modules due for review today!'
                  : 'No modules due for review by ${_dateFormat.format(_selectedDate!)}',
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Great job keeping up with your studies!',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh'),
              onPressed: _loadData,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressItem(ProgressSummary progress) {
    final moduleTitle = _moduleTitles[progress.moduleId] ?? 'Loading...';
    final cycleText = _formatCycleStudied(progress.cyclesStudied);
    final isItemDue = _isDue(progress);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          final String progressId = progress.id;
          debugPrint('Navigating to progress with ID: $progressId');
          debugPrint('Progress object data: ${progress.toString()}');

          GoRouter.of(
            context,
          ).push('/progress/$progressId').then((_) => _loadData());
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: progress.percentComplete / 100,
                          backgroundColor: colorScheme.surfaceContainerHighest,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _getProgressColor(
                              progress.percentComplete,
                              colorScheme,
                            ),
                          ),
                          strokeWidth: 4,
                        ),
                        Text(
                          '${progress.percentComplete.toInt()}%',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          moduleTitle,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Cycle: $cycleText',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: _getCycleColor(
                              progress.cyclesStudied,
                              colorScheme,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              isItemDue ? Icons.event_available : Icons.event,
                              size: 16,
                              color: isItemDue
                                  ? colorScheme.error
                                  : colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              progress.nextStudyDate != null
                                  ? _dateFormat.format(progress.nextStudyDate!)
                                  : 'Not scheduled',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: isItemDue
                                    ? colorScheme.error
                                    : colorScheme.onSurfaceVariant,
                                fontWeight: isItemDue ? FontWeight.bold : null,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (isItemDue)
                    Icon(
                      Icons.notifications_active,
                      color: colorScheme.error,
                      size: 20,
                    ),
                ],
              ),
              if (progress.repetitionCount > 0) ...[
                const SizedBox(height: 8),
                Chip(
                  label: Text('${progress.repetitionCount} repetitions'),
                  backgroundColor: colorScheme.surfaceContainerHigh,
                  side: BorderSide.none,
                  labelStyle: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getProgressColor(double percent, ColorScheme colorScheme) {
    if (percent >= 90) return colorScheme.tertiary;
    if (percent >= 60) return colorScheme.primary;
    if (percent >= 30) return colorScheme.secondary;
    return colorScheme.error;
  }

  Color _getCycleColor(CycleStudied cycle, ColorScheme colorScheme) =>
      switch (cycle) {
        CycleStudied.firstTime => colorScheme.primary,
        CycleStudied.firstReview => colorScheme.secondary,
        CycleStudied.secondReview => colorScheme.tertiary,
        CycleStudied.thirdReview => Colors.orange,
        CycleStudied.moreThanThreeReviews => Colors.purple,
      };
}
