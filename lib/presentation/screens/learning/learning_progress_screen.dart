import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:spaced_learning_app/core/services/learning_data_service.dart';
import 'package:spaced_learning_app/core/theme/app_colors.dart';
import 'package:spaced_learning_app/core/theme/app_dimens.dart';
import 'package:spaced_learning_app/core/utils/date_utils.dart';
import 'package:spaced_learning_app/core/utils/debouncer.dart';
import 'package:spaced_learning_app/domain/models/learning_module.dart';
import 'package:spaced_learning_app/presentation/widgets/learning/learning_filter_bar.dart';
import 'package:spaced_learning_app/presentation/widgets/learning/learning_footer.dart';
import 'package:spaced_learning_app/presentation/widgets/learning/learning_help_dialog.dart';
import 'package:spaced_learning_app/presentation/widgets/learning/learning_modules_table.dart';

class LearningProgressScreen extends StatefulWidget {
  const LearningProgressScreen({super.key});

  @override
  State<LearningProgressScreen> createState() => _LearningProgressScreenState();
}

class _LearningProgressScreenState extends State<LearningProgressScreen> {
  final List<LearningModule> _modules = [];
  List<LearningModule> _filteredModules = [];
  String _selectedBook = 'All';
  DateTime? _selectedDate;
  bool _isLoading = true;
  String? _errorMessage;
  bool _isInitialized = false;
  final ScrollController _verticalScrollController = ScrollController();
  final Debouncer _loadDebouncer = Debouncer(milliseconds: 300);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _loadDataDebounced();
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _verticalScrollController.dispose();
    _loadDebouncer.dispose();
    super.dispose();
  }

  void _loadDataDebounced() => _loadDebouncer.run(_loadData);

  Future<void> _loadData() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final learningDataService = context.read<LearningDataService>();
      final modules = await learningDataService.getModules();
      if (mounted) {
        setState(() {
          _modules.clear();
          _modules.addAll(modules);
          _applyFilters();
          _isLoading = false;
        });
      }
    } catch (e) {
      _handleLoadError(e.toString());
    }
  }

  void _applyFilters() {
    if (!mounted) return;
    final newFilteredModules =
        _modules.where((module) {
          final bookMatch =
              _selectedBook == 'All' || module.book == _selectedBook;
          final dateMatch =
              _selectedDate == null ||
              (module.nextStudyDate != null &&
                  AppDateUtils.isSameDay(
                    module.nextStudyDate!,
                    _selectedDate!,
                  ));
          return bookMatch && dateMatch;
        }).toList();

    if (_filteredModulesChanged(newFilteredModules)) {
      setState(() => _filteredModules = newFilteredModules);
    }
  }

  bool _filteredModulesChanged(List<LearningModule> newModules) {
    if (_filteredModules.length != newModules.length) return true;
    return _filteredModules.asMap().entries.any(
      (entry) => entry.value.id != newModules[entry.key].id,
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2026),
    );
    if (picked != null && picked != _selectedDate && mounted) {
      setState(() => _selectedDate = picked);
      _applyFilters();
    }
  }

  void _clearDateFilter() {
    if (!mounted) return;
    setState(() => _selectedDate = null);
    _applyFilters();
  }

  Future<void> _exportData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final learningDataService = context.read<LearningDataService>();
      final success = await learningDataService.exportData();
      if (mounted) {
        setState(() => _isLoading = false);
        _showExportResult(success);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showSnackBar('Error exporting data: $e', AppColors.lightError);
      }
    }
  }

  List<String> _getUniqueBooks() {
    if (_modules.isEmpty) return ['All'];
    final books =
        _modules.map((module) => module.book).toSet().toList()..sort();
    return ['All', ...books];
  }

  void _handleLoadError(String error) {
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _errorMessage = 'Error loading data: $error';
    });
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _showSnackBar(
          'Error loading data: $error',
          AppColors.lightError,
          retryAction: _loadDataDebounced,
        );
      }
    });
  }

  void _showExportResult(bool success) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _showSnackBar(
          success
              ? 'Data exported successfully. The file was saved to your downloads folder.'
              : 'Failed to export data. Please try again.',
          success ? AppColors.successLight : AppColors.lightError,
          duration: const Duration(seconds: 3),
        );
      }
    });
  }

  void _showSnackBar(
    String message,
    Color backgroundColor, {
    VoidCallback? retryAction,
    Duration? duration,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: duration ?? const Duration(seconds: 4),
        action:
            retryAction != null
                ? SnackBarAction(
                  label: 'Retry',
                  onPressed: retryAction,
                  textColor: Colors.white,
                )
                : null,
      ),
    );
  }

  void _showHelpDialog() {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => const LearningHelpDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(child: _buildBody()),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Learning Progress'),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: _loadDataDebounced,
          tooltip: 'Refresh data',
        ),
        IconButton(
          icon: const Icon(Icons.help_outline),
          onPressed: _showHelpDialog,
          tooltip: 'Help',
        ),
      ],
    );
  }

  Widget _buildBody() {
    final dueModules =
        _filteredModules
            .where(
              (m) =>
                  m.nextStudyDate != null &&
                  m.nextStudyDate!.isBefore(
                    DateTime.now().add(const Duration(days: 7)),
                  ),
            )
            .length;
    final totalModules = _filteredModules.length;
    final completedModules =
        _filteredModules.where((m) => m.percentage == 100).length;

    return Column(
      children: [
        _buildFilterBar(totalModules, dueModules, completedModules),
        if (_errorMessage != null && !_isLoading) _buildErrorDisplay(),
        Expanded(child: _buildModulesTable()),
        _buildFooter(totalModules, completedModules),
      ],
    );
  }

  Widget _buildFilterBar(
    int totalModules,
    int dueModules,
    int completedModules,
  ) {
    return LearningFilterBar(
      selectedBook: _selectedBook,
      selectedDate: _selectedDate,
      books: _getUniqueBooks(),
      onBookChanged: (value) {
        if (value != null && mounted) {
          setState(() => _selectedBook = value);
          _applyFilters();
        }
      },
      onDateSelected: _selectDate,
      onDateCleared: _clearDateFilter,
      totalCount: totalModules,
      dueCount: dueModules,
      completeCount: completedModules,
    );
  }

  Widget _buildErrorDisplay() {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppDimens.paddingL),
      margin: const EdgeInsets.all(AppDimens.paddingL),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: theme.colorScheme.error),
          const SizedBox(width: AppDimens.spaceM),
          Expanded(
            child: Text(
              _errorMessage!,
              style: TextStyle(color: theme.colorScheme.error),
            ),
          ),
          TextButton(onPressed: _loadDataDebounced, child: const Text('Retry')),
        ],
      ),
    );
  }

  Widget _buildModulesTable() {
    return SimplifiedLearningModulesTable(
      modules: _filteredModules,
      isLoading: _isLoading,
      verticalScrollController: _verticalScrollController,
    );
  }

  Widget _buildFooter(int totalModules, int completedModules) {
    return SizedBox(
      width: double.infinity,
      child: LearningFooter(
        totalModules: totalModules,
        completedModules: completedModules,
        onExportData: _exportData,
        onHelpPressed: _showHelpDialog,
      ),
    );
  }
}
