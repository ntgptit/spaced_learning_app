// lib/presentation/screens/learning/learning_progress_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate loading data
    await Future.delayed(const Duration(milliseconds: 800));

    setState(() {
      // Clear existing data to avoid duplicates on refresh
      _modules.clear();

      _modules.addAll([
        LearningModule(
          id: '1',
          book: 'Book1',
          subject: 'Vitamin_Book1_Chapter1-1 + 1-2',
          wordCount: 76,
          cyclesStudied: 2,
          firstLearningDate: DateTime(2024, 12, 8),
          percentage: 96,
          nextStudyDate: DateTime(2025, 4, 20),
          taskCount: 1,
        ),
        LearningModule(
          id: '2',
          book: 'Book1',
          subject: 'Vitamin_Book1_Chapter1-3: Single Final Consonants',
          wordCount: 52,
          cyclesStudied: 2,
          firstLearningDate: DateTime(2024, 12, 9),
          percentage: 98,
          nextStudyDate: DateTime(2025, 3, 15),
          taskCount: 1,
        ),
        LearningModule(
          id: '3',
          book: 'Book1',
          subject: 'Vitamin_Book1_Chapter1-3: Double Final Consonants',
          wordCount: 12,
          cyclesStudied: 2,
          firstLearningDate: DateTime(2024, 12, 10),
          percentage: 100,
          nextStudyDate: DateTime(2025, 2, 28),
          taskCount: 3,
        ),
        LearningModule(
          id: '4',
          book: 'Book1',
          subject: 'Vitamin_Book1_Chapter2-1: Vocabulary',
          wordCount: 31,
          cyclesStudied: 2,
          firstLearningDate: DateTime(2024, 12, 11),
          percentage: 94,
          nextStudyDate: DateTime(2025, 2, 28),
          taskCount: 3,
        ),
        LearningModule(
          id: '5',
          book: 'Book1',
          subject: 'Vitamin_Book1_Chapter2-2: Vocabulary',
          wordCount: 29,
          cyclesStudied: 2,
          firstLearningDate: DateTime(2024, 12, 12),
          percentage: 100,
          nextStudyDate: DateTime(2025, 3, 2),
          taskCount: 1,
        ),
        LearningModule(
          id: '19',
          book: 'Book2',
          subject: 'Vitamin_Book2_Chapter1-1: Vocabulary',
          wordCount: 74,
          cyclesStudied: 1,
          firstLearningDate: DateTime(2024, 12, 26),
          percentage: 86,
          nextStudyDate: DateTime(2025, 2, 27),
          taskCount: 1,
        ),
        LearningModule(
          id: '20',
          book: 'Book2',
          subject: 'Vitamin_Book2_Chapter1-2: Vocabulary',
          wordCount: 47,
          cyclesStudied: 2,
          firstLearningDate: DateTime(2024, 12, 27),
          percentage: 85,
          nextStudyDate: DateTime(2025, 3, 24),
          taskCount: 1,
        ),
        LearningModule(
          id: '34',
          book: 'Book3',
          subject: 'Vitamin_Book3_Chapter1-1: Vocabulary',
          wordCount: 108,
          cyclesStudied: null,
          firstLearningDate: null,
          percentage: 100,
          nextStudyDate: null,
          taskCount: null,
        ),
        LearningModule(
          id: '35',
          book: 'Book3',
          subject: 'Vitamin_Book3_Chapter1-2: Vocabulary',
          wordCount: 62,
          cyclesStudied: null,
          firstLearningDate: null,
          percentage: 100,
          nextStudyDate: null,
          taskCount: null,
        ),
        LearningModule(
          id: '38',
          book: 'Book3',
          subject: 'Vitamin_Book3_Chapter2-1: Korean - Honorifics',
          wordCount: 18,
          cyclesStudied: 1,
          firstLearningDate: DateTime(2025, 1, 2),
          percentage: 100,
          nextStudyDate: DateTime(2025, 2, 22),
          taskCount: 4,
        ),
        LearningModule(
          id: '40',
          book: 'Additional',
          subject: 'Additional_20240814: 대인 관계',
          wordCount: 60,
          cyclesStudied: null,
          firstLearningDate: null,
          percentage: 100,
          nextStudyDate: null,
          taskCount: null,
        ),
        LearningModule(
          id: '56',
          book: 'Duyen선생님_중급1',
          subject: 'Section 1: 대학 생활',
          wordCount: 40,
          cyclesStudied: 1,
          firstLearningDate: DateTime(2024, 12, 31),
          percentage: 97,
          nextStudyDate: DateTime(2025, 2, 26),
          taskCount: 3,
        ),
        LearningModule(
          id: '57',
          book: 'THTH Book2',
          subject: 'Section 1: 관계 +방문 + 인사말',
          wordCount: 46,
          cyclesStudied: 1,
          firstLearningDate: DateTime(2025, 1, 1),
          percentage: 100,
          nextStudyDate: DateTime(2025, 2, 25),
          taskCount: 4,
        ),
        LearningModule(
          id: '61',
          book: '[OJT_Korea_2024]',
          subject: 'Section 1: Cho đi và nhận lại',
          wordCount: 116,
          cyclesStudied: null,
          firstLearningDate: null,
          percentage: 100,
          nextStudyDate: null,
          taskCount: null,
        ),
      ]);

      _applyFilters();
      _isLoading = false;
    });
  }

  void _applyFilters() {
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

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _applyFilters();
      });
    }
  }

  void _clearDateFilter() {
    setState(() {
      _selectedDate = null;
      _applyFilters();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning Progress Overview'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: 'Refresh data',
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  // Filter bar
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Filters', style: theme.textTheme.titleMedium),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            // Book filter dropdown
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                  labelText: 'Book',
                                  border: OutlineInputBorder(),
                                ),
                                value: _selectedBook,
                                items:
                                    _getUniqueBooks()
                                        .map(
                                          (book) => DropdownMenuItem(
                                            value: book,
                                            child: Text(book),
                                          ),
                                        )
                                        .toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() {
                                      _selectedBook = value;
                                      _applyFilters();
                                    });
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Date filter button
                            Expanded(
                              child:
                                  _selectedDate == null
                                      ? OutlinedButton.icon(
                                        icon: const Icon(Icons.calendar_today),
                                        label: const Text('Select Date'),
                                        onPressed: _selectDate,
                                      )
                                      : InputChip(
                                        label: Text(
                                          DateFormat(
                                            'MMM dd, yyyy',
                                          ).format(_selectedDate!),
                                        ),
                                        deleteIcon: const Icon(Icons.clear),
                                        onDeleted: _clearDateFilter,
                                      ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Stats row
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatItem(
                                'Total',
                                _filteredModules.length.toString(),
                                Icons.book,
                                theme,
                              ),
                              _buildDivider(),
                              _buildStatItem(
                                'Due',
                                _filteredModules
                                    .where(
                                      (m) =>
                                          m.nextStudyDate != null &&
                                          m.nextStudyDate!.isBefore(
                                            DateTime.now().add(
                                              const Duration(days: 7),
                                            ),
                                          ),
                                    )
                                    .length
                                    .toString(),
                                Icons.warning,
                                theme,
                              ),
                              _buildDivider(),
                              _buildStatItem(
                                'Complete',
                                '${_filteredModules.where((m) => m.percentage == 100).length}',
                                Icons.check_circle,
                                theme,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Data table
                  Expanded(
                    child:
                        _filteredModules.isEmpty
                            ? Center(
                              child: Text(
                                'No data found for the selected filters',
                                style: theme.textTheme.bodyLarge,
                              ),
                            )
                            : SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: SingleChildScrollView(
                                child: DataTable(
                                  columnSpacing: 16,
                                  headingRowColor: WidgetStateProperty.all(
                                    theme.colorScheme.primary.withValues(
                                      alpha: 0.1,
                                    ),
                                  ),
                                  columns: const [
                                    DataColumn(label: Text('Subject')),
                                    DataColumn(
                                      label: Text('Book'),
                                      numeric: true,
                                    ),
                                    DataColumn(
                                      label: Text('Words'),
                                      numeric: true,
                                    ),
                                    DataColumn(
                                      label: Text('Cycles'),
                                      numeric: true,
                                    ),
                                    DataColumn(
                                      label: Text('Progress'),
                                      numeric: true,
                                    ),
                                    DataColumn(label: Text('Next Study')),
                                    DataColumn(
                                      label: Text('Tasks'),
                                      numeric: true,
                                    ),
                                  ],
                                  rows:
                                      _filteredModules.map((module) {
                                        final isNearDue =
                                            module.nextStudyDate != null &&
                                            module.nextStudyDate!.isBefore(
                                              DateTime.now().add(
                                                const Duration(days: 3),
                                              ),
                                            );

                                        return DataRow(
                                          cells: [
                                            DataCell(
                                              Container(
                                                constraints:
                                                    const BoxConstraints(
                                                      maxWidth: 300,
                                                    ),
                                                child: Text(
                                                  module.subject,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              // Simple display of details without additional actions
                                              onTap:
                                                  () => _showModuleDetails(
                                                    module,
                                                  ),
                                            ),
                                            DataCell(Text(module.book)),
                                            DataCell(
                                              Text(module.wordCount.toString()),
                                            ),
                                            DataCell(
                                              Text(
                                                module.cyclesStudied
                                                        ?.toString() ??
                                                    '-',
                                              ),
                                            ),
                                            DataCell(
                                              LinearProgressIndicator(
                                                value: module.percentage / 100,
                                                backgroundColor:
                                                    theme
                                                        .colorScheme
                                                        .surfaceContainerHighest,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                      Color
                                                    >(
                                                      module.percentage >= 90
                                                          ? Colors.green
                                                          : module.percentage >=
                                                              70
                                                          ? Colors.orange
                                                          : Colors.red,
                                                    ),
                                                minHeight: 10,
                                              ),
                                              onTap:
                                                  () => _showModuleDetails(
                                                    module,
                                                  ),
                                            ),
                                            DataCell(
                                              module.nextStudyDate != null
                                                  ? Text(
                                                    DateFormat(
                                                      'MMM dd, yyyy',
                                                    ).format(
                                                      module.nextStudyDate!,
                                                    ),
                                                    style:
                                                        isNearDue
                                                            ? TextStyle(
                                                              color:
                                                                  theme
                                                                      .colorScheme
                                                                      .error,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            )
                                                            : null,
                                                  )
                                                  : const Text('-'),
                                            ),
                                            DataCell(
                                              Text(
                                                module.taskCount?.toString() ??
                                                    '-',
                                              ),
                                            ),
                                          ],
                                        );
                                      }).toList(),
                                ),
                              ),
                            ),
                  ),
                ],
              ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 30,
      width: 1,
      color: Colors.grey.withValues(alpha: 0.3),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    ThemeData theme,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: theme.colorScheme.primary),
            const SizedBox(width: 4),
            Text(label, style: theme.textTheme.bodySmall),
          ],
        ),
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }

  void _showModuleDetails(LearningModule module) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        final theme = Theme.of(context);

        return DraggableScrollableSheet(
          initialChildSize: 0.5, // Decreased size since we removed some content
          maxChildSize: 0.8,
          minChildSize: 0.3,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Title
                    Text(module.subject, style: theme.textTheme.headlineSmall),
                    Text(
                      'From: ${module.book}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const Divider(height: 32),

                    // Details grid
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        _buildDetailItem(
                          context,
                          'Word Count',
                          module.wordCount.toString(),
                          Icons.text_fields,
                        ),
                        _buildDetailItem(
                          context,
                          'Progress',
                          '${module.percentage}%',
                          Icons.trending_up,
                        ),
                        _buildDetailItem(
                          context,
                          'Cycle',
                          module.cyclesStudied?.toString() ?? 'Not started',
                          Icons.loop,
                        ),
                        _buildDetailItem(
                          context,
                          'Tasks',
                          module.taskCount?.toString() ?? 'None',
                          Icons.assignment,
                        ),
                      ],
                    ),

                    const Divider(height: 32),

                    // Dates
                    if (module.firstLearningDate != null)
                      _buildDateItem(
                        context,
                        'First Learning',
                        module.firstLearningDate!,
                        Icons.play_circle,
                      ),

                    if (module.nextStudyDate != null) ...[
                      const SizedBox(height: 16),
                      _buildDateItem(
                        context,
                        'Next Study',
                        module.nextStudyDate!,
                        Icons.event,
                        isUpcoming: module.nextStudyDate!.isBefore(
                          DateTime.now().add(const Duration(days: 3)),
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),

                    // Only Close button
                    Center(
                      child: TextButton.icon(
                        icon: const Icon(Icons.close),
                        label: const Text('Close'),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final theme = Theme.of(context);

    return Container(
      width: MediaQuery.of(context).size.width / 2 - 32,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateItem(
    BuildContext context,
    String label,
    DateTime date,
    IconData icon, {
    bool isUpcoming = false,
  }) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('EEEE, MMMM d, yyyy');

    return Row(
      children: [
        Icon(
          icon,
          color:
              isUpcoming ? theme.colorScheme.error : theme.colorScheme.primary,
          size: 20,
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              dateFormat.format(date),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: isUpcoming ? FontWeight.bold : null,
                color: isUpcoming ? theme.colorScheme.error : null,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class LearningModule {
  final String id;
  final String book;
  final String subject;
  final int wordCount;
  final int? cyclesStudied;
  final DateTime? firstLearningDate;
  final int percentage;
  final DateTime? nextStudyDate;
  final int? taskCount;

  LearningModule({
    required this.id,
    required this.book,
    required this.subject,
    required this.wordCount,
    required this.cyclesStudied,
    required this.firstLearningDate,
    required this.percentage,
    required this.nextStudyDate,
    required this.taskCount,
  });
}
