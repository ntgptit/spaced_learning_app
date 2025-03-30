import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:spaced_learning_app/core/services/learning_data_service.dart';
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

  // Scroll controllers for table scrolling
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // First time initialization only
    if (!_isInitialized) {
      _loadData();
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    _verticalScrollController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Now it's safe to access Provider here
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
                  onPressed: _loadData,
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

    setState(() {
      _filteredModules =
          _modules.where((module) {
            // Filter by book
            final bookMatch =
                _selectedBook == 'All' || module.book == _selectedBook;

            // Filter by date
            final dateMatch =
                _selectedDate == null ||
                (module.nextStudyDate != null &&
                    _isSameDay(module.nextStudyDate!, _selectedDate!));

            return bookMatch && dateMatch;
          }).toList();
    });
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
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
        _applyFilters();
      });
    }
  }

  void _clearDateFilter() {
    if (!mounted) return;

    setState(() {
      _selectedDate = null;
      _applyFilters();
    });
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

    // Calculate stats for the filter bar and footer
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
        title: const Text('Learning Progress Overview'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
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
                    _applyFilters();
                  });
                }
              },
              onDateSelected: _selectDate,
              onDateCleared: _clearDateFilter,
              totalCount: totalModules,
              dueCount: dueModules,
              completeCount: completedModules,
            ),

            // Error display if needed
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
                      onPressed: _loadData,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),

            // Data table - we pass our scroll controllers to ensure consistent scrolling
            Expanded(
              child: LearningModulesTable(
                modules: _filteredModules,
                isLoading: _isLoading,
                horizontalScrollController: _horizontalScrollController,
                verticalScrollController: _verticalScrollController,
              ),
            ),

            // Footer
            LearningFooter(
              totalModules: totalModules,
              completedModules: completedModules,
              onExportData: _exportData,
              onHelpPressed: _showHelpDialog,
            ),
          ],
        ),
      ),
    );
  }
}
