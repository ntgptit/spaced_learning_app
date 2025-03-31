import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:spaced_learning_app/core/services/learning_data_service.dart';
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

  // Scroll controller for table scrolling
  final ScrollController _verticalScrollController = ScrollController();

  // Debouncer for load data to prevent rapid successive calls
  final Debouncer _loadDebouncer = Debouncer(milliseconds: 300);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // First time initialization only
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

  void _loadDataDebounced() {
    _loadDebouncer.run(() => _loadData());
  }

  Future<void> _loadData() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final learningDataService = Provider.of<LearningDataService>(
        context,
        listen: false,
      );
      final modules = await learningDataService.getModules();

      if (mounted) {
        setState(() {
          // Clear existing data to avoid duplicates on refresh
          _modules.clear();
          _modules.addAll(modules);
          _applyFilters();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Error loading data: ${e.toString()}';
        });

        // Use post-frame callback to show SnackBar safely
        SchedulerBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error loading data: ${e.toString()}'),
                backgroundColor: Colors.red,
                action: SnackBarAction(
                  label: 'Retry',
                  onPressed: _loadDataDebounced,
                  textColor: Colors.white,
                ),
              ),
            );
          }
        });
      }
    }
  }

  void _applyFilters() {
    if (!mounted) return;

    // Calculate new filtered modules
    final newFilteredModules =
        _modules.where((module) {
          // Filter by book
          final bookMatch =
              _selectedBook == 'All' || module.book == _selectedBook;

          // Filter by date
          final dateMatch =
              _selectedDate == null ||
              (module.nextStudyDate != null &&
                  AppDateUtils.isSameDay(
                    module.nextStudyDate!,
                    _selectedDate!,
                  ));

          return bookMatch && dateMatch;
        }).toList();

    // Only update state if the filtered results have changed
    if (_filteredModulesChanged(newFilteredModules)) {
      setState(() {
        _filteredModules = newFilteredModules;
      });
    }
  }

  // Check if filtered modules have changed to avoid unnecessary setState
  bool _filteredModulesChanged(List<LearningModule> newModules) {
    if (_filteredModules.length != newModules.length) {
      return true;
    }

    for (int i = 0; i < _filteredModules.length; i++) {
      if (_filteredModules[i].id != newModules[i].id) {
        return true;
      }
    }

    return false;
  }

  List<String> _getUniqueBooks() {
    // Use the service to get unique books, safely
    if (_modules.isEmpty) {
      return ['All'];
    }

    final books = _modules.map((module) => module.book).toSet().toList();
    books.sort();
    return ['All', ...books];
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2026),
    );

    if (picked != null && picked != _selectedDate && mounted) {
      setState(() {
        _selectedDate = picked;
      });
      _applyFilters();
    }
  }

  void _clearDateFilter() {
    if (!mounted) return;

    setState(() {
      _selectedDate = null;
    });
    _applyFilters();
  }

  void _exportData() async {
    if (!mounted) return;

    try {
      setState(() {
        _isLoading = true;
      });

      final learningDataService = Provider.of<LearningDataService>(
        context,
        listen: false,
      );
      final success = await learningDataService.exportData();

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // Show SnackBar safely using post frame callback
        SchedulerBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  success
                      ? 'Data exported successfully. The file was saved to your downloads folder.'
                      : 'Failed to export data. Please try again.',
                ),
                backgroundColor: success ? Colors.green : Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // Show SnackBar safely using post frame callback
        SchedulerBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error exporting data: ${e.toString()}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        });
      }
    }
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
    final theme = Theme.of(context);
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

    return Scaffold(
      appBar: AppBar(
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
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Filter bar
            LearningFilterBar(
              selectedBook: _selectedBook,
              selectedDate: _selectedDate,
              books: _getUniqueBooks(),
              onBookChanged: (value) {
                if (value != null && mounted) {
                  setState(() {
                    _selectedBook = value;
                  });
                  _applyFilters();
                }
              },
              onDateSelected: _selectDate,
              onDateCleared: _clearDateFilter,
              totalCount: totalModules,
              dueCount: dueModules,
              completeCount: completedModules,
            ),

            // Error message
            if (_errorMessage != null && !_isLoading)
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: theme.colorScheme.error),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(color: theme.colorScheme.error),
                      ),
                    ),
                    TextButton(
                      onPressed: _loadDataDebounced,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),

            // Main content - simplified table
            Expanded(
              child: SimplifiedLearningModulesTable(
                modules: _filteredModules,
                isLoading: _isLoading,
                verticalScrollController: _verticalScrollController,
              ),
            ),

            // Footer - takes full width
            SizedBox(
              width: double.infinity, // Ensure parent container is full width
              child: LearningFooter(
                totalModules: totalModules,
                completedModules: completedModules,
                onExportData: _exportData,
                onHelpPressed: _showHelpDialog,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
